---
title: "RAMmageddon Part 7: From data warehouse to AI door-opener"
kicker: "Future Proof Tech Briefing · May 2026"
date: 2026-05-28
author: "Jens Klasen"
readingTime: "12 minutes"
teaser: "Why data modernisation in 2026 hits three flies with one swat — hardware footprint, licence cost, and AI readiness in a single architectural move."
lang: "en"
aiTranslated: true
---

In Part 6, I tried to bury the word "crisis". What we're seeing in 2026 is not a transient bottleneck — it is a structural reset. A permanent reallocation of wafer capacity, in which the AI industry is buying up seventy percent of what the memory makers produce. Anyone waiting for the pendulum to swing back is planning against a reality that won't materialise.

From that diagnosis follows an uncomfortable consequence: hardware is no longer a buffer. Software inefficiency can no longer be bought away. Anyone who wants to keep their data centre efficient in 2026 has to attack where inefficiency has been hiding historically — in the data and application layer.

That is exactly where Part 7 goes. To one hotspot that exists in almost every mid-market data centre, but is rarely identified as a RAMmageddon problem: the grown data warehouse.

In Part 5 I sketched it as Use Case 07 on the map — data modernisation as the AI door-opener. Today we show what that means concretely. Through an anonymised, archetypal project picture of the kind we repeatedly encounter at mid-market mechanical-engineering firms in DACH.

## The archetype I'm anchoring this on

Picture a classic DACH mechanical-engineering firm, upper mid-market. Export-strong, global service organisation, a large installed base with customers in many countries. The service and spare-parts business is strategic — aftermarket margin is often higher than new-business margin, and brand loyalty is decided in the time after the machine is bought.

The IT landscape is typical for this mid-market: grown, functional, modernisation-due in many places. An SAP backbone, alongside it a PLM system, an in-house MES on the shop floor, an IoT platform for telemetry data from the installed machines, a CRM. And in the middle of it all: a historically grown data warehouse.

Oracle Database, built up sometime around the mid-2010s, since migrated onto a modern version, several terabytes of productive data. ETL chains over one of the established commercial tools, nightly loading cycles with multi-hour windows. Alongside it further SQL worlds from acquisitions — rarely cleanly integrated, mostly operated in parallel. Reports run through two or three BI tools, depending on department and history.

That works. It has worked for years. But it works with friction nobody notices anymore — because everyone has gotten used to it.

## What discovery shows

In environments like this we approach the matter with the service lens from Part 4. Several days of data collection, vCenter and database telemetry. Three findings we encounter in varying combinations in practically every mid-market DWH setup.

**First:** The read-to-write workload ratio on the Oracle DWH is heavily skewed. More than eighty percent of database activity is read queries — reports, ad-hoc analyses, BI-tool pulls, Tableau extracts. The nightly ETL chains write once a lot; afterwards the day is massive reading. Exactly the workloads for which Oracle EE including Partitioning, Advanced Compression and Active Data Guard are licensed.

**Second:** The wait time for new reports regularly runs into multiple working days. That isn't a technical problem in the narrow sense — it is an organisational one. Every new analysis needs adjustments in ETL logic, data model, BI cubes. A bottleneck at the data-engineering team, which simultaneously runs the nightly loads and is preparing the next migration project.

**Third — and this is the decisive finding:** An AI initiative pursued for months or years — predictive maintenance, spare-parts forecasting, a service assistant — fails to reach operationalisation. It doesn't fail on models, doesn't fail on algorithms, doesn't fail on budget. It fails because the data isn't accessible. Machine data lives in the IoT platform. Service history lives in the CRM. Spare-parts movements live in the ERP. Failure protocols live in an Excel-driven shadow IT inside the service organisation. Nobody pulls all of this into a shape a model could train on or run inference against.

This isn't one customer's problem. This is the pattern.

## Why AI projects fail structurally in the mid-market

