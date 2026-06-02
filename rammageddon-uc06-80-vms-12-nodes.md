---
title: "RAMmageddon UC 06: Aus 80 VMs werden 12 Kubernetes-Nodes – durchgerechnet"
description: "Ein synthetisches, aber realistisches Referenzmodell: Wie sich Konsolidierung auf VVF/VKS gegen einen Like-for-like-Refresh rechnet – Lizenzcores, RAM-Beschaffung, vSAN-Entitlement und Pure als S3-Capacity-Tier. Mit offengelegten Annahmen zum Selber-Nachrechnen."
pubDate: 2026-05-22
lang: "de"
slug: "rammageddon-uc06-80-vms-12-nodes"
series: "RAMmageddon"
part: "UC 06"
tags: ["RAMmageddon", "VMware", "VVF", "VKS", "Kubernetes", "vSAN", "Pure Storage", "Konsolidierung", "TCO", "Field CTO"]
draft: false
---

In Teil 6 habe ich die Doktrin formuliert: Hardware ist kein Puffer mehr, auf den man Software-Ineffizienz abladen kann. Das ist eine These. Eine These ist nur so viel wert wie die Rechnung, die sie trägt.

Also rechne ich einen der Hotspots aus der Landkarte (Teil 5) konkret durch – UC 06: aus 80 VMs werden 12 Kubernetes-Nodes.

## Vorab: Was diese Rechnung ist und was nicht

Ich verwende keine Kundendaten. Was folgt, ist ein **synthetisches Referenzmodell** mit branchenüblichen Annahmen eines mittelständischen Rechenzentrums. Jede Annahme ist offengelegt, damit du sie gegen deine eigene Umgebung gegenrechnen kannst. Wenn deine Zahlen abweichen, ändert das die Beträge – nicht die Logik.

Ich rechne bewusst **konservativ**: Preise eher am unteren Rand, Einsparungen eher vorsichtig, Migrationsaufwand explizit gegengerechnet. Ein Field-CTO-Argument, das die Gegenrechnung verschweigt, ist ein Verkaufsprospekt.

## Die Ausgangslage: die 80-VM-Welt

Ein typischer Mittelstands-Bestand, fünf Jahre alt, der Hardware-Refresh steht an.

**Workload-Struktur (80 VMs):**

- ~68 VMs stateless oder mit moderatem Aufwand containerisierbar: Web-/App-Server, Middleware, interne Tools, Test/Staging, Batch/Reporting
- ~12 VMs stateful: Datenbanken und persistente Dienste – wandern als StatefulSets mit Persistent Volumes auf den Cluster, Datenbestand auf den Capacity-Tier

**Sizing-Annahmen (Durchschnitt über die 80 VMs):**

| Kennzahl | Annahme | Provisioniert gesamt | Reale Auslastung (typ.) |
|---|---|---|---|
| vCPU je VM | 4 | 320 vCPU | 15–25 % |
| RAM je VM | 12 GB | 960 GB | 30–45 % Working Set |
| Storage je VM | 120 GB | 9,4 TB | ~5 TB belegt (thin) |

Der entscheidende Posten steht in der letzten Spalte. Provisioniert sind 960 GB RAM – real gearbeitet wird mit grob 350–430 GB. Die Differenz ist kein Schätzfehler, sie ist die zwei Jahrzehnte alte Gewohnheit, Ineffizienz mit Kapazität zuzudecken, weil Kapazität billig war. 2026 ist sie es nicht mehr.

Dazu der unsichtbare Posten: Jede VM trägt ein eigenes Gast-Betriebssystem – grob 1,5–2 GB RAM und 15–25 GB Disk, nur für das OS. Über 80 VMs sind das **rund 130 GB RAM und 1,5–2 TB Disk allein für Betriebssysteme**, die keine einzige Zeile Geschäftslogik ausführen. Genau diese OS-Steuer entfällt bei Containern.

## Die zwei Wege beim Refresh

**Weg A – Like-for-like.** Die 80 VMs 1:1 auf neue Hosts. Einfach, risikoarm im Projekt, teuer im Betrieb und in der Beschaffung – weil die provisionierte Größe plus Wachstumsreserve neu eingekauft werden muss, zu den Preisen von 2026.

**Weg B – Konsolidierung auf VVF/VKS.** Die 80 VMs werden zu 12 Kubernetes-Nodes auf VMware vSphere Foundation mit integriertem vSphere Kubernetes Service.

### Zielarchitektur Weg B

