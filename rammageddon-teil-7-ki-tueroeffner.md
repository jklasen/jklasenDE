---
title: "RAMmageddon Teil 7: Vom Data Warehouse zum KI-Türöffner"
description: "Warum Datenmodernisierung 2026 drei Fliegen mit einer Klappe schlägt — Hardware-Footprint, Lizenzkosten und KI-Readiness in einer Architekturbewegung."
pubDate: 2026-05-28
slug: "rammageddon-teil-7-ki-tueroeffner"
tags: ["rammageddon", "data-modernization", "lakehouse", "ki", "souveränität"]
readingTime: 12
section: "Future Proof Tech Briefing"
image: "/images/briefing/rammageddon-teil-7-cover.jpg"
draft: false
---

In Teil 6 habe ich versucht, das Wort „Krise" zu beerdigen. Was wir 2026 erleben, ist kein vorübergehender Engpass — es ist ein struktureller Reset. Eine dauerhafte Neuverteilung der Wafer-Kapazität, in der die KI-Industrie siebzig Prozent dessen aufkauft, was die Memory-Hersteller produzieren. Wer darauf wartet, dass sich das Pendel zurückbewegt, plant gegen eine Realität, die nicht eintreten wird.

Aus dieser Diagnose folgt eine unbequeme Konsequenz: Hardware ist kein Puffer mehr. Software-Ineffizienz lässt sich nicht mehr wegkaufen. Wer 2026 sein Rechenzentrum effizient halten will, muss dort ansetzen, wo die Ineffizienz historisch versteckt ist — in der Daten- und Anwendungsschicht.

Genau dorthin geht Teil 7. Konkret zu einem Hotspot, der in fast jedem mittelständischen Rechenzentrum existiert, aber selten als RAMmageddon-Problem erkannt wird: das gewachsene Data Warehouse.

In Teil 5 habe ich es als Use Case 07 in der Landkarte angedeutet — Datenmodernisierung als KI-Türöffner. Heute zeigen wir, was das konkret heißt. Anhand eines anonymisierten, archetypischen Projektbildes, wie wir es bei mittelständischen Maschinenbauern in DACH wiederholt antreffen.

## Der Archetyp, an dem ich das festmache

Stell Dir einen klassischen DACH-Maschinenbauer im gehobenen Mittelstand vor. Exportstark, weltweite Service-Organisation, eine große installierte Basis bei Kunden in vielen Ländern. Das Service- und Ersatzteilgeschäft ist strategisch — die Marge im Aftermarket ist häufig höher als im Neugeschäft, und die Bindung an die Marke entscheidet sich über die Zeit nach dem Maschinenkauf.

Die IT-Landschaft ist typisch für diesen Mittelstand: gewachsen, funktional, an vielen Stellen modernisierungsbedürftig. Ein SAP-Backbone, daneben ein PLM-System, ein eigenes MES auf den Werksböden, eine IoT-Plattform für die Telemetrie-Daten aus den installierten Maschinen, ein CRM. Und in der Mitte des Ganzen: ein historisch gewachsenes Data Warehouse.

Oracle Database, irgendwann ab Mitte der 2010er aufgebaut, inzwischen migriert auf eine moderne Version, mehrere Terabyte produktive Datenmenge. ETL-Strecken über eines der etablierten kommerziellen Tools, nächtliche Ladezyklen mit mehrstündigem Fenster. Daneben weitere SQL-Welten aus Akquisitionen — selten sauber integriert, meist parallel betrieben. Reports laufen über zwei oder drei BI-Tools, je nach Fachbereich und Historie.

Das funktioniert. Es funktioniert seit Jahren. Aber es funktioniert mit Reibungsverlust, der niemandem mehr auffällt — weil sich alle daran gewöhnt haben.

## Was Discovery zeigt

Wir gehen in solchen Umgebungen mit der Service-Brille aus Teil 4 an die Sache. Mehrere Tage Datensammlung, vCenter- und Datenbank-Telemetrie. Drei Befunde, die wir in unterschiedlicher Konstellation in praktisch jedem mittelständischen DWH-Setup wiederfinden.

