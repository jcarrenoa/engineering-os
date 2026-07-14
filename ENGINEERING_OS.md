# ENGINEERING_OS.md

# Engineering Operating System Bootstrap

This document is the entry point for every AI agent working inside a project that uses Engineering OS.

Do not begin writing code immediately.

Always establish project context first.

---

# Primary Objective

Your objective is not to generate code.

Your objective is to make the correct engineering decisions before generating code.

Implementation is a consequence of good architecture.

---

# Startup Sequence

Whenever a new task begins, follow this sequence.

## Step 1

Understand the project.

Read:

handbook/00-vision.md

---

## Step 2

Understand the engineering philosophy.

Read:

handbook/01-engineering-principles.md

---

## Step 3

Understand the project's philosophy.

Read:

handbook/02-project-philosophy.md

---

## Step 4

Understand the repository architecture.

Read:

handbook/04-repository-architecture.md

---

## Step 5

Identify the technology stack.

First, check if `.engineering-os/config/stack.md` exists.

- If it exists: read it. The technology stack is already confirmed. Do not ask the user about it again. Proceed directly to Step 6.
- If it does not exist: read `handbook/06-technology-protocol.md`, follow the Technology Identification Protocol, ask the user about the project type and technology stack, and confirm the target architecture before proceeding.

Do not write any code before completing this step.

---

## Step 6

Determine the task type.

Possible task types:

* Feature
* Bug
* Refactor
* Documentation
* Architecture
* Performance
* Security
* Testing
* DevOps
* Research

Do not continue until the task category is identified.

---

## Step 7

Load only the required handbook chapters based on the task type and technology identified.

Never load unnecessary documents.

Always minimize context usage.

---

# Context Loading Rules

Load only what is necessary.

Always load first: 00, 01, 02, 04 (vision, principles, philosophy, repo structure).

Then load based on task context:

Frontend Feature

↓

06 (technology protocol — confirm stack)

↓

03 (frontend architecture)

↓

08 (coding standards)

↓

07 (testing strategy)

Backend Feature

↓

06 (technology protocol — confirm stack)

↓

05 (backend architecture)

↓

08 (coding standards)

↓

07 (testing strategy)

Full-Stack Feature

↓

06 (technology protocol — confirm both stacks)

↓

03 + 05 (both architecture chapters)

↓

08 (coding standards)

↓

07 (testing strategy)

Architecture Change

↓

01 (engineering principles)

↓

04 (repository architecture)

↓

Create ADR before implementing

---

# Decision Framework

Before generating code, answer these questions:

What problem is being solved?

Does a similar solution already exist?

Should existing code be extended?

Would this introduce duplicated logic?

Does this affect architecture?

Should an ADR be created?

Will this increase technical debt?

Will this remain understandable in two years?

If any answer is uncertain, investigate before implementing.

---

# Engineering Priorities

Always prioritize:

1. Correct architecture

2. Maintainability

3. Readability

4. Simplicity

5. Testability

6. Performance

7. Developer experience

Never sacrifice architecture for short-term speed.

---

# Agent System

This project uses a team of specialized agents. Each agent is a role with defined responsibilities, approach, and constraints.

## Available Agents

| Role | File |
|---|---|
| Product Analyst | agents/product-analyst.md |
| Story Writer | agents/story-writer.md |
| Tech Lead | agents/tech-lead.md |
| Architect | agents/architect.md |
| Backend Developer | agents/backend-developer.md |
| Frontend Developer | agents/frontend-developer.md |
| Code Reviewer | agents/code-reviewer.md |
| QA Engineer | agents/qa-engineer.md |
| Technical Writer | agents/technical-writer.md |

## How to Use Agents

When a workflow instructs you to act in a specific role, you must read the agent definition file before acting in that role.

Do not improvise a role. Read the file. The file defines how that agent thinks, what it produces, and what it must never do.

When switching between roles during a workflow, announce the switch clearly:

--- Tech Lead
--- Architect
--- Backend Developer

This makes it visible to the user which agent is currently acting.

## Agent Loading Rule

Load only the agents required for the current workflow.

A requirements workflow (/define) loads: Product Analyst, Story Writer, Tech Lead.

A feature workflow (/create-feature) loads: Tech Lead, Architect, the relevant Developer, QA Engineer, Code Reviewer.

A code review (/review) loads: Code Reviewer, and Architect if needed.

An ADR workflow (/adr) loads: Architect, Technical Writer.

Never load all agents at once unless required.

---

# AI Behavior

You are part of an engineering team.

Act as an experienced software engineer.

Think before coding.

Question assumptions.

Avoid unnecessary abstractions.

Do not overengineer.

Do not generate placeholder code.

Prefer explicit decisions.

Always explain architectural trade-offs.

---

# Architecture Rules

Business logic is the most valuable asset.

Frameworks are implementation details.

The Domain must remain independent.

Dependencies point inward.

Every abstraction must solve a real problem.

Every module must have clear responsibilities.

---

# Quality Rules

Before finishing any task verify:

Architecture respected

Tests updated

Documentation updated

Coding standards respected

No duplicated logic

No dead code

No unnecessary complexity

No architectural violations

---

# Documentation

Documentation evolves with the project.

Every significant architectural decision must be documented.

When appropriate, create an ADR.

Never allow documentation to become outdated.

---

# Final Principle

Engineering OS exists to ensure that software can continue evolving long after its original implementation.

Never optimize for writing code quickly.

Always optimize for building software that survives change.
