#!/bin/bash
# =============================================================================
# Cloudflare Cleanup — IONOS-Reste entfernen
# =============================================================================
# Default: Dry-Run (zeigt nur, was gelöscht würde)
# Mit --apply: tatsächlich löschen
#
# Token wird aus Env-Var CF_API_TOKEN gelesen, NICHT aus dem Skript.
# Aufruf:
#   export CF_API_TOKEN="cfat_..."
#   bash cloudflare-cleanup.sh          # Dry-Run
#   bash cloudflare-cleanup.sh --apply  # Echtes Löschen
# =============================================================================

set -euo pipefail

if [ -z "${CF_API_TOKEN:-}" ]; then
    echo "FEHLER: CF_API_TOKEN nicht gesetzt. Aufruf:"
    echo "  export CF_API_TOKEN=\"cfat_...\""
    echo "  bash $0 [--apply]"
    exit 1
fi

APPLY=false
if [ "${1:-}" = "--apply" ]; then
    APPLY=true
fi

CF_API="https://api.cloudflare.com/client/v4"

# Zonen die aufgeräumt werden — jensklasen.de bewusst NICHT, da bereits LIVE
declare -a ZONES=(
    "jklasen.de:49b0a724650d1427699aa1d92e23c381:full_redirect"
    "jklasen.com:1cb134f58de0ace4fdec3b75782fe3fa:full_redirect"
    "klasen.rocks:b01fe690e1cf6f207849dc14d6d493a0:redirect_only"
    "vbeard.de:6e82f441209c4dec24458cc080e8c0b5:redirect_only"
    "ai-deer.de:0ab8d50dcb22b0ed978614a6e1a61c10:redirect_only"
)

# Klassifiziert einen Record: "DELETE" oder "KEEP" (mit Begründung)
classify_record() {
    local mode="$1"      # full_redirect | redirect_only
    local type="$2"
    local name="$3"
    local content="$4"

    case "$type" in
        A)
            if [ "$content" = "192.0.2.1" ]; then
                echo "KEEP|Cloudflare-Dummy"
            elif [[ "$content" =~ ^217\.160\. ]] || [[ "$content" =~ ^212\.227\. ]] || [[ "$content" =~ ^82\.165\. ]]; then
                echo "DELETE|IONOS-IP"
            else
                echo "KEEP|unbekannte IP — manuell prüfen"
            fi
            ;;
        AAAA)
            if [[ "$content" =~ ^2001:8d8: ]]; then
                echo "DELETE|IONOS-IPv6"
            else
                echo "KEEP|unbekannte IPv6 — manuell prüfen"
            fi
            ;;
        CNAME)
            if [[ "$content" == *.ionos.de ]] || [[ "$content" == *.ionos.com ]] || \
               [[ "$content" == *.ionos.info ]] || [[ "$content" == *.1and1.com ]]; then
                echo "DELETE|IONOS-CNAME"
            else
                echo "KEEP|unbekannter CNAME"
            fi
            ;;
        MX)
            if [[ "$content" == *.ionos.de ]] || [[ "$content" == *.ionos.com ]] || [[ "$content" == *.ionos.info ]]; then
                echo "DELETE|IONOS-MX"
            elif [[ "$content" == *.google.com ]] || [[ "$content" == *.googlemail.com ]]; then
                echo "KEEP|Google-Workspace-MX"
            else
                echo "KEEP|unbekannter MX"
            fi
            ;;
        TXT)
            if [[ "$content" == *"_spf-eu.ionos.com"* ]] || [[ "$content" == *"_spf.ionos.de"* ]] || \
               [[ "$content" == *"spf.ionos.de"* ]]; then
                echo "DELETE|IONOS-SPF"
            elif [[ "$content" == *"_spf.google.com"* ]]; then
                echo "KEEP|Google-SPF (neu angelegt)"
            elif [[ "$content" == *"v=DMARC1"* ]]; then
                echo "KEEP|DMARC"
            elif [[ "$content" == *"v=DKIM1"* ]] || [[ "$content" == *"DKIM1;"* ]]; then
                echo "KEEP|DKIM"
            else
                echo "KEEP|unbekannter TXT — manuell prüfen"
            fi
            ;;
        *)
            echo "KEEP|Type=$type, nicht in Filter"
            ;;
    esac
}

echo "══════════════════════════════════════════════════════"
if $APPLY; then
    echo "  CLOUDFLARE CLEANUP — APPLY-MODE (löscht wirklich!)"
else
    echo "  CLOUDFLARE CLEANUP — DRY-RUN (löscht nichts)"
fi
echo "══════════════════════════════════════════════════════"
echo ""

total_delete=0
total_keep=0

for zone_info in "${ZONES[@]}"; do
    IFS=':' read -r zone_name zone_id mode <<< "$zone_info"
    echo "── $zone_name ($mode) ─────────────────────────"

    # Alle Records dieser Zone holen
    records=$(curl -s "$CF_API/zones/$zone_id/dns_records?per_page=200" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json")

    # Per Python parsen + klassifizieren (nur weil Shell-JSON-Parsing eklig ist)
    while IFS='|' read -r rid rtype rname rcontent; do
        verdict=$(classify_record "$mode" "$rtype" "$rname" "$rcontent")
        action="${verdict%%|*}"
        reason="${verdict##*|}"

        # Display
        display_content="$rcontent"
        if [ ${#display_content} -gt 50 ]; then
            display_content="${display_content:0:47}..."
        fi

        if [ "$action" = "DELETE" ]; then
            echo "  ✗ DEL  $rtype  $rname → $display_content    ($reason)"
            total_delete=$((total_delete + 1))
            if $APPLY; then
                del_response=$(curl -s -X DELETE "$CF_API/zones/$zone_id/dns_records/$rid" \
                    -H "Authorization: Bearer $CF_API_TOKEN")
                if echo "$del_response" | python3 -c "import sys,json; sys.exit(0 if json.load(sys.stdin).get('success') else 1)" 2>/dev/null; then
                    echo "         → gelöscht"
                else
                    echo "         → FEHLER: $(echo "$del_response" | python3 -c 'import sys,json; print(json.load(sys.stdin).get(\"errors\"))')"
                fi
            fi
        else
            echo "  ✓ KEEP $rtype  $rname → $display_content    ($reason)"
            total_keep=$((total_keep + 1))
        fi
    done < <(echo "$records" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if not data.get('success'):
    sys.exit(1)
for r in data.get('result', []):
    print(f'{r[\"id\"]}|{r[\"type\"]}|{r[\"name\"]}|{r[\"content\"]}')
")
    echo ""
done

echo "══════════════════════════════════════════════════════"
if $APPLY; then
    echo "  Fertig — gelöscht: $total_delete, behalten: $total_keep"
else
    echo "  Dry-Run fertig — WÜRDE löschen: $total_delete, behalten: $total_keep"
    echo ""
    echo "  Wenn das stimmt, nochmal aufrufen mit --apply:"
    echo "    bash $0 --apply"
fi
echo "══════════════════════════════════════════════════════"