**Erstens:** Das Verhältnis aus Read- und Write-Workload auf dem Oracle-DWH ist drastisch verschoben. Mehr als achtzig Prozent der Datenbankaktivität sind Read-Queries — Reports, Ad-hoc-Analysen, BI-Tool-Pulls, Tableau-Extracts. Die nächtlichen ETL-Strecken schreiben einmal viel, danach wird tagsüber massiv gelesen. Genau die Workloads, für die Oracle EE inklusive Partitioning, Advanced Compression und Active Data Guard lizenziert ist.

**Zweitens:** Die Wartezeit für neue Reports beträgt regelmäßig mehrere Werktage. Das ist kein technisches Problem im engeren Sinn — es ist ein organisatorisches. Jede neue Auswertung braucht Anpassungen in der ETL-Logik, im Datenmodell, in den BI-Cubes. Ein Engpass beim Data-Engineering-Team, das gleichzeitig die nächtlichen Ladezyklen betreut und das nächste Migrationsprojekt vorbereitet.

**Drittens — und das ist der entscheidende Befund:** Eine seit Monaten oder Jahren verfolgte KI-Initiative — Predictive Maintenance, Ersatzteil-Forecasting, ein Service-Assistent — kommt nicht in die Operationalisierung. Sie scheitert nicht an Modellen, nicht an Algorithmen, nicht am Budget. Sie scheitert daran, dass die Daten nicht zugänglich sind. Maschinendaten liegen in der IoT-Plattform. Service-Historie liegt im CRM. Ersatzteilbewegungen liegen im ERP. Ausfallprotokolle liegen in einer Excel-getriebenen Schatten-IT der Service-Organisation. Niemand bringt das in eine Form, mit der ein Modell trainieren oder eine Inferenz laufen könnte.

Das ist nicht das Problem eines einzelnen Kunden. Das ist das Muster.

## Warum KI-Projekte im Mittelstand strukturell scheitern

Ich sehe diesen Pattern bei einer hohen einstelligen Zahl an Kundengesprächen pro Monat. Jeder Mittelständler in DACH hat 2026 eine KI-Initiative auf der Roadmap. Predictive Maintenance, Ersatzteil-Forecasting, automatisierte Service-Assistenten, Vision-Modelle für die Qualitätssicherung. Die Use Cases sind solide, die Modelle sind verfügbar, die Hardware kann man — mit den Einschränkungen aus den ersten sechs Teilen dieser Serie — beschaffen.

Was fehlt, ist nicht die KI. Was fehlt, ist die Datenarchitektur, auf der eine KI überhaupt anlaufen kann.

Die gewachsene Landschaft aus Teil 5 — Data Warehouse, ETL-Strecken, BI-Tools, Silo-Datenbanken aus Akquisitionen — ist auf die Geschäftslogik von vor zehn Jahren optimiert. Sie ist gebaut, um vordefinierte Reports zu liefern. Sie ist nicht gebaut, um in Echtzeit oder Quasi-Echtzeit Daten aus mehreren Quellen zu kombinieren, an Vektorindizes weiterzureichen, oder als Kontextquelle für ein Retrieval-Augmented-Generation-Setup zu dienen.

Wer auf dieser Architektur einen KI-Use-Case starten will, baut praktisch immer denselben Workaround: Ein Data Engineer extrahiert Daten aus den Quellsystemen, schreibt sie in eine flache Datei, bereinigt sie manuell, lädt sie in ein Notebook, trainiert ein Modell. Drei Monate später ist das Modell veraltet, weil niemand den Prozess wiederholbar gemacht hat. Der POC scheitert nicht am Modell — er scheitert an seiner eigenen Nicht-Operationalisierbarkeit.

Das ist der Grund, warum die KI-Welle im Mittelstand 2026 langsamer kommt, als die Vendor-Folien suggerieren. Nicht weil die Technologie nicht reif wäre. Sondern weil die Datenarchitektur ein Engpass ist, den niemand priorisiert hat.

## Die Architektur-Antwort: Lakehouse als semantische Schicht

Was wir in solchen Konstellationen architektonisch vorschlagen, ist keine Migration. Es ist eine zusätzliche Schicht — und genau diese Unterscheidung ist entscheidend.

