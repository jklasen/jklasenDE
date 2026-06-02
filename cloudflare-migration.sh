#!/bin/bash
# =============================================================================
# jklasen.de Cloudflare DNS Migration Script
# =============================================================================
# Dieses Script legt alle DNS-Einträge und Redirect Rules für die
# Domain-Migration von IONOS zu Cloudflare an.
#
# VORAUSSETZUNGEN (manuell erledigen, bevor du das Script startest):
# 1. Alle vier Domains in Cloudflare hinzufügen (Free Plan):
#    - jklasen.de, jklasen.com, klasen.rocks, vbeard.de
# 2. Cloudflare API-Token erstellen:
#    Dashboard → My Profile → API Tokens → Create Token
#    Template: "Edit zone DNS" + Permissions hinzufügen:
#      Zone → Zone Settings → Edit
#      Zone → DNS → Edit
#      Zone → Page Rules → Edit (für Redirect Rules)
#    Zone Resources: "All zones"
# 3. DKIM-Keys aus Google Workspace Admin Console holen:
#    Admin Console → Apps → Google Workspace → Gmail →
#    E-Mail authentifizieren → DKIM → Domain wählen →
#    "Neuen Eintrag generieren" → TXT-Wert kopieren
# 4. Zone-IDs notieren (Cloudflare Dashboard → Domain → rechts unten)
#
# NACH dem Script:
# - Nameserver bei IONOS umstellen auf die Cloudflare-Nameserver
# - 1-24h warten auf DNS-Propagation
# - E-Mail testen (senden + empfangen)
# - Redirect testen (jklasen.com → jensklasen.de)
# =============================================================================

set -euo pipefail

# =============================================================================
# KONFIGURATION — HIER DEINE WERTE EINTRAGEN
# =============================================================================

# Cloudflare API Token (NIEMALS committen oder teilen!)
CF_API_TOKEN="DEIN_CLOUDFLARE_API_TOKEN_HIER"

# Zone-IDs (findest du im Cloudflare Dashboard → Domain → rechts unten)
ZONE_ID_JKLASEN_DE="49b0a724650d1427699aa1d92e23c381"
ZONE_ID_JKLASEN_COM="1cb134f58de0ace4fdec3b75782fe3fa"
ZONE_ID_KLASEN_ROCKS="b01fe690e1cf6f207849dc14d6d493a0"
ZONE_ID_VBEARD_DE="6e82f441209c4dec24458cc080e8c0b5"
ZONE_ID_AI_DEER_DE="0ab8d50dcb22b0ed978614a6e1a61c10"
ZONE_ID_JENSKLASEN_DE="0462c50422050c04d924940db940cc42"

# DKIM-Keys aus Google Workspace Admin Console
# (Langer String, beginnt mit "v=DKIM1; k=rsa; p=...")
DKIM_KEY_JKLASEN_DE="v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAl+Ou+N3zbGMyObPAUI5T8wx2i82XiQ4lOC6vTK0cYbSu5iWM+/iTJd2CVNho+/quWjH3/9XglN+U99+eduZ3LiMYi9nLdAUNia3eNn0okfyHd8f6zH5It/iLTdP1ErDReqTKlwKQRRV8/+yfQAUWCNz6u1k3KPwgtiHD307EektQ9JshekGgScfuAhACh6qGbGWAtpMXczrnRzYKsRzGmhclXR7FDv7nzDKvXVn3dTb2Rcm+xM1Xd3CLZ0bE5T6g3xKH9+rzvMhQy5mup5pEEhC01bm2J8yA2kMxMAULLf0UevmUWQmG56LpuJYjRfB/JOwAjBHemHhNr+tWncnVXwIDAQAB"
DKIM_KEY_JKLASEN_COM="v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp/bUyaAGpGvMNexidueYAECKwRFolCfqtEkrfJytJIqwgFl7ByUn6w7jVuyvC2SG+aU0YFdKzw1pdO1nvhpPnulg2xt2sCaLG4Q8q69Y6JnBGNB3CjKinJoF6daeTPPK3MbY2B7shz2YC4kQkEbOMsQguCR8A5TFNGhayPthlTi+H1TUfnVRk8KsqTRR/FY/VQ3OxTXZfP6z2HFIhhS3p46900a0/r27EcN9+eQ9qf5twJJwQfjKWjhBIg7lHSC+u0LrBFg9Iwlzmo3X4zK+4EifK+nMqjgSE377s02fxRxMEb6zi2C5DztK3gnZsg68dv2yQDtC17lsZWbvpf6g2QIDAQAB"

