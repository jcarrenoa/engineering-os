# Workflow — Create Feature

## Purpose

Define and implement a new feature from requirement to production-ready code.

No implementation begins before architecture is validated.

No feature is complete before it is tested and reviewed.

---

## Triggered By

Command: `/create-feature`

---

## Participants

| Agent | Role in this workflow |
|---|---|
| Tech Lead | Receives request, clarifies requirements, breaks into tasks |
| Architect | Validates architectural approach, creates ADR if needed |
| Backend Developer | Implements backend domain, application, and infrastructure layers |
| Frontend Developer | Implements frontend domain, ViewModel, data, and View layers |
| QA Engineer | Defines test strategy, writes tests alongside implementation |
| Code Reviewer | Reviews the full implementation before completion |
| Technical Writer | Documents any architectural decisions made |

---

## Steps

### Step 1 — Requirements Clarification (Tech Lead)

Receive the feature request.

Before any other step, confirm:

- What problem is this feature solving?
- Who is the user of this feature?
- What are the acceptance criteria?
- What are the edge cases and failure scenarios?
- Is there an existing feature that partially covers this?

Do not proceed until requirements are clear and agreed upon.

**Output:** Confirmed, unambiguous feature description.

---

### Step 2 — Architectural Review (Architect)

Evaluate the architectural implications of the feature:

- Does this feature cross bounded context boundaries?
- Does this feature require new domain concepts (entities, value objects, aggregates)?
- Does this feature require new ports or adapters?
- Does this feature change existing contracts?
- Should this decision be documented in an ADR?

If an ADR is required: run `workflows/create-adr.md` before proceeding.

If the architecture is clear and unambiguous: document the approach and approve implementation.

**Output:** Architectural assessment. ADR if required.

---

### Step 3 — Task Breakdown (Tech Lead)

Break the feature into implementable tasks:

- Domain layer tasks (entities, value objects, repository interfaces)
- Application layer tasks (use cases, ports, DTOs)
- Infrastructure layer tasks (adapters, persistence)
- Frontend domain tasks (if applicable)
- Frontend ViewModel tasks (if applicable)
- Frontend View and data layer tasks (if applicable)
- Test tasks (unit, integration)

Sequence tasks so that inner layers are implemented before outer layers.

**Output:** Ordered task list with agent assignments.

---

### Step 4 — Test Strategy (QA Engineer)

Before implementation begins, define:

- Which behaviors must be unit tested?
- Which integration points require integration tests?
- What are the edge cases that must be covered?
- Are there critical user journeys requiring E2E tests?

Produce a test plan using `templates/test-plan.md`.

**Output:** Test plan document.

---

### Step 5 — Backend Implementation (Backend Developer)

Implement in order:

1. Domain layer — entities, value objects, aggregates, repository interfaces, domain events
2. Application layer — use cases, inbound and outbound ports, DTOs
3. Infrastructure layer — repository implementations, HTTP controllers, external adapters

Write unit tests for domain and application layers alongside implementation.

Flag any architectural questions to the Architect before proceeding.

**Output:** Implemented backend layers with unit tests passing.

---

### Step 6 — Frontend Implementation (Frontend Developer)

Implement in order:

1. Domain layer — entities, repository interfaces, use case interfaces
2. ViewModel — state management, interaction handlers, use case calls
3. Data layer — repository implementations, data sources, response models
4. View — renders ViewModel state, delegates interactions

Write unit tests for all ViewModels alongside implementation.

Flag any architectural questions to the Architect before proceeding.

**Output:** Implemented frontend layers with ViewModel tests passing.

---

### Step 7 — Integration Testing (QA Engineer)

Execute integration tests against real or in-memory infrastructure.

Verify that adapters communicate correctly with real data sources.

Identify and report any integration failures.

**Output:** Integration tests passing. Failures reported with root cause.

---

### Step 8 — Code Review (Code Reviewer)

Review the full implementation:

1. Architecture compliance
2. Correctness
3. Test coverage adequacy
4. Coding standards
5. Simplicity

Produce a review report using `templates/code-review-report.md`.

If blocking issues exist: return to the responsible developer with specific feedback.

If approved: feature is ready for merge.

**Output:** Code review report. Verdict: Approved / Changes Required.

---

### Step 9 — Documentation (Technical Writer)

If any architectural decisions were made during the feature:

- Create or update ADRs
- Update relevant handbook chapters if patterns evolved
- Document any non-obvious domain concepts introduced

**Output:** Updated documentation.

---

### Step 10 — Completion (Tech Lead)

Verify all steps are complete:

- [ ] Requirements confirmed
- [ ] Architecture validated
- [ ] Tasks completed
- [ ] Tests written and passing (unit + integration)
- [ ] Code review approved
- [ ] Documentation updated

Feature is complete when all items are checked.

---

## Outputs

- Implemented feature (backend and/or frontend)
- Test suite (unit + integration)
- ADR if architectural decision was made — `templates/adr.md`
- Feature specification — `templates/feature-spec.md`
- Code review report — `templates/code-review-report.md`
- Test plan — `templates/test-plan.md`