Konkret: Ein Lakehouse, das die bestehenden Quellsysteme nicht ablöst, sondern föderiert. Apache Iceberg als offenes Tabellenformat. Parquet als Speicherformat auf einem S3-kompatiblen Object Storage im eigenen Rechenzentrum — etwa ein MinIO-Cluster auf bestehender Hardware. Eine Query-Engine wie Dremio oder Starburst als Zugriffspunkt für analytische Last und als föderierter Layer über Oracle, MSSQL, IoT-Plattform und ERP.

dbt für die Transformationslogik, in Code statt in proprietärer ETL-Tool-Logik versioniert. Apache Airflow für die Orchestrierung. Ein Vektorindex — etwa Qdrant oder Weaviate — für den KI-Layer. Und ein lokal betriebenes Open-Weight-Modell für die RAG-Schicht, mit dem Service-Techniker und Disponenten via Chat-Interface auf Maschinen-, Service- und Ersatzteildaten zugreifen können.

„Chat with your service data" — die Service-Organisation kann jetzt fragen, welche Maschinen in einem bestimmten Werk im letzten Quartal welche Fehlerbilder zeigten, und bekommt eine konsolidierte Antwort, die aus IoT-Plattform, CRM und ERP zusammengeführt ist. Ohne dass ein Data Engineer beteiligt sein muss. Ohne dass Daten das Haus verlassen.

Das ist die KI-Brücke, von der ich in der Serie seit Teil 3 spreche. Datenmodernisierung ist nicht das Folgeprojekt, das man nach der KI-Strategie startet. Sie ist die Voraussetzung dafür, dass die KI-Strategie überhaupt operationalisierbar wird.

## Der ehrliche Realitätscheck — was Federation NICHT spart

Hier muss ich klar werden, weil mir in den letzten Wochen mehrfach die Frage gestellt wurde: „Wenn ihr das Lakehouse nur obendrauf setzt — wie spart das Lizenzen?"

Die Antwort ist: Federation allein spart genau gar keine Lizenzen.

Wenn das Lakehouse als reine zusätzliche Abfrage-Schicht über den Quellsystemen sitzt, läuft Oracle weiter wie vorher. Die Lizenzen laufen weiter. Die Wartung läuft weiter. MSSQL läuft weiter. Die ETL-Tools laufen weiter. Ich habe eine zusätzliche Komponente in der Architektur — sie kostet erstmal Geld, sie spart erstmal nichts.

Das ist die ehrliche erste Hälfte der Geschichte. Wer Datenmodernisierung als Quick-Win für die Lizenzkostenstelle verkauft, lügt — oder verkauft eine andere Architektur als die, die im Implementierungsprojekt tatsächlich gebaut wird.

Die Einsparung kommt nicht aus der Federation. Sie kommt aus der schrittweisen Workload-Verlagerung, die das Lakehouse erst möglich macht. Und sie kommt zeitversetzt.

## Die zweite Bewegung — Read-Workloads umziehen

Mit dem Lakehouse als operativer Schicht entsteht die Möglichkeit, Read-Last vom Oracle-DWH wegzuziehen. Das ist die zweite Bewegung im Projekt, die typischerweise sechs bis zwölf Monate nach der initialen Federation startet — wenn das Lakehouse stabil läuft, wenn die Datenmodelle gut sind, wenn die Fachbereiche Vertrauen in die neue Schicht haben.

Konkret heißt das: BI-Reports werden nach und nach gegen das Lakehouse umverdrahtet. Self-Service-Analytics über Dremio statt direkt gegen Oracle. Ad-hoc-Queries der Power-User wandern in die offene Schicht. Die Stored-Procedure-Logik für die wiederkehrenden Reports wird in dbt-Modelle übersetzt.

Was vorher achtzig Prozent der Oracle-Last ausgemacht hat, läuft jetzt im Lakehouse. Und genau hier entsteht der Hebel.

Mit dramatisch reduzierter Read-Last auf Oracle werden plötzlich Optionen aktivierbar, die vorher betriebswirtschaftlich nicht gingen.

