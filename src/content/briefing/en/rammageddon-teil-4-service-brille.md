---
title: "RAMmageddon Part 4: Hardware lens off, service lens on"
kicker: "Future Proof Tech Briefing · April 2026"
date: 2026-04-30
author: "Jens Klasen"
readingTime: "6 minutes"
teaser: "Why classic sizing is the wrong tool in 2026 — and how a different reading of the same dataset saves the refresh budget."
lang: "en"
aiTranslated: true
---

Six weeks after Part 3, much has been confirmed — and one question has crystallized out of the responses. It came from CTOs, IT leaders, one CFO, and even from two architects who deal with refresh tickets in their day jobs. It is phrased differently each time, but at its core always the same:

*"We've understood that we should modernize. But where do we start?"*

That is exactly what today is about.

## Q2 2026: the forecast was right

Quick status, without repeating the first three parts. TrendForce has published its Q2 forecast: server DRAM has gone up by another ~60 percent this quarter. NAND allocations for 2026 are sold out in most categories. Hyperscalers are negotiating 2027 contingents. Intel and AMD are still reporting six-month lead times for standard server CPUs.

The structural crisis I wrote up as a thesis in January is now taken for granted. Nobody I currently speak to asks "is it really that dramatic?". Everyone asks "what do we do now?".

## The uncomfortable observation from customer conversations

Over the past weeks I've spoken with a number of IT leaders. One pattern runs through almost every meeting:

**The diagnosis is there. What's missing is the lens through which to read your own environment.**

The standard tools in most data centers are sizing tools from hardware vendors. They answer exactly one question: *which box fits 1:1 for the refresh?* They collect CPU, RAM, IOPS, latency — and map it onto the next-generation device in the vendor's portfolio.

What they don't answer: which software is driving the load? Where are the hotspots that could be modernized instead of replaced? In the workload that's maxing out a server right now, what has grown over the years, what is necessary, what is junk?

For that there is no standard tool. There is only a different reading of the same dataset.

## Two lenses, one dataset

Imagine a discovery tool collects seven days of telemetry from your vCenter, your Hyper-V cluster or your Linux fleet. Hostnames, OS, CPU sockets, RAM, IOPS, latency, VMs, boot times, provisioning dates, application signatures. Non-invasive, no impact on operations.

**With the hardware lens** the picture is:

- 9 hosts, each 768 GB RAM, totaling 284 cores
- Peak load in the 95th percentile
- Storage delivers around 3,300 IOPS, latency at the pain threshold
- Recommendation: same class, new generation, more RAM, all-flash — list price Q2 2026 (teeth gritted)

**With the service lens**, the same dataset reads:

- Only 27 percent of the installed RAM is actually in use
- 14 percent of the VMs haven't rebooted in over 480 days
- Three VMs generate 65 percent of the storage load
- 22 percent of the VMs run on end-of-life operating systems
- Several dozen VMs are similar apps with identical OS stacks — container candidates with no further debate
- Recommendation: modernize first, dimension leaner second, then procure

It is the same dataset. It is a different question. And it is the only lens with which you can still defend a refresh budget in 2026 that isn't spent on yesterday's architecture at today's prices.

## Six lenses through which the refresh report skips past you

What the service lens does concretely can be distilled into six reading lenses. Each shows something a classic sizing report systematically ignores.

**1. Naming conventions.** VM names reveal business context. *SAP-PROD-01, ERP-DB-04, TEST-OLDPROJ-2020, MIGRATION-TMP-18.* In every data center, the name list is a map of the past — and of the spots where cleanup pays off.

**2. Provisioned vs. active memory.** The single most common lever. A typical picture: hosts with 768 GB RAM, of which 700 are allocated, of which only 200 are actively used. The customer has been paying licenses, power and hardware for 500 GB of air for years.

**3. Boot time and date provisioned.** VMs that haven't been restarted in 18 months. VMs provisioned in 2019 for a project that ended in 2020. Zombie workloads that survive every refresh, because nobody knows who the owner is anymore.

**4. Applications and OS distribution.** What percentage of VMs run on Windows Server 2012 R2? How many databases are still SQL Server 2014? Which Linux distributions are end-of-life? Audit risk, license inefficiency, and modernization leverage live in the same table.

**5. Workload concentration.** Pareto strikes everywhere: in almost every data center fewer than ten percent of VMs generate the bulk of IOPS load. Buying an all-flash array for the whole environment is the most expensive answer to a three-VM problem.

**6. Datastore mapping.** Which VMs share which storage pools? Where are the consolidation opportunities a sizing tool never sees, because it only asks "how much storage do we need next year"?

Six lenses, one dataset, an entirely different conversation with the CFO.

## A case from the field

This sounds theoretical. It isn't. An anonymized Hyper-V environment a vendor documented in its own discovery reference — nine hosts, five days of data collection:

- 9 two-socket hosts, each 36 cores and 768 GB RAM
- 284 cores total, 6.9 TB RAM
- 78 guest VMs, all Windows Server 2019
- Compellent storage, hybrid, iSCSI over 10 GbE

That is the hardware view. Now the service view from the same five days:

- **27 percent RAM utilization.** 1.56 TiB actually active out of 5.62 TiB installed.
- **23 percent CPU utilization.** 195 GHz at peak out of 844 GHz available.
- **3,329 IOPS** in the 95th percentile — on a hybrid storage setup that had long become the brake.
- **100 percent Windows Server 2019** — modernization stagnation for years.

The vendor architect's diagnosis, verbatim: *"Old environment was over-dimensioned. VMs were under-provisioned. Storage was the bottleneck."*

That is not a sizing finding. That is an architecture diagnosis. And precisely because of that, the answer was not "buy the same stack new", but "consolidate onto a third fewer hosts with fewer cores, higher frequency, more RAM per host, and fast NVMe storage".

**A third less hardware at the same performance. That only works with the service lens.**

## What this means for your refresh planning

Three concrete consequences I now give every customer:

**First:** Before you ask for a sizing quote, run a discovery. The tools are available, the bar is low — management-system access is enough, runtime between 24 hours and seven days, no impact on operations.

**Second:** Let the analysis be done by someone who brings the service lens. Hardware partners deliver discovery tools — they do not deliver architecture readings. You need both. The separation isn't accidental.

**Third:** Accept that the result will be uncomfortable. Anyone who reads five days of telemetry honestly will find zombies, over-provisioning, legacy hotspots, license waste. The bad news: that's a lot of cleanup work. The good news: every one of those points is a lever that frees hardware budget.

Anyone who triggers a refresh in 2026 without first reading their architecture isn't financing their own IT — they are financing the hyperscalers' AI margin through the component supply chain. That's tough, but after three newsletter parts it shouldn't surprise anyone anymore.

## What's coming next

In Part 5 we go deeper into the use cases. Seven concrete patterns we find in almost every environment — from zombie VMs through database hotspots to the lakehouse as an answer to the legacy data warehouse. With numbers, with examples, with clear modernization levers.

Until then, two questions for you:

Who among you has already run a discovery in Q2 — and what was the biggest aha moment in the report?

And: which hotspot category hurts most in your environment — licenses, legacy OS, storage heat, zombies, over-provisioning?

Write to me. The next posts grow out of answers like that.

Until Part 5.
