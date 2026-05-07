---
title: "RAMmageddon Teil 5: Die Landkarte — sieben Muster, an denen 2026 das Geld verdunstet"
kicker: "Future Proof Tech Briefing · Mai 2026"
date: 2026-05-05T22:00:00+02:00
author: "Jens Klasen"
readingTime: "10 Minuten"
teaser: "Sieben Muster im Rechenzentrum, in denen 2026 das Geld verdunstet — plus die Brücke über souveräne europäische Cloud-Anbieter und Open-Source-Plattformen."
---

In Teil 4 habe ich beschrieben, warum klassisches Sizing 2026 das falsche Werkzeug ist und wie die Service-Brille denselben Datensatz neu liest — Software, nicht Hardware, ist der Hebel. Die häufigste Reaktion in den Wochen danach kam in zwei Varianten:

*„Verstanden — aber wo fangen wir an?"*

Und ehrlicher: *„Hast Du eine Liste, an der wir uns abarbeiten können?"*

Heute liefere ich genau die. Sieben Muster, die in fast jedem mittelständischen Rechenzentrum in den Live-Optics-, RVTools- oder Hyper-V-Exporten sichtbar sind, sobald man weiß, wonach man sucht. Keine Empfehlung in der Tiefe — diese Beiträge folgen ab Teil 6 für die Cases, die im Markt am stärksten Resonanz erzeugen. Heute geht es um die Karte, nicht das Gelände.

## Q2-Status in einem Absatz

Die Lage hat sich seit Teil 4 nicht entspannt. DDR5-Spotpreise liegen weiter über dem Februar-Niveau, die HBM-Allokation für 2027 ist bereits weitgehend ausverhandelt, und Server-OEMs schieben Refresh-Termine erneut nach hinten. Wer im Q3 oder Q4 bestellen muss, bestellt in einen Markt, in dem Verfügbarkeit das eigentliche Gut ist — nicht der Preis. Das macht jede Stunde Discovery-Arbeit, die man jetzt investiert, wirtschaftlich um ein Vielfaches wertvoller als ein zusätzlicher Vergleichsangebot-Loop.

## Die Landkarte

Die sieben Muster gliedern sich in drei Schichten:

- **Konsumption** — wo wird Kapazität verbraucht, ohne Wert zu schaffen (UC01–UC02)
- **Modernisierung** — wo blockiert Legacy-Architektur die nächste Effizienzstufe (UC03–UC05)
- **Architektur** — wo löst eine andere Topologie das Problem strukturell (UC06–UC07)

Jede Beobachtung folgt demselben Muster: *Was sehen wir? Was bedeutet es? Welcher Hebel passt?*

---

### Use Case 01 — DB-IOPS-Hotspots

**Was wir sehen.** Eine Pareto-Verteilung über alle Datenbank-VMs: Zwanzig Prozent der DBs verursachen achtzig Prozent der IOPS-Last. Der Rest dümpelt unter zehn IOPS pro VM.

**Was es bedeutet.** Es gibt kein internes Tiering. Jede DB landet auf demselben Storage-Layer, weil die Konversation darüber nie geführt wurde. Ergebnis: Premium-Storage trägt Karteileichen, während die produktiven Hotspots dieselben Latenzbudgets bekommen wie ein Test-System.

**Welcher Hebel.** Tier-Trennung mit Resource Governance in der DB-Engine, NVMe gezielt für die Hotspots, Cold-Tier für den Rest. Häufig öffnet das die Tür zu Query-Optimierung — manche Hotspots sind keine, sie sind schlecht geschriebene Joins.

---

### Use Case 02 — Zombie-VMs

**Was wir sehen.** VMs mit `Date Provisioned` älter als drei Jahre, `Boot Time` vor wenigen Tagen, Active-CPU dauerhaft unter ein Prozent, kein Login-Traffic, keine Backup-Job-Last.