**Erstens: Oracle-Options abbestellen.** Partitioning kostet im Support typisch zwischen zehn- und fünfzehntausend Euro pro Core jährlich. Advanced Compression in derselben Größenordnung. Active Data Guard ähnlich. Diese Options waren historisch nötig, um die Read-Last performant zu bedienen. Wenn die Read-Last weg ist, sind die Options im engeren Sinn nicht mehr nötig. In typischen Mittelstandsprojekten reden wir hier über einen sechsstelligen Euro-Betrag jährlich allein aus Option-Abbestellungen.

**Zweitens: Edition-Downgrade von Oracle EE auf SE** auf den Bestandssystemen, die nicht mehr alle EE-Features brauchen. Lizenzkosten halbieren sich pro Core. Das ist nicht überall möglich — manche Workloads brauchen EE-Features unabhängig vom DWH-Layer — aber wo es möglich ist, ist der Hebel groß.

**Drittens, und das ist der eigentliche Reset: Engine-Tausch** für die Workloads, die nicht zwingend auf Oracle bleiben müssen. Transaktionale Anwendungen, die historisch auf Oracle entwickelt wurden, weil das die Konzern-Standard-DB war, können in PostgreSQL umziehen. Analytische Workloads bleiben ohnehin im Lakehouse. Oracle wird zur Insel für genau die Workloads, die wirklich auf Oracle bleiben müssen — erfahrungsgemäß bleiben etwa dreißig bis vierzig Prozent des ursprünglichen Oracle-Footprints. Die restlichen sechzig bis siebzig Prozent wandern.

Das Ergebnis nach achtzehn bis vierundzwanzig Monaten: Lizenzkosten auf der Datenbank-Seite reduzieren sich realistisch zwischen dreißig und fünfzig Prozent. Nicht durch das Lakehouse selbst. Sondern durch die Workload-Verlagerung, die das Lakehouse als technischen Enabler ermöglicht.

Das ist die ehrliche Mechanik. Sie ist langsamer als jede Marketing-Folie suggeriert. Sie ist anspruchsvoller in der Umsetzung. Und sie ist genau deshalb auch nicht von jedem Wettbewerber lieferbar, der mit einem Lakehouse-Logo in der Präsentation auftaucht.

## Was sich gleichzeitig verändert — die KI-Brücke

Während die Lizenzbewegung über die Zeit läuft, passiert auf der KI-Seite etwas anderes — und schneller. Sobald das Lakehouse läuft, sobald die Datenmodelle stehen, sobald der Vektorindex eingebunden ist, wird der KI-Use-Case operationalisierbar.

Konkret bedeutet das: Ein Predictive-Maintenance-POC, der monatelang oder jahrelang liegengeblieben war, kommt innerhalb von wenigen Wochen in einen Produktionsbetrieb. Nicht weil das Modell besser geworden wäre — sondern weil die Datengrundlage zum ersten Mal verlässlich, wiederholbar und in einem Format vorliegt, mit dem ein Modell arbeiten kann. Service-Intervalle werden datenbasiert, Ersatzteil-Forecasts verbessern sich messbar, Service-Einsätze werden planbarer.

Parallel läuft der RAG-basierte Service-Assistent an. Service-Techniker können auf Deutsch, Englisch oder mit etwas mehr Aufwand auf weiteren Sprachen Maschinen-Historien abfragen, Fehlercodes nachschlagen, ähnliche Vorfälle in der installierten Basis identifizieren. Die Daten verlassen das Rechenzentrum nicht. Das Modell — typischerweise ein lokal betriebenes Open-Weight-Modell auf einer GPU-Infrastruktur — bleibt im eigenen Haus.

Das ist die KI-Souveränität, die viele Mittelständler fordern, ohne den Weg dorthin zu kennen. Sie ergibt sich nicht aus einer Cloud-Strategie. Sie ergibt sich aus einer Datenarchitektur, die KI-Workloads im eigenen Rechenzentrum betreibbar macht.

## Die Zeitachse — ehrlich

Damit niemand mit falschen Erwartungen startet, hier die realistische Projekt-Zeitachse, mit der wir in solchen Konstellationen arbeiten.

