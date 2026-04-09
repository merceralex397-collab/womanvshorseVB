---
name: model-operating-profile
description: Apply the `Standard-tier evidence-first profile` operating profile for the selected downstream models. Use when shaping prompts, delegation briefs, review asks, or evidence requests for this repo.
---

# Model Operating Profile

Before reading anything else, call `skill_ping` with `skill_id: "model-operating-profile"` and `scope: "project"`.

Selected runtime profile:

- model tier: `standard`
- provider: `minimax-coding-plan`
- team lead / planner / reviewers: `minimax-coding-plan/minimax-coding-plan/MiniMax-M2.7`
- implementer: `minimax-coding-plan/minimax-coding-plan/MiniMax-M2.7`
- utilities, docs, and QA helpers: `minimax-coding-plan/minimax-coding-plan/MiniMax-M2.7`
- operating profile: `Standard-tier evidence-first profile`
- prompt density: `explicit checklists with selective examples and linked truth sources`

Use this profile when drafting:

- task prompts
- delegation briefs
- review requests
- handoff expectations

Profile guidance:

`Keep prompts explicit and bounded, but use lighter repetition. Preserve stop conditions and verification checklists while relying more on linked canonical docs than inline examples.`

Required rules:

- keep stop conditions and verification checklists explicit
- reference canonical truth surfaces directly when they already contain the durable procedure
- use examples only where the workflow would otherwise stay ambiguous
- keep tasks bounded and evidence-first
- surface blockers clearly instead of improvising around them

## MiniMax-M2.7 Operational Constraints

Known behavioral tendencies:

- Can be verbose; always set explicit output length or shape expectations
- Responds well to numbered checklists and concrete stop conditions
- May speculate beyond the task scope without explicit boundaries
- Performs best with single-objective tasks; avoid multi-goal prompts
- Requires explicit "stop and return a blocker" instructions to avoid improvising past obstacles

Prompting rules for this model:

1. **One objective per prompt** — split multi-step work into sequential delegations
2. **Name the exact truth surfaces to read** — don't say "check the docs", say "read `tickets/manifest.json` field `tickets[0].status`"
3. **Specify output shape** — provide the expected format (markdown template, JSON schema, checklist)
4. **Include stop conditions** — "If X is missing, return a blocker. Do not improvise."
5. **Set evidence requirements** — "Include raw command output. Do not claim success without paste."
6. **Bound the search space** — "Only modify files under `scenes/`. Do not touch `project.godot`."

When ambiguity is likely, prefer a concrete output shape such as:

```text
Goal
Constraints
Expected output
Evidence required
Stop conditions
Blockers
```