# Weiterleitung — wohin alle Domains zeigen sollen
REDIRECT_TARGET="https://jensklasen.de"

# =============================================================================
# FUNKTIONEN
# =============================================================================

CF_API="https://api.cloudflare.com/client/v4"

log() {
    echo ""
    echo "══════════════════════════════════════════════════════"
    echo "  $1"
    echo "══════════════════════════════════════════════════════"
}

log_step() {
    echo "  → $1"
}

log_ok() {
    echo "  ✓ $1"
}

log_warn() {
    echo "  ⚠ $1"
}

log_error() {
    echo "  ✗ $1"
}

# DNS-Eintrag anlegen
# Argumente: zone_id, type, name, content, [priority], [proxied]
create_dns() {
    local zone_id="$1"
    local type="$2"
    local name="$3"
    local content="$4"
    local priority="${5:-}"
    local proxied="${6:-false}"

    local data="{\"type\":\"$type\",\"name\":\"$name\",\"content\":\"$content\",\"proxied\":$proxied,\"ttl\":1"

    if [ -n "$priority" ]; then
        data="$data,\"priority\":$priority"
    fi

    data="$data}"

    local response
    response=$(curl -s -X POST "$CF_API/zones/$zone_id/dns_records" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "$data")

    local success
    success=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('success', False))" 2>/dev/null || echo "False")

    if [ "$success" = "True" ]; then
        log_ok "$type $name → $content"
    else
        local errors
        errors=$(echo "$response" | python3 -c "
import sys,json
r=json.load(sys.stdin)
errs=r.get('errors',[])
if errs:
    # Code 81057 = Record existiert bereits
    if any(e.get('code')==81057 for e in errs):
        print('EXISTS')
    else:
        print('; '.join(e.get('message','?') for e in errs))
else:
    print('Unknown error')
" 2>/dev/null || echo "Parse error")

        if [ "$errors" = "EXISTS" ]; then
            log_warn "$type $name — existiert bereits, übersprungen"
        else
            log_error "$type $name — Fehler: $errors"
        fi
    fi
}

# SSL-Modus setzen
set_ssl_mode() {
    local zone_id="$1"
    local mode="$2"

    local response
    response=$(curl -s -X PATCH "$CF_API/zones/$zone_id/settings/ssl" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "{\"value\":\"$mode\"}")

    local success
    success=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('success', False))" 2>/dev/null || echo "False")

    if [ "$success" = "True" ]; then
        log_ok "SSL-Modus → $mode"
    else
        log_error "SSL-Modus konnte nicht gesetzt werden"
    fi
}

# Always Use HTTPS aktivieren
set_always_https() {
    local zone_id="$1"

    local response
    response=$(curl -s -X PATCH "$CF_API/zones/$zone_id/settings/always_use_https" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data '{"value":"on"}')

    local success
    success=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('success', False))" 2>/dev/null || echo "False")

    if [ "$success" = "True" ]; then
        log_ok "Always Use HTTPS → on"
    else
        log_warn "Always Use HTTPS konnte nicht gesetzt werden (evtl. bereits aktiv)"
    fi
}

