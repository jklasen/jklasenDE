---
title: "RAMmageddon: Die sechsstellige Lizenzrechnung, die niemand nachrechnet"
kicker: "Future Proof Tech Briefing · Juni 2026"
date: 2026-06-09
author: "Jens Klasen"
readingTime: "6 Minuten"
teaser: "SQL-Server-Lizenzen sind 2026 oft der teurere Posten als die Hardware – warum Konsolidierung der unterschätzte Spar-Hebel ist."
---

In der letzten Ausgabe ging es um Datenmodernisierung – warum ein Lakehouse 2026 gleichzeitig Hardware-Druck, Lizenzkosten und KI-Bereitschaft adressiert. Heute zoome ich auf einen einzelnen Posten, der in fast jeder Bestandsaufnahme auftaucht und trotzdem fast nie sauber durchgerechnet wird: die SQL-Server-Lizenz.

Und ich sage es direkt: In vielen Umgebungen ist nicht das Blech der teuerste Teil eines Datenbank-Servers. Es ist die Lizenz, die jedes Jahr aufs Neue fällig wird – und die im RAMmageddon-Getöse untergeht, weil alle auf DRAM-Preise und Lieferzeiten starren.

## Was wir sehen

Wir gehen in gewachsene Mittelstandsumgebungen und finden fast immer dasselbe Muster: Dutzende kleine SQL-Server-VMs. Typisch zwei bis vier vCPU, 16 bis 32 GB RAM, jede für genau eine Anwendung. Die CPU-Last liegt im Mittel unter fünfzehn Prozent. Daneben laufen Dev- und Test-Datenbanken munter auf Produktiv-Editionen, und Enterprise-Lizenzen kleben auf Maschinen, die nie eine Enterprise-Funktion angefasst haben.

Jedes Projekt hat über die Jahre seine eigene Instanz mitgebracht. Niemand hat konsolidiert, weil niemand das Lizenzmodell sauber gegenrechnet.

## Was es bedeutet

Hier wird es unbequem, und an dieser Stelle lohnt der Blick ins Kleingedruckte. SQL Server wird pro Kern lizenziert, verkauft in Zwei-Kern-Paketen – mit einem Minimum von vier Kern-Lizenzen pro VM. Heißt: Eine VM mit zwei vCPU kostet dich trotzdem vier Kerne. Eine mit drei kostet vier. Die Untergrenze greift unabhängig davon, wie wenig die Kiste tatsächlich arbeitet.

Rechne das auf dreißig, vierzig kleine SQL-VMs hoch, und du bezahlst ein Vielfaches an Kern-Lizenzen für eine Auslastung, die zusammengenommen auf eine Handvoll Kerne passen würde. Standard Edition pro VM ist damit die teuerste Form, SQL Server zu betreiben, die es gibt.

Dazu die Klassiker: Dev und Test auf bezahlten Editionen, obwohl die Developer Edition voll funktionsfähig und für nicht-produktive Nutzung kostenlos ist. Enterprise, wo Standard längst reichen würde. Passive Failover-Replikate ohne Software Assurance, die plötzlich lizenzpflichtig werden. In Summe landet man in typischen Mittelstandsumgebungen schnell im hohen fünf- bis sechsstelligen Bereich pro Jahr – Geld, das jedes Jahr aufs Neue abfließt.

## Welcher Hebel

Der Weg heraus ist kein Hexenwerk, aber er braucht eine ehrliche Inventur statt eines Bauchgefühls:

**Konsolidieren.** Viele kleine Instanzen wandern auf wenige, größere Hosts. Wer einen Host vollständig mit Enterprise plus Software Assurance lizenziert, bekommt unbegrenzte Virtualisierung auf dieser Maschine – aus dreißig kleinen Lizenz-Inseln wird eine. Workload-Trennung übernimmt der Resource Governor.

**Editionen prüfen.** Dev und Test auf Developer Edition. Standard statt Enterprise überall dort, wo keine Enterprise-Funktion nachweisbar im Einsatz ist.

**Software Assurance gezielt setzen** – für Mobilität, für passive Replikate, für genau die Flexibilität, die Konsolidierung erst sauber macht.

Und jetzt die Brücke zu RAMmageddon: Right-Sizing und Konsolidierung senken Hostzahl und Kernanzahl. Weil die Lizenz an den Kernen hängt, schlägt jede eingesparte CPU direkt auf die Lizenzrechnung durch. Die Hardware-Einsparung ist die Nebenwirkung. Die Lizenzeinsparung ist der Hauptpunkt.

## Warum gerade jetzt

In einem Jahr, in dem RAM- und Server-Preise jede Hardware-Beschaffung zur Lotterie machen, ist die Versuchung groß, alles auf Capex und Lieferzeiten zu reduzieren. Aber der größte planbare Hebel liegt woanders. Eine Hardware-Bestellung ist ein einmaliger Schmerz. Eine überdimensionierte Lizenzlandschaft ist ein Dauerauftrag, der jedes Jahr abgebucht wird.

Genau deshalb ist die SQL-Konsolidierung der Posten, den ein CFO sofort versteht – und der unabhängig von jedem Beschaffungs-Stopp funktioniert. Du musst dafür keinen einzigen neuen Server kaufen. Du musst nur aufhören, für Luft zu bezahlen.

## Wie wir das angehen

Wir lesen das nicht aus dem Bauch, sondern aus den Daten. Ein Assessment über die bestehende Landschaft zeigt schwarz auf weiß, welche Editionen wo laufen, wie viele Kerne lizenziert sind und wie wenig davon tatsächlich gebraucht wird. Daraus wird eine Konsolidierungs-Roadmap, die Lizenz, Hardware und Modernisierung in einer Rechnung zusammenführt – nicht in dreien.

Wie geht ihr mit eurem SQL-Bestand um? Habt ihr Editionen und Kern-Lizenzen in den letzten zwölf Monaten gegengeprüft – oder läuft das seit dem letzten Projekt einfach weiter?

In der nächsten Ausgabe nehme ich mir das Cloud-Bursting-Thema vor: wann es ein echter Hebel gegen Hardware-Knappheit ist – und wann es nur die Kostenfalle von der Cloud-Seite her aufmacht.
