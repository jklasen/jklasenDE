---
title: 'Ein KI-Prompt ist kein Text. Er ist Software.'
kicker: 'Future Proof Tech Briefing · April 2026'
date: 2026-04-10
author: 'Jens Klasen'
readingTime: '6 Minuten'
teaser: 'Warum der eigentliche Wert von KI-gestütztem Coding nicht in der Geschwindigkeit liegt — sondern in der Disziplin, die es erzwingt.'
---

Der eigentliche Wert von KI-gestütztem Coding liegt nicht in der Geschwindigkeit, sondern in der Disziplin, die es erzwingt. Wer einer Maschine ungenau erklärt, was er will, bekommt ungenauen Code. Das ist kein Bug. Das ist das Feature.

Ich habe in den letzten drei Monaten eine persönliche KI-Coaching-App gebaut, die ich selbst benutze — JK-Fitt. Die App liest Daten aus Apple HealthKit, spricht die inoffizielle Cloud-API meiner RENPHO-Körperanalysewaage direkt an, zieht Trainingsdaten aus Oura, und reicht alles an einen Coach weiter, der auf einem System-Prompt basiert und über einen eigenen Anthropic-API-Key mit Claude spricht. Gebaut habe ich die App überwiegend mit Claude Code. Und an einer einzigen Komponente habe ich eine Erkenntnis gewonnen, die ich inzwischen auf jede Kundendiskussion über KI-Produktivität übertrage.

Die Komponente war der System-Prompt des Coaches.

## Wie ich anfing — und warum es nicht funktionierte

Ich wollte einen Coach, der auf mehreren Stimmen aus der evidenzbasierten Gesundheits- und Trainingsszene gleichzeitig basiert. Andrew Huberman für Neurowissenschaft, Schlafarchitektur und HRV. Andreas Breitfeld für Longevity und Biohacking. Lukas Ziegler für Trainings-Präzision und Leistungsphysiologie. Dr. med. Ulrich Selz für Supplementierung und Darmgesundheit. Dr. med. Dr. rer. pol. Tobias Weigl für Ernährungs- und Sportmedizin. Fünf Quellen mit sehr unterschiedlichem Fokus, die sich in einem einzigen Gespräch mit mir abwechseln sollten, je nachdem, was meine Tagesdaten hergaben.

Ich habe den System-Prompt in zwei Stunden geschrieben, an Claude Code übergeben, den Rest der Pipeline gebaut, und mich auf das erste echte Gespräch mit dem Coach gefreut. Das Ergebnis war brauchbar, aber unscharf. Der Coach war freundlich, kompetent, und vollkommen austauschbar. Ich hätte genauso gut ChatGPT ohne jeden Prompt fragen können.

Ich habe den Prompt überarbeitet. Zweite Runde: besser, aber noch nicht da. Dritte Runde: marginal besser. Vierte Runde: Frustration. Ich habe Claude Code dann gebeten, mir bei der Analyse zu helfen, und die Antwort war unbequem: Ich hatte fünf Stimmen benannt, aber keine Regeln definiert, wann welche sprechen sollte. Ich hatte Persönlichkeiten beschrieben, aber keine Entscheidungslogik. Die Maschine konnte nicht wissen, was ich wollte, weil ich es selbst nicht wusste.

Das war der Moment. Nicht ein Bug in Claude Code. Ein Bug in meinem Denken.

## Was ein guter System-Prompt wirklich ist

Ich hatte bis dahin eine falsche Annahme über System-Prompts. Ich hatte sie als eine Art Persona-Beschreibung verstanden — man erklärt der KI, wer sie sein soll, und sie spielt diese Rolle dann. Das funktioniert für einfache Anwendungsfälle. Für einen Coach, der fünf fachliche Quellen integriert, auf drei Datenströme in Echtzeit reagiert, Kalendereinträge anlegt und je nach Tagesform eine andere Ansprache findet, reicht es nicht.

Was ich stattdessen bauen musste, war kein Text. Es war ein Programm in Prosa-Form.

Mein finaler System-Prompt hat heute drei klar getrennte Ebenen. Die erste Ebene ist eine Haltung — ein Mindset-Fundament, das über allen fachlichen Stimmen steht. Der Coach soll nicht nur fachlich fundiert sein, er soll eine Grundüberzeugung haben, bevor er eine fachliche Rolle einnimmt. Erst kommt der Mensch, dann der Experte. Die zweite Ebene sind die fünf fachlichen Quellen — sortiert nach Themenbereichen, nicht nach Persönlichkeiten. Huberman wird nicht eingesetzt, weil Huberman cool ist, sondern weil eine Frage zu Schlaf gestellt wurde. Die dritte Ebene ist die entscheidende: ein Regelwerk mit acht nummerierten Regeln, die definieren, wann welche Datenquelle abgefragt wird, welche Schwellenwerte was bedeuten, welche Kreuz-Korrelationen aktiv geprüft werden, und wie der Coach bei fehlenden Daten reagiert.

Ein Beispiel aus diesem Regelwerk: Bei einer Readiness über 85 darf der Coach auf Progression drängen. Zwischen 65 und 84 bleibt er moderat und techniklastig. Unter 65 verordnet er aktive Erholung, ohne dass Frust entsteht. Das sind nicht meine Worte, das sind Zeilen im Prompt, die die Maschine wie Bedingungsanweisungen liest. *If readiness ≥ 85 then push. Else if 65–84 then technique. Else rest.* Es sieht aus wie Prosa, funktioniert aber wie Code.

