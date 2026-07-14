# Command — /fix-bug

## Purpose

Initiates the bug investigation and fix workflow from report to verified resolution.

---

## Usage

```
/fix-bug [description of the bug]
```

**Example:**

```
/fix-bug login fails when the email contains uppercase letters
```

---

## What This Command Does

1. Activates the **Tech Lead** agent as triage coordinator
2. Triggers `workflows/fix-bug.md` in full
3. Ensures a regression test is written before the fix is implemented
4. Routes through Code Reviewer before declaring the bug resolved

---

## Required Inputs

Minimum required:

- What the observed behavior is
- What the expected behavior should be

The Tech Lead will ask for reproduction steps and severity if not provided.

---

## What Will Happen

When you run this command:

**Tech Lead** will:
- Categorize the bug by severity and layer
- Assign investigation to the appropriate developer

**Developer (Backend or Frontend)** will:
- Investigate and identify the root cause
- Report the specific location and cause before writing any fix

**Architect** will:
- Evaluate if the bug is symptomatic of an architectural problem
- Determine if the fix requires a structural change

**QA Engineer** will:
- Write a regression test that reproduces the bug before the fix is implemented
- Verify the fix resolves the issue and all tests pass

**Code Reviewer** will:
- Review both the fix and the regression test

---

## What You Must Provide

- Description of the observed behavior
- Description of the expected behavior
- Any additional context (environment, steps to reproduce, when it started)

---

## What This Command Will Not Do

- Apply a fix before the root cause is identified
- Skip the regression test
- Merge a fix that has not been code reviewed
- Treat a symptom without evaluating the root cause

---

## Workflow Reference

`workflows/fix-bug.md`

---

## Templates Produced

- `templates/code-review-report.md` — Review of the fix
- `templates/adr.md` — If a structural architectural change is required