**Was es bedeutet.** Projekte, die nie offiziell beendet wurden. Test-Umgebungen aus Migrationen, die niemand löscht, weil niemand sich zuständig fühlt. „Lassen wir lieber an, falls jemand fragt."

**Welcher Hebel.** Decommission-Welle mit klarem Veto-Fenster für Fachbereiche. Der Gewinn ist nicht nur RAM und Cores — Lizenzen, Backup-Volumen, Monitoring-Lizenzen, Patch-Management-Aufwand. Zombies sind das günstigste Aufräumen mit dem höchsten Sofort-Effekt.

---

### Use Case 03 — Legacy-OS

**Was wir sehen.** Windows Server 2012 / 2012 R2 noch im Produktivbetrieb, RHEL 6, vereinzelt sogar Server 2008 R2 mit ESU-Vertrag. Häufig auf isolierten Hosts mit dedizierter VLAN-Anbindung.

**Was es bedeutet.** Die Anwendung darüber ist der Anker — ein Branchen-ERP, eine Maschinensteuerung, ein Eigenentwicklungs-Stack ohne aktive Pflege. Migration wurde mehrfach versucht, scheiterte an Abhängigkeiten oder Budget.

**Welcher Hebel.** Replatform statt Re-Host. Die Anwendung in einen Container heben, das Legacy-OS abschalten. Wo die Anwendung containerunfähig ist: gezielter Modernisierungs-Sprint mit Vendor oder eigenem Team. Sicherheitsbudget aus dem ESU-Topf finanziert den Sprint typischerweise mit.

---

### Use Case 04 — SQL-Lizenzen

**Was wir sehen.** Dutzende kleine SQL-Server-VMs, typisch zwei bis vier vCPU, RAM zwischen 16 und 32 GB, jede für eine Anwendung. CPU-Last im Mittel unter fünfzehn Prozent.

**Was es bedeutet.** Jedes Projekt brachte seine eigene SQL-Instanz mit. Niemand hat konsolidiert, weil niemand das Lizenzmodell sauber nachrechnet. Standard Edition pro VM ist die teuerste Form, SQL Server zu betreiben, die es gibt.

**Welcher Hebel.** Consolidation auf wenige große Instanzen, Enterprise Edition mit Core-Lizenzierung, Instance-Pooling über Resource Governor. Die Hardware-Einsparung ist Nebenwirkung — die Lizenzeinsparung ist der Hauptpunkt.

---

### Use Case 05 — Container-Kandidaten

**Was wir sehen.** VMs, die ausschließlich eine einzelne Java-, Node- oder Python-Anwendung tragen. Vier vCPU, 8 GB RAM, Auslastung im niedrigen einstelligen Prozentbereich. Häufig mehrere Dutzend dieser Profile parallel.

**Was es bedeutet.** Die Anwendungen sind containerfähig — die Migration wurde nur nie priorisiert. Jede dieser VMs trägt ein vollständiges Betriebssystem, einen Hypervisor-Footprint und eine Backup-Last für eine Anwendung, die zwölfmal kleiner sein könnte.

**Welcher Hebel.** Containerisierung auf Kubernetes — egal, ob auf bestehender vSphere-Basis, auf Nutanix NKP oder direkt auf Bare Metal. Density-Faktor zehn bis zwanzig ist realistisch. Das ist der Use Case, in dem Cloud-Native Engineering als CID-Sprint den größten konkreten Hebel hat.

---

### Use Case 06 — Cloud-Bursting

**Was wir sehen.** Hosts oder Cluster, die für einen klar definierten Peak ausgelegt sind: Monatsabschluss, nächtliche Batch-Strecke, saisonales Reporting. Außerhalb dieser Fenster Auslastung im niedrigen zweistelligen Bereich.

**Was es bedeutet.** Die Kapazität ist auf den Peak dimensioniert, nicht auf den Mittelwert. Wer 95 Prozent des Jahres Leerstand bezahlt, finanziert eine Versicherung, die er auch elastisch einkaufen könnte.

