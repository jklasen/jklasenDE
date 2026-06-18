---
title: "RAMmageddon UC 06: 80 VMs become 12 Kubernetes nodes — fully costed"
kicker: "Future Proof Tech Briefing · May 2026"
date: 2026-05-22
author: "Jens Klasen"
readingTime: "10 minutes"
teaser: "A synthetic but realistic reference model: how consolidation onto VVF/VKS pencils out against a like-for-like refresh — license cores, RAM procurement, vSAN entitlement, and Pure as an S3 capacity tier. With assumptions disclosed for your own recalculation."
lang: "en"
aiTranslated: true
---

In Part 6 I formulated the doctrine: hardware is no longer a buffer onto which you can dump software inefficiency. That is a thesis. A thesis is only worth as much as the calculation that carries it.

So I'm working through one of the hotspots from the map (Part 5) concretely — UC 06: 80 VMs become 12 Kubernetes nodes.

## Up front: what this calculation is and what it isn't

I'm using no customer data. What follows is a **synthetic reference model** with industry-standard assumptions for a mid-market data center. Every assumption is disclosed so you can re-run it against your own environment. If your numbers diverge, that changes the amounts — not the logic.

I'm deliberately calculating **conservatively**: prices at the lower end, savings cautious, migration cost explicitly accounted for. A Field-CTO argument that conceals the counter-calculation is a sales brochure.

## The starting point: the 80-VM world

A typical mid-market estate, five years old, with the hardware refresh due.

**Workload structure (80 VMs):**

- ~68 VMs stateless or containerisable with moderate effort: web/app servers, middleware, internal tools, test/staging, batch/reporting
- ~12 VMs stateful: databases and persistent services — move onto the cluster as StatefulSets with persistent volumes, data set on the capacity tier

**Sizing assumptions (average across the 80 VMs):**

| Metric | Assumption | Provisioned total | Real utilization (typ.) |
|---|---|---|---|
| vCPU per VM | 4 | 320 vCPU | 15–25% |
| RAM per VM | 12 GB | 960 GB | 30–45% working set |
| Storage per VM | 120 GB | 9.4 TB | ~5 TB used (thin) |

The decisive figure sits in the last column. 960 GB of RAM are provisioned — actual working memory is somewhere around 350–430 GB. The delta isn't a measurement error, it is the two-decade-old habit of covering inefficiency with capacity, because capacity was cheap. In 2026 it isn't.

On top of that the invisible item: every VM carries its own guest operating system — roughly 1.5–2 GB of RAM and 15–25 GB of disk, just for the OS. Across 80 VMs that's **around 130 GB of RAM and 1.5–2 TB of disk just for operating systems**, executing no line of business logic. That is exactly the OS tax that disappears with containers.

## The two refresh paths

**Path A — like-for-like.** The 80 VMs 1:1 onto new hosts. Simple, low project risk, expensive in operations and procurement — because the provisioned size plus growth buffer has to be bought new, at 2026 prices.

**Path B — consolidation onto VVF/VKS.** The 80 VMs become 12 Kubernetes nodes on VMware vSphere Foundation with integrated vSphere Kubernetes Service.

### Target architecture Path B

- **Cluster topology:** 3 control-plane nodes (4 vCPU / 16 GB each) + 9 worker nodes (16 vCPU / 96 GB each) = 12 nodes
- **Cluster compute (worker):** 144 vCPU / 864 GB virtual — against a real working-set demand of ~400 GB. The buffer covers bin-packing reserve, load spikes, and the loss of one worker node (N+1).
- **ESXi underlay:** 4 hosts instead of 6
- **Two-tier storage:**
  - *Hot tier* (persistent volumes, container images, etcd, short-term logs/metrics) on **vSAN**
  - *Capacity / object tier* (Velero backups, S3-native app data, Loki/Mimir object store, image registry, archive, long-term logs, large datasets) on **Pure (Evergreen) as an S3-compatible tier**, used from VKS via the S3 API

The two-tier split is not cosmetic — it is the lever at the most expensive spot (see vSAN entitlement below).

## The hardware assumptions, disclosed

