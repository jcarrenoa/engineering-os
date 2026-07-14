# Bug Report

**ID:** [BUG-NNN]

**Date reported:** [YYYY-MM-DD]

**Reported by:** [Name or team]

**Severity:** Critical / High / Medium / Low

**Status:** Open / In Investigation / Fix In Progress / Fixed / Closed

---

## Summary

[One sentence describing the bug]

---

## Observed Behavior

[What actually happens]

[Be specific — describe exactly what the system does]

---

## Expected Behavior

[What should happen instead]

---

## Steps to Reproduce

1. [Step 1]
2. [Step 2]
3. [Step 3]
4. [Observed result]

**Reproducible:** Always / Sometimes / Rarely / Could not reproduce

---

## Environment

**Environment:** Production / Staging / Development / Local

**Version / Build:** [Version number or commit hash]

**Platform:** [OS, browser, device, etc. if applicable]

---

## Root Cause Analysis

*Filled in during investigation*

**Root cause:** [What is causing the bug?]

**Layer affected:** Domain / Application / Infrastructure / Frontend Domain / ViewModel / Data / View

**Root cause type:**

- [ ] Logic error
- [ ] Missing validation or invariant enforcement
- [ ] Incorrect data handling
- [ ] Integration failure
- [ ] Architectural violation
- [ ] Missing or incorrect test
- [ ] Other: [describe]

---

## Architectural Impact

[Does this bug reveal a missing domain invariant?]

[Does this bug indicate that logic is in the wrong layer?]

[Does this require an ADR?]

ADR reference (if applicable): `docs/adr/NNN-description.md`

---

## Fix Description

*Filled in after fix is implemented*

[What was changed to fix the bug?]

[Why does this fix resolve the root cause?]

---

## Regression Test

**Test added:** Yes / No

**Test location:** [File path of regression test]

**Test description:** [What behavior the test verifies]

---

## Resolution

**Fixed in:** [Commit / PR / Version]

**Fixed by:** [Developer]

**Verified by:** [QA Engineer]

**Date closed:** [YYYY-MM-DD]