- **Cluster-Topologie:** 3 Control-Plane-Nodes (je 4 vCPU / 16 GB) + 9 Worker-Nodes (je 16 vCPU / 96 GB) = 12 Nodes
- **Cluster-Compute (Worker):** 144 vCPU / 864 GB virtuell – gegen einen realen Working-Set-Bedarf von ~400 GB. Der Puffer deckt Bin-Packing-Reserve, Lastspitzen und den Ausfall eines Worker-Nodes (N+1).
- **ESXi-Unterbau:** 4 Hosts statt 6
- **Storage zweistufig:**
  - *Hot-Tier* (Persistent Volumes, Container-Images, etcd, kurzfristige Logs/Metriken) auf **vSAN**
  - *Capacity-/Object-Tier* (Velero-Backups, S3-native App-Daten, Loki/Mimir-Objektstore, Image-Registry, Archive, Langzeit-Logs, große Datasets) auf **Pure (Evergreen) als S3-kompatibler Tier**, von VKS aus über die S3-API genutzt

Die zweistufige Trennung ist nicht kosmetisch – sie ist der Hebel an der teuersten Stelle (siehe vSAN-Entitlement weiter unten).

## Die Hardware-Annahmen, offengelegt

| | Weg A (Like-for-like) | Weg B (VVF/VKS) |
|---|---|---|
| ESXi-Hosts | 6 | 4 |
| CPU je Host | 2 × 32 Cores | 2 × 24 Cores |
| Physische Cores gesamt | 384 | 192 |
| Phys. RAM je Host (Refresh-Dimensionierung) | 256 GB | 192 GB |
| Phys. RAM Cluster gesamt | 1.536 GB | 768 GB |
| vSAN-Flash raw (mit Wachstum/FTT) | ~16 TB | ~8 TB |

Die 16-Core-Minimum-Regel pro CPU ist in beiden Fällen erfüllt (24- und 32-Core-CPUs liegen darüber), es entstehen also keine „Ghost Cores". Wer kleinere CPUs einsetzt, zahlt in *beiden* Wegen den 16-Core-Aufschlag – das verschiebt das Delta nicht.

## Der Hebel, Position für Position

### 1. VVF-Lizenzcores: −192 Cores (−50 %)

VVF wird pro physischem Core lizenziert. Weg A: 384 Cores. Weg B: 192 Cores. Differenz: **192 Cores weniger, dauerhaft, jedes Jahr der Subscription.**

Ich nenne hier bewusst keinen erfundenen Core-Preis – setz deinen real verhandelten Wert ein:

> Einsparung Lizenz = 192 Cores × (dein VVF-€/Core/Jahr) × Subscription-Laufzeit

Illustrativ, mit einer klar als Beispiel gekennzeichneten Annahme von 250 €/Core/Jahr: 192 × 250 = **48.000 €/Jahr**, über eine 3-Jahres-Subscription **144.000 €**. Das ist die mit Abstand größte Einzelposition – und sie ist nicht einmalig, sie wiederkehrt.

### 2. RAM-Beschaffung: −768 GB physisch

Weg A muss beim Refresh 1.536 GB physisches RAM einkaufen, Weg B nur 768 GB. Differenz: **768 GB, die nicht beschafft werden müssen.**

Bei konservativ angesetzten ~1.100 € je 64-GB-DDR5-RDIMM (EU, Mai 2026, unteres Ende der Marktspanne):

> 768 GB / 64 GB = 12 Module × 1.100 € ≈ **~13.200 € vermiedene RAM-Beschaffung**

Das ist der konservative Wert. Realistische Bandbreite bei 1.100–1.800 €/Modul: **13.000–21.600 €**. Und der eigentliche Punkt: Dieser Posten wird quartalsweise teurer – DRAM-Contractpreise steigen in Q2/2026 noch einmal um 58–63 %. Vermiedene Beschaffung 2026 ist vermiedene, deutlich höhere Beschaffung 2027.

### 3. vSAN-Add-on: vermieden – der eleganteste Hebel

VVF enthält 0,25 TiB (256 GiB) vSAN-Kapazität pro lizenziertem Core, über die Umgebung aggregiert.

- Weg B: 192 Cores × 0,25 TiB = **48 TiB vSAN-Entitlement inklusive**
- Hot-Tier-Bedarf nach Konsolidierung: ~6 TB nutzbar, mit vSAN-RAID-5-Overhead ~8 TB raw

