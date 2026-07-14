# 03 — Frontend Architecture

This document defines the frontend architecture required in all Engineering OS projects.

These principles apply regardless of the frontend technology.

Flutter, Angular, React, Vue — the architecture is the same.

The technology is an implementation detail.

The architecture is the contract.

---

# Required Patterns

## MVVM — Model View ViewModel

MVVM is mandatory for all frontend implementations.

---

### Model

Represents domain data and business rules.

Must be independent of the UI framework.

Must be testable without rendering any UI.

Has no knowledge of how it will be displayed.

---

### View

Responsible only for rendering the UI.

Contains no business logic.

Contains no presentation logic.

Observes the ViewModel and reacts to state changes.

Delegates all user interactions to the ViewModel.

A View that contains an `if` statement for business logic is already wrong.

---

### ViewModel

Mediates between the View and the domain.

Holds UI state derived from domain state.

Contains presentation logic — not business logic.

Does not know how the state is rendered.

Does not reference View components.

Does not call APIs or data sources directly.

Communicates with the domain through Repository interfaces or Use Cases.

---

## Clean Architecture — Frontend Layers

### Presentation Layer

Contains Views and ViewModels.

Responsible for UI rendering and user interaction.

Has no direct dependency on data sources.

Communicates with the domain only through abstractions (interfaces).

---

### Domain Layer

Contains business entities, use cases, and repository interfaces.

Has no dependency on any framework, library, or UI toolkit.

This layer defines what the application does.

This layer does not define how it does it.

This layer is the most stable part of the application.

---

### Data Layer

Contains repository implementations, API clients, and local storage adapters.

Implements the interfaces defined in the domain layer.

Has no business logic.

Has no UI code.

---

## Dependency Rule for Frontend

```
View
  └── ViewModel
        └── UseCase / Repository Interface
              └── Domain Entity
Data Layer implements Repository Interface
```

View never depends on the Data layer.

ViewModel never depends on Data layer implementations.

Domain never depends on Presentation or Data.

---

## Feature-First Organization

The project is organized by features, not by technical layers.

Each feature is a self-contained module.

A feature contains its own Presentation, Domain, and Data components.

Shared components live in a `core` or `shared` module.

Cross-feature dependencies must be minimized.

If two features share logic, that logic belongs in `shared` or a dedicated module — never inside another feature.

**Technology-agnostic structure:**

```
features/
  auth/
    presentation/
      views/
      viewmodels/
    domain/
      entities/
      repositories/     ← interfaces only
      use_cases/
    data/
      repositories/     ← implementations
      datasources/
      models/
  dashboard/
    presentation/
    domain/
    data/
shared/
  ui/
  utils/
core/
  network/
  storage/
  config/
```

---

## Repository Pattern — Frontend

Every data source is accessed through a Repository.

The Repository **interface** is defined in the Domain layer.

The Repository **implementation** is in the Data layer.

The ViewModel depends on the Repository interface, never the implementation.

This enables:

- Testability — swap real implementations with mocks in tests
- Flexibility — change data sources without touching business logic
- Separation of concerns — ViewModel does not know where data comes from

**Rule: ViewModels never call APIs, databases, or local storage directly.**

---

## Modular Design

Each feature is an independent module with a clear public API.

A module must not expose its internal implementation details.

Modules communicate through well-defined interfaces or facades.

Dependencies between modules must be explicit and minimal.

A module that knows the internals of another module is not a module — it is a tightly coupled component.

---

# State Management

State is managed by ViewModels.

State changes are predictable and driven by user interactions or domain events.

UI state is derived from domain state, not the inverse.

Avoid global mutable state.

Prefer observable, reactive state that ViewModels expose and Views observe.

The technology used for state management (Riverpod, NgRx, Zustand, etc.) is an implementation detail.

The pattern is not.

---

# Testing Requirements

Domain entities: unit tested, no framework required.

Use cases: unit tested with mocked repositories.

ViewModels: unit tested with mocked use cases or repositories.

Views: UI-tested for rendering correctness only.

Data layer: integration tested against real or simulated data sources.

---

# Forbidden

- Business logic inside Views
- API calls inside ViewModels directly
- Direct database or storage access outside the Data layer
- Feature modules importing from other feature modules' internal layers
- Shared mutable state without clear ownership
- ViewModels with more than one unrelated responsibility
- Domain entities that import framework classes
