# 04 — Repository Architecture

This document defines how projects using Engineering OS organize their source code.

Folder structure is documentation.

A developer reading the folder structure must immediately understand the architecture.

If the structure communicates the technology before it communicates the architecture, it is wrong.

---

# Core Principle

Structure reflects architecture, not technology.

Technology-specific concerns live inside architecture-defined boundaries.

The top-level structure must be immediately readable by any engineer, regardless of the framework used.

---

# General Repository Structure

All Engineering OS projects follow this general structure:

```
project-root/
├── handbook/               ← Engineering OS handbook (this directory)
├── src/                    ← All application source code
│   ├── features/           ← Feature modules (frontend) or bounded contexts (backend)
│   ├── core/               ← Shared infrastructure and cross-cutting concerns
│   └── shared/             ← Shared domain components or UI components
├── tests/                  ← All tests
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── docs/                   ← Technical documentation
│   └── adr/                ← Architecture Decision Records
├── scripts/                ← Build, deploy, and utility scripts
└── config/                 ← Environment and configuration files
```

---

# Frontend Feature Module Structure

```
features/
└── feature_name/
    ├── presentation/
    │   ├── views/          ← UI components and screens
    │   ├── viewmodels/     ← ViewModel classes
    │   └── widgets/        ← Feature-specific UI elements
    ├── domain/
    │   ├── entities/       ← Domain models
    │   ├── repositories/   ← Repository interfaces (no implementations here)
    │   └── use_cases/      ← Application use cases
    └── data/
        ├── repositories/   ← Repository implementations
        ├── datasources/    ← Remote and local data sources
        └── models/         ← Data transfer objects and response models
```

---

# Backend Bounded Context Structure

```
src/
└── context_name/
    ├── domain/
    │   ├── entities/           ← Domain entities
    │   ├── value_objects/      ← Value objects
    │   ├── aggregates/         ← Aggregate roots
    │   ├── repositories/       ← Repository interfaces (no implementations here)
    │   ├── services/           ← Domain services
    │   └── events/             ← Domain events
    ├── application/
    │   ├── use_cases/          ← Application use cases
    │   ├── ports/              ← Inbound and outbound ports
    │   └── dtos/               ← Data transfer objects
    └── infrastructure/
        ├── adapters/
        │   ├── inbound/        ← HTTP controllers, CLI handlers, message consumers
        │   └── outbound/       ← External service clients, messaging adapters
        └── persistence/        ← Repository implementations, ORM models
```

---

# Architecture Decision Records

Every significant architectural decision is recorded as an ADR.

ADRs live in `docs/adr/`.

Naming format: `docs/adr/NNN-short-description.md`

Example: `docs/adr/001-use-hexagonal-architecture.md`

Each ADR includes:

- **Status** — Proposed / Accepted / Deprecated / Superseded
- **Context** — Why this decision was needed
- **Decision** — What was decided and why
- **Consequences** — What changes as a result

ADRs are never deleted.

Outdated ADRs are marked Deprecated or Superseded and updated with a reference to the replacement.

---

# Naming Conventions

## Directories

Lowercase.

Words separated by underscores.

Reflects architectural role, not technical type.

Good: `use_cases/`, `repositories/`, `adapters/`

Bad: `controllers/`, `models/`, `helpers/`

## Files

Match the naming convention of the target technology.

Snake case for Python.

Camel case or Pascal case for Dart, TypeScript, Kotlin.

File names describe what the component is, not where it lives.

Good: `user_repository.py`, `CreateUserUseCase.ts`

Bad: `repo.py`, `handler.ts`

## Tests

Test files live at the same relative path as the source file they test, inside the `tests/` tree.

Source: `src/features/auth/domain/use_cases/login_use_case.py`

Test: `tests/unit/features/auth/domain/use_cases/test_login_use_case.py`

---

# Rules

Business logic must never appear outside the domain or application layers.

Every directory must have a single, clear purpose.

Circular dependencies between modules are forbidden.

A module must not import from another module's internal layers.

Imports must cross module boundaries only through public interfaces or facades.

If a directory grows beyond manageable size, introduce a subdirectory that reflects a meaningful architectural subdivision — never an arbitrary one.
