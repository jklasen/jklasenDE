---
title: "RAMmageddon Teil 6: Vom Engpass zum Structural Reset"
kicker: "Future Proof Tech Briefing · Mai 2026"
date: 2026-05-19
author: "Jens Klasen"
readingTime: "9 Minuten"
teaser: "Was viele noch als zyklischen Engpass missverstehen, ist ein struktureller Reset des Speichermarkts. Q2-2026-Zahlen, warum 'abwarten' die teuerste Strategie ist und die fünf Prinzipien der Handlungsdoktrin."
---

In Teil 1 dieser Serie habe ich von einer Krise geschrieben. Heute, ein gutes halbes Jahr und fünf Ausgaben später, muss ich dieses Wort zurücknehmen.

Eine Krise hat ein Ende. Man hält den Atem an, überbrückt, wartet auf die Entspannung – und danach ist die Welt wieder so, wie sie war. Genau diese Erwartung ist der teuerste Denkfehler, den ein IT-Entscheider 2026 machen kann.

Was wir gerade erleben, ist keine Krise. Es ist ein Reset.

## Die Zahlen, die das Wort „Krise" beerdigen

Schauen wir auf die Beweislage, Stand dieser Woche.

Nach dem Rekordquartal Q1/2026 – die Contract-Preise für konventionelles DRAM stiegen um 90 bis 95 Prozent gegenüber dem Vorquartal – folgt in Q2 keine Entspannung, sondern die nächste Stufe: DRAM noch einmal +58 bis +63 Prozent, NAND Flash +70 bis +75 Prozent (TrendForce, Memory-Pricing-Survey). Zum ersten Mal in diesem Zyklus steigt NAND schneller als DRAM. Die Verknappung frisst sich von der Compute- in die Storage-Schicht.

Drei Einzelbefunde sind für mich aussagekräftiger als jede Prozentzahl:

**Erstens:** IDC nennt das Geschehen nicht mehr Engpass, sondern „strukturellen Reset" – eine potenziell dauerhafte, strategische Neuverteilung der weltweiten Wafer-Kapazität. Das DRAM-Angebotswachstum liegt 2026 bei nur 16 Prozent gegenüber Vorjahr, NAND bei 17 Prozent – deutlich unter dem historischen Mittel. Das ist keine Konjunktur. Das ist eine Verschiebung der Geschäftsgrundlage.

**Zweitens:** Micron hat sich mit der Schließung des Crucial-Geschäfts vollständig aus dem Consumer-Segment zurückgezogen und konzentriert die Fertigung auf Enterprise- und GPU-Speicher. Wenn ein Hersteller einen ganzen Markt verlässt, weil die Marge anderswo strukturell höher ist, kommt dieser Markt nicht zurück, sobald „die Krise vorbei" ist. Es gibt keine Brücke zurück.

**Drittens:** Der DDR4-Spotpreis liegt inzwischen über dem HBM3e-Contractpreis. Lass das einen Moment wirken. Speicher der vorletzten Generation kostet im Spotmarkt mehr als High-Bandwidth-Memory für KI-Beschleuniger. Wenn die Preishierarchie sich invertiert, ist der Markt nicht angespannt – er ist neu sortiert.

Dazu der Rahmen: Die großen Hersteller – Samsung, SK hynix, Micron – warnen offen, dass die Lage bis 2027 und darüber hinaus angespannt bleibt. Gartner und Counterpoint sehen den frühesten Wendepunkt nicht vor dem vierten Quartal 2027. McKinsey rechnet bis 2030 mit sieben Billionen US-Dollar Rechenzentrums-Investitionen, davon 5,2 Billionen KI-getrieben. Speicher macht in diesem Jahr rund 30 Prozent der Rechenzentrums-Ausgaben der Hyperscaler aus – viermal so viel wie 2023.

Und ein Detail, das mich besonders freut: Der Begriff „RAMmageddon" ist inzwischen in der wissenschaftlichen Fachpresse angekommen. Nature beschreibt, wie Forschungslabore an Speichergrenzen stoßen – und zieht denselben Schluss, den ich hier seit Teil 1 vertrete: Der Mangel zwingt dazu, effizientere Algorithmen zu entwickeln, die mit weniger Speicher auskommen. Wenn die Grundlagenforschung zur gleichen These kommt wie die Infrastruktur-Praxis, sind wir nicht mehr im Bereich der Meinung.