# Redirect Rule anlegen (Single Redirects)
create_redirect_rule() {
    local zone_id="$1"
    local domain="$2"
    local target="$3"

    local response
    response=$(curl -s -X POST "$CF_API/zones/$zone_id/rulesets" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "{
            \"name\": \"Redirect $domain to jensklasen.de\",
            \"kind\": \"zone\",
            \"phase\": \"http_request_dynamic_redirect\",
            \"rules\": [{
                \"expression\": \"(http.host eq \\\"$domain\\\") or (http.host eq \\\"www.$domain\\\")\",
                \"description\": \"Redirect $domain → jensklasen.de\",
                \"action\": \"redirect\",
                \"action_parameters\": {
                    \"from_value\": {
                        \"target_url\": {
                            \"expression\": \"concat(\\\"$target\\\", http.request.uri.path)\"
                        },
                        \"status_code\": 301,
                        \"preserve_query_string\": true
                    }
                }
            }]
        }")

    local success
    success=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin).get('success', False))" 2>/dev/null || echo "False")

    if [ "$success" = "True" ]; then
        log_ok "Redirect Rule: $domain → $target"
    else
        local errors
        errors=$(echo "$response" | python3 -c "
import sys,json
r=json.load(sys.stdin)
errs=r.get('errors',[])
print('; '.join(e.get('message','?') for e in errs) if errs else 'Unknown')
" 2>/dev/null || echo "Parse error")
        log_error "Redirect Rule für $domain — Fehler: $errors"
        log_warn "Falls 'phase already exists': Redirect manuell im Dashboard anlegen"
    fi
}

# Bestehende DNS-Records einer Zone auflisten
list_dns_records() {
    local zone_id="$1"
    local type="${2:-}"

    local url="$CF_API/zones/$zone_id/dns_records?per_page=100"
    if [ -n "$type" ]; then
        url="$url&type=$type"
    fi

    curl -s "$url" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" | \
    python3 -c "
import sys, json
data = json.load(sys.stdin)
if data.get('success'):
    for r in data.get('result', []):
        prio = f' (Priority: {r[\"priority\"]})' if 'priority' in r and r['priority'] else ''
        proxy = ' [PROXIED]' if r.get('proxied') else ''
        print(f'    {r[\"type\"]:6s} {r[\"name\"]:40s} → {r[\"content\"][:60]}{prio}{proxy}')
else:
    print('    Fehler beim Abrufen')
" 2>/dev/null
}

# =============================================================================
# VALIDIERUNG
# =============================================================================

log "Validierung"

# Prüfe, ob Platzhalter noch drin sind
if [[ "$CF_API_TOKEN" == *"DEIN_"* ]]; then
    log_error "CF_API_TOKEN ist noch ein Platzhalter!"
    log_error "Bitte trage deinen echten API-Token ein."
    exit 1
fi

for var_name in ZONE_ID_JKLASEN_DE ZONE_ID_JKLASEN_COM ZONE_ID_KLASEN_ROCKS ZONE_ID_VBEARD_DE ZONE_ID_AI_DEER_DE ZONE_ID_JENSKLASEN_DE; do
    eval val=\$$var_name
    if [[ "$val" == *"DEIN_"* ]]; then
        log_error "$var_name ist noch ein Platzhalter!"
        exit 1
    fi
done

if [[ "$DKIM_KEY_JKLASEN_DE" == *"DEIN_"* ]]; then
    log_warn "DKIM-Key für jklasen.de fehlt — DKIM wird übersprungen"
fi

if [[ "$DKIM_KEY_JKLASEN_COM" == *"DEIN_"* ]]; then
    log_warn "DKIM-Key für jklasen.com fehlt — DKIM wird übersprungen"
fi

# API-Token testen
log_step "Teste API-Token..."
token_test=$(curl -s "$CF_API/zones?per_page=1" \
    -H "Authorization: Bearer $CF_API_TOKEN" | \
    python3 -c "import sys,json; print(json.load(sys.stdin).get('success', False))" 2>/dev/null || echo "False")

if [ "$token_test" != "True" ]; then
    log_error "API-Token ungültig oder keine Berechtigung!"
    exit 1
fi
log_ok "API-Token gültig"

# =============================================================================
# 1. jklasen.de — Google Workspace + Redirect
# =============================================================================

log "1/6 — jklasen.de (Google Workspace + Redirect)"

log_step "SSL-Modus setzen..."
set_ssl_mode "$ZONE_ID_JKLASEN_DE" "full"
set_always_https "$ZONE_ID_JKLASEN_DE"

log_step "DNS-Einträge anlegen..."

# Dummy-IP für Redirect (Cloudflare empfohlene Methode)
create_dns "$ZONE_ID_JKLASEN_DE" "A" "jklasen.de" "192.0.2.1" "" "true"
create_dns "$ZONE_ID_JKLASEN_DE" "A" "www.jklasen.de" "192.0.2.1" "" "true"

