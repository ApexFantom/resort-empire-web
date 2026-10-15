# Semantic Routes

| Intent | Semantic route | Factual owner / next authority |
|---|---|---|
| Current bootstrap state | current/STATE.md | VibeGo.resortMission.status(), .vibe/environment.json, git.status |
| Physical environment / local execution | contracts/LOCAL_EXECUTION.md | .vibe/environment.json; .vibe/host-bridge/ |
| Application architecture | architecture/BOUNDARIES.md | repository source owners once scaffolded |
| Product meaning / scope | domain/PRODUCT.md | RESORT_EMPIRE_REQUIREMENTS_FINAL(2).md |
| Browser verification / testing | contracts/BROWSER_TESTING.md | test source + Chrome DevTools MCP runtime evidence once installed |
| Debug / developer observability | contracts/DEBUG.md | src/debug/DebugTransport.ts; src/core/runtime.ts; src/dev/installDevFacade.ts; src/main.tsx |
| Git / GitHub / Jira | contracts/GIT_GITHUB_JIRA.md | .git, future GitHub remote, future dedicated Jira project |
| Accepted verification evidence | evidence/README.md | factual test/runtime/browser evidence |
| Reusable process lessons | lessons/README.md | accepted incident evidence and repaired source |

Routing rule:
If the factual owner named here does not yet exist, do not invent a substitute implementation. Treat the owner as NOT YET MATERIALIZED and follow the active Bootstrap Mission.