## Warum „zyklisch" das gefährlichste Wort des Jahres ist

Die Speicherindustrie ist eine Boom-Bust-Industrie. Jeder, der lange genug dabei ist – ich bin es seit 25 Jahren –, hat den Reflex gelernt: Preise hoch, also abwarten, irgendwann kippt es, dann nachkaufen. Dieser Reflex hat über zwei Jahrzehnte funktioniert. Genau deshalb ist er 2026 gefährlich.

Der Unterschied ist die Ursache. Frühere Engpässe waren angebotsseitig: ein Fabrikbrand, eine Naturkatastrophe, eine Fehlplanung der Kapazität. Solche Störungen lösen sich auf, sobald die Logistik sich normalisiert. Was wir jetzt sehen, ist nachfrageseitig und strukturell: Jeder Wafer, der in einen HBM-Stack für einen KI-Beschleuniger wandert, ist ein Wafer, der nicht in das DDR5-Modul eines Servers oder die SSD eines Mittelständlers wandert. Es ist ein Nullsummenspiel – und die Nachfrageseite, der KI-Ausbau, hört nicht auf zu wachsen.

Eine angebotsgetriebene Knappheit endet, wenn die Störung behoben ist. Eine nachfragegetriebene Knappheit endet erst, wenn die Nachfragequelle versiegt. Niemand, der bei Verstand ist, wettet 2026 darauf, dass der KI-Ausbau versiegt.

Wer also „abwarten" als Strategie wählt, plant nicht gegen eine vorübergehende Spitze. Er plant gegen eine neue Normalität – und kommt mit jeder Quartalsrunde teurer wieder rein.

## Die strategische Konsequenz: Hardware ist kein Puffer mehr

Zwei Jahrzehnte lang war Hardware der stille Stoßdämpfer der IT. Software ineffizient? Mehr RAM. Datenbank schlecht modelliert? Schnellere Disks. Architektur überaltert? Größere Maschine. Hardware war so billig und so verfügbar, dass Ineffizienz schlicht weggekauft werden konnte. Das war keine Faulheit – es war über lange Zeit die wirtschaftlich rationale Entscheidung.

Diese Rationalität ist tot. Wenn die Kostenkurve von Speicher sich dauerhaft nach oben verschiebt, verschiebt sich auch der Punkt, an dem sich Software-Modernisierung rechnet – und zwar fundamental und in jeder TCO-Rechnung. Was 2023 ein „Nice to have" war, ist 2026 die mathematisch zwingende Antwort.

Daraus folgen drei Verschiebungen in der IT-Doktrin:

**Von Beschaffung zu Architektur.** Die zentrale Frage ist nicht mehr „Wann bestellen wir, und zu welchem Preis?", sondern „Welche Last muss diese Hardware in drei Jahren überhaupt noch tragen?". Wer die zweite Frage nicht beantwortet, optimiert die erste vergeblich.

**Vom CAPEX-Reflex zum Effizienz-Hebel.** Der schnellste verfügbare Speicher 2026 ist der, den du nicht kaufen musst, weil deine Software ihn nicht mehr braucht. Software-Effizienz ist die einzige Kapazitätsquelle, die nicht allokiert, nicht verzollt und nicht von Hyperscalern weggekauft werden kann.

**Von Kapazität zu Wahlfreiheit.** Wenn man Hardware nicht beliebig nachordern kann, wird die Fähigkeit, Lasten zwischen Plattformen und Anbietern zu verschieben, zum strategischen Asset. Souveränität heißt nicht keine Cloud – sie heißt die Freiheit, jederzeit den Anbieter zu wechseln. Diesen Satz habe ich in Teil 5 geprägt; der Structural Reset macht ihn von einer Haltung zu einer betriebswirtschaftlichen Notwendigkeit.

## Die Handlungsdoktrin

