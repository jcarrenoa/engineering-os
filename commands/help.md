# Command — /help

## Purpose

Display the complete Engineering OS reference: what the framework is, all available commands, agents, workflows, and how to start a new project.

---

## What This Command Does

Read this file and output the help guide below to the user.
Do not start any workflow.
Do not ask any questions.
Output the content between the `---` markers as a formatted response.

---

## Output

---

# Engineering OS — Reference Guide

Engineering OS is an opinionated framework that turns Claude into a structured engineering team. It enforces clean architecture, guided workflows, and consistent standards regardless of the technology you use.

---

## Getting Started

### Set up a new project

**1. Pick a starter template**

Copy the starter for your stack from `templates/starters/<stack>/` to your project root.

| Stack | Directory |
|---|---|
| React | `templates/starters/react-typescript/` |
| Vue | `templates/starters/vue-typescript/` |
| Angular | `templates/starters/angular-typescript/` |
| NestJS | `templates/starters/nestjs-typescript/` |
| Flutter | `templates/starters/flutter-dart/` |
| FastAPI | `templates/starters/fastapi-python/` |
| Spring Boot | `templates/starters/spring-java/` |
| .NET | `templates/starters/dotnet-csharp/` |
| Go | `templates/starters/go/` |

**2. Copy the dev scripts**

Copy these four files from `templates/` to your project root:

```
install.bat   install.ps1   run.bat   run.ps1
```

**3. Install dependencies**

Run `install.bat` from the project root.

On first run, it auto-detects the stack and asks which package manager to use:

| Stack | Options |
|---|---|
| Python (FastAPI) | `uv` (recommended) or `pip` |
| TypeScript / Node | `bun` (recommended) or `pnpm` |

The choice is saved to `.eng-config.json`. Delete that file to re-prompt.

**4. Start the dev server**

Run `run.bat` — opens the dev server in a new terminal window.
For full-stack projects with `frontend/` and `backend/` directories, it opens both.

---

## Commands

### /project-plan — Design the architecture and plan implementation

Use this first, before writing any feature.

```
/project-plan a task management app for freelancers with invoicing
/project-plan a real-time multiplayer game with matchmaking
/project-plan an e-commerce platform with inventory and payments
```

Activates **Architect + Tech Lead**. Produces `docs/plan.md` with:
- Technology stack with justification for each choice
- Core domain concepts, bounded contexts, key entities
- Feature breakdown by phase (MVP → Growth)
- Architecture decisions with rejected alternatives
- Risks, open questions, and success criteria

Then use `/define` to break each planned feature into stories and tasks.

---

### /define — Turn a feature into stories and tasks

```
/define the client wants users to register and log in
/define we need a subscription management screen
/define add push notifications when an order changes status
```

Produces: user stories in `docs/stories/`, tasks in `docs/tasks/`.

---

### /create-feature — Implement a feature end-to-end

```
/create-feature user authentication with email and password
/create-feature US-001
```

Runs the full workflow: requirements → architecture → implementation → tests → code review.
Nothing is merged until all steps pass.

---

### /fix-bug — Investigate and fix a bug

```
/fix-bug login fails when the email contains uppercase letters
/fix-bug checkout crashes on iOS 16 after selecting a payment method
```

Workflow: triage → root cause → regression test → fix → code review.
The fix is never applied before the root cause is identified.

---

### /review — Code review an implementation

```
/review the auth feature implementation
/review the last commit
/review the changes in src/features/payments/
```

Produces a structured report: architecture compliance → correctness → test coverage → standards.
Verdict: Approved / Approved with Suggestions / Changes Required.

---

### /adr — Document an architecture decision

```
/adr select state management library for the frontend
/adr define the persistence strategy for orders
/adr adopt event-driven communication between bounded contexts
```

Produces a filed ADR in `docs/adr/NNN-short-description.md`.

---

### /test — Design and implement a test suite

```
/test the user authentication use case
/test the payments feature
/test the OrderAggregate domain entity
```

Strategy first, implementation second.
Unit tests → integration tests → E2E.

---

### /help — Show this guide

```
/help
```

---

## Agents

Each command activates one or more agents. You can reference them directly in conversation.

