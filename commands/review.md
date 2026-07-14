# Command — /review

## Purpose

Initiates a code review of an implementation against Engineering OS architectural, quality, and standards requirements.

---

## Usage

```
/review [what to review]
```

**Examples:**

```
/review the auth feature implementation
/review the last commit
/review the changes in src/features/payments/
```

---

## What This Command Does

1. Activates the **Code Reviewer** agent as primary
2. Triggers `workflows/code-review.md` in full
3. Produces a structured review report with categorized findings
4. Delivers a clear verdict: Approved / Approved with Suggestions / Changes Required

---

## Required Inputs

Minimum required:

- What implementation or change to review

Optional but helpful:

- The purpose of the change (feature / bug fix / refactor)
- Specific concerns you want reviewed

---

## What Will Happen

When you run this command:

**Code Reviewer** will:
- Review architecture compliance first
- Review correctness second
- Review test coverage third
- Review coding standards fourth
- Produce a structured report with numbered findings

**Architect** will be consulted if:
- An architectural question cannot be resolved by the Code Reviewer alone
- A potential structural violation is found

**QA Engineer** will:
- Evaluate test adequacy and identify missing test coverage

---

## What You Must Provide

- The code, files, or change set to review

---

## What This Command Will Not Do

- Give vague or unactionable feedback
- Block a merge for non-blocking suggestions
- Review unrelated code
- Enforce personal style preferences without a standards basis

---

## Workflow Reference

`workflows/code-review.md`

---

## Templates Produced

- `templates/code-review-report.md` — Full review report with verdict