Aus diesen Verschiebungen leite ich fünf Prinzipien ab. Sie sind bewusst übertragbar – sie funktionieren für den 45-Host-Mittelständler genauso wie für den Konzern.

1. **Behandle Speicher als knappes Gut, nicht als Commodity.** Quote-Fenster sind auf ein bis 30 Tage geschrumpft, in Einzelfällen wird der Preis erst bei Auslieferung fixiert. Beschaffung ist kein Bestellvorgang mehr, sondern Risikomanagement mit Vorlauf. Wer das nicht organisatorisch abbildet, zahlt den Aufschlag der Unvorbereiteten.

2. **Miss, bevor du modernisierst.** Ohne belastbares Workload-Profil ist jede Effizienz-Diskussion Glaubenssache. Welche VMs sind Zombies? Wo sitzen die IOPS-Hotspots? Welche Datenmodelle erzwingen RAM, das eine Modernisierung halbieren würde? Die Landkarte aus Teil 5 ist der Anfang – die Vermessung ist die Pflicht.

3. **Senke den Speicherbedarf, bevor du Speicher kaufst.** Jede Modernisierung, die den Footprint reduziert, ist eine Investition mit zweifacher Rendite: einmal in der vermiedenen Hardware zu heutigen Preisen, einmal in der vermiedenen Hardware zu den Preisen von 2027.

4. **Bau Portabilität strukturell ein.** Open-Source-Plattformen – ob Kubermatic, OpenShift, Rancher oder NKP – sind 2026 keine Glaubensfrage mehr, sondern die Versicherung gegen Lock-in in einem Markt, in dem du dir Lock-in nicht mehr leisten kannst.

5. **Trenne die Architektur von morgen vom Preis von gestern.** Wer jetzt in Panik überteuerte Hardware bestellt, friert die Architektur von gestern zum Preis von heute ein. Die teuerste Entscheidung 2026 ist die, die du unter Zeitdruck triffst, ohne die ersten vier Prinzipien angewendet zu haben.

## Warum ich darüber so klar spreche

Bei CID haben wir diese Doktrin nicht im Nachhinein formuliert, sondern vorgelebt. Wir haben unsere Hardware bereits im September 2025 bestellt – vor der ersten Eskalation –, weil die Signale früh lesbar waren. Das hat uns nicht nur Beschaffungssicherheit gegeben, sondern etwas Wertvolleres: POC-Kapazität in einem Markt, in dem POC-Kapazität gerade zur härtesten Währung der Branche wird. Genau diese Kapazität setzen wir aktuell ein, um auf Lenovo-GPU-Infrastruktur Plattform-Modernisierung unter realer Last zu validieren – nicht als Folienarchitektur, sondern als betriebsfähiger Beweis.

Das ist der Punkt, an dem aus einer These ein Handwerk wird. Eine Krise kommentieren kann jeder. Eine Architektur bauen, die dem Structural Reset standhält, ist Ingenieursarbeit – und genau dafür stehe ich, und dafür steht das Team, mit dem ich arbeite.

## Was als Nächstes kommt

Teil 5 hat die Landkarte gezeichnet – sieben Use Cases, in denen 2026 das Geld verdunstet. Teil 6 hat die Doktrin formuliert, mit der man diese Landkarte liest. Die nächsten Tiefenbeiträge gehen in die einzelnen Hotspots: die Daten- und Workload-Modernisierung als KI-Türöffner, und die souveräne Architektur als Übergangs- und Zielzustand zugleich.

Welches der fünf Prinzipien trifft bei dir gerade den wundesten Punkt? Schreib es in die Kommentare – die Reihenfolge der nächsten Tiefenbeiträge richte ich danach aus.

Eine Krise wartet man ab. Einen Reset gestaltet man – oder er gestaltet einen.

---

*Quellen: TrendForce Memory-Pricing-Survey (Q1/Q2 2026); IDC, Global Memory Shortage Crisis – Market Analysis 2026; Gartner und Counterpoint Research (Preisausblick bis Q4 2027); McKinsey (Rechenzentrums-CAPEX bis 2030); Nature, „How labs are coping with RAMmageddon" (2026); Tom's Hardware / The Register (TrendForce-Auswertungen).*