8 TB liegen weit unter 48 TiB. Ergebnis: **kein vSAN-Add-on nötig, 0 € zusätzliche Kapazitätslizenz.** Hätte man bei Weg A die provisionierten ~9,4 TB plus Wachstum plus FTT komplett auf vSAN gelegt, wäre man je nach Schutzlevel in die Add-on-TiB-Lizenzierung gelaufen.

Der Doppeleffekt: Die Konsolidierung halbiert die Cores – und der reduzierte Storage-Footprint passt trotzdem komfortabel ins kleinere Entitlement. Du zahlst die Hälfte der Cores und verschenkst trotzdem keine Storage-Lizenz.

### 4. Flash-/NAND-Beschaffung: −8 TB teures Datacenter-Flash

vSAN-Flash raw sinkt von ~16 TB auf ~8 TB. Die kapazitätslastigen, kalten Daten liegen nicht mehr auf teurem vSAN-Flash, sondern auf dem Pure-Capacity-Tier – günstigerer €/TB, QLC-/kapazitätsoptimiert, und vor allem **ohne Bezug zu VMware-Lizenzcores**. NAND-Contractpreise steigen in Q2/2026 um 70–75 % QoQ, also schneller als DRAM. Der vermiedene Flash-Einkauf ist der Posten, der sich am schnellsten verteuert.

### 5. Betrieb: 6 → 4 Hosts

Ein Drittel weniger Hosts: weniger Strom, Rack-HE, Wartungsverträge, Patch-Fläche. Eine Plattform für VMs *und* Container statt zweier getrennter Welten. Kubernetes-Verwaltung über VKS, ohne separates Kubernetes-Lizenzkonstrukt.

## Die Gegenrechnung – damit es ehrlich bleibt

Weg B ist kein Geschenk. Es ist eine Migration, und eine Migration kostet, bevor sie spart. Wer das verschweigt, verkauft – er rechnet nicht.

Der Aufwand verteilt sich auf fünf Phasen. Die Personentage sind Beispielannahmen für das synthetische 80-VM-Modell mittlerer Containerisierungs-Reife – setz deine eigene Reife und Teamkapazität ein:

- **Assessment und Workload-Profiling** (Abhängigkeiten, Datenflüsse, Containerisierbarkeit je Workload): ~10–20 PT
- **Plattform-Aufbau** (VVF/VKS, Storage-Tiering vSAN plus Pure-S3, Netzwerk/Ingress, GitOps- und Observability-Basis): ~20–35 PT
- **Containerisierung der ~68 stateless/semi-stateless Workloads** (gebündelt über Templating, nicht 68-mal von vorn): ~40–80 PT
- **~12 stateful Dienste** (DB-Migration, Persistent-Volume- und Backup-Strategie, Cutover, Wiederanlauf-Tests – hier sitzt das Projektrisiko): ~35–70 PT
- **Cutover, Hypercare, Team-Enablement** (Parallelbetrieb, Wissenstransfer, GitOps-/Kubernetes-Betriebsbefähigung): ~15–35 PT

In Summe grob **130 bis 240 Personentage**. Mit einer klar als Beispiel gekennzeichneten Tagessatz-Annahme von 1.100–1.400 € (spezialisierte Cloud-Native-/Plattformberatung, DACH) ergibt das einen einmaligen Migrations-Invest in der Größenordnung **~145.000 bis ~335.000 €**. Setz deinen realen Satz ein – und beachte: Wer ein eigenes Plattformteam hat, verschiebt einen erheblichen Teil von externem Invest zu interner Kapazität, die Summe verschwindet dadurch aber nicht, sie wechselt nur die Kostenstelle.

Diese Zahl ehrlich gegen die Einsparung gestellt: Die wiederkehrende Komponente (halbierte Lizenzcores, vermiedenes vSAN-Add-on, ein Drittel weniger Hosts im Betrieb, plus der mit jedem Refresh-Zyklus wachsende vermiedene RAM- und Flash-Einkauf) trägt den Invest – aber nicht in 12 Monaten. Realistisch liegt der Break-even je nach realem Lizenzpreis und Containerisierungs-Reife bei **rund zwei bis vier Jahren**. Wer schon Pipelines und ein Plattformteam hat, ist am unteren Rand; wer bei null startet, am oberen.