| | Path A (Like-for-like) | Path B (VVF/VKS) |
|---|---|---|
| ESXi hosts | 6 | 4 |
| CPU per host | 2 × 32 cores | 2 × 24 cores |
| Physical cores total | 384 | 192 |
| Physical RAM per host (refresh sizing) | 256 GB | 192 GB |
| Physical RAM cluster total | 1,536 GB | 768 GB |
| vSAN flash raw (with growth/FTT) | ~16 TB | ~8 TB |

The 16-core minimum rule per CPU is satisfied in both cases (24- and 32-core CPUs are above it), so no "ghost cores". Anyone using smaller CPUs pays the 16-core surcharge in *both* paths — that doesn't shift the delta.

## The lever, position by position

### 1. VVF license cores: −192 cores (−50%)

VVF is licensed per physical core. Path A: 384 cores. Path B: 192 cores. Delta: **192 cores fewer, permanently, every year of the subscription.**

I'm deliberately not naming an invented per-core price — plug in your real negotiated value:

> License saving = 192 cores × (your VVF €/core/year) × subscription term

For illustration only, with a clearly flagged sample assumption of €250/core/year: 192 × 250 = **€48,000/year**, over a 3-year subscription **€144,000**. That is by far the largest single line item — and it is not one-off, it recurs.

### 2. RAM procurement: −768 GB physical

Path A has to purchase 1,536 GB of physical RAM for the refresh, Path B only 768 GB. Delta: **768 GB that don't have to be procured.**

At conservatively assumed ~€1,100 per 64 GB DDR5 RDIMM (EU, May 2026, lower end of market):

> 768 GB / 64 GB = 12 modules × €1,100 ≈ **~€13,200 RAM procurement avoided**

That is the conservative figure. The realistic range at €1,100–€1,800 per module: **€13,000–€21,600**. And the real point: this line item gets more expensive every quarter — DRAM contract prices rise another 58–63% in Q2/2026. Procurement avoided in 2026 is procurement avoided at significantly higher 2027 prices.

### 3. vSAN add-on: avoided — the most elegant lever

VVF includes 0.25 TiB (256 GiB) of vSAN capacity per licensed core, aggregated across the environment.

- Path B: 192 cores × 0.25 TiB = **48 TiB of vSAN entitlement included**
- Hot-tier demand after consolidation: ~6 TB usable, with vSAN RAID-5 overhead ~8 TB raw

8 TB sits well below 48 TiB. Result: **no vSAN add-on needed, €0 additional capacity license.** If Path A had put the provisioned ~9.4 TB plus growth plus FTT all on vSAN, you would have run into the add-on TiB licensing depending on the protection level.

The double effect: consolidation halves the cores — and the reduced storage footprint still fits comfortably into the smaller entitlement. You pay half the cores and still don't give away any storage license.

### 4. Flash / NAND procurement: −8 TB of expensive datacentre flash

vSAN flash raw drops from ~16 TB to ~8 TB. The capacity-heavy, cold data no longer sits on expensive vSAN flash, but on the Pure capacity tier — cheaper €/TB, QLC/capacity-optimized, and above all **without ties to VMware license cores**. NAND contract prices rise 70–75% QoQ in Q2/2026, faster than DRAM. The avoided flash purchase is the line item that gets more expensive the fastest.

### 5. Operations: 6 → 4 hosts

A third fewer hosts: less power, rack U, maintenance contracts, patch surface. One platform for VMs *and* containers instead of two separate worlds. Kubernetes management via VKS, without a separate Kubernetes licensing construct.

## The counter-calculation — to keep it honest

Path B is no gift. It is a migration, and a migration costs before it saves. Anyone who hides that is selling — not calculating.

The effort distributes across five phases. The person-days are sample assumptions for the synthetic 80-VM model at medium containerization maturity — plug in your own maturity and team capacity:

- **Assessment and workload profiling** (dependencies, data flows, containerisability per workload): ~10–20 PD
- **Platform build** (VVF/VKS, storage tiering vSAN plus Pure S3, network/ingress, GitOps and observability base): ~20–35 PD
- **Containerization of the ~68 stateless / semi-stateless workloads** (bundled via templating, not 68 times from scratch): ~40–80 PD
- **~12 stateful services** (DB migration, persistent volume and backup strategy, cutover, recovery tests — this is where the project risk sits): ~35–70 PD
- **Cutover, hypercare, team enablement** (parallel operation, knowledge transfer, GitOps / Kubernetes operational enablement): ~15–35 PD

In total roughly **130 to 240 person-days**. At a clearly flagged sample day-rate assumption of €1,100–€1,400 (specialist cloud-native / platform consulting, DACH) that gives a one-off migration investment in the range **~€145,000 to ~€335,000**. Plug in your real rate — and note: anyone with their own platform team shifts a substantial part from external invest to internal capacity, but the sum doesn't disappear, it just changes cost center.

Honestly set against the saving: the recurring component (halved license cores, avoided vSAN add-on, a third fewer hosts in operations, plus the avoided RAM and flash purchase growing with every refresh cycle) carries the invest — but not in 12 months. Realistically the break-even, depending on real license price and containerization maturity, sits at **roughly two to four years**. Whoever already has pipelines and a platform team is at the lower end; whoever starts at zero, at the upper.

That makes the break-even a planning parameter, not an obstacle. Whoever's next hardware refresh is three to five years away has exactly the window the amortization needs — and invests today, at today's day-rates, in a platform that stands precisely when the procurement moment has become structurally and substantively more expensive. The time to refresh isn't a risk here, it is the reason to schedule the project now rather than later. That is the direct consequence of the structural reset in Part 6: modernization is a scheduled preparation for a procurement moment that will with high certainty be more expensive — not an act of faith.

And exactly here is the point a pure amortization calculation doesn't capture.

## The strategic consequence: less lock-in

The investment doesn't just buy a cheaper cost curve. It buys a structural property that doesn't appear in any ROI line.

After the migration, the business workloads are described as containers and Kubernetes manifests — not as VMs tied to a specific hypervisor layer. That is an architectural fact, independent of whether a platform change ever happens.

Clear framing so this isn't misread: this is not a call to leave VMware. VVF is the platform in this model and stays the platform — and soberly speaking, in 2026 there is no full 1:1 alternative to an integrated enterprise platform with HCI, Kubernetes and lifecycle from one source. A rushed switch would not be a serious recommendation, but trading a known risk for an unknown one.

The value lies not in the switch, but in the optionality. When the workload layer is decoupled from the infrastructure layer, the negotiating position shifts: the platform vendor has to re-earn its value across the subscription term, rather than primarily securing it through switching cost. Lock-in reduction is an architectural principle here, not a vendor verdict — and it is the concrete technical fulfilment of the sovereignty line from Parts 5 and 6: not no platform, but structural choice as a property of the system, not as a hope.

## What it comes down to

80 VMs becoming 12 nodes is not a compaction trick. It is the concrete application of the doctrine from Part 6: software efficiency is the only capacity source that can't be allocated, can't be tariffed, and can't be bought up by hyperscalers. Every core you don't license, every GB of RAM you don't procure, is defended against a market that is structurally getting more expensive — and the workload layer is no longer chained to the most expensive layer.

Exactly this migration path — assessment, platform build, containerization, stateful cutover without operational outage — is not a slide business, it is project craft. It is the work the team I work with stands for; and the effort I costed openly above is openly costed precisely because hiding it would be the opposite of advice.

Run it on your own numbers. If your core price, your day rate, your RAM offer or your workload structure tips the picture, write it in the comments — I take solid counter-calculations seriously and gladly into the next post.

---

*Future Proof Tech Briefing — RAMmageddon series, deep dive UC 06. Synthetic reference model, no customer data. Assumptions disclosed for your own recalculation.*

**Sources:** Broadcom Product Guide / VVF SPD February 2026 and Broadcom TechDocs (VVF licensing, 16-core minimum, 0.25 TiB/core vSAN entitlement, VKS included in VVF); TrendForce Memory Pricing Survey Q2/2026 (DRAM +58–63%, NAND +70–75% QoQ); Server DDR5 RDIMM market ranges May 2026 (Memory.NET / secondary sources).