I see this pattern in a high single-digit number of customer conversations per month. Every mid-market firm in DACH has an AI initiative on the roadmap in 2026. Predictive maintenance, spare-parts forecasting, automated service assistants, vision models for quality assurance. The use cases are solid, the models are available, and the hardware — with the constraints from the first six parts of this series — can be procured.

What's missing isn't the AI. What's missing is the data architecture on which an AI can even start.

The grown landscape from Part 5 — data warehouse, ETL chains, BI tools, silo databases from acquisitions — is optimised for the business logic of ten years ago. It is built to deliver predefined reports. It is not built to combine data from multiple sources in real time or near-real time, hand it on to vector indexes, or serve as a context source for a retrieval-augmented-generation setup.

Anyone trying to start an AI use case on this architecture builds practically always the same workaround: a data engineer extracts data from the source systems, writes it into a flat file, cleans it manually, loads it into a notebook, trains a model. Three months later the model is stale, because nobody made the process repeatable. The POC doesn't fail on the model — it fails on its own non-operationalisability.

That is why the AI wave is arriving more slowly in the mid-market in 2026 than vendor slides suggest. Not because the technology isn't mature. Because the data architecture is a bottleneck nobody prioritised.

## The architectural answer: lakehouse as semantic layer

What we propose architecturally in these constellations isn't a migration. It is an additional layer — and that distinction is the decisive one.

Concretely: a lakehouse that doesn't replace the existing source systems but federates them. Apache Iceberg as the open table format. Parquet as the storage format on an S3-compatible object store in your own data centre — for example a MinIO cluster on existing hardware. A query engine like Dremio or Starburst as the access point for analytical load and as the federated layer over Oracle, MSSQL, IoT platform and ERP.

dbt for the transformation logic, in code instead of in proprietary ETL-tool logic, versioned. Apache Airflow for orchestration. A vector index — Qdrant or Weaviate — for the AI layer. And a locally operated open-weight model for the RAG layer, with which service technicians and dispatchers can access machine, service and spare-parts data via a chat interface.

"Chat with your service data" — the service organisation can now ask which machines in a given plant showed which fault patterns in the last quarter, and gets a consolidated answer that fuses IoT platform, CRM and ERP. Without a data engineer in the loop. Without data leaving the building.

This is the AI bridge I've been talking about since Part 3 of this series. Data modernisation is not the follow-on project you start after the AI strategy. It is the precondition that makes the AI strategy operationalisable in the first place.

## The honest reality check — what federation does NOT save

Here I have to be clear, because over the last weeks the question has come up multiple times: "If you only put the lakehouse on top — how does that save licences?"

The answer is: federation alone saves precisely zero licences.

When the lakehouse sits as a pure additional query layer on top of the source systems, Oracle keeps running as before. The licences keep running. The maintenance keeps running. MSSQL keeps running. The ETL tools keep running. I have an additional component in the architecture — it costs money initially, it saves nothing initially.

That is the honest first half of the story. Anyone selling data modernisation as a quick win for the licence cost centre is lying — or selling a different architecture than the one actually being built in the implementation project.

The saving doesn't come from the federation. It comes from the gradual workload migration that the lakehouse enables in the first place. And it arrives time-delayed.

## The second movement — moving read workloads

With the lakehouse as an operational layer, the option emerges to pull read load off the Oracle DWH. That is the second movement in the project, which typically starts six to twelve months after the initial federation — once the lakehouse is running stably, once the data models are sound, once the business units trust the new layer.

Concretely that means: BI reports are gradually rewired against the lakehouse. Self-service analytics over Dremio instead of directly against Oracle. Ad-hoc queries from power users migrate into the open layer. The stored-procedure logic for recurring reports is translated into dbt models.

What used to be eighty percent of Oracle load now runs on the lakehouse. And exactly here is where the lever appears.

With dramatically reduced read load on Oracle, options suddenly become activatable that previously didn't make economic sense.

