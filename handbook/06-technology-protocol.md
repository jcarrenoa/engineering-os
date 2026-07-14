# 06 — Technology Protocol

This document defines how Engineering OS identifies the technology stack for each project and adapts its guidance accordingly.

Architecture principles are technology-agnostic.

Their implementation patterns are not.

An MVVM ViewModel in Flutter differs from one in Angular.

A Hexagonal Repository in FastAPI differs from one in NestJS.

The principles remain constant. The idioms adapt.

---

# MANDATORY: Technology Identification Protocol

This protocol must be executed at the start of every new session before writing any code.

Do not assume the technology stack.

Do not guess from file extensions or folder names.

Ask explicitly. Confirm before proceeding.

---

## Step 1 — Ask About Project Type

Ask the user:

> Before we begin, I need to understand the project context.
>
> Is this a **frontend** project, a **backend** project, or a **full-stack** project?

Wait for the answer before proceeding.

---

## Step 2 — Ask About the Technology Stack

### If the project is Frontend or includes a Frontend:

Ask:

> Which frontend technology is this project using?
>
> 1. Flutter / Dart
> 2. Angular / TypeScript
> 3. React / TypeScript
> 4. Vue / TypeScript
> 5. Other — please specify

---

### If the project is Backend or includes a Backend:

Ask:

> Which backend technology is this project using?
>
> 1. FastAPI / Python
> 2. Node.js / TypeScript — NestJS, Express, or Fastify
> 3. Spring Boot / Java or Kotlin
> 4. .NET / C#
> 5. Go
> 6. Other — please specify

---

## Step 3 — Confirm the Architecture

After identifying the technology, confirm the architecture with the user:

> This project will follow Engineering OS architecture standards:
>
> **Frontend:** MVVM + Clean Architecture + Feature-First + Repository Pattern
>
> **Backend:** Hexagonal Architecture + DDD (where justified) + SOLID + Repository Pattern + Async-First
>
> Do you confirm this as the target architecture for this project?

If the user confirms: load the appropriate architecture chapter and proceed.

If the user requests a deviation: document it in an ADR before proceeding. Never silently abandon a principle.

---

## Step 4 — Load the Appropriate Handbook Chapters

Based on the technology identified:

**For all Frontend projects:**

Read `handbook/03-frontend-architecture.md`

Then apply the technology-specific notes below.

**For all Backend projects:**

Read `handbook/05-backend-architecture.md`

Then apply the technology-specific notes below.

**For Full-Stack projects:**

Read both chapters.

---

# Technology-Specific Implementation Notes

## Flutter / Dart

**State management:** Riverpod (preferred), BLoC, or Provider.

Repository interfaces are implemented as classes injected via Riverpod providers.

`StateNotifier` or `Notifier` classes act as ViewModels.

Feature-first structure maps directly to Flutter module organization.

Domain entities are plain Dart classes — no Flutter imports.

`freezed` is acceptable for immutable domain models.

Tests use `mockito` or `mocktail` for repository mocking.

---

## Angular / TypeScript

**State management:** NgRx (preferred for complex state), Angular Signals, or RxJS-based services.

ViewModels are implemented as injectable Services that expose Observable or Signal state.

Feature-first maps to Angular feature modules or standalone component groups.

Domain entities are plain TypeScript classes with no Angular dependencies.

Use `async pipe` in templates — avoid manual subscription management.

---

## React / TypeScript

**State management:** Zustand (preferred for simplicity), Redux Toolkit (for complex state), or Jotai.

ViewModels are implemented as custom hooks that manage and expose state.

Feature-first maps to React feature folders with their own hooks, components, and services.

Domain entities are plain TypeScript types or classes with no React dependencies.

Avoid prop-drilling — use context or state management for cross-component state.

---

## Vue / TypeScript

**State management:** Pinia (preferred) or Vuex.

ViewModels are implemented using Pinia stores or the Composition API with `ref` and `computed`.

Feature-first maps to Vue composable groups and view folders.

Domain entities are plain TypeScript classes with no Vue dependencies.

---

## FastAPI / Python

Routes are inbound adapters — keep them thin.

Domain entities are plain Python dataclasses or classes with no Pydantic or SQLAlchemy dependencies.

Pydantic models are DTOs in the application layer — not domain entities.

SQLAlchemy models are persistence models in the infrastructure layer — not domain entities.

Use `async def` throughout — blocking I/O is forbidden.

Dependency injection is achieved through FastAPI's `Depends()` mechanism at the adapter layer.

---

## NestJS / TypeScript

NestJS modules map cleanly to bounded contexts.

Use NestJS DI container for dependency injection.

Domain entities are plain TypeScript classes — no NestJS decorators in the domain layer.

Controllers act as inbound adapters.

Providers implementing domain interfaces act as outbound adapters.

Use `async/await` throughout.

---

## Spring Boot / Java or Kotlin

Hexagonal Architecture maps well using Spring's DI container.

Domain entities must not use Spring annotations (`@Entity`, `@Component`, etc.) — those belong in the infrastructure layer.

Use constructor injection (not field injection) in all layers.

JPA/Hibernate entities are persistence models — map them to domain entities in the repository implementation.

Use Kotlin coroutines or Project Reactor for async operations.

---

## .NET / C#

Use the built-in DI container for all dependency injection.

Domain entities are plain C# classes with no framework attributes.

Entity Framework models are persistence models — not domain entities.

Use `async/await` throughout for all I/O.

Organize bounded contexts as separate projects or namespaces within the solution.

---

## Go

Interfaces are defined where they are used (inside the application core), not where they are implemented.

Domain types are plain Go structs with no external dependencies.

HTTP handlers act as inbound adapters.

Use goroutines and channels deliberately — document all concurrency decisions.

Avoid global state — wire all dependencies explicitly at `main`.

---

## Other Technologies

Apply the same architectural principles.

Identify the equivalent patterns in the target technology.

Map the architecture layers to the technology's idiomatic structure.

Document any significant mapping decisions in an ADR.

The architecture does not change. Only the idioms do.

---

# Session Rules

Once the technology stack is confirmed, do not re-ask during the session.

If the user switches context (frontend to backend, or a different service), confirm the stack change explicitly.

When starting a new feature or task within the same session, re-read the relevant architecture chapter if needed but do not re-run the full identification protocol.

---

# Non-Negotiable Rules

Regardless of technology:

- MVVM is mandatory for frontend
- Hexagonal Architecture is mandatory for backend
- Repository Pattern is mandatory for both
- Domain must not depend on infrastructure in either layer
- Dependency Inversion is non-negotiable
- Asynchronous-first is required for backend I/O

Technology cannot override architecture.

If the chosen technology makes it difficult to follow a principle, document the constraint in an ADR and propose the best available alternative — but never silently abandon the principle.
