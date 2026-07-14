# 01 — Engineering Principles

These principles apply to every project, every task, and every line of code produced under Engineering OS.

They are not suggestions.

They are constraints.

Violating them requires explicit justification documented in an ADR.

---

# SOLID Principles

## Single Responsibility

Every class, module, and function has exactly one reason to change.

If a component does more than one thing, split it.

A component that is hard to name is violating this principle.

---

## Open / Closed

Software entities are open for extension and closed for modification.

Add new behavior through extension, not by modifying working tested code.

Define stable interfaces. Add new implementations when requirements change.

---

## Liskov Substitution

A subtype must be fully substitutable for its base type without altering system correctness.

If overriding behavior changes the contract, the abstraction is wrong.

---

## Interface Segregation

Clients must not depend on interfaces they do not use.

Prefer many focused interfaces over one large general interface.

An interface with ten methods is almost always the wrong design.

---

## Dependency Inversion

High-level modules must not depend on low-level modules.

Both depend on abstractions.

Abstractions must not depend on details.

Details depend on abstractions.

This principle is the foundation of testability, replaceability, and architectural integrity.

---

# Clean Architecture

Software is organized into concentric layers.

Each layer has a single clear responsibility.

Dependencies always point inward — toward the domain.

The domain has no external dependencies.

Inner layers define interfaces.

Outer layers implement those interfaces.

Business logic is independent of frameworks, databases, and delivery mechanisms.

## The Dependency Rule

Source code dependencies must point inward.

Nothing in an inner layer knows anything about an outer layer.

This rule is absolute.

## Layers

**Domain Layer**

Contains business rules, domain models, and core logic.

No dependency on any external library or framework.

Independently testable in isolation.

**Application Layer**

Contains use cases and orchestration.

Depends only on the domain layer.

Defines ports (interfaces) that outer layers must implement.

**Infrastructure Layer**

Implements the ports defined by the application layer.

Contains database adapters, HTTP clients, external service integrations.

Framework-specific code lives here and only here.

---

# Foundational Rules

## DRY — Do Not Repeat Yourself

Every piece of knowledge has a single, unambiguous representation in the system.

Duplication signals a missing abstraction.

Do not create abstractions just to avoid duplication.

Create them when the abstraction carries its own meaning.

---

## KISS — Keep It Simple

Simple solutions are always preferred over complex ones.

Complexity must be justified by a real and current requirement.

If a solution is hard to explain, the design is probably wrong.

---

## YAGNI — You Ain't Gonna Need It

Do not implement functionality before it is needed.

Premature abstractions are technical debt in disguise.

Design for what is needed today.

Enable change for tomorrow without building it today.

---

## Separation of Concerns

Each module addresses exactly one concern.

Business rules are separate from presentation.

Presentation is separate from data access.

Data access is separate from business rules.

---

## Explicit Over Implicit

Behavior must be visible and predictable.

Side effects are isolated and documented.

Magic is never acceptable.

Configuration is explicit.

Hidden dependencies are forbidden.

---

## Dependency Direction

Dependencies always point inward.

Business logic never depends on infrastructure.

Domain entities never depend on frameworks.

If reversing a dependency feels painful, the architecture needs review.

---

# Engineering Discipline

Every decision is intentional.

Every abstraction solves a real problem.

Every file justifies its existence.

Every dependency is questioned.

Complexity grows by itself.

Simplicity requires constant discipline.