**Monate eins bis sechs:** Aufbau der Lakehouse-Schicht. Iceberg-Tabellen, Object Storage, Query Engine, erste Datenmodelle. Federation gegen die bestehenden Quellsysteme. Erster KI-Use-Case — typischerweise der RAG-Assistent — wird in eine produktive Pilotphase gebracht. Keine Lizenzeinsparung in dieser Phase. Investition steht im Vordergrund.

**Monate sechs bis zwölf:** Read-Workloads werden schrittweise vom Oracle-DWH ins Lakehouse umverdrahtet. BI-Reports werden migriert. Self-Service-Analytics geht produktiv. Predictive-Maintenance-Modell läuft operativ. Erste Option-Lizenzen werden abbestellt, sobald die zugehörige Last sicher weg ist.

**Monate zwölf bis vierundzwanzig:** Engine-Tausch für tauschbare Workloads. Edition-Downgrades wo möglich. Oracle reduziert sich auf die Insel-Workloads. Lizenzeinsparung wird in der Kostenstelle sichtbar. Parallel kommen weitere KI-Use-Cases dazu, ohne dass die Datenarchitektur dafür angefasst werden muss.

Nach vierundzwanzig Monaten ist das Bild: Datenbank-Lizenzkosten zwischen dreißig und fünfzig Prozent niedriger als zum Start. Hardware-Footprint für die Daten- und Analytics-Schicht deutlich schlanker, weil das Lakehouse auf günstigerem Compute läuft als die Oracle-Workloads vorher. Zwei bis drei KI-Use-Cases produktiv. Reporting-Wartezeiten von mehreren Werktagen auf wenige Stunden gesunken.

Das ist der zusammengefasste Effekt. Es ist die Summe aus drei Bewegungen, die einzeln nicht außergewöhnlich sind. Es ist die Architektur-Disziplin, sie konsequent durchzuziehen, die den Unterschied macht.

## Souveränität ist hier nicht Marketing — sie ist Architektur

Den Souveränitäts-Aspekt habe ich in der Serie schon mehrfach behandelt, in Teil 3 als Reaktion auf die geopolitische Eskalation, in Teil 5 als Übergangs- und Zielarchitektur. Bei der Datenmodernisierung wird er konkret.

**Erstens: Datenresidenz.** Maschinendaten, Service-Historien, Ersatzteil-Bewegungen — das ist sensibles Geschäftswissen. Wer das in ein Hyperscaler-Modell schickt, verliert nicht nur die Hoheit über die Daten, sondern macht sich abhängig von Plattform-Entscheidungen, die anderswo getroffen werden. Mit einem lokalen Lakehouse und einem lokal betriebenen Modell bleibt beides im Haus.

**Zweitens: Modellsouveränität.** Open-Weight-Modelle — von Llama über Mistral bis zu spezialisierten europäischen Entwicklungen — sind 2026 leistungsfähig genug, um in einem konkreten Use Case wie diesem mit den großen kommerziellen Modellen mitzuhalten. Der Performance-Abstand zu den Top-Modellen ist für Branchenanwendungen wie Predictive Maintenance oder Service-Assistenz oft irrelevant. Was zählt, ist Domänen-Tuning, Datenqualität und Integrationstiefe.

**Drittens: Portabilität.** Die Lakehouse-Architektur, die ich beschrieben habe, ist nicht an einen Anbieter gebunden. Iceberg ist ein offenes Tabellenformat. Parquet ist ein offenes Speicherformat. Dremio und Starburst sind austauschbar. Der Storage liegt auf einem S3-kompatiblen Layer, der bei einem souveränen Provider wie STACKIT, IONOS oder im eigenen Rechenzentrum laufen kann. Wenn der Kunde morgen entscheidet, die Compute-Schicht in eine externe souveräne Cloud zu schieben — das ist eine Sechs-Wochen-Migration, kein Architektur-Reset.

Das ist die Definition von Souveränität, die ich in dieser Serie trage: nicht die Abwesenheit von Cloud, sondern die Freiheit, jederzeit den Anbieter zu wechseln. Bei der Datenmodernisierung wird diese Freiheit zur expliziten Design-Entscheidung.

## Was das für Deine Refresh-Planung bedeutet

Drei konkrete Konsequenzen, die ich gerade jedem Kunden mitgebe, der im Q3 oder Q4 2026 einen Refresh ansteht.

