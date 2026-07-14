# Test Plan

**Feature / Component:** [Name of what is being tested]

**Date:** [YYYY-MM-DD]

**QA Engineer:** [Name or agent]

**Status:** Draft / Approved / In Progress / Complete

---

## Scope

### What Is Being Tested

[List the components, features, or behaviors in scope]

### What Is Not Being Tested

[Explicitly state what is out of scope and why]

---

## Test Strategy Summary

| Test Type | Count | Priority |
|---|---|---|
| Unit tests | [N] | High |
| Integration tests | [N] | Medium |
| E2E tests | [N] | Low (critical journeys only) |

---

## Unit Tests

### [Component Name — e.g., LoginUseCase]

| Test | Behavior Verified | Priority |
|---|---|---|
| `test_login_succeeds_with_valid_credentials` | User can log in with correct email and password | High |
| `test_login_fails_when_password_is_incorrect` | Login is rejected when password does not match | High |
| `test_login_fails_when_user_does_not_exist` | Login is rejected when email is not registered | High |
| `test_login_fails_when_email_is_malformed` | Malformed email is rejected before processing | Medium |

---

### [Component Name — e.g., UserEntity]

| Test | Behavior Verified | Priority |
|---|---|---|
| `test_user_email_must_be_valid_format` | User cannot be created with an invalid email | High |
| `test_...` | ... | ... |

---

## Integration Tests

### [Integration Point — e.g., UserRepository → PostgreSQL]

| Test | Behavior Verified | Priority |
|---|---|---|
| `test_user_is_persisted_and_retrieved_correctly` | Saved user can be found by ID | High |
| `test_...` | ... | ... |

---

## End-to-End Tests

### [User Journey — e.g., User Login Flow]

| Step | Expected Result |
|---|---|
| User submits login form with valid credentials | User is authenticated and redirected to dashboard |
| User submits login form with wrong password | Error message is displayed, user remains on login screen |

---

## Edge Cases

[List the edge cases that must be covered across any test type]

- [Edge case 1]
- [Edge case 2]
- [Edge case 3]

---

## Testability Notes

[Any components that required architectural adjustments to become testable]

[Dependencies that required mocking and why]

---

## Coverage Summary

*Filled in after implementation*

| Layer | Behaviors Identified | Behaviors Tested | Coverage |
|---|---|---|---|
| Domain | [N] | [N] | [%] |
| Application | [N] | [N] | [%] |
| Infrastructure | [N] | [N] | [%] |
| ViewModel | [N] | [N] | [%] |

---

## Known Gaps

[Any behaviors that are not tested and the justification for deferral]

| Behavior | Reason Not Tested | Planned |
|---|---|---|
| [Behavior] | [Reason] | [Yes / No / Future] |