**Welcher Hebel.** Hybrid-Topologie — Baseline on-prem, Peak in Public Cloud oder bei einem souveränen Provider wie STACKIT, IONOS, Hetzner. Voraussetzung: Workload-Portabilität. Genau hier verbindet sich der Use Case mit der Souveränitäts-These aus Teil 3.

---

### Use Case 07 — Datenmodernisierung als KI-Türöffner

**Was wir sehen.** Gewachsenes Data Warehouse auf Oracle oder MSSQL, mehrere Terabyte in Silos, nächtliche ETL-Ketten, die halbe Nächte belegen. Fachbereich wartet zwei bis drei Tage auf neue Reports. KI-Initiativen scheitern, weil niemand sauber an die Daten kommt.

**Was es bedeutet.** Das Data Warehouse ist nicht nur teuer — es ist der Grund, warum der Kunde keinen eigenen KI-Use-Case ans Laufen bringt. Beide Probleme haben dieselbe Wurzel: Architektur aus den 2010ern.

**Welcher Hebel.** Modern Data Stack mit Iceberg als Tabellenformat, Dremio oder Starburst als Query-Engine, Federation statt Migration. Eigenes LLM mit RAG auf dem Lakehouse — „Chat with your own data" — bleibt im Haus, ohne Daten in Hyperscaler-Modelle zu schicken. Datenmodernisierung schlägt drei Fliegen auf einmal: Hardware, Betrieb, AI-Readiness.

---

## Hotspot-Matrix

Wer alle sieben Cases parallel angeht, verzettelt sich. Die folgende Lesart hat sich als Priorisierungs-Anker bewährt — je Case drei Dimensionen: Business-Relevanz, Optimierungs-Potenzial, Zeit-zum-Hebel.

- **01 DB-IOPS-Hotspots** — Relevanz hoch · Potenzial hoch · Zeit kurz
- **02 Zombie-VMs** — Relevanz niedrig · Potenzial hoch · Zeit kurz
- **03 Legacy-OS** — Relevanz mittel · Potenzial mittel · Zeit lang
- **04 SQL-Lizenzen** — Relevanz mittel · Potenzial hoch · Zeit mittel
- **05 Container** — Relevanz mittel · Potenzial hoch · Zeit mittel
- **06 Cloud-Bursting** — Relevanz hoch · Potenzial mittel · Zeit mittel
- **07 Datenmodernisierung** — Relevanz hoch · Potenzial hoch · Zeit lang

Die Quick Wins sitzen oben: Zombies aufräumen, IOPS-Hotspots adressieren, SQL-Lizenzen konsolidieren. Der strategische Hebel sitzt unten — Datenmodernisierung braucht längere Vorlaufzeit, liefert dafür den größten Effekt, weil er Effizienz-Thema und KI-Wachstums-Thema in einer Bewegung adressiert.

## Die Brücke: Souveräne Cloud als Übergangs- und Ziel-Architektur

Die sieben Cases zeigen, wo der Hebel sitzt — aber Modernisierung ist ein Marathon. Ein SQL-Konsolidierungs-Projekt dauert sechs Monate, ein Lakehouse-Refactoring zwölf bis achtzehn. Was passiert mit der Last, die heute kommt, wenn die Hardware nicht verfügbar ist und die Software noch nicht so weit?

Historisch waren Hyperscaler die Brücke. AWS, Azure und GCP nahmen Last auf, während on-prem umgebaut wurde. Der Preis dafür ist 2026 deutlich klarer als 2020: Datenabfluss, Vendor-Lock-in, Lizenz-Komplikationen bei Microsoft, Oracle und SAP — und seit den US-Section-232-Zöllen und der Iran-Eskalation auch eine geopolitische Exposition, die für KRITIS, regulierte Branchen und mittelständische IP-Träger nicht mehr neutral ist.

Souveräne deutsche und europäische Cloud-Anbieter haben in den letzten zwei Jahren technisch und kommerziell aufgeschlossen. Eine Auswahl mit kurzer Charakterisierung:

