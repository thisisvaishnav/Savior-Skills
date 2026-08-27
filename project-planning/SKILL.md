---
name: project-planning
description: Breaking down software projects into clear scope, milestones, tasks, and risks before implementation begins. Use when starting a new project, feature, or when a task needs to be decomposed into an actionable plan.
---

# Project Planning

## Planning Workflow

### 1. Define the Outcome
- What problem does this solve, and for whom?
- What does "done" look like? Write measurable success criteria.
- Explicitly list what is **out of scope** — this is as important as what's in.

### 2. Identify Constraints
- Deadline, budget, team size, existing tech stack, integrations, compliance.
- Note hard constraints vs. soft preferences.

### 3. Decompose into Milestones
- Slice the work into 2–4 milestones, each delivering something demonstrably valuable and testable.
- Order by dependency and risk: tackle the riskiest unknowns first.

### 4. Break Milestones into Tasks
- Each task should be completable in roughly a day or less.
- Write tasks as verifiable outcomes ("Users can reset their password via email link"), not vague activities ("work on auth").
- Capture dependencies between tasks.

### 5. Surface Risks
For each major risk, record: likelihood, impact, and mitigation or fallback. Common categories — unclear requirements, unfamiliar technology, third-party dependencies, and performance/scale unknowns.

## Output Format

```markdown
## Scope
**Goal:** ...
**In scope:** ...
**Out of scope:** ...
**Success criteria:** ...

## Milestones
1. [Name] — [outcome] — [target date]
...

## Tasks
- [ ] [Task] (depends on: [task]) — [owner]
...

## Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
```

## Principles

- Plans are living documents — revisit after each milestone and when assumptions change.
- Favor a thin end-to-end slice over polishing one layer at a time.
- Surface unknowns early with prototypes or spikes before committing to design.
- Communicate changes in scope or estimates as soon as they're known, not at the deadline.