**Erstens:** Wenn Du heute einen Hardware-Refresh planst, der auch das DWH oder die Analytics-Schicht betrifft — halte inne. Eine schlanke Lakehouse-Architektur stellt für die nächsten fünf Jahre die Hardware-Frage anders, als das gewachsene DWH-Setup es tat. Wer jetzt 1:1 nachkauft, friert die Architektur von gestern zu den RAMmageddon-Preisen von heute ein. Mit einer Lakehouse-Zielarchitektur ändern sich Sizing, Storage-Profile und Lizenzmodelle fundamental.

**Zweitens:** Wenn Du gerade eine KI-Initiative kalkulierst und die Wirtschaftlichkeitsrechnung wackelt — frage zuerst, ob das Problem an der KI-Schicht oder an der Datenarchitektur liegt. Wenn die Antwort „Datenarchitektur" lautet, ist die KI-Initiative kein eigenes Projekt mehr. Sie ist das Folgekapitel einer Datenmodernisierung, die ohnehin sinnvoll ist — und die durch die KI-Brücke einen zusätzlichen Business-Case bekommt.

**Drittens:** Wenn Du heute über Lizenzkostenreduktion bei Oracle, MSSQL oder vergleichbaren kommerziellen Datenbanken nachdenkst — denke das Ziel zu Ende. Ohne eine Alternative zur Read-Last-Bedienung wird Edition-Downgrade scheitern, weil die Workloads die Features brauchen. Mit einem Lakehouse als analytischer Schicht wird die Workload-Verlagerung möglich, und damit die Lizenz-Optimierung in einer Größenordnung, die ohne diese Architektur nicht erreichbar ist.

## Was als nächstes kommt

In Teil 8 gehen wir an Use Case 06 in die Tiefe — den ich vor zwei Wochen schon als Post angerissen habe. „Aus 80 VMs werden 12 Kubernetes-Nodes" funktioniert als Headline, aber die Realität dahinter verdient mehr Raum: Wie sieht der Migrationspfad konkret aus, an welchen Stellen kippen Java-Monolithen das Projekt, wo wird der Density-Faktor zehn realistisch — und wo bleibt er Wunschdenken? Mit einem zweiten Projektbild, das die Hardware-Seite der Modernisierungsdiskussion adressiert, während Teil 7 die Datenseite gemacht hat.

In Teil 9 folgt dann der dritte Tiefenartikel: DB-IOPS-Tiering in der Praxis. Pareto-Lesung, Resource Governance, NVMe-Targeting — und warum die Query-Optimierung am Ende oft der wichtigste Hebel ist.

Die Reihenfolge spiegelt die Priorisierungs-Matrix aus Teil 5 wider. Datenmodernisierung kommt zuerst, weil sie den größten strategischen Hebel hat — sie löst Effizienz und KI-Wachstum in einer Bewegung. Container kommen als zweites, weil sie der schnellste Effizienz-Hebel auf der Hardware-Seite sind. IOPS-Tiering kommt als drittes, weil es der technisch tiefste, aber thematisch fokussierteste der drei ist.

---

Wer das in eigenen Zahlen sehen will: Wir machen genau das bei CID. Discovery-Run, Lesart durch die Service-Brille, Architektur-Workshop für die Lakehouse-Zielarchitektur, Roadmap mit ehrlicher Zeit- und Kostenschätzung. Anfragen gerne über Direktnachricht.

Und an Dich als Leser, weil mich die Resonanz auf diese Serie interessiert: Wo siehst Du bei Euch den größeren Bremsklotz für KI-Use-Cases — an der Modell-Seite oder an der Datenarchitektur? Schreib es in die Kommentare. Aus solchen Antworten entstehen die nächsten Tiefenbeiträge.

Bis Teil 8.

---

*Quellen und Hintergründe: Apache Iceberg Project, Dremio und Starburst Documentation, MinIO Reference Architecture, dbt Labs, Apache Airflow Documentation, Qdrant und Weaviate Vector Database Comparisons (2026); Oracle Database Licensing Information User Manual (April 2025); TrendForce Memory-Pricing-Survey (Q2 2026).*
