---
title: "RAMmageddon Teil 9: Der Küchentisch-Moment"
kicker: "Future Proof Tech Briefing · Juli 2026"
date: 2026-07-21
author: "Jens Klasen"
readingTime: "7 Minuten"
teaser: "Kubricks Monolith steht jetzt auf dem Küchentisch: DDR5-Kits im Jahresvergleich bis zu 440 Prozent teurer, Microns 100-Milliarden-Dollar-Verträge, Lenovos Survival Guide – und warum Architektur die Antwort auf die Kontrollfrage ist."
---

*Ein Monolith, ein Küchentisch und die Frage, wer hier eigentlich die Kontrolle hat.*

---

## 2001

1968 stellt Stanley Kubrick einen schwarzen Monolithen vor eine Handvoll Vormenschen. Sie begreifen nicht, was da steht. Sie tasten, sie zögern, sie weichen zurück – und dann verändert dieses eine Artefakt alles, was danach kommt. Der berühmteste Schnitt der Filmgeschichte folgt Minuten später: ein hochgeworfener Knochen wird zum Raumschiff. Aus einem Werkzeug wird der Sprung in ein neues Zeitalter.

Der Monolith erklärt sich nie. Er steht einfach da – und zwingt jeden, der davorsteht, zu einer Entscheidung: begreifen oder überrollt werden.

## 2026

Der Monolith steht jetzt auf deinem Küchentisch. Er ist neun Zentimeter hoch, grün, und er heißt DDR5.

Ein Blick auf die Zahlen: Ein 16-GB-DDR5-5600-Modul kostete im Sommer 2025 rund 45 Euro. Ende 2025 waren es 60, und ein 32-GB-Kit liegt 2026 bei rund 300 Euro. Im Jahresvergleich sind einzelne DDR5-Kits laut Marktdaten um bis zu 440 Prozent teurer geworden; DRAM-Chips generell um über 170 Prozent. Allein im dritten Quartal 2026 legen die Preise noch einmal um bis zu 18 Prozent zu. Gartner rechnet mit einem kombinierten Anstieg von DRAM und SSD um 130 Prozent bis Jahresende, Jefferies mit weiteren 40 bis 50 Prozent im dritten und 30 bis 40 Prozent im vierten Quartal.

Was in den letzten acht Teilen dieser Serie eine abstrakte Zeile in Hyperscaler-Investmentberichten war, liegt heute als Preisschild neben deinem Laptop und deinem Controller. Nicht im Rechenzentrum „da draußen". Auf deinem Tisch. Im Warenkorb. In der Rechnung für das Speicher-Upgrade, das vor einem Jahr noch einen Bruchteil gekostet hat.

Das ist der Küchentisch-Moment. Der Punkt, an dem die Datacenter-Ökonomie aufhört, ein Thema für Einkäufer und Architekten zu sein, und anfängt, für jeden sichtbar zu werden, der ein Gerät besitzt. Ich nenne es **Consumerization of Visibility**: nicht die Technologie wird demokratisiert, sondern ihre Knappheit.

## Warum das kein Zyklus ist

Frühere Speicherkrisen waren Wellen – sie kamen, sie gingen. Diese ist strukturell. Die Hersteller verlagern ihre Kapazität in die lukrativen High-End-Segmente für KI-Server. Anbieter wie Adata sprechen offen von „akuter Angebotsknappheit" und bedienen große Cloud-Kunden zuerst, Endkunden zuletzt. Micron hat langfristige, nicht kündbare Lieferverträge über rund 100 Milliarden Dollar unterschrieben – eine vertragliche Preisuntergrenze, die auch dann greift, wenn neue Fabriken ans Netz gehen, weil deren Kapazität längst an Hyperscaler vergeben ist.

Selbst wer traditionell enorme Einkaufsmacht hat, spürt den Druck. Und Ende Juni 2026 landete das Thema sogar vor Gericht: eine Sammelklage gegen Samsung, SK Hynix und Micron wegen des Vorwurfs illegaler Preisabsprachen. Ob berechtigt oder nicht – sie zeigt, wie sehr die Knappheit inzwischen als System wahrgenommen wird, das sich der Kontrolle des Einzelnen entzieht.

