---
title: "RAMmageddon: The six-figure license bill nobody recalculates"
kicker: "Future Proof Tech Briefing · June 2026"
date: 2026-06-09
author: "Jens Klasen"
readingTime: "6 minutes"
teaser: "SQL Server licenses are often the bigger 2026 cost item than the hardware — why consolidation is the underestimated saving lever."
lang: "en"
aiTranslated: true
---

In the last issue it was about data modernization — why a lakehouse in 2026 addresses hardware pressure, license costs and AI readiness all at once. Today I'm zooming in on a single line item that shows up in almost every inventory and still almost never gets cleanly calculated: the SQL Server license.

And I'll say it straight: in many environments the metal isn't the most expensive part of a database server. It's the license that comes due year after year — and it gets lost in the RAMmageddon noise, because everyone is staring at DRAM prices and lead times.

## What we see

We go into organically grown mid-market environments and almost always find the same pattern: dozens of small SQL Server VMs. Typically two to four vCPU, 16 to 32 GB RAM, each for exactly one application. CPU load averages below fifteen percent. Alongside them, dev and test databases happily run on production editions, and Enterprise licenses are stuck on machines that have never touched an Enterprise feature.

Every project brought its own instance over the years. Nobody consolidated, because nobody calculated the licensing model properly.

## What it means

This is where it gets uncomfortable, and where it pays to read the fine print. SQL Server is licensed per core, sold in two-core packs — with a minimum of four core licenses per VM. Meaning: a VM with two vCPU still costs you four cores. One with three costs four. The floor applies regardless of how little the box actually works.

Scale that to thirty, forty small SQL VMs and you're paying a multiple in core licenses for a utilization that, taken together, would fit on a handful of cores. Standard Edition per VM is thus the most expensive way to run SQL Server there is.

On top, the classics: dev and test on paid editions, even though the Developer Edition is fully functional and free for non-production use. Enterprise where Standard would long since do. Passive failover replicas without Software Assurance that suddenly become licensable. In sum, in typical mid-market environments you quickly land in the high five- to six-figure range per year — money that flows out anew every year.

## Which lever

The way out is no black magic, but it needs an honest inventory instead of a gut feeling:

**Consolidate.** Many small instances move onto a few larger hosts. Whoever licenses a host fully with Enterprise plus Software Assurance gets unlimited virtualization on that machine — thirty small license islands become one. The Resource Governor handles workload separation.

**Check editions.** Dev and test on Developer Edition. Standard instead of Enterprise everywhere no Enterprise feature is demonstrably in use.

**Apply Software Assurance deliberately** — for mobility, for passive replicas, for exactly the flexibility that makes consolidation clean in the first place.

And now the bridge to RAMmageddon: right-sizing and consolidation reduce host count and core count. Because the license hangs on the cores, every CPU saved hits the license bill directly. The hardware saving is the side effect. The license saving is the main point.

## Why now

In a year where RAM and server prices turn every hardware procurement into a lottery, the temptation is great to reduce everything to capex and lead times. But the biggest plannable lever lies elsewhere. A hardware order is a one-off pain. An oversized license landscape is a standing order that gets debited every year.

That's exactly why SQL consolidation is the line item a CFO understands immediately — and that works independently of any procurement freeze. You don't have to buy a single new server for it. You just have to stop paying for air.

## How we approach this

We don't read this from the gut, but from the data. An assessment across the existing landscape shows in black and white which editions run where, how many cores are licensed and how little of that is actually needed. From that comes a consolidation roadmap that brings license, hardware and modernization together in one calculation — not three.

How do you handle your SQL estate? Have you cross-checked editions and core licenses in the last twelve months — or has it just been running on since the last project?

In the next issue I'll take on the cloud-bursting topic: when it's a real lever against hardware scarcity — and when it just opens the cost trap from the cloud side.
