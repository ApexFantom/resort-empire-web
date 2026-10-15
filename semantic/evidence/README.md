# Evidence

Accepted behavior claims require factual evidence.

Canonical accepted envelope:
resort-verification-result/v1

Evidence may include:
- deterministic Vitest results
- runtime observations
- Chrome DevTools MCP browser observations
- source diffs
- exact environment/host bridge responses
- Git lineage references
- Jira Work references

A generated file, successful commit, Jira status, or isolated test alone is not sufficient completion proof.

Keep evidence bounded and claim-specific. Do not turn this directory into a raw-log dump or a second source tree.
- Governed observability v1: `observability-v1.json` + `observability-v1.md` + `assets/observability-v1.webp`
- CP-09 end-to-end non-gameplay canary v1: `end-to-end-nongameplay-canary-v1.json` + `end-to-end-nongameplay-canary-v1.md` — ACCEPTED; engineering, deterministic, real-browser, Git/GitHub, Jira lineage, semantic delta, and fresh no-chat durable recovery are proven.
- Bootstrap closure readiness v1: `bootstrap-closure-readiness-v1.json` — ACCEPTED; CP-03 authenticated negative identity-mismatch behavior and CP-10 empty blocker inventory/successor readiness are proven.
- Bootstrap Mission closure v1: `bootstrap-mission-closure-v1.json` — canonical `resort-vibe-mission-closure-evidence/v1` envelope with PROVEN evidence references for CP-01 through CP-12. Gameplay remains forbidden until semantic `MISSION_SEALED` acceptance.
