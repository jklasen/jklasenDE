# Cloudflare DNS Migration — Auftrag an Claude Code

## Kontext

Jens migriert fünf Domains von IONOS zu Cloudflare. Die Domains sind bereits in Cloudflare als Zonen angelegt (Free Plan). Die Nameserver bei IONOS werden NACH erfolgreicher Konfiguration umgestellt — nicht vorher.

## Was du tun sollst

1. Das mitgelieferte Script `cloudflare-migration.sh` im Home-Verzeichnis ablegen
2. Jens nach den Credentials fragen (siehe unten)
3. Die Credentials ins Script eintragen
4. Das Script ausführen
5. Die Ausgabe prüfen und bei Fehlern diagnostizieren
6. Nach erfolgreicher Ausführung das Script bereinigen (Credentials entfernen)

## Credentials, die Jens dir im Chat geben muss

Frage Jens nach diesen Werten — er hat sie aus dem Cloudflare Dashboard und der Google Workspace Admin Console:

```
CF_API_TOKEN=
ZONE_ID_JKLASEN_DE=
ZONE_ID_JKLASEN_COM=
ZONE_ID_KLASEN_ROCKS=
ZONE_ID_VBEARD_DE=
ZONE_ID_AI_DEER_DE=
ZONE_ID_JENSKLASEN_DE=
DKIM_KEY_JKLASEN_DE=
DKIM_KEY_JKLASEN_COM=
```

Falls Jens die DKIM-Keys noch nicht hat: Das Script kann auch ohne DKIM laufen — es überspringt DKIM dann mit einer Warnung. DKIM kann später manuell nachgetragen werden.

## Was das Script tut (Übersicht)

| Domain | Google Workspace MX | SPF/DKIM/DMARC | Redirect → jensklasen.de |
|--------|-------------------|----------------|--------------------------|
| jklasen.de | 4 MX-Records | Ja | Ja |
| jklasen.com | 4 MX-Records | Ja | Ja |
| klasen.rocks | Nein | Nein | Ja |
| vbeard.de | Nein | Nein | Ja |
| ai-deer.de | Nein | Nein | Ja |
| jensklasen.de | Prüfung nur | Prüfung + Fix | Nein (ist das Ziel) |

Pro Domain:
- SSL-Modus auf "Full" setzen
- "Always Use HTTPS" aktivieren
- DNS-Einträge anlegen (A-Dummy für Redirect, MX für Mail, TXT für SPF/DKIM/DMARC)
- Redirect Rule anlegen (301, mit Pfad-Übernahme)

## Ablauf

### Schritt 1: Script ablegen

```bash
cp ~/Downloads/cloudflare-migration.sh ~/cloudflare-migration.sh
chmod +x ~/cloudflare-migration.sh
```

Falls die Datei nicht in Downloads liegt, frage Jens wo sie ist.

### Schritt 2: Credentials eintragen

Ersetze die Platzhalter im Script mit den Werten, die Jens dir gibt. Nutze sed oder direktes Editieren:

```bash
# Beispiel (Jens gibt dir die echten Werte):
sed -i '' 's|DEIN_CLOUDFLARE_API_TOKEN_HIER|ECHTER_TOKEN|' ~/cloudflare-migration.sh
sed -i '' 's|DEINE_ZONE_ID_JKLASEN_DE|ECHTE_ID|' ~/cloudflare-migration.sh
# ... usw. für alle Platzhalter
```

### Schritt 3: Ausführen

```bash
cd ~
./cloudflare-migration.sh 2>&1 | tee cloudflare-migration-log.txt
```

Das `tee` speichert die Ausgabe in eine Log-Datei, falls Jens sie später braucht.

### Schritt 4: Ergebnis prüfen

- Jede Zeile mit ✓ = erfolgreich angelegt
- Jede Zeile mit ⚠ = existierte bereits (OK, kein Problem)
- Jede Zeile mit ✗ = Fehler — diagnostizieren

Häufige Fehler:
- "Authentication error" → API-Token falsch oder Berechtigungen fehlen
- "phase already exists" bei Redirect Rules → Es gibt schon ein Ruleset für diese Phase. Lösung: Im Cloudflare Dashboard unter Rules → Redirect Rules prüfen, ob schon eine Rule existiert, und dort manuell die neue Rule hinzufügen
- "Record already exists" → Kein Fehler, Cloudflare hat den Record beim Domain-Import schon angelegt

### Schritt 5: Bereinigung

Nach erfolgreicher Ausführung den API-Token aus dem Script entfernen:

```bash
sed -i '' 's|CF_API_TOKEN=".*"|CF_API_TOKEN="ENTFERNT"|' ~/cloudflare-migration.sh
```

Oder das Script ganz löschen:

```bash
rm ~/cloudflare-migration.sh
```

Die Log-Datei behalten:

```bash
mv ~/cloudflare-migration-log.txt ~/Documents/cloudflare-migration-log.txt
```

### Schritt 6: Verifikation (optional, nach Nameserver-Umstellung)

Nachdem Jens die Nameserver bei IONOS umgestellt hat und 1-24h gewartet hat, kann Claude Code die Konfiguration extern prüfen:

```bash
# DNS-Auflösung prüfen
for domain in jklasen.de jklasen.com klasen.rocks vbeard.de ai-deer.de; do
    echo "=== $domain ==="
    dig +short MX $domain
    dig +short TXT $domain
    dig +short TXT _dmarc.$domain
    echo ""
done

# Redirect prüfen
for domain in jklasen.de jklasen.com klasen.rocks vbeard.de ai-deer.de; do
    echo "=== $domain ==="
    curl -sI "https://$domain" 2>/dev/null | head -5
    echo ""
done

# E-Mail-Authentifizierung prüfen (nutzt Google Toolbox)
for domain in jklasen.de jklasen.com jensklasen.de; do
    echo "=== SPF für $domain ==="
    dig +short TXT $domain | grep spf
    echo "=== DKIM für $domain ==="
    dig +short TXT google._domainkey.$domain
    echo "=== DMARC für $domain ==="
    dig +short TXT _dmarc.$domain
    echo ""
done
```

## Wichtige Hinweise

- Das Script legt DNS-Einträge an, BEVOR die Nameserver umgestellt werden. Das ist sicher — Cloudflare akzeptiert die Einträge, aber sie werden erst aktiv, wenn die Nameserver auf Cloudflare zeigen.
- Die Nameserver-Umstellung bei IONOS muss Jens MANUELL machen — kein Script kann das übernehmen.
- Nach der Nameserver-Umstellung dauert es 1-24 Stunden, bis alles propagiert ist. In dieser Zeit kann E-Mail kurzzeitig gestört sein — das ist normal und löst sich von selbst.
- Die 192.0.2.1 IP im Script ist ein Cloudflare-Dummy (RFC 5737 "TEST-NET"). Sie wird nie erreicht, weil die Redirect Rule vorher greift.
