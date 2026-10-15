# Current Bootstrap State

Observed bootstrap state after the new-PC rebind and host-boundary acceptance.

- Project: resort-empire-web
- Bootstrap Mission: v2.2, active
- Semantic session: resort-empire-web-bootstrap-v2
- Active Distance: RESOLVE_FROM:VibeGo.resortMission.status()
- Physical environment authority: .vibe/environment.json
- Current observed host: DESKTOP-QBQU3HP
- Current observed repo: D:\TempleNet\WorkSpace\RRH
- Local branch: main
- Local Git lineage: MATERIALIZED on main
- Host relay: 0.1.1, proven end-to-end
- Resort host bridge: 1.1.0, proven read + governed write + typed governed process execution
- GitHub remote: MATERIALIZED as origin -> https://github.com/ApexFantom/resort-empire-web.git
- Dedicated Jira project: MATERIALIZED as ComCen_SI / CC / 10035 at https://ukfig2.atlassian.net
- Jira Bootstrap Work seed: CC-1 (CP-08 Task), read/write proven
- Application scaffold: MATERIALIZED; minimal runnable shell accepted
- Chrome DevTools MCP test path: ACCEPTED; governed browser-control evidence is materialized
- Gameplay implementation: FORBIDDEN until Bootstrap Mission closure

This file is descriptive current state, not physical-environment authority.

Before acting on a fact here, route to and re-read the factual owner.

## Accepted bootstrap implementation state

Minimal runnable shell is now materialized and accepted.

Exact architecture route:
semantic/architecture/BOUNDARIES.md

Accepted evidence:
semantic/evidence/minimal-runnable-shell-v1.md

Current factual implementation surfaces include:
- package.json + package-lock.json
- src/core/
- src/app/
- src/render/
- src/persistence/
- src/runtime/
- src/dev/
- Vite + TypeScript + Vitest configuration

Verified:
- headless Vitest core/contract tests pass
- TypeScript + production Vite build pass
- governed Vite dev-server lifecycle reaches RUNNING, returns HTTP 200, and terminates cleanly

Local Git history:
MATERIALIZED on main.
Initial canonical commit: eede43ab6bbd51411df8fdc993b21fd29b180179
Commit identity: Vadzim Mayamsin <55667882+ApexFantom@users.noreply.github.com>
Accepted Git evidence: semantic/evidence/local-git-lineage-v1.md
Dedicated GitHub remote: MATERIALIZED at https://github.com/ApexFantom/resort-empire-web.git.
Live current head must be resolved from Git; do not treat this descriptive state file as commit authority.

GitHub / Jira lineage:
CP-08 evidence: semantic/evidence/github-jira-lineage-v1.md.
Dedicated Jira project: ComCen_SI / CC / 10035.
Accepted Bootstrap Work: CC-1, representing Mission predicate CP-08.
Jira/GitHub remain non-authoritative for product meaning and runtime behavior.

Gameplay implementation:
FORBIDDEN until the Bootstrap Mission is sealed.

Dynamic Mission/Distance state is intentionally resolved from VibeGo.resortMission.status() rather than duplicated here.

Browser control:
Real Chrome MCP browser acceptance: ACCEPTED via semantic/evidence/browser-control-v1.json; implementation commit 842da26f5c75e56ab6fb16089a54a054a2fbb35c.

Observability:
ACCEPTED via semantic/evidence/observability-v1.json.
Typed lazy owner: src/debug/DebugTransport.ts.
Read-only developer plane: health(), snapshot(), eventCount(), events().
Disabled categories avoid payload construction; history is bounded; eventCount() reads that same bounded history; sink failure is isolated.

CP-09 end-to-end non-gameplay canary:
Engineering, deterministic, canonical real-browser, Git/GitHub and Jira factual-lineage proof is materialized at semantic/evidence/end-to-end-nongameplay-canary-v1.json and companion .md.
Implementation/GitHub commit: 570b958ca3cec6454af2ff01c31ed1efdab298e1.
Jira factual lineage: CC-1 comment 10033, independently read back through authenticated Atlassian MCP.
Exactly one CP-09 acceptance condition remains: fresh durable reload/recovery from repository artifacts without relying on the prior chat.
Do not treat CP-09 as sealed until that recovery evidence is accepted and the canonical record is finalized.
