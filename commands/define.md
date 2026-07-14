# Command — /define

## Purpose

Transforms a raw idea or client request into validated user stories and a documented task list ready for development.

Nothing is built until the need is understood, the stories are written, and the tasks are planned.

---

## Usage

```
/define [idea or request]
```

**Examples:**

```
/define the client wants users to be able to register and log in
/define we need a way for users to manage their subscription plan
/define add notifications when an order changes status
```

---

## What This Command Does

1. Activates the **Product Analyst** as the first agent
2. Triggers `workflows/define-requirements.md` in full
3. Passes through Product Analyst → Story Writer → Tech Lead in sequence
4. Produces user stories in `docs/stories/` and tasks in `docs/tasks/`

---

## What Will Happen

**Product Analyst** will:
- Ask clarifying questions one at a time
- Validate your understanding of the need
- Produce a requirements summary for your confirmation

**Story Writer** will:
- Convert the validated requirements into formal user stories
- Write acceptance criteria as testable scenarios
- Save each story as `docs/stories/US-NNN.md`

**Tech Lead** will:
- Break each story into development tasks
- Assign tasks to agents by layer
- Sequence tasks in implementation order
- Save each task as `docs/tasks/TASK-NNN.md`
- Produce the full task list at `docs/tasks/task-list.md`

---

## What You Must Provide

- A description of what you want to build (one sentence is enough to start)
- Answers to the Product Analyst's clarifying questions
- Confirmation before stories are written and tasks are created

---

## What This Command Will Not Do

- Start writing code
- Proceed without confirming the requirements with you
- Create tasks before stories are approved
- Write vague stories that cannot be tested

---

## What Comes Next

Once `/define` completes, use `/create-feature` to implement a specific story:

```
/create-feature US-001
```

---

## Workflow Reference

`workflows/define-requirements.md`

---

## Documents Produced

- `docs/stories/US-NNN.md` — one per user story, using `templates/user-story.md`
- `docs/tasks/task-list.md` — full task list, using `templates/task-list.md`
- `docs/tasks/TASK-NNN.md` — one per task, using `templates/task.md`