# Google Workspace MX
create_dns "$ZONE_ID_JKLASEN_DE" "MX" "jklasen.de" "aspmx.l.google.com" "1"
create_dns "$ZONE_ID_JKLASEN_DE" "MX" "jklasen.de" "alt1.aspmx.l.google.com" "5"
create_dns "$ZONE_ID_JKLASEN_DE" "MX" "jklasen.de" "alt2.aspmx.l.google.com" "5"
create_dns "$ZONE_ID_JKLASEN_DE" "MX" "jklasen.de" "aspmx2.googlemail.com" "10"

# SPF
create_dns "$ZONE_ID_JKLASEN_DE" "TXT" "jklasen.de" "v=spf1 include:_spf.google.com ~all"

# DMARC
create_dns "$ZONE_ID_JKLASEN_DE" "TXT" "_dmarc.jklasen.de" "v=DMARC1; p=none; rua=mailto:dmarc-reports@jklasen.de"

# DKIM
if [[ "$DKIM_KEY_JKLASEN_DE" != *"DEIN_"* ]]; then
    create_dns "$ZONE_ID_JKLASEN_DE" "TXT" "google._domainkey.jklasen.de" "$DKIM_KEY_JKLASEN_DE"
else
    log_warn "DKIM für jklasen.de übersprungen — Key fehlt"
fi

log_step "Redirect Rule anlegen..."
create_redirect_rule "$ZONE_ID_JKLASEN_DE" "jklasen.de" "$REDIRECT_TARGET"

# =============================================================================
# 2. jklasen.com — Google Workspace + Redirect
# =============================================================================

log "2/6 — jklasen.com (Google Workspace + Redirect)"

log_step "SSL-Modus setzen..."
set_ssl_mode "$ZONE_ID_JKLASEN_COM" "full"
set_always_https "$ZONE_ID_JKLASEN_COM"

log_step "DNS-Einträge anlegen..."

create_dns "$ZONE_ID_JKLASEN_COM" "A" "jklasen.com" "192.0.2.1" "" "true"
create_dns "$ZONE_ID_JKLASEN_COM" "A" "www.jklasen.com" "192.0.2.1" "" "true"

# Google Workspace MX
create_dns "$ZONE_ID_JKLASEN_COM" "MX" "jklasen.com" "aspmx.l.google.com" "1"
create_dns "$ZONE_ID_JKLASEN_COM" "MX" "jklasen.com" "alt1.aspmx.l.google.com" "5"
create_dns "$ZONE_ID_JKLASEN_COM" "MX" "jklasen.com" "alt2.aspmx.l.google.com" "5"
create_dns "$ZONE_ID_JKLASEN_COM" "MX" "jklasen.com" "aspmx2.googlemail.com" "10"

# SPF
create_dns "$ZONE_ID_JKLASEN_COM" "TXT" "jklasen.com" "v=spf1 include:_spf.google.com ~all"

# DMARC
create_dns "$ZONE_ID_JKLASEN_COM" "TXT" "_dmarc.jklasen.com" "v=DMARC1; p=none; rua=mailto:dmarc-reports@jklasen.com"

# DKIM
if [[ "$DKIM_KEY_JKLASEN_COM" != *"DEIN_"* ]]; then
    create_dns "$ZONE_ID_JKLASEN_COM" "TXT" "google._domainkey.jklasen.com" "$DKIM_KEY_JKLASEN_COM"
else
    log_warn "DKIM für jklasen.com übersprungen — Key fehlt"
fi

log_step "Redirect Rule anlegen..."
create_redirect_rule "$ZONE_ID_JKLASEN_COM" "jklasen.com" "$REDIRECT_TARGET"

# =============================================================================
# 3. klasen.rocks — Nur Redirect
# =============================================================================

log "3/6 — klasen.rocks (nur Redirect)"

log_step "SSL-Modus setzen..."
set_ssl_mode "$ZONE_ID_KLASEN_ROCKS" "full"
set_always_https "$ZONE_ID_KLASEN_ROCKS"