## HAL

Und genau hier wird aus einer Preisgeschichte eine Kontrollfrage.

Kubrick hat den Monolithen nie erklärt. Aber er hat uns HAL 9000 gezeigt – das System, das irgendwann selbst entscheidet. HAL war nicht böse. HAL war das, was passiert, wenn wir die Kontrolle über unsere eigene Technik an eine Logik abgeben, die wir nicht mehr überblicken.

2026 ist HAL kein Bordcomputer. HAL ist die Beschaffungslogik einer Handvoll Hyperscaler, die faktisch mitentscheidet, wie viel Speicher für den Rest der Welt übrig bleibt. Die Frage ist nicht, ob der Monolith auf deinem Tisch steht – er steht schon da. Die Frage ist, ob du Dave bist: ruhig, methodisch, die Hand am Schalter. Oder ob du dich überrollen lässt.

Nebenbei: HAL ist im Alphabet nur einen Buchstaben von IBM entfernt. Clarke schwor, das sei Zufall gewesen – und vielleicht ist das die eigentliche Pointe. Die Systeme, die uns die Kontrolle abnehmen, brauchen keine versteckte Botschaft. Sie sind einfach da, ein Buchstabe daneben, und tun ihre Arbeit.

## Der Survival Guide

Lenovo hat auf der ISC 2026 genau diese Haltung eingenommen. Martin Hiegl formulierte dort, was das Unternehmen den „RAMageddon Survival Guide" nennt – mit der halb ernsten, halb schmunzelnden Ansage, so günstig wie letztes Jahr werde es „nie mehr". Gemeint ist: eine neue Normalität, die sich frühestens um 2030 einpendelt, dauerhaft oberhalb des Niveaus von 2024.

Der Guide besteht aus fünf Schritten, und sie sind unspektakulär – im besten Sinne: Anforderungen ehrlich prüfen. Den Betrieb optimieren. Die richtige CPU wählen. Die Anwendung anpassen. Und, als wichtigster Hebel: speicherintensive Workloads auf GPUs verlagern, wo es sinnvoll ist. Denn KI-Inferenz muss nicht zwingend den DDR5 des Hosts belasten – GPUs bringen ihren eigenen Speicher mit (HBM oder GDDR6). Wer diese Last vom zentralen Speicher wegroutet, senkt den DDR5-Bedarf und macht das Budget ein Stück weit unabhängig von der Preisspirale.

Der rote Faden ist keine Panik-Bevorratung, sondern Architektur. Wer heute weiß, welche Workloads wirklich speicherhungrig sind und welche sich verlagern lassen, wer seine Infrastruktur so baut, dass sie Knappheit aushält statt ihr ausgeliefert zu sein – der steht vor dem Monolithen wie Dave, nicht wie der Vormensch.

Das ist übrigens der Punkt, an dem Cloud-Native aufhört, ein Buzzword zu sein. Wer Workloads sauber orchestriert, portabel hält und über Cluster – notfalls über Anbieter – hinweg steuern kann, verwandelt eine Hardware-Knappheit in eine reine Planungsaufgabe. Darum geht es bei Cloud-Native-Kompetenz im Kern: nicht um die coolste Technologie, sondern um die Fähigkeit, souverän zu bleiben, wenn die Grundlagen knapp werden.

## Aus einer Position der Kontrolle

Der Monolith zwingt zur Entscheidung. Das war 1968 so, und das ist 2026 so.

Du kannst warten, bis der Preis dich zwingt. Oder du planst jetzt – aus einer Position der Kontrolle heraus, nicht aus Druck.

---

*Jens Klasen ist Tech Evangelist bei CID GmbH und schreibt in der RAMmageddon-Serie über die Speicherkrise 2026 und ihre Folgen für Enterprise-IT-Architektur. Alle bisherigen Teile findet ihr in meinem Newsletter und auf [klasen.ai](https://klasen.ai/).*
