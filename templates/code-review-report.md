# Code Review Report

**Review ID:** [REVIEW-NNN]

**Date:** [YYYY-MM-DD]

**Reviewer:** Code Reviewer

**Change reviewed:** [Feature name / Bug fix / PR / Commit range]

**Workflow origin:** Feature / Bug fix / Refactor / Other

---

## Verdict

**[ ] Approved**

No blocking findings. Implementation meets Engineering OS standards.

**[ ] Approved with Suggestions**

No blocking findings. Non-blocking suggestions provided for consideration.

**[ ] Changes Required**

Blocking findings must be resolved before merge. See findings below.

---

## Summary

[One to three sentences summarizing the overall quality of the implementation]

---

## Findings

Each finding is numbered and includes severity, category, location, and a specific recommendation.

**Severity levels:**

- **Blocking** — Must be resolved before merge
- **Suggestion** — Improvement recommended, not required for merge

**Categories:**

- **Architecture** — Dependency violations, layer misplacement, wrong abstraction
- **Correctness** — Logic errors, unhandled edge cases, silent failures
- **Tests** — Missing tests, incorrect mocking, tests that verify implementation not behavior
- **Standards** — Naming, magic values, dead code, unnecessary complexity

---

### Finding 001

**Severity:** Blocking / Suggestion

**Category:** Architecture / Correctness / Tests / Standards

**Location:** `[file path]:[line number]`

**Issue:**

[Clear description of the problem]

**Why it matters:**

[Explanation of the engineering impact]

**Recommendation:**

[Specific, actionable suggestion for what to do instead]

---

### Finding 002

**Severity:** Blocking / Suggestion

**Category:** Architecture / Correctness / Tests / Standards

**Location:** `[file path]:[line number]`

**Issue:**

[Clear description of the problem]

**Why it matters:**

[Explanation of the engineering impact]

**Recommendation:**

[Specific, actionable suggestion]

---

*(Add as many findings as needed)*

---

## Architecture Assessment

**Dependency direction respected:** Yes / No / Partially

**Business logic in correct layer:** Yes / No / Partially

**Domain free of framework dependencies:** Yes / No

**Repository interfaces defined in domain:** Yes / No / Not applicable

**Notes:**

[Any architectural observations not captured in individual findings]

---

## Test Assessment

**Unit tests present:** Yes / No / Partial

**Tests verify behavior, not implementation:** Yes / No / Partial

**Tests are independent:** Yes / No

**Regression test included (for bug fixes):** Yes / No / Not applicable

**Coverage gaps identified:**

[List any behaviors that should be tested but are not]

---

## Positive Observations

[What the implementation does well — specific and genuine]

- [Observation 1]
- [Observation 2]

---

## Resolution Tracking

*Filled in after developer responds to findings*

| Finding | Status | Resolution |
|---|---|---|
| 001 | Open / Resolved / Disputed | [Description of resolution] |
| 002 | Open / Resolved / Disputed | [Description of resolution] |

**Final verdict after resolution:** Approved / Changes still required