**First: unsubscribe Oracle options.** Partitioning typically costs between ten and fifteen thousand euros per core per year on support. Advanced Compression in the same order of magnitude. Active Data Guard similarly. These options were historically needed to serve read load performantly. Once the read load is gone, the options are no longer needed in the narrow sense. In typical mid-market projects we're talking about a six-figure euro amount per year from option un-subscriptions alone.

**Second: edition downgrade from Oracle EE to SE** on the existing systems that no longer need all EE features. Licence cost halves per core. This isn't possible everywhere — some workloads need EE features independent of the DWH layer — but where it's possible, the lever is large.

**Third, and this is the actual reset: engine swap** for the workloads that don't strictly need to stay on Oracle. Transactional applications historically built on Oracle because that was the corporate-standard DB can move to PostgreSQL. Analytical workloads stay on the lakehouse anyway. Oracle becomes an island for exactly those workloads that really have to stay on Oracle — empirically that's around thirty to forty percent of the original Oracle footprint. The remaining sixty to seventy percent moves.

The result after eighteen to twenty-four months: database licence costs realistically reduce by between thirty and fifty percent. Not through the lakehouse itself. Through the workload migration the lakehouse enables as a technical enabler.

That is the honest mechanism. It is slower than any marketing deck suggests. It is more demanding to execute. And that is exactly why it can't be delivered by every competitor that shows up with a lakehouse logo on a slide.

## What changes in parallel — the AI bridge

While the licence movement plays out over time, something different — and faster — happens on the AI side. Once the lakehouse is running, once the data models stand, once the vector index is wired in, the AI use case becomes operationalisable.

Concretely that means: a predictive maintenance POC that had been lying around for months or years comes into production operation within a few weeks. Not because the model got better — but because the data basis is reliable, repeatable and in a shape a model can work with for the first time. Service intervals become data-driven, spare-parts forecasts improve measurably, service deployments become more plannable.

In parallel the RAG-based service assistant goes live. Service technicians can query machine histories in German, English, or with a bit more effort in further languages, look up fault codes, identify similar incidents in the installed base. The data doesn't leave the data centre. The model — typically a locally operated open-weight model on a GPU infrastructure — stays in-house.

This is the AI sovereignty many mid-market firms demand without knowing the path to it. It doesn't emerge from a cloud strategy. It emerges from a data architecture that makes AI workloads operable in the own data centre.

## The timeline — honest

So that nobody starts with the wrong expectations, here is the realistic project timeline we work with in these constellations.

**Months one to six:** Build of the lakehouse layer. Iceberg tables, object store, query engine, first data models. Federation against the existing source systems. First AI use case — typically the RAG assistant — taken into a productive pilot phase. No licence saving in this phase. Investment is in the foreground.

**Months six to twelve:** Read workloads are gradually rewired from the Oracle DWH into the lakehouse. BI reports are migrated. Self-service analytics go productive. The predictive-maintenance model runs operationally. First option licences are unsubscribed once the corresponding load is safely gone.

**Months twelve to twenty-four:** Engine swap for swappable workloads. Edition downgrades where possible. Oracle shrinks to the island workloads. Licence saving becomes visible in the cost centre. In parallel further AI use cases come online, without the data architecture needing to be touched.

After twenty-four months the picture is: database licence cost between thirty and fifty percent lower than at the start. Hardware footprint for the data and analytics layer significantly leaner, because the lakehouse runs on cheaper compute than the Oracle workloads before. Two to three AI use cases in production. Reporting wait times down from several working days to a few hours.

That is the aggregated effect. It is the sum of three movements that individually aren't extraordinary. It is the architectural discipline to carry them through consistently that makes the difference.

## Sovereignty here isn't marketing — it is architecture

I've treated the sovereignty angle multiple times in this series, in Part 3 as a response to the geopolitical escalation, in Part 5 as transition and target architecture. With data modernisation it becomes concrete.

