# Workflow — Create Tests

## Purpose

Design and implement a test suite for an existing or new component.

Used when tests need to be created independently of a feature workflow, or when test coverage needs to be increased for an existing module.

---

## Triggered By

Command: `/test`

---

## Participants

| Agent | Role in this workflow |
|---|---|
| QA Engineer | Primary owner — designs and implements the test suite |
| Backend Developer | Provides context on backend components being tested |
| Frontend Developer | Provides context on frontend components being tested |
| Architect | Consulted if untestable code reveals an architectural issue |

---

## Steps

### Step 1 — Understand the Target (QA Engineer)

Identify what is being tested:

- Which component, layer, or feature?
- Which behaviors must be verified?
- What tests already exist? What is missing?
- What is the risk level of this component? (High risk → higher coverage priority)

**Output:** Test scope confirmed.

---

### Step 2 — Identify Behaviors to Test (QA Engineer)

For each component in scope, list:

- Happy path behaviors
- Edge cases and boundary conditions
- Failure paths and error conditions
- Invariants that must always hold

Do not list tests by method name.

List tests by behavior: "user cannot withdraw more than available balance."

**Output:** Behavior list for each component.

---

### Step 3 — Classify Tests by Type (QA Engineer)

For each behavior identified:

- Is this a **unit test**? (No I/O, all dependencies mocked, tests a single behavior)
- Is this an **integration test**? (Tests real interaction between components)
- Is this an **E2E test**? (Tests a full user journey through the running system)

Prefer unit tests.

Use integration tests only at architectural boundaries.

Use E2E tests only for critical user journeys.

**Output:** Classified test list with type assignments.

---

### Step 4 — Check Testability (QA Engineer + Architect if needed)

Before writing tests, verify:

- Can each component be instantiated in isolation for unit testing?
- Are dependencies injectable?
- Does the component have hidden I/O (direct database calls, static dependencies)?

If a component cannot be unit tested: flag it as an architectural issue and escalate to the Architect.

Do not write integration tests as workarounds for bad unit testability.

**Output:** Testability assessment. Issues escalated if found.

---

### Step 5 — Write Unit Tests (QA Engineer + Developer)

Implement unit tests following the AAA pattern:

- **Arrange** — Set up the test state
- **Act** — Execute the behavior
- **Assert** — Verify the outcome

Each test verifies exactly one behavior.

Test names describe behavior: `test_order_total_includes_all_line_items`.

All external dependencies are mocked at architectural boundaries.

**Output:** Unit tests implemented and passing.

---

### Step 6 — Write Integration Tests (QA Engineer + Developer)

Implement integration tests for:

- Repository implementations against a real or in-memory data source
- Adapter interactions with external systems (using test doubles for external APIs)
- Application layer wired to real infrastructure

Integration tests use real implementations — no mocking of the components being integrated.

**Output:** Integration tests implemented and passing.

---

### Step 7 — Produce Test Plan (QA Engineer)

Document the test strategy using `templates/test-plan.md`:

- Which components are covered
- Which behaviors are tested
- Test type breakdown (unit / integration / E2E)
- Coverage gaps identified and rationale for deferral (if any)

**Output:** Test plan document.

---

## Outputs

- Unit test implementations
- Integration test implementations (if applicable)
- E2E test cases (if applicable)
- Test plan — `templates/test-plan.md`
