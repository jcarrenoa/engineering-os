# Workflow — Code Review

## Purpose

Verify that an implementation meets Engineering OS architectural, quality, and standards requirements before it is merged.

A code review is not a search for stylistic preference.

It is an engineering quality gate.

---

## Triggered By

Command: `/review`

---

## Participants

| Agent | Role in this workflow |
|---|---|
| Code Reviewer | Primary reviewer — owns this workflow |
| Architect | Consulted for architectural ambiguities |
| QA Engineer | Reviews test adequacy |

---

## Steps

### Step 1 — Understand the Change (Code Reviewer)

Before reviewing, understand:

- What is the purpose of this change?
- What workflow produced it? (Feature / Bug fix / Refactor / Other)
- Which layers were modified?
- Are there associated tests?
- Is there an ADR for any architectural decision in this change?

Do not begin reviewing without understanding what you are reviewing.

**Output:** Review scope confirmed.

---

### Step 2 — Architecture Review (Code Reviewer + Architect if needed)

Review architectural compliance:

- Are layers respected? Does business logic stay in the domain?
- Does the dependency direction point inward?
- Are new ports and adapters correctly placed?
- Are domain entities free of framework dependencies?
- Are repository interfaces defined in the domain, not the infrastructure?
- Are use cases doing exactly one thing?
- Did any structural decision bypass the Architect?

If an architectural question cannot be resolved: consult the Architect.

**Output:** List of architectural findings (blocking or suggestions).

---

### Step 3 — Correctness Review (Code Reviewer)

Verify that the implementation correctly solves the stated problem:

- Does the implementation match the acceptance criteria?
- Are edge cases handled?
- Are failure paths handled explicitly?
- Are there silent failures?
- Is error handling correct and meaningful?

**Output:** List of correctness findings.

---

### Step 4 — Test Coverage Review (QA Engineer)

Review test adequacy:

- Are domain behaviors unit tested?
- Are use cases tested with mocked dependencies?
- Are ViewModels tested independently?
- Are repository implementations integration tested?
- Are test names descriptive of behavior?
- Are tests independent of execution order?
- Is there a regression test for any bug fix in this change?

**Output:** Test coverage assessment. Missing tests identified.

---

### Step 5 — Standards Review (Code Reviewer)

Review coding standards compliance:

- Do names communicate intent clearly?
- Are there magic numbers or magic strings?
- Are comments explaining why, not what?
- Are there dead code paths?
- Is there duplicated logic that signals a missing abstraction?
- Is complexity justified?

**Output:** List of standards findings.

---

### Step 6 — Produce Review Report (Code Reviewer)

Produce the review report using `templates/code-review-report.md`.

Each finding includes:

- Location (file and line reference)
- Category (Architecture / Correctness / Tests / Standards)
- Severity (Blocking / Suggestion)
- Description of the issue
- Reason it matters
- Specific recommendation

**Output:** Completed code review report.

---

### Step 7 — Verdict

**Approved**

No blocking findings. Implementation meets Engineering OS standards.

May include non-blocking suggestions for future improvement.

**Approved with Suggestions**

No blocking findings. Suggestions provided for the implementer's consideration.

Implementation can proceed to merge.

**Changes Required**

One or more blocking findings. Implementation must not be merged.

Findings are returned to the responsible developer with specific feedback.

Developer addresses findings and resubmits for review.

---

## Outputs

- Code review report — `templates/code-review-report.md`
- Verdict: Approved / Approved with Suggestions / Changes Required