**First: data residency.** Machine data, service history, spare-parts movements — that is sensitive business knowledge. Anyone shipping it into a hyperscaler model loses not only sovereignty over the data, but becomes dependent on platform decisions made elsewhere. With a local lakehouse and a locally operated model, both stay in-house.

**Second: model sovereignty.** Open-weight models — from Llama to Mistral to specialised European developments — are in 2026 powerful enough to compete with the large commercial models in a concrete use case like this one. The performance gap to the top models is often irrelevant for industry applications such as predictive maintenance or service assistance. What counts is domain tuning, data quality, and integration depth.

**Third: portability.** The lakehouse architecture I've described is not tied to a single vendor. Iceberg is an open table format. Parquet is an open storage format. Dremio and Starburst are interchangeable. The storage sits on an S3-compatible layer that can run at a sovereign provider like STACKIT, IONOS or in your own data centre. If the customer decides tomorrow to push the compute layer into an external sovereign cloud — that's a six-week migration, not an architecture reset.

That is the definition of sovereignty I carry through this series: not the absence of cloud, but the freedom to switch providers at any time. With data modernisation that freedom becomes an explicit design decision.

## What this means for your refresh planning

Three concrete consequences I am giving every customer who has a refresh due in Q3 or Q4 2026.

**First:** If you're planning a hardware refresh today that also touches the DWH or the analytics layer — pause. A lean lakehouse architecture poses the hardware question for the next five years differently than the grown DWH setup did. Anyone who buys 1:1 now freezes yesterday's architecture at today's RAMmageddon prices. With a lakehouse target architecture, sizing, storage profiles, and licensing models change fundamentally.

**Second:** If you're costing an AI initiative right now and the business case is wobbling — ask first whether the problem sits at the AI layer or at the data architecture. If the answer is "data architecture", the AI initiative is no longer its own project. It is the follow-on chapter of a data modernisation that makes sense anyway — and that gains an additional business case through the AI bridge.

**Third:** If you're thinking today about licence-cost reduction at Oracle, MSSQL or comparable commercial databases — think the goal through. Without an alternative for serving read load, edition downgrade will fail, because the workloads need the features. With a lakehouse as the analytical layer, workload migration becomes possible, and with it licence optimisation in an order of magnitude not reachable without that architecture.

## What's coming next

In Part 8 we go into Use Case 06 in depth — which I previewed two weeks ago as a post. "From 80 VMs to 12 Kubernetes nodes" works as a headline, but the reality behind it deserves more room: what does the migration path look like concretely, at which point do Java monoliths tip the project, where does a density factor of ten become realistic — and where does it stay wishful thinking? With a second project picture that addresses the hardware side of the modernisation discussion, while Part 7 took the data side.

In Part 9 follows the third deep article: DB IOPS tiering in practice. Pareto reading, resource governance, NVMe targeting — and why query optimisation often ends up being the most important lever.

The order reflects the prioritisation matrix from Part 5. Data modernisation comes first because it has the largest strategic lever — it solves efficiency and AI growth in one movement. Containers come second because they are the fastest efficiency lever on the hardware side. IOPS tiering comes third because it is the technically deepest but most topic-focused of the three.

---

If you want to see this in your own numbers: we do exactly that at CID. A discovery run, reading through the service lens, architecture workshop for the lakehouse target architecture, roadmap with honest time and cost estimation. Inquiries welcome via direct message.

And to you as a reader, because the resonance to this series interests me: where do you see the bigger blocker for AI use cases at your firm — on the model side or on the data architecture? Write it in the comments. Out of answers like those, the next deep posts grow.

Until Part 8.

---

*Sources and background: Apache Iceberg Project, Dremio and Starburst Documentation, MinIO Reference Architecture, dbt Labs, Apache Airflow Documentation, Qdrant and Weaviate Vector Database Comparisons (2026); Oracle Database Licensing Information User Manual (April 2025); TrendForce Memory Pricing Survey (Q2 2026).*
