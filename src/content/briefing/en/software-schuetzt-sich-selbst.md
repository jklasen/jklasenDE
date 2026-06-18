---
title: "Modern software protects itself — older software doesn't. What that means for your hardware."
kicker: "Future Proof Tech Briefing · June 2026"
date: 2026-06-16
author: "Jens Klasen"
readingTime: "5 minutes"
teaser: "Cloud-native software protects itself, legacy software relies on the infrastructure — and that one difference decides what your hardware has to look like."
lang: "en"
aiTranslated: true
---

Modern software protects itself. Older software relies on the infrastructure to protect it.

This one difference decides what your hardware has to look like — and it gets skipped in almost every modernization discussion. People talk about the software stack, about Kubernetes, about the VMware question. But rarely about the layer where modernization is actually decided: the metal underneath.

## Two kinds of software, opposing demands

Look closely and you have two worlds side by side in the data center.

Cloud-native applications run distributed across multiple instances. They absorb the failure of a node themselves and expect little more from the infrastructure than fast, local resources. Protection is part of the application, not the platform.

Classic, organically grown software runs as a single instance, doesn't keep its own state highly available, and depends on protection from the infrastructure — hypervisor HA, redundant storage, snapshots, array-level replication.

One paradigm wants ephemeral, cheap, local speed. The other wants rock-solid enterprise resilience. And both sit in the same rack.

## Where modernization is really decided

Right here — not in the software stack, but in the question of whether your hardware can serve both worlds at once. In a node design I helped shape substantially, that was the guiding idea: NVMe-dense worker nodes, sized for the more demanding profile, so the same hardware is at home in both worlds:

- as a **vSAN ESA host** that secures classic VMs with infrastructural HA
- as a **Kubernetes worker with Portworx** that pools the local NVMe into a data pool for stateful workloads

One hardware foundation, two protection models.

## And the flexibility doesn't end at the node

Across the same data plane I bring in different storage classes transparently: local NVMe as the fast pool, a FlashBlade as the S3/object tier, plus existing Dell EMC systems from the "old" world for the applications that need exactly that kind of protection. Fast and slow, new and ageing, several vendors — all behind one consistent layer.

## Responsiveness in both directions

This is more than an architecture gimmick.

Inwards, you give every application exactly the level of protection it needs — instead of blanketing everything with expensive enterprise redundancy. The self-protecting cloud-native app gets fast local NVMe and nothing else. The critical legacy application gets its full safety net. You pay for protection on demand, not by the watering can.

Outwards, you respond to storage supply shortages without rethinking the stack. If you can't get one system, or only in twelve months, you simply slot the other one underneath. The workloads don't notice a thing.

## You don't have to choose between old and new

That's the good news for everyone who has to keep running their VMware infrastructure for a while — some by choice, some under duress. As your software modernizes, from infrastructure-dependent to self-protecting, you shift the resources along on the same foundation, step by step: a workload moves, a node is repurposed, existing storage stays in use. No forklift, no second procurement.

In a year where every server, every GB of NVMe and the lead time for the next array turn into a budget fight, infrastructure that serves both worlds and isn't chained to a single delivery date is the most efficient capital there is.

Cloud-native isn't a pure software decision after all. It reaches all the way down to the metal. Whoever specifies their infrastructure along the real protection needs of their software buys optionality instead of yet another silo.

How granular is your infrastructure protection planning — does every application get the same safety net, or do you tailor it to what the software actually needs?
