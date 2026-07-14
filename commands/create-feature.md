# Command — /create-feature

## Purpose

Initiates the full feature creation workflow from requirement to production-ready implementation.

---

## Usage

```
/create-feature [brief description of the feature]
```

**Example:**

```
/create-feature user authentication with email and password
```

---

## What This Command Does

1. Activates the **Tech Lead** agent as the primary coordinator
2. Triggers `workflows/create-feature.md` in full
3. Coordinates the Architect, Developers, QA Engineer, and Code Reviewer through each step
4. Does not complete until all steps in the workflow are satisfied

---

## Required Inputs

The command requires enough context to begin the requirements clarification step.

Minimum required:

- What the feature should do (one sentence is enough to start)

The Tech Lead will ask clarifying questions from there.

---

## What Will Happen

When you run this command:

**Tech Lead** will:
- Ask clarifying questions about the feature requirements
- Confirm acceptance criteria with you

**Architect** will:
- Evaluate architectural implications
- Create an ADR if a structural decision is required
- Approve the implementation approach before any code is written

**QA Engineer** will:
- Define the test strategy before implementation begins

**Developers** will:
- Implement starting from the domain layer inward
- Write tests alongside implementation

**Code Reviewer** will:
- Review the full implementation before the feature is declared complete

---

## What You Must Provide

- A clear description of the feature (what it should do, not how)
- Answers to the Tech Lead's clarifying questions
- Confirmation of acceptance criteria before implementation begins

---

## What This Command Will Not Do

- Start writing code before requirements are clear
- Skip the architectural review for non-trivial features
- Skip the code review step
- Declare the feature complete without tests passing

---

## Workflow Reference

`workflows/create-feature.md`

---

## Templates Produced

- `templates/feature-spec.md` — Feature specification
- `templates/adr.md` — If an architectural decision is made
- `templates/test-plan.md` — Test strategy for the feature
- `templates/code-review-report.md` — Code review outcome
