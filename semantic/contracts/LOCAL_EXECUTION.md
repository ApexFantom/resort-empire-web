# Local Execution Contract

Physical execution authority:
.vibe/environment.json

Current governed transport:

VIBE-GO page
→ Opera GX Chromium relay
→ authenticated 127.0.0.1:18765
→ Resort host bridge
→ bound repository

Current factual source owners:
- .vibe/environment.json
- .vibe/host-bridge/server.ps1
- .vibe/host-bridge/start.ps1
- .vibe/host-bridge/stop.ps1
- .vibe/host-bridge/extension/

Current bridge capability surface:
- capabilities.list
- bridge.environment
- fs.stat
- fs.list
- fs.read
- fs.sha256
- fs.mkdir
- fs.writeExact
- git.status
- request.get

Mutation rules:
- exact bound project/environment/host/repo/ChatGPT Project must match
- new files require expected_absent=true
- existing writes require expected_sha256 CAS
- unique request identity and durable request outcome ledger
- UNKNOWN outcome must be reconciled; never blind-replay a possibly committed mutation
- paths are confined to the repository
- reparse traversal is rejected
- arbitrary shell execution is not currently enabled

Current observed versions relay=0.1.1 and bridge=1.0.1 are current-state observations, not architectural identity.


## Environment rebind repair

A physical-machine or repository-path change is not a Mission/product rewrite.

Repair sequence:

1. Observe the new host, repository root, Git root/version and control-browser project identity without mutation.
2. Compare them against the current .vibe/environment.json authority.
3. Perform one explicit fail-closed environment rebind; preserve stable project identity and ChatGPT Project identity unless separate accepted authority changes them.
4. Revalidate the rebound .vibe/environment.json from the new physical host.
5. Rehydrate or explicitly amend browser-local SemanticSession authority if the control browser does not contain the prior session.
6. Install or repair the Resort-native bridge for the rebound environment; never silently reuse copied machine-local secret/runtime state as new authority.
7. Re-prove transport health, read access and one guarded mutation independently.
8. Update semantic/current/STATE.md only after those factual checks succeed.

If any source identity, expected SHA, host, repo root or project identity is inconsistent, stop fail-closed and investigate rather than overwriting authority.


## Governed process execution

Current bridge capability surface additionally includes:

- process.run
- process.start
- process.status
- process.stop

Execution contract:

- process executable identity is selected from a bridge-owned allowlist; callers do not provide an arbitrary executable path
- current project-tool allowlist includes git, node, npm and npx
- diagnostic.loopback-delay exists only as an internal bounded lifecycle/timeout canary
- caller arguments use array semantics; no shell command-string interpretation is introduced
- process cwd is confined to the bound repository
- process.run returns bounded stdout/stderr, exit code, timeout and termination evidence
- process.start returns a durable job identity
- process.status and process.stop operate on that governed job identity
- mutating process requests use the same durable request ledger as filesystem mutations
- transport UNKNOWN is not permission to retry: first reconcile the exact request_id through request.get
- if the ledger reports COMMITTED, recovery may resend only the exact same request identity/payload and must receive the cached committed result
- arbitrary shell execution remains disabled

Current observed bridge version:
resort-host-bridge/1.1.0

Accepted process proof is recorded in:
semantic/evidence/governed-process-execution-v1.md
