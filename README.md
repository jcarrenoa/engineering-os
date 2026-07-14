# Engineering OS

> **Design for evolution. Build software that survives change.**

Engineering OS is an opinionated engineering framework designed to help AI assistants and developers collaborate on long-term software projects.

It is **not** a code framework.

It is **not** a template generator.

It is an operating system for software engineering.

Its purpose is to provide a consistent way to design, build, test, review, document and evolve software projects using AI-assisted development.

---

## Why Engineering OS?

Modern AI tools are excellent at writing code.

However, they often struggle with:

- Maintaining architectural consistency
- Preserving project context
- Following long-term engineering decisions
- Applying coding standards consistently
- Scaling projects without accumulating technical debt

Engineering OS addresses these problems by defining a structured engineering environment where architecture, documentation, workflows and AI agents collaborate under the same engineering philosophy.

---

## Core Philosophy

> **The quality of software depends more on engineering decisions than on code generation.**

The framework prioritizes:

- Architecture over implementation
- Maintainability over speed
- Readability over cleverness
- Simplicity over unnecessary abstractions
- Documentation as part of the product
- Long-term scalability

---

## Quick Start

### 1. Pick a starter

Copy the starter for your stack from `templates/starters/<stack>/` to your project root.

### 2. Add the dev scripts

Copy `install.bat`, `install.ps1`, `run.bat`, and `run.ps1` from `templates/` to the project root.

### 3. Install dependencies

Run `install.bat`. On first run it detects your stack and prompts once:

| Stack | Package manager options |
|---|---|
| Python (FastAPI) | `uv` (recommended) or `pip` |
| TypeScript / Node | `bun` (recommended) or `pnpm` |

The choice is saved to `.eng-config.json`. Delete it to re-prompt.

### 4. Start the dev server

Run `run.bat`. For full-stack projects (`frontend/` + `backend/`), opens both in separate windows.

### 5. Open Claude Code and run `/help`

```
/help
```

See all commands, agents, and the recommended workflow.

---

## Supported Technologies

### Frontend

| Technology | Architecture |
|---|---|
| React + TypeScript | MVVM + Clean Architecture |
| Vue + TypeScript | MVVM + Clean Architecture |
| Angular + TypeScript | MVVM + Clean Architecture |
| Flutter + Dart | MVVM + Clean Architecture |

### Backend

| Technology | Architecture |
|---|---|
| FastAPI (Python) | Hexagonal + DDD  /  Clean Architecture |
| NestJS (TypeScript) | Hexagonal + DDD  /  Clean Architecture |
| Spring Boot (Java) | Hexagonal + DDD  /  Clean Architecture |
| .NET (C#) | Hexagonal + DDD  /  Clean Architecture |
| Go | Hexagonal + DDD  /  Clean Architecture |

---

## Commands

| Command | What it does |
|---|---|
| `/project-plan` | Design architecture and plan implementation phases |
| `/define` | Turn a feature idea into user stories and tasks |
| `/create-feature` | Implement a feature end-to-end with full workflow |
| `/fix-bug` | Investigate, root-cause, and fix a bug |
| `/review` | Code review with architecture compliance report |
| `/adr` | Document an architecture decision |
| `/test` | Design and implement a test suite |
| `/help` | Show the full reference guide |

---

## Agents

| Agent | Model | Role |
|---|---|---|
| Architect | Fable 5 | Architecture decisions, ADRs, structural reviews |
| Tech Lead | Opus 4.8 | Triage, task planning, delivery coordination |
| Product Analyst | Opus 4.8 | Requirements clarification, user story validation |
| Code Reviewer | Opus 4.8 | Architecture compliance, correctness, standards |
| Story Writer | Sonnet 4.6 | Formal user stories with testable acceptance criteria |
| Backend Developer | Sonnet 4.6 | Backend implementation (Hexagonal Architecture) |
| Frontend Developer | Sonnet 4.6 | Frontend implementation (MVVM + Clean Architecture) |
| QA Engineer | Sonnet 4.6 | Test strategy, implementation, regression verification |
| Technical Writer | Haiku 4.5 | Documentation, ADR filing, written output |

Model assignments live in `config/models.md`.

---

## Repository Structure

```
engineering-os/
├── handbook/        Engineering principles, architecture standards, coding conventions
├── agents/          Agent definitions with roles, responsibilities, and constraints
├── commands/        Slash command definitions loaded by Claude Code
├── workflows/       Step-by-step workflow instructions for each command
├── templates/
│   ├── starters/    Ready-to-run project starters (9 technology stacks)
│   ├── install.ps1  Dependency installer with package manager selector
│   ├── run.ps1      Dev server launcher
│   └── *.md         Document templates (ADR, user story, task, plan, etc.)
├── config/
│   └── models.md    Model assignments per agent
└── examples/        Reference implementations per technology
```

---

## Design Principles

- The Domain is Forever.
- Frameworks are implementation details.
- Architecture must evolve.
- Every file must justify its existence.
- Documentation is part of the implementation.
- AI should collaborate, not improvise.
- Simplicity is a feature.
- Engineering decisions must be explicit.
- Business rules must remain independent.
- Every module should be replaceable.

---

## Guiding Motto

> **The Domain is Forever.**

Technology changes. Frameworks change. Programming languages change.

Business rules are what give software its value. Engineering OS protects that value.

---

## Author

**Aaron Jose Rodriguez Carreño**
GitHub: [github.com/jcarrenoa](https://github.com/jcarrenoa)

---

## License

© 2026 Aaron Jose Rodriguez Carreño — [PolyForm Noncommercial 1.0.0](LICENSE)

Uso, modificación y distribución permitidos para fines no comerciales. El uso comercial requiere autorización expresa del autor.

See [LICENSE](LICENSE) for the full text.

---

## Status

Under active development.
