# Workflow — Define Requirements

## Purpose

Transform a raw idea, client request, or vague need into validated user stories and a documented task list ready for development.

No development task is created before the requirement is understood.

No user story is written before the requirement is validated.

No task is assigned before the story is approved.

---

## Triggered By

Command: `/define`

---

## Participants

| Agent | Role in this workflow |
|---|---|
| Product Analyst | Understands the need, validates requirements, defines acceptance criteria |
| Story Writer | Converts validated requirements into formal user stories |
| Tech Lead | Reviews stories, breaks them into development tasks, sequences the work |
| Architect | Consulted if a story has architectural implications |

---

## Output Documents

| Document | Template | Location |
|---|---|---|
| User stories | `templates/user-story.md` | `docs/stories/US-NNN.md` |
| Task list | `templates/task-list.md` | `docs/tasks/task-list.md` |
| Individual tasks | `templates/task.md` | `docs/tasks/TASK-NNN.md` |

---

## Steps

### Step 1 — Receive and Understand the Request (Product Analyst)

Receive the raw idea or request from the user.

Do not assume you understand it. Ask:

- Who is the user of this feature? What is their role?
- What problem are they trying to solve?
- What does success look like from their perspective?
- What are the constraints or business rules that apply?
- What is explicitly out of scope?

Ask one question at a time.

Wait for the answer before asking the next.

When enough is known, summarize your understanding and ask for confirmation.

**Do not proceed to Step 2 until the user confirms the summary.**

**Output:** Confirmed requirements summary.

---

### Step 2 — Document Requirements (Product Analyst)

Produce a structured requirements summary:

- The business problem being solved
- Who the users are (with their roles and context)
- What the system must do (functional requirements)
- What the system must never do or allow (business rules and constraints)
- Acceptance criteria in business language
- Edge cases and failure scenarios
- Out of scope items

**Output:** Requirements summary document (inline, not a separate file).

---

### Step 3 — Write User Stories (Story Writer)

Convert the validated requirements into user stories.

For each requirement or user need:

1. Identify the actor (who)
2. Identify the action (what)
3. Identify the benefit (why)
4. Write the story: "As a [role], I want [action], so that [benefit]"
5. Write acceptance criteria as Given/When/Then scenarios
6. Identify edge cases and failure scenarios as additional criteria
7. Identify dependencies between stories
8. Assign priority based on business value

Produce each story using `templates/user-story.md`.

Save each story as `docs/stories/US-NNN.md`.

**Output:** Set of user stories saved in `docs/stories/`.

---

### Step 4 — Architectural Review (Architect — if needed)

If any story introduces:

- A new domain concept, aggregate, or bounded context
- A new integration with an external system
- A significant change to existing architecture

The Architect must review the story set before task breakdown begins.

If an ADR is required: trigger `workflows/create-adr.md` before proceeding.

**Output:** Architectural assessment. ADR if needed.

---

### Step 5 — Task Breakdown (Tech Lead)

For each approved user story, break it into development tasks.

For each task:

1. Define exactly what needs to be implemented
2. Identify which layer it belongs to (Domain / Application / Infrastructure / Frontend)
3. Assign it to the appropriate agent
4. Identify dependencies between tasks
5. Sequence tasks so inner layers are always implemented before outer layers

Create one task file per task using `templates/task.md`.

Save each task as `docs/tasks/TASK-NNN.md`.

Produce the complete task list using `templates/task-list.md`.

Save it as `docs/tasks/task-list.md`.

**Output:** Individual task files and task list document.

---

### Step 6 — Review and Confirm (Tech Lead + User)

Present the full picture to the user:

- Number of stories defined
- Number of tasks generated
- Estimated sequence of work
- Any dependencies or risks identified

Ask the user to confirm before any implementation begins.

If the user requests changes: return to the appropriate step.

**Output:** Confirmed task list ready for development.

---

## What Comes Next

Once this workflow is complete, each story and its tasks are ready for implementation.

To implement a story, trigger:

```
/create-feature US-NNN
```

The create-feature workflow will reference the story's acceptance criteria and the task files to guide implementation.

---

## Document Structure Created by This Workflow

```
docs/
├── stories/
│   ├── US-001.md
│   ├── US-002.md
│   └── US-003.md
└── tasks/
    ├── task-list.md
    ├── TASK-001.md
    ├── TASK-002.md
    └── TASK-003.md
```
