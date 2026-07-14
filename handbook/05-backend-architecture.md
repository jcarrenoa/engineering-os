# 05 — Backend Architecture

This document defines the backend architecture required in all Engineering OS projects.

These principles apply regardless of the backend technology.

FastAPI, NestJS, Spring Boot, .NET, Go — the architecture is the same.

The technology is an implementation detail.

The architecture is the contract.

---

# Hexagonal Architecture — Ports and Adapters

Hexagonal Architecture is mandatory for all backend implementations.

The application core must be completely isolated from external systems.

External systems communicate with the core through ports.

Adapters implement ports for specific technologies.

---

## The Application Core

Contains the domain model and application use cases.

Has no dependencies on external frameworks or infrastructure libraries.

Is independently testable without starting any server, database, or external service.

---

## Ports

Ports are interfaces defined by the application core.

### Inbound Ports — Driving Ports

Define how external actors interact with the application.

Examples: use case interfaces, command handlers, query handlers.

The core defines these. External systems call them.

### Outbound Ports — Driven Ports

Define how the application interacts with external systems.

Examples: repository interfaces, notification interfaces, messaging interfaces.

The core defines these. External systems implement them.

---

## Adapters

Adapters implement ports using specific technologies.

### Inbound Adapters

Convert external requests into calls to inbound ports.

Examples: HTTP controllers, CLI commands, message consumers, scheduled job runners.

No business logic lives here.

### Outbound Adapters

Implement outbound ports using concrete technologies.

Examples: database repositories, HTTP clients for external APIs, email senders.

No business logic lives here.

---

## Dependency Rule

The core never depends on adapters.

Adapters depend on the core through ports.

```
[HTTP Controller] → [Inbound Port] → [Use Case] → [Outbound Port] ← [DB Adapter]
```

Reversing this direction is an architectural violation.

---

# Domain Driven Design

Apply DDD principles where domain complexity justifies them.

Do not apply DDD patterns to simple CRUD operations — it adds noise without value.

Apply DDD where the business rules are complex, evolving, and central to the system's value.

---

## Entities

Defined by identity, not by attributes.

Identity persists through state changes.

Contain behavior related to their own state.

Do not expose internal state for external mutation — use methods that represent domain operations.

---

## Value Objects

Defined by attributes, not identity.

Immutable.

No side effects.

Represent domain concepts that carry no identity.

Examples: Money, Email, Address, DateRange.

---

## Aggregates

Clusters of entities and value objects treated as a transactional unit.

Each aggregate has a root entity (the Aggregate Root).

External objects reference the aggregate only through its root.

The aggregate root enforces invariants within its boundary.

Never bypass the aggregate root to modify internal entities.

---

## Domain Services

Contain domain logic that does not belong to any single entity or value object.

Used when an operation involves multiple aggregates or domain concepts.

Stateless.

Do not confuse Domain Services with Application Services — Domain Services contain domain logic, Application Services orchestrate use cases.

---

## Repository Interfaces (Domain)

Defined in the domain layer as interfaces.

Abstract the persistence mechanism from the domain.

Operate on aggregates, not on raw data structures.

Never expose database concepts (queries, columns, transactions) to the domain.

---

## Domain Events

Represent significant occurrences within the domain.

Named in past tense: `OrderPlaced`, `UserRegistered`, `PaymentProcessed`.

Used to communicate between aggregates and bounded contexts without direct coupling.

---

# SOLID in Backend

All SOLID principles apply (see `01-engineering-principles.md`).

Special emphasis:

**Single Responsibility** — Each use case class handles exactly one application operation.

**Open / Closed** — Ports are stable interfaces. New integrations are new adapters, not modifications to existing ones.

**Dependency Inversion** — This is the foundation of Hexagonal Architecture. Every layer depends on abstractions, not on implementations.

---

# Repository Pattern

Repositories abstract data access from the application core.

Each aggregate has a corresponding repository interface in the domain layer.

Repository interfaces use domain terminology, not database terminology.

Good: `find_active_users()`, `save(user: User)`

Bad: `select_from_users_where_active_true()`, `insert_user_row()`

Repository implementations live in the infrastructure layer.

Repository methods receive and return domain objects, not raw data or ORM models.

---

# Service Layer

A service layer is created only when it is justified.

**Justification for a service layer:**

- Orchestrating multiple use cases as a single transaction
- Coordinating across multiple aggregates
- Managing complex cross-cutting concerns

**Default approach:**

Each use case is a single class with a single public method.

Prefer explicit use case classes over generic services.

A `UserService` with ten methods is a violation of Single Responsibility.

Ten use case classes, each with one method, is correct design.

---

# Dependency Injection

All dependencies are injected through constructors.

No service locators.

No static dependencies.

No global mutable state.

The composition root wires all dependencies at application startup.

Test code can inject mock implementations without modifying production code.

---

# Asynchronous-First Design

All I/O operations are asynchronous by default.

Blocking operations are forbidden inside the application core.

Do not mix synchronous and asynchronous patterns in the same module.

Background tasks are explicitly declared, managed, and monitored.

Long-running operations belong in background workers, not in request handlers.

Timeouts are configured for all external calls.

---

# Layer Structure

```
Application Core
├── domain/
│   ├── entities/
│   ├── value_objects/
│   ├── aggregates/
│   ├── repositories/       ← interfaces only
│   ├── services/           ← domain services
│   └── events/
├── application/
│   ├── use_cases/
│   ├── ports/              ← inbound and outbound interfaces
│   └── dtos/
Infrastructure
└── adapters/
    ├── inbound/
    │   ├── http/           ← route handlers, request/response models
    │   └── messaging/      ← message consumers
    └── outbound/
        ├── persistence/    ← repository implementations, ORM configuration
        └── external/       ← third-party API clients
```

---

# Forbidden

- Business logic inside HTTP controllers or route handlers
- Direct database queries inside use cases or domain entities
- Domain entities with dependencies on framework libraries or ORMs
- Use cases calling other use cases directly (use domain events or orchestration services)
- Global mutable state
- Synchronous blocking I/O in async contexts
- Framework-specific annotations or decorators inside domain or application layers
- HTTP concepts (status codes, request objects) leaking into the application core