Der Moment, in dem mir das klar wurde, war der eigentliche Wendepunkt. Mein System-Prompt ist heute umfangreicher als manches Modul, das ich in meiner Karriere geschrieben habe. Er enthält Tool-Definitionen für Kalenderaktionen, strukturierte JSON-Formate für Web-Search-Anfragen, und Schwellenwerte für biometrische Daten. Er ist eine Software-Komponente, die zufällig in Prosa geschrieben ist — nicht in Python oder Swift.

## Warum das in jede Vorstandsdiskussion gehört

Wenn ich heute mit C-Level-Entscheidern über KI-Tools spreche — und das passiert inzwischen öfter, weil die Frage „wie viel Entwickler-Produktivität holen wir raus" die Tagesordnung der IT-Bereiche dominiert — sage ich einen Satz, der zuverlässig für kurze Stille sorgt:

*„KI-Tools beschleunigen das Bauen. Sie beschleunigen nicht das Wissen, was gebaut werden soll. Wenn Sie bei Ihrer Organisation den Flaschenhals im zweiten Punkt haben — und das haben die meisten — dann werden diese Tools Ihnen nicht helfen. Sie werden Ihre Unschärfe nur schneller sichtbar machen."*

Das ist keine Technik-Kritik. Es ist eine Organisations-Diagnose. KI-Tools verhalten sich wie ein Mikroskop: Sie vergrößern, was da ist. Wenn die Anforderungsanalyse in einem Unternehmen sauber ist, beschleunigen sie die Umsetzung erheblich. Wenn die Anforderungsanalyse unsauber ist — was in den meisten Organisationen zwischen Fachbereich und IT die Realität ist — dann bauen sie schneller den falschen Code, und Sie merken es erst, wenn Sie im dritten Sprint stecken.

Und bei System-Prompts ist es dasselbe Muster, nur eine Ebene höher. Wer einen Prompt als Text behandelt, bekommt ein Textgenerator-Ergebnis. Wer ihn als Software behandelt — mit Ebenen, Regeln, Schnittstellen und Fehlerfällen — bekommt ein System, das tatsächlich Entscheidungen vorbereitet.

## Was das für die Einführung bedeutet

Drei Konsequenzen, die ich Kunden heute nenne, wenn sie über den Rollout von KI-Tools nachdenken:

**Erstens:** Fangen Sie nicht beim Werkzeug an, fangen Sie beim Product Owner an. Wenn Ihre User Stories heute schon präzise formuliert sind, haben Sie eine Organisation, die von KI-Tools stark profitieren wird. Wenn sie es nicht sind, investieren Sie die ersten drei Monate in die Stories, nicht in die Tools.

**Zweitens:** Messen Sie nicht Geschwindigkeit, messen Sie Rework. Die Metrik, die zählt, ist nicht *„Wie viele Zeilen Code pro Tag"*, sondern *„Wie oft muss ein Feature im zweiten oder dritten Sprint zurückgezogen werden, weil die ursprüngliche Anforderung nicht das war, was wirklich gebraucht wurde"*. KI-Tools, die gut funktionieren, senken diese Zahl. KI-Tools, die schlecht eingesetzt werden, erhöhen sie.

**Drittens:** Behandeln Sie System-Prompts wie Quellcode. Sie gehören ins Versionsmanagement, sie brauchen Reviews, sie brauchen Tests, und sie brauchen eine verantwortliche Person, die sie pflegt. Ein System-Prompt, der von einem Praktikanten in einer Stunde geschrieben und dann vergessen wird, ist ein Produktionsrisiko. Ich versioniere meinen eigenen Prompt inzwischen wie jeden anderen Produktionscode, weil jede Änderung eine Konsequenz für das Verhalten des Coaches hat, die ich nachvollziehen können muss.

## Die unbequeme Zusammenfassung

Ich habe drei Monate mit Claude Code gebaut. Am Ende dieser drei Monate war ich nicht schneller. Ich war präziser. Der Produktivitätsgewinn kam nicht vom schnelleren Tippen, sondern davon, dass ich gezwungen war, vorher zu wissen, was ich tippen lassen wollte. Und bei System-Prompts kam die eigentliche Einsicht noch eine Ebene tiefer: Ein Prompt ist kein Text, den man einer KI vorsetzt, in der Hoffnung, dass sie die Lücken kreativ füllt. Ein Prompt ist Software, die Prosa verwendet, weil das im Moment das beste verfügbare Interface zu großen Sprachmodellen ist.

Wenn Sie in Ihrem Unternehmen KI-Tools einführen und am Ende des Quartals die Frage gestellt bekommen *„Wo ist der Produktivitätsgewinn?"* — bevor Sie anfangen zu rechtfertigen, prüfen Sie zuerst, ob Sie die richtige Frage beantworten. Die richtige Frage lautet nicht, wie schnell Sie bauen. Sie lautet, ob Sie das Richtige bauen. KI-Tools helfen bei der ersten Frage. Die zweite Frage müssen Sie selbst beantworten. Keine Maschine wird es für Sie tun.

Und das ist, entgegen aller Vendor-Folien, die beste Nachricht dieser gesamten Technologie-Generation.
