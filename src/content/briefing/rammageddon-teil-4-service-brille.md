---
title: "RAMmageddon Teil 4: Hardware-Brille runter, Service-Brille auf"
kicker: "Future Proof Tech Briefing · April 2026"
date: 2026-04-30
author: "Jens Klasen"
readingTime: "6 Minuten"
teaser: "Warum klassisches Sizing 2026 das falsche Werkzeug ist — und wie eine andere Lesart desselben Datensatzes das Refresh-Budget rettet."
---

Sechs Wochen nach Teil 3 hat sich vieles bestätigt — und eine Frage hat sich aus den Antworten herauskristallisiert. Sie kam von CTOs, IT-Leitern, einem CFO und sogar von zwei Architekten, die in ihrem Alltag mit Refresh-Tickets zu tun haben. Sie klingt jedes Mal anders, aber im Kern immer gleich:

*„Wir haben verstanden, dass wir modernisieren sollen. Aber wo fangen wir an?"*

Genau darum geht es heute.

## Q2 2026: Die Prognose hat recht behalten

Kurzer Status, ohne Wiederholung der ersten drei Teile. TrendForce hat seine Q2-Prognose veröffentlicht: Server-DRAM ist im laufenden Quartal weitere rund 60 Prozent gestiegen. NAND-Allokationen für 2026 sind in den meisten Kategorien dicht. Hyperscaler verhandeln 2027er-Kontingente. Intel und AMD melden weiterhin Lieferzeiten von sechs Monaten für Standard-Server-CPUs.

Die strukturelle Krise, die ich im Januar als These geschrieben habe, ist heute Selbstverständlichkeit. Niemand, mit dem ich aktuell spreche, fragt mehr „ist das wirklich so dramatisch". Alle fragen „was machen wir jetzt".

## Die unbequeme Beobachtung aus den Kundengesprächen

In den letzten Wochen habe ich mit einigen IT-Verantwortlichen gesprochen. Ein Muster zieht sich durch fast alle Termine:

**Die Diagnose ist da. Was fehlt, ist die Linse, durch die man die eigene Umgebung lesen kann.**

Die Standard-Werkzeuge in den meisten Rechenzentren sind Sizing-Tools von Hardware-Herstellern. Sie beantworten exakt eine Frage: *Welche Box passt 1:1 für den Refresh?* Sie sammeln CPU, RAM, IOPS, Latenz — und mappen das auf die nächste Generation aus dem Hersteller-Portfolio.

Was sie nicht beantworten: Welche Software treibt die Last? Wo sind Hotspots, die sich modernisieren statt austauschen lassen? Was an dem Workload, der gerade einen Server ausreizt, ist über die Jahre gewachsen, was ist notwendig, was ist Müll?

Genau dafür gibt es kein Standard-Tool. Es gibt nur eine andere Lesart desselben Datensatzes.

## Zwei Brillen, ein Datensatz

Stellt euch vor, ein Discovery-Tool sammelt sieben Tage lang Telemetrie aus eurem vCenter, eurem Hyper-V-Cluster oder eurer Linux-Flotte. Hostnamen, OS, CPU-Sockets, RAM, IOPS, Latenz, VMs, Boot-Times, Provisioning-Daten, Anwendungssignaturen. Nicht-invasiv, ohne Eingriff in den Betrieb.

**Mit der Hardware-Brille** ergibt das Bild:

- 9 Hosts, jeweils 768 GB RAM, in Summe 284 Cores
- Peak-Auslastung im 95. Perzentil
- Storage liefert rund 3.300 IOPS, Latenz an der Schmerzgrenze
- Empfehlung: gleiche Klasse, neue Generation, mehr RAM, All-Flash — Listenpreis Q2 2026 (zähneknirschend)

**Mit der Service-Brille** ergibt derselbe Datensatz:

- Nur 27 Prozent des installierten RAM wird tatsächlich genutzt
- 14 Prozent der VMs haben seit über 480 Tagen nicht rebootet
- Drei VMs erzeugen 65 Prozent der Storage-Last
- 22 Prozent der VMs laufen auf End-of-Life-Betriebssystemen
- Mehrere Dutzend VMs sind gleichartige Apps mit identischem OS-Stack — Container-Kandidaten ohne Diskussion
- Empfehlung: erst modernisieren, dann schlanker dimensionieren, dann beschaffen

Es ist derselbe Datensatz. Es ist eine andere Frage. Und es ist die einzige Brille, mit der man 2026 noch ein Refresh-Budget verteidigen kann, das nicht für gestrige Architektur zu heutigen Preisen draufgeht.

## Sechs Linsen, in denen der Refresh-Bericht euch überliest

Was die Service-Brille konkret tut, lässt sich auf sechs Lese-Linsen herunterbrechen. Jede davon zeigt etwas, das ein klassischer Sizing-Bericht systematisch ignoriert.

**1. Naming Conventions.** VM-Namen verraten Business-Kontext. *SAP-PROD-01, ERP-DB-04, TEST-OLDPROJ-2020, MIGRATION-TMP-18.* In jedem Rechenzentrum ist die Namensliste eine Landkarte der Vergangenheit — und der Stellen, an denen Sanierung lohnt.

**2. Provisioned vs. Active Memory.** Der häufigste Hebel überhaupt. Ein typisches Bild: Hosts mit 768 GB RAM, davon vergeben 700, davon tatsächlich aktiv 200. Der Kunde zahlt seit Jahren Lizenzen, Strom und Hardware für 500 GB Luft.

