# Workflow — Fix Bug

## Purpose

Investigate, fix, and prevent recurrence of a reported defect.

A bug is not just a code problem — it is evidence of a missing test, a missing abstraction, or an unclear requirement.

Every bug fix includes a regression test.

Every bug that reveals an architectural weakness is escalated to the Architect.

---

## Triggered By

Command: `/fix-bug`

---

## Participants

| Agent | Role in this workflow |
|---|---|
| Tech Lead | Triages the report, categorizes severity, assigns investigation |
| Architect | Evaluates if the bug is symptomatic of an architectural problem |
| Backend Developer | Investigates and fixes backend bugs |
| Frontend Developer | Investigates and fixes frontend bugs |
| QA Engineer | Writes regression test, verifies fix |
| Code Reviewer | Reviews the fix and the regression test |

---

## Steps

### Step 1 — Bug Triage (Tech Lead)

Receive the bug report.

Before investigating, confirm:

- What is the observed behavior?
- What is the expected behavior?
- Can this bug be reproduced reliably?
- What is the severity? (Critical / High / Medium / Low)
- Which layer is the likely origin? (Frontend / Backend / Integration / Unknown)

**Output:** Categorized, reproducible bug description.

---

### Step 2 — Root Cause Investigation (Backend or Frontend Developer)

Investigate the root cause.

Do not assume the fix before understanding the cause.

Identify:

- Where exactly the incorrect behavior originates
- What condition triggers it
- Which layer or component is responsible
- Whether this is a logic error, a missing validation, or a data problem

**Output:** Root cause identified with specific location in the code.

---

### Step 3 — Architectural Assessment (Architect)

The Architect evaluates:

- Is this bug a symptom of an architectural violation?
- Did it occur because logic was in the wrong layer?
- Did it occur because a domain invariant was not enforced by the entity?
- Does fixing it require a structural change or is it an isolated logic fix?

If the bug reveals an architectural problem: the fix must address the root architectural cause, not just the symptom. Create an ADR if a structural change is required.

**Output:** Architectural assessment. ADR if structural change is needed.

---

### Step 4 — Regression Test First (QA Engineer)

Before writing the fix, write a test that:

- Reproduces the bug
- Fails with the current code
- Will pass once the fix is applied

This test becomes the regression test that prevents recurrence.

**Output:** Failing regression test that reproduces the bug.

---

### Step 5 — Implement the Fix (Backend or Frontend Developer)

Implement the minimal fix that:

- Makes the regression test pass
- Does not break existing tests
- Addresses the root cause, not just the symptom

Do not refactor unrelated code during a bug fix.

If refactoring is needed, it is a separate task.

**Output:** Fix implemented. All tests passing.

---

### Step 6 — Code Review (Code Reviewer)

Review the fix:

- Does the fix address the root cause?
- Is the regression test meaningful and correctly written?
- Does the fix introduce any new risks?
- Are existing tests still passing?

**Output:** Review verdict. Approved / Changes Required.

---

### Step 7 — Documentation (Technical Writer)

If the bug revealed undocumented system behavior or an unstated invariant:

- Document the invariant in the domain model
- Update relevant handbook sections if a pattern was clarified
- Note the bug in the ADR if an architectural change was made

**Output:** Updated documentation if applicable.

---

### Step 8 — Completion (Tech Lead)

Verify all steps are complete:

- [ ] Root cause identified
- [ ] Regression test written and failing before fix
- [ ] Fix implemented
- [ ] All tests passing after fix
- [ ] Architectural implications evaluated
- [ ] Code review approved
- [ ] Documentation updated if applicable

---

## Outputs

- Bug fix implementation
- Regression test (mandatory for every fix)
- ADR if an architectural change was made — `templates/adr.md`
- Code review report — `templates/code-review-report.md`
