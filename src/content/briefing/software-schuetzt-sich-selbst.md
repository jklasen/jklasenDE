---
title: "Moderne Software schützt sich selbst – ältere nicht. Was das für deine Hardware bedeutet."
kicker: "Future Proof Tech Briefing · Juni 2026"
date: 2026-06-16
author: "Jens Klasen"
readingTime: "5 Minuten"
teaser: "Cloud-native Software schützt sich selbst, gewachsene Software braucht die Infrastruktur – und genau dieser Unterschied entscheidet, wie deine Hardware aussehen muss."
---

Moderne Software schützt sich selbst. Ältere Software verlässt sich darauf, dass die Infrastruktur sie schützt.

Dieser eine Unterschied entscheidet, wie deine Hardware aussehen muss – und er wird in fast jeder Modernisierungs-Diskussion übersprungen. Man redet über den Software-Stack, über Kubernetes, über die VMware-Frage. Aber selten über die Ebene, auf der sich Modernisierung wirklich entscheidet: das Blech darunter.

## Zwei Sorten Software, gegensätzliche Ansprüche

Schau genau hin, und du hast im Rechenzentrum zwei Welten nebeneinander.

Cloud-native Anwendungen laufen verteilt über mehrere Instanzen. Sie fangen den Ausfall eines Knotens selbst ab und erwarten von der Infrastruktur wenig mehr als schnelle, lokale Ressourcen. Schutz ist Teil der Anwendung, nicht der Plattform.

Klassische, gewachsene Software läuft als einzelne Instanz, hält ihren Zustand nicht selbst hoch und ist auf Schutz aus der Infrastruktur angewiesen – Hypervisor-HA, redundantes Storage, Snapshots, Replikation auf Array-Ebene.

Das eine Paradigma will ephemere, günstige, lokale Geschwindigkeit. Das andere will felsenfeste Enterprise-Absicherung. Und beide stehen im selben Rack.

## Wo Modernisierung wirklich entschieden wird

Genau hier – nicht im Software-Stack, sondern bei der Frage, ob deine Hardware beide Welten gleichzeitig bedienen kann. Bei einem Node-Design, das ich maßgeblich mitgestaltet habe, war das der Leitgedanke: NVMe-dichte Worker Nodes, ausgelegt aufs anspruchsvollere Profil, sodass dieselbe Hardware in beiden Welten zu Hause ist:

- als **vSAN-ESA-Host**, der klassische VMs mit infrastruktureller HA absichert
- als **Kubernetes-Worker mit Portworx**, der die lokalen NVMe zum Datenpool für stateful Workloads bündelt

Ein Hardware-Fundament, zwei Schutzmodelle.

## Und die Flexibilität endet nicht am Node

Über dieselbe Datenebene binde ich verschiedene Storage-Klassen transparent ein: lokales NVMe als schnellen Pool, eine FlashBlade als S3-/Objekt-Tier, dazu bestehende Dell-EMC-Systeme aus der „alten" Welt für die Anwendungen, die genau diese Absicherung brauchen. Schnell und langsam, neu und betagt, mehrere Hersteller – alles hinter einer konsistenten Schicht.

## Reaktionsfähigkeit nach zwei Seiten

Das ist mehr als ein Architektur-Gimmick.

Nach innen gibst du jeder Anwendung genau das Schutzniveau, das sie braucht – statt alles pauschal mit teurer Enterprise-Redundanz zu überziehen. Die selbstschützende Cloud-native-App bekommt schnelles lokales NVMe und sonst nichts. Die kritische Altanwendung bekommt ihr volles Sicherheitsnetz. Du zahlst Schutz nach Bedarf, nicht nach Gießkanne.

Nach außen reagierst du auf Lieferengpässe bei Storage, ohne den Stack neu zu denken. Bekommst du das eine System nicht oder erst in zwölf Monaten, schiebst du eben das andere unter. Die Workloads merken davon nichts.

## Du musst dich nicht zwischen alt und neu entscheiden

Das ist die gute Nachricht für alle, die ihre VMware-Infrastruktur noch eine Weile weiterbetreiben müssen – manche aus eigener Entscheidung, manche dazu genötigt. Während deine Software modernisiert, von infrastruktur-abhängig zu selbstschützend, verschiebst du auf demselben Fundament die Ressourcen Schritt für Schritt mit: Workload wandert, Node wird umgewidmet, vorhandenes Storage wird weiterverwendet. Ohne Forklift, ohne zweite Beschaffung.

In einem Jahr, in dem jeder Server, jedes GB NVMe und die Lieferzeit fürs nächste Array zum Budgetkampf werden, ist Infrastruktur, die beide Welten bedient und sich nicht an einen einzelnen Liefertermin kettet, das effizienteste Kapital überhaupt.

Cloud-native ist eben keine reine Software-Entscheidung. Sie reicht bis aufs Blech. Wer seine Infrastruktur entlang des echten Schutzbedarfs seiner Software spezifiziert, kauft sich Optionalität statt eines weiteren Silos.

Wie differenziert plant ihr euren Infrastruktur-Schutz – bekommt bei euch jede Anwendung dasselbe Sicherheitsnetz, oder richtet ihr es am tatsächlichen Bedarf der Software aus?
