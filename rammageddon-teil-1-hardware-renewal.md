---
title: "RAMmageddon Teil 1: Hardware-Renewal 2026 — Zeit für Vorbereitung, nicht für Panik-Bestellungen"
description: "Eine strukturelle Speicherknappheit, getrieben vom KI-Ausbau, verändert die Hardware-Beschaffung 2026 grundlegend. Warum die richtige Antwort nicht in Lift-and-Shift liegt, sondern in Architektur-Arbeit, die wir uns nie zuvor leisten konnten."
pubDate: 2026-02-10
slug: "rammageddon-teil-1-hardware-renewal"
tags: ["rammageddon", "hardware-crisis", "right-sizing", "private-cloud", "infrastructure"]
readingTime: 8
section: "Future Proof Tech Briefing"
draft: false
---

In meinem letzten Beitrag habe ich über unseren Tech-Refresh und die Pläne für 2026 gesprochen. Doch seit Jahresbeginn hat sich die Lage auf dem Hardware-Markt dramatisch verschärft — und das wird jedes Infrastruktur-Projekt in diesem Jahr direkt betreffen. Wer jetzt Server-Hardware bestellen muss, steht vor einer bitteren Realität.

## Die Fakten: Eine Krise, die sich gewaschen hat

Was wir gerade erleben, hat die Branche als „RAMmageddon" getauft — und der Name ist Programm.

Samsung hat die Preise für Server-DRAM (DDR5) seit September 2025 um bis zu 60 Prozent angehoben. DRAM-Kontraktpreise sind im Jahresverlauf 2025 um insgesamt rund 170 Prozent gestiegen. Dell, Lenovo, HP und HPE haben Preiserhöhungen von 15 bis 20 Prozent für Server angekündigt — teils bereits seit Dezember 2025 wirksam. Intel warnt vor CPU-Lieferzeiten von bis zu sechs Monaten. SK Hynix meldet: HBM-, DRAM- und NAND-Kapazitäten sind bis Ende 2026 ausverkauft. IDC prognostiziert im pessimistischen Szenario einen Markteinbruch von bis zu 9 Prozent.

Dell COO Jeff Clarke bringt es auf den Punkt: „This is the worst shortage I have ever witnessed."

Der Grund? Die KI-Infrastruktur verschlingt alles. Bis zu 70 Prozent der weltweit produzierten Speicherchips werden 2026 in Rechenzentren der Hyperscaler fließen. Hersteller wie Samsung, SK Hynix und Micron haben ihre Produktionskapazitäten massiv auf hochmargige HBM- und KI-Chips umgeschichtet — auf Kosten von „normalem" DDR5 und DDR4 für Enterprise-Server. Micron hat sogar seine 30 Jahre alte Consumer-Marke Crucial eingestellt, um sich voll auf den KI-Markt zu konzentrieren. Silicon Motion CEO Wallace C. Kou fasst es zusammen: „We're facing what has never happened before: HDD, DRAM, HBM, NAND… all in severe shortage."

Das ist keine temporäre Delle — das ist eine strukturelle Umverteilung der globalen Halbleiter-Kapazitäten.

## Ein Covid-Effekt auf das Rechenzentrum

Die Parallelen zur Covid-bedingten Chipkrise sind nicht übertrieben — das Wall Street Journal zieht sie bereits selbst. Aber diesmal ist die Ursache nicht eine Pandemie, sondern ein KI-getriebener Nachfrageschock, der alle Segmente gleichzeitig trifft: DRAM, NAND, HDDs, CPUs, sogar Glasgewebe für die Chip-Produktion.

Für IT-Organisationen, die 2026 Hardware-Refreshes geplant haben, bedeutet das konkret: längere Lieferzeiten, kürzere Angebotsgültigkeiten, explodierende Budgets — und sehr schwierige Gespräche mit dem CFO.

## Supportverlängerungen: Sinnvolle Brücke, nicht Notlösung

Meine erste Empfehlung ist pragmatisch: Supportverlängerungen auf bestehende Systeme sind jetzt nicht nur eine Notlösung — sie sind eine strategisch sinnvolle Maßnahme. Sie verschaffen Dir Zeit, ohne Dich in überteuerte Bestellungen zu drängen.

Aber — und das ist der entscheidende Punkt — diese gewonnene Zeit muss aktiv genutzt werden.

## Die eigentliche Chance: Jetzt planen, wofür wir nie Zeit hatten zu planen

Wann hatten wir zuletzt in der IT die Ruhe, bestehende Architekturen und Softwarelösungen wirklich von Grund auf zu überdenken? Eigentlich nie. Es war immer: altes System raus, neues rein, Lift-and-Shift, weiter im Takt.

Genau hier liegt die Chance in der Krise.

Proof of Concepts und Minimum Viable Products — jetzt.

Nutze die erzwungene Pause, um intensiv an der zukünftigen Architektur zu arbeiten. Prüfe, ob Technologien wie Virtualisierung, oder auch KubeVirt, moderne SDN-Konzepte oder containerisierte Plattformen für Deine Workloads geeignet sind. Analysiere, wo überdimensionierte Infrastrukturen Kosten verursachen — nicht nur bei VMware, sondern über die gesamte Softwarelandschaft hinweg.

Wir bei der CID machen genau das: Wir fahren aktuell POCs über mehrere Brandabschnitte, testen unter realer Last und gewinnen Erkenntnisse, die kein Datenblatt liefern kann.

## Und bitte: Kein panischer Lift-and-Shift in die Cloud

Ich höre es schon: „Dann gehen wir halt in die Cloud." Aber ein unvorbereiteter Lift-and-Shift ist keine Lösung — er ist eine Kostenfalle. Wer seine überdimensionierte On-Prem-Infrastruktur 1:1 in die Cloud hebt, zahlt am Ende sogar mehr als für überteuerte Server. Die Ineffizienzen wandern einfach mit — nur dass Du jetzt monatlich dafür bezahlst statt einmalig.

Cloud-Migration macht Sinn — aber nur mit einer durchdachten Architektur, Right-Sizing und einer klaren Strategie. Und genau die kannst Du jetzt entwickeln.

## Vorbereitung ist die beste Alternative

Wenn sich die Preise wieder beruhigen — und das werden sie irgendwann — bist Du vorbereitet. Du bestellst dann wirklich das, was benötigt wird. Nicht so viel wie möglich, sondern so viel wie nötig. Das ist echter Right-Sizing-Ansatz.

Die Formel lautet:

Support verlängern → Architektur überdenken → POCs durchführen → gezielt bestellen.

Wer jetzt in Panik bestellt, zahlt Premium-Preise für eine Architektur von gestern. Wer jetzt plant, investiert in eine Architektur von morgen — zu den Preisen von morgen.

---

*Quellen: Tom's Hardware („Data centers will consume 70% of memory chips in 2026"); TrendForce („Dell Hikes Prices 15-20%, Lenovo from January 2026"); Tom's Hardware („Intel, AMD server CPUs suffering from supply shortages"); Network World („Server memory prices could double by 2026"); TechWire Asia („Memory chip shortage 2026 reaches crisis levels"); Dataconomy („Global Memory Chip Shortage to Drive Up Tech Prices in 2026"); Wikipedia („2024–present global memory supply shortage").*
