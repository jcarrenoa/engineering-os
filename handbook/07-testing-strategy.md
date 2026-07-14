# 07 — Testing Strategy

Testing is not optional.

Untested code is code that may or may not work.

Testing is part of the implementation, not an afterthought.

A feature is not complete until it is tested.

---

# Testing Philosophy

Tests protect architecture.

A test suite that only verifies output is weak.

A test suite that verifies behavior in isolation, at the boundary, and end-to-end is strong.

Tests must be fast, deterministic, and independent of each other.

A test that depends on execution order is broken.

A test that depends on network access is an integration test — never call it a unit test.

If a unit cannot be tested in isolation, the architecture has a dependency problem.

Fix the architecture. Then write the test.

---

# Test Types

## Unit Tests

Test a single unit of behavior in complete isolation.

All external dependencies are replaced with mocks, stubs, or fakes.

No I/O operations — no network, no disk, no database.

Execution must be fast (milliseconds per test).

**What to cover:**

- Domain entities and their invariants
- Value objects
- Domain services
- Use cases (with mocked repositories and ports)
- ViewModels (with mocked use cases or repositories)

---

## Integration Tests

Test the interaction between two or more real components.

Use real implementations, not mocks.

May access a real or in-memory database.

May access the file system.

Slower than unit tests — acceptable.

**What to cover:**

- Repository implementations against a real database
- Outbound adapter integrations
- Application layer wired to real infrastructure
- API route handlers wired to use cases

---

## End-to-End Tests

Test the full flow from user interaction to system response.

Use a fully running instance of the application.

Slowest category — use sparingly.

Cover only critical user journeys.

Every additional E2E test is a maintenance commitment — add them deliberately.

---

# Coverage Requirements

| Layer | Required Coverage |
|---|---|
| Domain entities and value objects | Near 100% |
| Use cases | Near 100% |
| ViewModels | Near 100% |
| Repository implementations | Integration tested |
| HTTP controllers / adapters | Integration tested |
| Views / UI components | UI tested for rendering |
| Configuration and wiring | Smoke tested |

---

# Test Organization

Tests mirror the source structure.

```
tests/
├── unit/
│   └── features/
│       └── auth/
│           ├── domain/
│           └── application/
├── integration/
│   └── features/
│       └── auth/
│           └── infrastructure/
└── e2e/
    └── flows/
```

Each test file corresponds to a single source file.

Source: `src/features/auth/domain/use_cases/login_use_case.py`

Test: `tests/unit/features/auth/domain/use_cases/test_login_use_case.py`

---

# Test Naming

Tests describe behavior, not method names.

**Good:**

```
test_user_cannot_withdraw_more_than_available_balance
test_login_fails_when_password_is_incorrect
test_order_total_includes_all_line_items
```

**Bad:**

```
test_withdraw
test_login_method
test_calculate_total
```

The test name must read as a specification of expected behavior.

---

# Test Structure — AAA

Every test follows the Arrange-Act-Assert pattern.

**Arrange:** Set up the state required for the test.

**Act:** Execute the behavior being tested.

**Assert:** Verify the outcome.

No test mixes multiple Act-Assert cycles.

One test verifies one behavior.

---

# Test Independence

Every test sets up its own state.

No shared mutable state between tests.

No dependency on test execution order.

No test modifies state that another test depends on.

Tests can run in any order and produce the same result.

---

# Mocking Rules

Mock at architectural boundaries only.

Mock the repository interface when testing a use case.

Mock the use case when testing a ViewModel.

Do not mock domain entities or value objects — test them directly.

Do not mock what you do not own — wrap third-party dependencies behind an interface and mock the interface.

---

# Testing as Architecture Enforcement

If a piece of code cannot be unit tested, the architecture has a dependency violation.

Common symptoms:

- A use case that cannot be tested without a real database → missing repository abstraction
- A ViewModel that cannot be tested without a real HTTP call → missing port or interface
- A domain entity that requires a framework to instantiate → domain is coupled to infrastructure

Identify the architectural violation.

Fix the design.

Then write the test.

Never introduce workarounds (reflection, test-only constructors, patching) to test code that should be testable by design.
