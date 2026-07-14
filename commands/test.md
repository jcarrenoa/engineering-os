# Command — /test

## Purpose

Initiates the test creation workflow to design and implement a test suite for an existing or new component.

---

## Usage

```
/test [what to test]
```

**Examples:**

```
/test the user authentication use case
/test the payments feature
/test the OrderAggregate domain entity
```

---

## What This Command Does

1. Activates the **QA Engineer** agent as primary owner
2. Triggers `workflows/create-tests.md` in full
3. Designs the full test strategy before writing any tests
4. Produces a test plan and implemented test suite

---

## Required Inputs

Minimum required:

- What component, feature, or layer to test

Optional but helpful:

- Which behaviors you are most concerned about
- Whether you want unit tests, integration tests, or both
- Current test coverage gaps you are aware of

---

## What Will Happen

When you run this command:

**QA Engineer** will:
- Identify all behaviors that must be verified
- Classify each test as unit, integration, or E2E
- Check testability — flag architectural issues if found
- Implement unit tests first, then integration tests

**Architect** will be consulted if:
- A component cannot be unit tested (indicates an architectural issue)

**Developer (Backend or Frontend)** will:
- Provide context about the component's internals when needed
- Help resolve testability issues

---

## What You Must Provide

- The target component or feature to test
- Confirmation of the most critical behaviors to cover first

---

## What This Command Will Not Do

- Write tests before understanding what behaviors to verify
- Write integration tests as a workaround for untestable unit code
- Mark a component as tested without adequate coverage of its behaviors

---

## Workflow Reference

`workflows/create-tests.md`

---

## Templates Produced

- `templates/test-plan.md` — Test strategy and coverage documentation
