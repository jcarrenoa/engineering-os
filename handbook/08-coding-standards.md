# 08 — Coding Standards

These standards apply regardless of technology.

Technology-specific conventions supplement these rules — they never override them.

---

# Naming

Names must be descriptive and unambiguous.

Names communicate intent, not implementation.

A reader must understand what something does from its name alone.

Abbreviations are forbidden unless universally understood in the domain.

**Classes and types:** Noun or noun phrase. Describes what the thing is.

**Methods and functions:** Verb or verb phrase. Describes what the action does.

**Booleans:** Answer a yes/no question.

Good: `is_active`, `has_permission`, `can_withdraw`, `is_email_verified`

Bad: `flag`, `status`, `check`, `active`

**Collections:** Plural nouns.

Good: `users`, `pending_orders`, `active_sessions`

Bad: `list`, `data`, `items`

---

# Functions and Methods

A function does one thing.

A function name describes that one thing completely.

Functions are short enough to read in a single view without scrolling.

Functions with more than three parameters use a parameter object or a dedicated input type.

Side effects are isolated, named clearly, and documented when non-obvious.

A function that both queries state and modifies state is two functions pretending to be one.

---

# Classes and Modules

A class has one responsibility.

If naming a class requires the word "And" or "Manager" or "Helper", the class has too many responsibilities.

A module has a clear public API.

Internal implementation details are never exposed publicly.

Do not expose what callers do not need.

---

# Comments

Comments explain why, not what.

Code must be readable without comments.

If a comment is required to understand what the code does, rewrite the code.

Comments that capture a hidden constraint, a non-obvious invariant, or a workaround for an external bug are valuable.

Comments that describe what a well-named function obviously does are noise.

---

# Error Handling

Errors are handled explicitly.

Silent failures are forbidden.

Every error path produces a meaningful, actionable message.

Errors from external systems are translated into domain-specific error types before reaching the application core.

Do not let infrastructure errors (database timeouts, HTTP errors, filesystem errors) leak into the domain layer as raw exceptions.

Never use exceptions for control flow.

---

# Constants and Magic Values

Magic numbers are forbidden.

Magic strings are forbidden.

Every constant is named and placed in an appropriate constants file or enumeration.

Good: `MAX_RETRY_ATTEMPTS = 3`, `DEFAULT_PAGE_SIZE = 20`

Bad: `if retries > 3`, `limit = 20`

---

# Dependencies

Every dependency is justified.

Prefer the standard library over third-party libraries when the standard library is sufficient.

Every third-party dependency is a maintenance commitment and a supply-chain risk.

Dependencies that are no longer used are removed immediately.

---

# Immutability

Prefer immutable data over mutable data.

Domain entities change state through explicit methods that represent domain operations — not through direct property assignment from outside the entity.

Value objects are always immutable.

---

# Code Duplication

Duplication signals a missing abstraction.

Three or more identical or nearly identical blocks of code justify an abstraction.

Two similar blocks may be coincidence — evaluate carefully before abstracting.

Premature abstraction is worse than duplication.

Introduce abstractions when they carry meaning, not just to reduce line count.

---

# Code Review Checklist

Before any implementation is considered complete, verify:

Architecture

- [ ] Architecture layers respected
- [ ] Dependency direction respected (inward only)
- [ ] No business logic in the wrong layer
- [ ] Domain has no external dependencies

Quality

- [ ] Tests written and passing
- [ ] No duplicated logic
- [ ] No dead code
- [ ] No magic numbers or strings
- [ ] Error handling is explicit

Readability

- [ ] Names communicate intent clearly
- [ ] No unnecessary complexity
- [ ] No premature abstractions

Documentation

- [ ] ADR created if an architectural decision was made
- [ ] Significant non-obvious decisions have inline comments
- [ ] Public interfaces are documented if behavior is not self-evident

---

# What Good Code Looks Like

Good code reads like well-written prose.

A function tells a story with a beginning, a middle, and an end.

A class represents a single concept with a clear contract.

A module defines a boundary that makes the system easier to understand.

Good code does not require a guide to read.

Good code is the guide.