| Agent | Model | Role |
|---|---|---|
| **Architect** | Fable 5 | Architecture decisions, ADRs, structural reviews |
| **Tech Lead** | Opus 4.8 | Triage, task planning, delivery coordination |
| **Product Analyst** | Opus 4.8 | Requirements clarification, user story validation |
| **Code Reviewer** | Opus 4.8 | Architecture compliance, correctness, standards |
| **Story Writer** | Sonnet 4.6 | Formal user stories with testable acceptance criteria |
| **Backend Developer** | Sonnet 4.6 | Backend implementation following Hexagonal Architecture |
| **Frontend Developer** | Sonnet 4.6 | Frontend implementation following MVVM + Clean Architecture |
| **QA Engineer** | Sonnet 4.6 | Test strategy, test implementation, regression verification |
| **Technical Writer** | Haiku 4.5 | Documentation, ADR filing, clear written output |

Model assignments are configured in `config/models.md`.

---

## Architecture Standards

### Frontend (all technologies)

- **MVVM** — Views observe ViewModels. ViewModels never reference Views.
- **Clean Architecture** — Presentation / Domain / Data layers.
- **Feature-First** — Code is organized by feature, not by layer.
- **Repository Pattern** — ViewModels depend on interfaces, never implementations.

### Backend (all technologies)

**Hexagonal Architecture:**
```
adapters/inbound/  → controllers, routes
adapters/outbound/ → persistence, external APIs
application/       → use cases, ports, DTOs
domain/            → entities, repositories (interfaces), services, events
```

**Clean Architecture:**
```
api/               → routers, services, repositories
config/            → settings
database/          → DB connection and models
external/          → third-party clients
http/              → HTTP client utilities
```

---

## Folder Structure

### Frontend — Feature-First

```
features/
  auth/
    presentation/   views/ + viewmodels/
    domain/         entities/ + repositories/ + use_cases/
    data/           repositories/ + datasources/ + models/
shared/             ui/ + utils/
core/               network/ + storage/ + config/
```

### Backend — Hexagonal

```
domain/             entities/ + repositories/ + services/ + events/
application/        use_cases/ + ports/ + dtos/
adapters/
  inbound/          http/ + messaging/
  outbound/         persistence/ + external/
```

### Backend — Clean Architecture

```
api/                routers/ + services/ + repositories/
config/
database/
external/
http/
```

---

## Starter Templates

All starters include a `/health` endpoint and an index page with the project name and a health check button.

| Technology | Entry point | Includes |
|---|---|---|
| React | `src/App.tsx` | Vite, TypeScript, CSS modules |
| Vue | `src/App.vue` | Vite, TypeScript, SFC |
| Angular | `src/app/app.component.ts` | Standalone components, HttpClient |
| NestJS | `src/main.ts` | Module + controller scaffold |
| Flutter | `lib/main.dart` | Material 3, http package |
| FastAPI | `app/main.py` | CORS, settings, .env |
| Spring Boot | `src/main/java/` | Maven, Boot 3.3, Java 21 |
| .NET | `Program.cs` | Minimal API, .NET 8 |
| Go | `cmd/api/main.go` | Standard library only |

**TypeScript starters** install with `bun` or `pnpm` (your choice at first install).
**Python starters** install with `uv` or `pip` (your choice at first install).

---

## Handbook

The handbook lives in `.engineering-os/handbook/` inside your project.

| Chapter | Topic |
|---|---|
| `00-vision.md` | Project vision — fill this in first |
| `01-engineering-principles.md` | SOLID, Clean Architecture, DRY/KISS/YAGNI |
| `02-project-philosophy.md` | Why Engineering OS exists |
| `03-frontend-architecture.md` | MVVM, Feature-First, Repository Pattern |
| `04-repository-architecture.md` | Folder structure and ADR conventions |
| `05-backend-architecture.md` | Hexagonal, DDD, SOLID, Async-First |
| `06-technology-protocol.md` | How Claude identifies your tech stack |
| `07-testing-strategy.md` | Unit / integration / E2E strategy |
| `08-coding-standards.md` | Naming, functions, error handling |

---

## Typical Workflow

```
1. /project-plan    → design architecture and plan phases
2. /define          → break each feature into user stories and tasks
3. /adr             → document architectural decisions (when needed)
4. /create-feature  → implement feature by feature
5. /test            → add missing test coverage (when needed)
6. /review          → review before merging
7. /fix-bug         → when something breaks in production
```

---