- **STACKIT** — Schwarz-Gruppe, voll deutscher Stack, SAP-affin, BSI-konform
- **IONOS Cloud** — deutscher Anbieter, breites IaaS/PaaS-Portfolio, Made in Germany
- **Hetzner** — preislich aggressiv, starke Bare-Metal- und VM-Basis, Standorte in Deutschland und Finnland
- **plusserver** — deutscher Multi-Cloud-Spezialist mit Managed-Services-Tiefe, KRITIS-erfahren
- **OVHcloud** — französischer Anbieter, EU-weit, eigene Rechenzentren
- **Open Telekom Cloud** — Deutsche Telekom, OpenStack-Basis, gewachsene KRITIS-Kundschaft

Alle sechs operieren in deutschem oder europäischem Rechtsraum, ohne CLOUD-Act-Exposure, mit klarer Datenresidenz.

Damit die Brücke nicht selbst zum Lock-in wird, braucht es eine portable Plattform-Schicht. Open-Source-Stacks liefern genau das: Kubernetes mit Distributionen wie NKP, OpenShift, Rancher oder Kubermatic, KubeVirt für VM-Workloads, die noch nicht containerfähig sind, Ceph für Storage. Wer Workloads auf diesen Plattformen aufsetzt, kann sie zwischen Private Cloud, souveräner externer Cloud und — falls strategisch sinnvoll — auch Hyperscaler bewegen, ohne neu zu engineeren.

Damit verschiebt sich der Charakter der Brücke. Was als Atempause für die Modernisierung gedacht war, wird zur dauerhaften Topologie: Private Core für Daten und Workloads, die im Haus bleiben sollen — souveräne externe Cloud für Peaks, neue Use Cases, Time-to-Market-Sprints. Workloads pendeln je nach Lastprofil, nicht je nach Vertragsbindung. Aus „Private *oder* Cloud" wird „Private Core *plus* souveräne Cloud".

Das ist die Definition von Souveränität, die in dieser Serie trägt: Souveränität heißt nicht keine Cloud — sondern die Freiheit, jederzeit den Anbieter zu wechseln. Wer auf souveräne europäische Provider und Open-Source-Plattformen setzt, kauft sich genau diese Freiheit — und überbrückt die RAMmageddon-Lücke in derselben Bewegung.

## Was als nächstes kommt

Drei dieser Cases lohnen einen eigenen, tiefen Beitrag — und genau dort führt die Serie hin:

- **Teil 6: Datenmodernisierung als KI-Türöffner.** Wie ein Lakehouse-Refactoring nicht nur Hardware spart, sondern den eigenen KI-Use-Case erst möglich macht. Mit konkreter Referenz aus einem CID-Projekt.
- **Teil 7: Vom Java-Monolithen zu Kubernetes-Density.** Warum Container-Migration 2026 kein Innovations-, sondern ein Effizienz-Thema ist — und wo der Density-Faktor zehn realistisch wird.
- **Teil 8: DB-IOPS-Tiering in der Praxis.** Pareto-Lesung, Resource Governance, NVMe-Targeting — und warum die Query-Optimierung am Ende der wichtigste Hebel ist.

Die Reihenfolge ist nicht zufällig gewählt: Teil 6 öffnet die Brücke zur AI-Diskussion, in der die meisten Mittelständler 2026 stehen — und macht aus einem Effizienz-Thema ein Wachstums-Thema.

## Soft-CTA

Wer das in eigenen Zahlen sehen will: Wir machen genau das bei CID. Discovery-Run mit Eurem Live-Optics-, RVTools- oder Hyper-V-Export, Lesart durch die Service-Brille, Hotspot-Report mit klarer Priorisierung. Anfragen gerne über Direktnachricht.

Und: Wenn einer der sieben Cases bei Euch besonders sitzt — schreibt es in die Kommentare. Die Reihenfolge der nächsten Beiträge passe ich gerne an dem an, wo der Druck am größten ist.
