# Agent Catalog

Prefix: `wvhvb`

Visible entrypoint:

- `wvhvb-team-leader`

Core hidden specialists:

- `wvhvb-planner`
- `wvhvb-plan-review`
- `wvhvb-implementer`
- `wvhvb-reviewer-code`
- `wvhvb-reviewer-security`
- `wvhvb-tester-qa`
- `wvhvb-docs-handoff`
- `wvhvb-backlog-verifier`
- `wvhvb-ticket-creator`

Utility hidden specialists:

- `wvhvb-utility-explore`
- `wvhvb-utility-shell-inspect`
- `wvhvb-utility-summarize`
- `wvhvb-utility-ticket-audit`
- `wvhvb-utility-github-research`
- `wvhvb-utility-web-research`

Workflow contract:

- the team leader advances stages through ticket tools and workflow state, not by manually editing ticket files
- each major stage must leave a canonical artifact before the next stage begins
- read-only specialists return findings, artifacts, or blockers instead of mutating repo files
- per-ticket stage order stays sequential, and the repo defaults to one active lane unless bounded parallel work is explicitly justified
- the backlog verifier reads canonical artifact bodies through `ticket_lookup` before deciding whether old completion still holds
- the team leader runs the deterministic `smoke_test` tool between QA and closeout instead of delegating that stage to another agent
- post-migration, remediation, or reverification follow-up tickets are created only from current registered evidence through the guarded ticket flow
