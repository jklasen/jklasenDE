---
title: "An AI prompt is not text. It is software."
kicker: "Future Proof Tech Briefing · April 2026"
date: 2026-04-10
author: "Jens Klasen"
readingTime: "6 minutes"
teaser: "Why the real value of AI-assisted coding isn't speed — it's the discipline it forces on you."
lang: "en"
aiTranslated: true
---

The real value of AI-assisted coding isn't speed. It is the discipline it forces on you. If you explain imprecisely to a machine what you want, you get imprecise code. That isn't a bug. That's the feature.

Over the last three months I built a personal AI coaching app that I use myself — JK-Fitt. The app reads data from Apple HealthKit, talks directly to the unofficial cloud API of my RENPHO body composition scale, pulls training data from Oura, and hands everything to a coach that's built on a system prompt and talks to Claude through its own Anthropic API key. I built the app mostly with Claude Code. And on one single component I gained an insight I now carry into every customer conversation about AI productivity.

That component was the coach's system prompt.

## How I started — and why it didn't work

I wanted a coach grounded simultaneously in several voices from the evidence-based health and training space. Andrew Huberman for neuroscience, sleep architecture and HRV. Andreas Breitfeld for longevity and biohacking. Lukas Ziegler for training precision and exercise physiology. Dr. Ulrich Selz for supplementation and gut health. Dr. Tobias Weigl for nutrition and sports medicine. Five sources with very different focuses, meant to alternate inside a single conversation with me, depending on what my daily data showed.

I wrote the system prompt in two hours, handed it to Claude Code, built the rest of the pipeline, and looked forward to the first real conversation with the coach. The result was usable but unfocused. The coach was friendly, competent, and completely interchangeable. I might as well have queried ChatGPT with no prompt at all.

I revised the prompt. Second pass: better, but not there yet. Third pass: marginally better. Fourth pass: frustration. I then asked Claude Code to help me analyse it, and the answer was uncomfortable: I had named five voices, but defined no rules for when each should speak. I had described personalities, but no decision logic. The machine couldn't know what I wanted, because I didn't know it myself.

That was the moment. Not a bug in Claude Code. A bug in my thinking.

## What a good system prompt actually is

Until then I had held a false assumption about system prompts. I'd understood them as a kind of persona description — you explain to the AI who it should be, and it plays that role. That works for simple use cases. For a coach that integrates five subject-matter sources, reacts to three real-time data streams, creates calendar entries, and finds a different tone depending on the day's readiness, it doesn't.

What I had to build instead wasn't text. It was a program in prose form.

My final system prompt today has three clearly separated layers. The first layer is a stance — a mindset foundation that sits above all the subject-matter voices. The coach should not just be technically grounded, he should have a baseline conviction before he takes on any technical role. Human first, expert second. The second layer is the five subject-matter sources — sorted by topic area, not by personality. Huberman doesn't get pulled in because Huberman is cool, but because the question is about sleep. The third layer is the decisive one: a rulebook of eight numbered rules that define when which data source gets queried, what thresholds mean, which cross-correlations get actively checked, and how the coach behaves when data is missing.

An example from that rulebook: at a readiness above 85, the coach is allowed to push for progression. Between 65 and 84 he stays moderate and technique-focused. Below 65 he prescribes active recovery, without inducing frustration. Those aren't my words, those are lines in the prompt that the machine reads like conditional statements. *If readiness ≥ 85 then push. Else if 65–84 then technique. Else rest.* It looks like prose, but it functions like code.

The moment that became clear to me was the real turning point. My system prompt today is more extensive than some modules I've shipped over my career. It contains tool definitions for calendar actions, structured JSON formats for web search queries, and threshold values for biometric data. It is a software component that happens to be written in prose — instead of in Python or Swift.

## Why this belongs in every boardroom conversation

When I talk with C-level decision-makers today about AI tools — and that happens more often, because the question "how much developer productivity do we get out of this" dominates the IT department's agenda — I say one sentence that reliably produces a short silence:

*"AI tools accelerate building. They don't accelerate knowing what to build. If your organisation's bottleneck is the second one — and in most it is — these tools won't help you. They'll just make your fuzziness visible faster."*

That isn't a critique of the technology. It's an organisational diagnosis. AI tools behave like a microscope: they magnify what's there. If the requirements analysis in a company is clean, they accelerate delivery considerably. If the requirements analysis is unclean — which is the reality in most organisations between the business side and IT — then they build the wrong code faster, and you only notice in the third sprint.

And with system prompts, it's the same pattern, just one level up. If you treat a prompt as text, you get a text-generator result. If you treat it as software — with layers, rules, interfaces and error cases — you get a system that actually prepares decisions.

## What that means for rollout

Three consequences I give customers today, when they're thinking about an AI-tool rollout:

**First:** don't start with the tool, start with the product owner. If your user stories are already precisely worded, you have an organisation that will benefit strongly from AI tools. If they aren't, invest the first three months in the stories, not in the tools.

**Second:** don't measure speed, measure rework. The metric that counts isn't *"how many lines of code per day"*, it's *"how often does a feature have to be pulled back in the second or third sprint because the original requirement wasn't what was actually needed"*. AI tools that work well lower that number. AI tools deployed badly raise it.

**Third:** treat system prompts like source code. They belong in version control, they need reviews, they need tests, and they need a responsible owner who maintains them. A system prompt written by an intern in an hour and then forgotten is a production risk. I version my own prompt today like any other production code, because every change has a consequence for the coach's behaviour that I need to be able to trace.

## The uncomfortable summary

I built with Claude Code for three months. At the end of those three months I was not faster. I was more precise. The productivity gain didn't come from faster typing, but from being forced to know in advance what I wanted typed for me. And with system prompts, the real insight sat one level deeper still: a prompt is not text you set in front of an AI in the hope that it'll creatively fill the gaps. A prompt is software that uses prose, because prose is currently the best available interface to large language models.

When your company rolls out AI tools and at the end of the quarter the question comes back at you, *"where's the productivity gain?"* — before you start justifying, check first whether you're answering the right question. The right question isn't how fast you build. It's whether you're building the right thing. AI tools help with the first question. The second question you have to answer yourself. No machine will do it for you.

And that, contrary to all the vendor decks, is the best news of this entire technology generation.