log_step "DNS-Einträge anlegen..."
create_dns "$ZONE_ID_KLASEN_ROCKS" "A" "klasen.rocks" "192.0.2.1" "" "true"
create_dns "$ZONE_ID_KLASEN_ROCKS" "A" "www.klasen.rocks" "192.0.2.1" "" "true"

log_step "Redirect Rule anlegen..."
create_redirect_rule "$ZONE_ID_KLASEN_ROCKS" "klasen.rocks" "$REDIRECT_TARGET"

# =============================================================================
# 4. vbeard.de — Nur Redirect
# =============================================================================

log "4/6 — vbeard.de (nur Redirect)"

log_step "SSL-Modus setzen..."
set_ssl_mode "$ZONE_ID_VBEARD_DE" "full"
set_always_https "$ZONE_ID_VBEARD_DE"

log_step "DNS-Einträge anlegen..."
create_dns "$ZONE_ID_VBEARD_DE" "A" "vbeard.de" "192.0.2.1" "" "true"
create_dns "$ZONE_ID_VBEARD_DE" "A" "www.vbeard.de" "192.0.2.1" "" "true"

log_step "Redirect Rule anlegen..."
create_redirect_rule "$ZONE_ID_VBEARD_DE" "vbeard.de" "$REDIRECT_TARGET"

# =============================================================================
# 5. ai-deer.de — Nur Redirect
# =============================================================================

log "5/6 — ai-deer.de (nur Redirect)"

log_step "SSL-Modus setzen..."
set_ssl_mode "$ZONE_ID_AI_DEER_DE" "full"
set_always_https "$ZONE_ID_AI_DEER_DE"

log_step "DNS-Einträge anlegen..."
create_dns "$ZONE_ID_AI_DEER_DE" "A" "ai-deer.de" "192.0.2.1" "" "true"
create_dns "$ZONE_ID_AI_DEER_DE" "A" "www.ai-deer.de" "192.0.2.1" "" "true"

log_step "Redirect Rule anlegen..."
create_redirect_rule "$ZONE_ID_AI_DEER_DE" "ai-deer.de" "$REDIRECT_TARGET"

# =============================================================================
# 6. jensklasen.de — SPF/DKIM/DMARC prüfen (Hauptdomain)
# =============================================================================

log "6/6 — jensklasen.de (E-Mail-Authentifizierung prüfen)"

log_step "Bestehende TXT-Records abrufen..."
echo ""
echo "  Aktuelle TXT-Records für jensklasen.de:"
list_dns_records "$ZONE_ID_JENSKLASEN_DE" "TXT"
echo ""

