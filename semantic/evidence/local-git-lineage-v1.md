# Local Git Lineage v1 — Acceptance Record

Claim:
The accepted Resort bootstrap substrate and minimal runnable shell now have truthful local Git lineage on main, with machine-local secrets/runtime state excluded from version control.

## Repository

- repository: D:/TempleNet/WorkSpace/RRH
- branch: main
- initial commit: eede43ab6bbd51411df8fdc993b21fd29b180179
- initial commit subject: bootstrap: establish governed Resort substrate
- commit author: Vadzim Mayamsin <55667882+ApexFantom@users.noreply.github.com>

Git identity is repository-local.

## Initial staged-set discipline

The initial commit used an explicit path manifest.
No git add . was used.

Durable committed surfaces include:

- .vibe/environment.json physical authority
- current Stage5D VIBE-GO firmware source
- current Resort host bridge server/start/stop source
- current Chromium relay extension source, excluding machine-local config
- FINAL product requirements
- semantic development plan
- Mission v2.2 contract
- semantic routing/contracts/evidence/current state
- non-gameplay application shell and package lock
- Vite/TypeScript/Vitest configuration

## Explicitly excluded

- .vibe/host-bridge/token.txt
- .vibe/host-bridge/extension/config.js
- .vibe/host-bridge/ledger/
- .vibe/host-bridge/runtime/
- .vibe/rebind-backup/
- host-bridge extension backups
- host-bridge repair backups
- mutation canary
- one-shot root RESORT_*.ps1 scripts
- node_modules/
- dist/
- coverage/

No excluded path was present in the initial staged manifest.

## Authority SHA anchors

- product requirements:
  50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de
- development plan:
  c4c139a1a4692801c50967a4ae7259117a06f7062da98e06187360ce99add59e
- Mission v2.2 JSON:
  d9d4f5198793a5a16efe5f4a95dbea535c02b1e417f8d200a612716b89cf14d3
- Mission v2.2 Markdown:
  7068b9b5db5129f44135e7bafafb857068a9c4410dd88e683d58414c5b207ce0
- Stage5D firmware:
  604be75059bec907cae65b27a29eb0bdcc684559ce3ba272ba806e0569781007
- environment:
  6bc90a2c3a647daff9d9087132a54b34a635a056308acc81545a0791d82b9602

## Reproducibility

After the initial commit, without changing application source:

- npm test: exit code 0
- Vitest core tests passed
- npm run build: exit code 0
- TypeScript check passed
- Vite production build passed

Generated build output remains ignored.

## Authority rule

Git/GitHub are implementation lineage, not product or behavior authority.

Behavior is proven by tests/runtime/browser evidence.
Product truth remains the FINAL requirements authority.
Semantic files route and remember accepted meaning; they do not replace implementation truth.
