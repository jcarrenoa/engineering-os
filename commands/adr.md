# Command — /adr

## Purpose

Initiates the Architecture Decision Record creation workflow to document a significant technical decision.

---

## Usage

```
/adr [brief description of the decision]
```

**Examples:**

```
/adr select state management library for the frontend
/adr define the persistence strategy for the orders bounded context
/adr adopt event-driven communication between bounded contexts
```

---

## What This Command Does

1. Activates the **Architect** agent as primary owner
2. Triggers `workflows/create-adr.md` in full
3. Researches options and trade-offs before making a decision
4. Produces a filed ADR document ready to commit to the repository

---

## Required Inputs

Minimum required:

- What decision needs to be documented

Optional but helpful:

- Known constraints or requirements that affect the decision
- Options you are already considering
- Why this decision is being made now

---

## What Will Happen

When you run this command:

**Architect** will:
- Confirm whether this decision warrants an ADR
- Identify and evaluate the realistic alternatives
- Analyze trade-offs against Engineering OS principles
- Make and justify the architectural decision

**Tech Lead** will:
- Provide business context
- Confirm the decision's impact on delivery

**Technical Writer** will:
- Ensure the ADR is clearly written and correctly filed in `docs/adr/`

---

## What You Must Provide

- The decision topic
- Any constraints you know of
- Confirmation once the Architect presents the recommendation

---

## What This Command Will Not Do

- Make a decision without presenting alternatives and trade-offs
- Create an ADR for routine implementation decisions
- File an ADR that is not clearly justified

---

## Workflow Reference

`workflows/create-adr.md`

---

## Templates Produced

- `templates/adr.md` — Filed in `docs/adr/NNN-short-description.md`