log_step "Prüfe SPF..."
spf_check=$(curl -s "$CF_API/zones/$ZONE_ID_JENSKLASEN_DE/dns_records?type=TXT&per_page=100" \
    -H "Authorization: Bearer $CF_API_TOKEN" | \
    python3 -c "
import sys, json
data = json.load(sys.stdin)
found = any('v=spf1' in r.get('content','') for r in data.get('result',[]))
print('FOUND' if found else 'MISSING')
" 2>/dev/null || echo "ERROR")

if [ "$spf_check" = "FOUND" ]; then
    log_ok "SPF vorhanden"
else
    log_warn "SPF fehlt! Lege an..."
    create_dns "$ZONE_ID_JENSKLASEN_DE" "TXT" "jensklasen.de" "v=spf1 include:_spf.google.com ~all"
fi

log_step "Prüfe DMARC..."
dmarc_check=$(curl -s "$CF_API/zones/$ZONE_ID_JENSKLASEN_DE/dns_records?type=TXT&name=_dmarc.jensklasen.de&per_page=100" \
    -H "Authorization: Bearer $CF_API_TOKEN" | \
    python3 -c "
import sys, json
data = json.load(sys.stdin)
found = any('v=DMARC1' in r.get('content','') for r in data.get('result',[]))
print('FOUND' if found else 'MISSING')
" 2>/dev/null || echo "ERROR")

if [ "$dmarc_check" = "FOUND" ]; then
    log_ok "DMARC vorhanden"
else
    log_warn "DMARC fehlt! Lege an..."
    create_dns "$ZONE_ID_JENSKLASEN_DE" "TXT" "_dmarc.jensklasen.de" "v=DMARC1; p=none; rua=mailto:dmarc-reports@jensklasen.de"
fi

log_step "Prüfe DKIM..."
dkim_check=$(curl -s "$CF_API/zones/$ZONE_ID_JENSKLASEN_DE/dns_records?type=TXT&name=google._domainkey.jensklasen.de&per_page=100" \
    -H "Authorization: Bearer $CF_API_TOKEN" | \
    python3 -c "
import sys, json
data = json.load(sys.stdin)
found = any('DKIM1' in r.get('content','') for r in data.get('result',[]))
print('FOUND' if found else 'MISSING')
" 2>/dev/null || echo "ERROR")

if [ "$dkim_check" = "FOUND" ]; then
    log_ok "DKIM vorhanden"
else
    log_warn "DKIM fehlt für jensklasen.de!"
    log_warn "Bitte DKIM-Key aus Google Workspace Admin holen und manuell anlegen:"
    log_warn "  Typ: TXT"
    log_warn "  Name: google._domainkey.jensklasen.de"
    log_warn "  Wert: (aus Admin Console → Gmail → E-Mail authentifizieren)"
fi

# =============================================================================
# ZUSAMMENFASSUNG
# =============================================================================

log "Zusammenfassung"

echo ""
echo "  DNS-Einträge angelegt für:"
echo "    • jklasen.de   (MX + SPF + DMARC + DKIM + Redirect)"
echo "    • jklasen.com  (MX + SPF + DMARC + DKIM + Redirect)"
echo "    • klasen.rocks (Redirect)"
echo "    • vbeard.de    (Redirect)"
echo "    • ai-deer.de   (Redirect)"
echo "    • jensklasen.de (SPF/DMARC geprüft/ergänzt)"
echo ""
echo "  ┌─────────────────────────────────────────────────────┐"
echo "  │  NÄCHSTE SCHRITTE (manuell):                        │"
echo "  │                                                     │"
echo "  │  1. Nameserver bei IONOS umstellen für:             │"
echo "  │     - jklasen.de                                    │"
echo "  │     - jklasen.com                                   │"
echo "  │     - klasen.rocks                                  │"
echo "  │     - vbeard.de                                     │"
echo "  │     - ai-deer.de                                    │"
echo "  │     → Auf die Cloudflare-Nameserver, die im         │"
echo "  │       Dashboard pro Domain angezeigt werden.        │"
echo "  │                                                     │"
echo "  │  2. Warten: 1–24 Stunden DNS-Propagation            │"
echo "  │                                                     │"
echo "  │  3. Testen:                                         │"
echo "  │     - E-Mail senden von jklasen.de + jklasen.com    │"
echo "  │     - E-Mail empfangen auf beiden Domains           │"
echo "  │     - https://jklasen.com im Browser → Redirect?    │"
echo "  │     - https://klasen.rocks im Browser → Redirect?   │"
echo "  │     - https://vbeard.de im Browser → Redirect?      │"
echo "  │     - https://ai-deer.de im Browser → Redirect?     │"
echo "  │                                                     │"
echo "  │  4. IONOS SSL-Pakete kündigen (spart 48€/Jahr)      │"
echo "  │                                                     │"
echo "  │  5. Falls DKIM für jensklasen.de fehlt:             │"
echo "  │     Google Workspace Admin → Gmail →                 │"
echo "  │     E-Mail authentifizieren → DKIM generieren →      │"
echo "  │     TXT-Record in Cloudflare anlegen                │"
echo "  └─────────────────────────────────────────────────────┘"
echo ""

# Verifizierung: Alle DNS-Records auflisten
log "Verifizierung — Angelegte Records"

for domain_info in \
    "jklasen.de:$ZONE_ID_JKLASEN_DE" \
    "jklasen.com:$ZONE_ID_JKLASEN_COM" \
    "klasen.rocks:$ZONE_ID_KLASEN_ROCKS" \
    "vbeard.de:$ZONE_ID_VBEARD_DE" \
    "ai-deer.de:$ZONE_ID_AI_DEER_DE"; do

    domain="${domain_info%%:*}"
    zone_id="${domain_info##*:}"

    echo ""
    echo "  ── $domain ──"
    list_dns_records "$zone_id"
done

echo ""
log "Script abgeschlossen"