Das macht den Break-even zum Planungsparameter, nicht zum Hindernis. Wer den nächsten Hardware-Refresh erst in drei bis fünf Jahren vor sich hat, hat exakt das Fenster, das die Amortisation braucht – und investiert heute, zu heutigen Tagessätzen, in eine Plattform, die genau dann steht, wenn der Beschaffungszeitpunkt struktureller und teurer geworden ist. Die Zeit bis zum Refresh ist hier kein Risiko, sondern der Grund, das Projekt jetzt zu terminieren statt später. Das ist die direkte Konsequenz aus dem Structural Reset in Teil 6: Die Modernisierung ist eine terminierte Vorbereitung auf einen Beschaffungszeitpunkt, der mit hoher Sicherheit teurer wird, nicht eine Vorleistung auf Verdacht.

Und genau hier ist der Punkt, den eine reine Amortisationsrechnung nicht erfasst.

## Die strategische Konsequenz: weniger Lock-in

Der Invest kauft nicht nur eine günstigere Kostenkurve. Er kauft eine strukturelle Eigenschaft, die in keiner ROI-Zeile auftaucht.

Nach der Migration sind die Geschäfts-Workloads als Container und Kubernetes-Manifeste beschrieben – nicht als VMs, die an eine bestimmte Hypervisor-Schicht gebunden sind. Das ist eine architektonische Tatsache, unabhängig davon, ob jemals ein Plattformwechsel stattfindet.

Klare Einordnung, damit das nicht missverstanden wird: Das ist kein Aufruf, VMware zu verlassen. VVF ist in diesem Modell die Plattform und bleibt es – und nüchtern betrachtet gibt es 2026 für eine integrierte Enterprise-Plattform mit HCI, Kubernetes und Lifecycle aus einer Hand keine vollwertige 1:1-Alternative am Markt. Ein überstürzter Wechsel wäre keine seriöse Empfehlung, sondern das Eintauschen eines bekannten Risikos gegen ein unbekanntes.

Der Wert liegt nicht im Wechsel, sondern in der Optionalität. Wenn die Workload-Schicht von der Infrastrukturschicht entkoppelt ist, verschiebt sich die Verhandlungsposition: Der Plattformanbieter muss seinen Wert über die Subscription-Laufzeit immer wieder neu beweisen, statt ihn primär über Wechselkosten abzusichern. Lock-in-Reduktion ist hier ein Architekturprinzip, kein Lieferantenurteil – und es ist die konkrete technische Einlösung der Souveränitäts-Linie aus Teil 5 und 6: nicht keine Plattform, sondern strukturelle Wahlfreiheit als Eigenschaft des Systems, nicht als Hoffnung.

## Worauf es hinausläuft

Aus 80 VMs werden 12 Nodes ist keine Verdichtungsspielerei. Es ist die konkrete Anwendung der Doktrin aus Teil 6: Software-Effizienz ist die einzige Kapazitätsquelle, die nicht allokiert, nicht verzollt und nicht von Hyperscalern weggekauft werden kann. Jeder Core, den du nicht lizenzierst, jedes GB RAM, das du nicht beschaffst, ist gegen einen Markt verteidigt, der strukturell teurer wird – und die Workload-Schicht ist danach nicht mehr an die teuerste Schicht gekettet.

Genau dieser Migrationspfad – Assessment, Plattformbau, Containerisierung, Stateful-Cutover ohne Betriebsausfall – ist kein Foliengeschäft, sondern Projekthandwerk. Es ist die Arbeit, für die das Team steht, mit dem ich arbeite; und der Aufwand, den ich oben offen beziffert habe, ist genau deshalb offen beziffert, weil ihn zu verschweigen das Gegenteil von Beratung wäre.

Rechne es mit deinen Zahlen nach. Wenn dein Core-Preis, dein Tagessatz, dein RAM-Angebot oder deine Workload-Struktur das Bild kippt, schreib es in die Kommentare – ich nehme belastbare Gegenrechnungen ernst und gerne in den nächsten Beitrag auf.

---

*Future Proof Tech Briefing – RAMmageddon-Serie, Tiefenbeitrag UC 06. Synthetisches Referenzmodell, keine Kundendaten. Annahmen offengelegt zum Selber-Nachrechnen.*

**Quellen:** Broadcom Product Guide / VVF SPD Februar 2026 und Broadcom TechDocs (VVF-Lizenzierung, 16-Core-Minimum, 0,25 TiB/Core vSAN-Entitlement, VKS in VVF enthalten); TrendForce Memory-Pricing-Survey Q2/2026 (DRAM +58–63 %, NAND +70–75 % QoQ); Marktspannen Server-DDR5-RDIMM Mai 2026 (Memory.NET / Sekundärquellen).
