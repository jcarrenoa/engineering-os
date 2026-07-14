# Workflow — Create ADR

## Purpose

Document a significant architectural decision so that its context, reasoning, and consequences are preserved for the future.

An ADR answers three questions:

- Why was this decision needed?
- What was decided and why?
- What are the consequences?

A decision not documented does not exist.

---

## Triggered By

Command: `/adr`

Also triggered automatically within:
- `workflows/create-feature.md` when an architectural decision is identified
- `workflows/fix-bug.md` when a structural change is required

---

## Participants

| Agent | Role in this workflow |
|---|---|
| Architect | Primary owner — produces and owns the ADR |
| Tech Lead | Provides business context and confirms impact |
| Technical Writer | Reviews clarity and ensures the ADR is findable |

---

## When to Create an ADR

Create an ADR when:

- A new architectural pattern is introduced
- An existing pattern is changed or replaced
- A technology is selected (framework, database, state management library)
- A significant trade-off is made that is not obvious from the code
- A principle from Engineering OS is deliberately violated — with justification
- A new bounded context or aggregate boundary is defined
- An integration approach with an external system is decided

Do not create an ADR for:

- Routine implementation decisions
- Minor code organization choices
- Decisions that are obvious from the code itself

---

## Steps

### Step 1 — Identify the Decision (Architect + Tech Lead)

Confirm:

- What is the decision that needs to be documented?
- What is the context that makes this decision necessary?
- Who is affected by this decision?
- Is this the right moment to make this decision, or should it be deferred?

**Output:** Decision identified and confirmed as worthy of an ADR.

---

### Step 2 — Research Options (Architect)

Before documenting the decision, identify:

- What are the realistic alternatives?
- What are the trade-offs of each alternative?
- What constraints eliminate some alternatives?
- What Engineering OS principles apply to this decision?

**Output:** Options and trade-offs documented.

---

### Step 3 — Make the Decision (Architect)

Based on the research:

- Select the option that best satisfies the constraints and principles
- Be explicit about what is being accepted and what is being rejected
- Be explicit about the trade-offs being accepted

**Output:** Decision made and justified.

---

### Step 4 — Write the ADR (Technical Writer + Architect)

Produce the ADR using `templates/adr.md`.

The ADR must include:

- **Number and title** — Sequential number, short descriptive title
- **Status** — Proposed / Accepted / Deprecated / Superseded
- **Date** — When the decision was made
- **Context** — What situation made this decision necessary
- **Options considered** — What alternatives were evaluated
- **Decision** — What was decided and why
- **Consequences** — What changes as a result, positive and negative
- **Related decisions** — References to related ADRs

**Output:** Completed ADR document.

---

### Step 5 — File and Index (Technical Writer)

Save the ADR at:

```
docs/adr/NNN-short-description.md
```

Where NNN is the next sequential number.

Ensure the ADR is reachable from the project documentation index.

**Output:** ADR filed and indexed.

---

## ADR Lifecycle

**Proposed** — Decision is being considered. Not yet final.

**Accepted** — Decision is final and in effect.

**Deprecated** — Decision is no longer followed but not replaced.

**Superseded** — Decision has been replaced by a newer ADR. Reference the replacement.

ADRs are never deleted.

When a decision changes, the original ADR is marked Superseded and a new ADR is created.

---

## Outputs

- ADR document — `templates/adr.md` — filed in `docs/adr/`
