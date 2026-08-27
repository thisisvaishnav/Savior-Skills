---
name: architecture
description: Create or evaluate an architecture decision record (ADR). Use when choosing between technologies (e.g., Kafka vs SQS), documenting a design decision with trade-offs and consequences, reviewing a system design proposal, or designing a new component from requirements and constraints.
---

# Architecture

Create an Architecture Decision Record (ADR) or evaluate a system design.

## Modes

**Create an ADR**: "Should we use Kafka or SQS for our event bus?"

**Evaluate a design**: "Review this microservices proposal"

**System design**: "Design the notification system for our app"

## Workflow

1. **State constraints upfront.** Deadlines ("ship in 2 weeks"), scale targets ("10K rps"), and team expertise shape the answer — gather these before analyzing options.
2. **Name the options.** Even when leaning one way, analyze at least two or three explicit alternatives for a balanced comparison.
3. **Include non-functional requirements.** Latency, cost, team familiarity, and maintenance burden matter as much as features.
4. **Write the decision down** using the ADR format below, including consequences and follow-ups.

## Output — ADR Format

```markdown
# ADR-[number]: [Title]

**Status:** Proposed | Accepted | Deprecated | Superseded
**Date:** [Date]
**Deciders:** [Who needs to sign off]

## Context
[What is the situation? What forces are at play?]

## Decision
[What is the change we're proposing?]

## Options Considered

### Option A: [Name]

| Dimension | Assessment |
|-----------|------------|
| Complexity | [Low/Med/High] |
| Cost | [Assessment] |
| Scalability | [Assessment] |
| Team familiarity | [Assessment] |

**Pros:** [List]
**Cons:** [List]

### Option B: [Name]
[Same format]

## Trade-off Analysis
[Key trade-offs between options with clear reasoning]

## Consequences
- [What becomes easier]
- [What becomes harder]
- [What we'll need to revisit]

## Action Items
1. [ ] [Implementation step]
2. [ ] [Follow-up]
```

## Tips

1. **State constraints upfront** — "We need to ship in 2 weeks" or "Must handle 10K rps" shapes the answer.
2. **Name your options** — Even if you're leaning one way, a more balanced analysis comes from explicit alternatives.
3. **Include non-functional requirements** — Latency, cost, team expertise, and maintenance burden matter as much as features.