**3. Boot Time und Date Provisioned.** VMs, die seit 18 Monaten nicht neu gestartet wurden. VMs, die 2019 für ein Projekt provisioniert wurden, das 2020 endete. Zombie-Workloads, die jeden Refresh überleben, weil niemand mehr weiß, wer der Owner ist.

**4. Applications und OS-Distribution.** Wie viel Prozent der VMs laufen auf Windows Server 2012 R2? Wie viele Datenbanken sind noch SQL Server 2014? Welche Linux-Distributionen sind End-of-Life? Audit-Risiko, Lizenz-Ineffizienz und Modernisierungs-Hebel stehen in derselben Tabelle.

**5. Workload Concentration.** Pareto schlägt überall durch: in fast jedem Rechenzentrum erzeugen weniger als zehn Prozent der VMs den Großteil der IOPS-Last. Ein All-Flash-Array für die ganze Umgebung zu kaufen ist die teuerste Antwort auf ein Drei-VM-Problem.

**6. Datastore-Mapping.** Welche VMs teilen sich welche Storage-Pools? Wo liegen die Konsolidierungs-Potentiale, die ein Sizing-Tool nie sieht, weil es nur fragt „wie viel Speicher brauchen wir nächstes Jahr"?

Sechs Linsen, ein Datensatz, eine völlig andere Konversation mit dem CFO.

## Ein Belegstück aus dem Feld

Das klingt theoretisch. Es ist es nicht. Eine anonymisierte Hyper-V-Umgebung, die ein Hersteller in seiner eigenen Discovery-Referenz dokumentiert hat — neun Hosts, fünf Tage Datensammlung:

- 9 Zwei-Sockel-Hosts, je 36 Cores und 768 GB RAM
- In Summe 284 Cores, 6,9 TB RAM
- 78 Gast-VMs, alle Windows Server 2019
- Compellent-Storage hybrid, iSCSI über 10 GbE

Das ist die Hardware-Sicht. Jetzt die Service-Sicht aus denselben fünf Tagen:

- **27 Prozent RAM-Auslastung.** 1,56 TiB tatsächlich aktiv von 5,62 TiB installiert.
- **23 Prozent CPU-Auslastung.** 195 GHz im Peak von 844 GHz verfügbar.
- **3.329 IOPS** im 95. Perzentil — bei einem hybriden Storage-Setup, das längst zur Bremse geworden war.
- **100 Prozent Windows Server 2019** — Modernisierungs-Stillstand seit Jahren.

Die Diagnose des Hersteller-Architekten lautete wörtlich: *„Alte Umgebung war zu groß dimensioniert. VMs waren zu klein provisioniert. Storage bremste."*

Das ist kein Sizing-Befund. Das ist eine Architektur-Diagnose. Und genau deshalb war die Antwort nicht „kauft denselben Stack neu", sondern „konsolidiert auf ein Drittel weniger Hosts mit weniger Cores, höherer Frequenz, mehr RAM pro Host und schnellem NVMe-Storage".

**Ein Drittel weniger Hardware bei gleicher Leistung. Das geht nur mit der Service-Brille.**

## Was das für eure Refresh-Planung bedeutet

Drei konkrete Konsequenzen, die ich gerade jedem Kunden mitgebe:

**Erstens:** Bevor ihr ein Sizing-Angebot anfragt, lasst eine Discovery laufen. Die Werkzeuge sind verfügbar, die Hürde ist niedrig — Management-System-Zugriff genügt, Laufzeit zwischen 24 Stunden und sieben Tagen, kein Eingriff in den Betrieb.

**Zweitens:** Lasst die Auswertung von jemandem machen, der die Service-Brille mitbringt. Hardware-Partner liefern Discovery-Tools — sie liefern keine Architektur-Lesart. Beides braucht es. Die Trennung ist nicht zufällig.

**Drittens:** Akzeptiert, dass das Ergebnis unbequem sein wird. Wer fünf Tage Telemetrie ehrlich liest, findet Zombies, Über-Provisionierung, Legacy-Hotspots, Lizenz-Verschwendung. Die schlechte Nachricht: das ist viel Aufräum-Arbeit. Die gute Nachricht: jeder dieser Punkte ist ein Hebel, der Hardware-Budget freisetzt.

Wer 2026 den Refresh auslöst, ohne vorher seine Architektur zu lesen, finanziert nicht seine eigene IT — er finanziert die KI-Marge der Hyperscaler über die Komponenten-Lieferkette. Das ist hart, aber nach drei Newsletter-Teilen sollte das niemanden mehr überraschen.

## Was als Nächstes kommt

In Teil 5 gehen wir in die Tiefe der Use Cases. Sieben konkrete Muster, die wir in fast jeder Umgebung wiederfinden — von Zombie-VMs über Datenbank-Hotspots bis zum Lakehouse als Antwort auf das gewachsene Data Warehouse. Mit Zahlen, mit Beispielen, mit klaren Modernisierungs-Hebeln.

Bis dahin zwei Fragen an euch:

Wer von euch hat im Q2 schon eine Discovery laufen lassen — und was war der größte Aha-Moment im Bericht?

Und: Welche Hotspot-Kategorie schmerzt in eurer Umgebung am meisten — Lizenzen, Legacy-OS, Storage-Hitze, Zombies, Über-Provisionierung?

Schreibt mir gerne. Aus solchen Antworten entstehen die nächsten Beiträge.

Bis Teil 5.
