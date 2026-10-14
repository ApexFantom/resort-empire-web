# Resort Empire Web — Bootstrap Mission Contract v2.2

**Status:** environment-rebind-aware revision of the already accepted Bootstrap Mission.

## What changed

Mission semantics, North Star, forbidden states and CP-01..CP-12 are unchanged.

v2.2 repairs one architectural mistake in v2.1: physical host/repository coordinates were duplicated inside the Mission contract. They now resolve through the single repo-local environment authority `.vibe/environment.json`.

The current explicit rebind evidence is preserved as history, but operational routing does not hard-code the current PC path.

## Environment authority

```text
.vibe/environment.json
  -> environment_id
  -> host
  -> repo_root
  -> platform/shell
  -> ChatGPT Project identity
```

A future explicit physical rebind therefore changes this authority rather than forcing another product/architecture Mission rewrite.

## Session rehydration

The SemanticSession was browser-local and did not move to the new PC/control-browser storage. After exact environment preflight, v2.2 permits explicit recreation of the same session identity `resort-empire-web-bootstrap-v2` with the same bootstrap Mission and active semantic-routing Distance.

## Full structured contract

```json
{
  "schema": "resort-vibe-bootstrap-mission/v2.2",
  "revision": "2026-10-14-environment-rebind-v2.2",
  "status": "ACTIVE_AFTER_EXPLICIT_INSTALL_OR_AMEND",
  "project_id": "resort-empire-web",
  "mission_id": "resort-empire-web-bootstrap-substrate-v2.2",
  "mission_kind": "development-substrate",
  "supersedes": {
    "schema": "resort-vibe-bootstrap-mission/v2.1",
    "revision": "2026-10-14-user-approved-v2.1",
    "reason": "Physical development environment was explicitly rebound from the laptop to DESKTOP-QBQU3HP. v2.2 removes duplicated hard-coded physical host/repo facts from Mission architecture and resolves them through the repo-local environment authority. Mission semantics and CP-01..CP-12 are unchanged."
  },
  "user_authority": {
    "checkpoint_4_initial": {
      "accepted": true,
      "instruction": "зашивай"
    },
    "amendment_v2_1": {
      "accepted": true,
      "accepted_at": "2026-10-14T19:12:15Z",
      "instruction": "окей"
    }
  },
  "north_star": "Establish for Resort Empire Web a self-sufficient, fail-closed, evidence-governed development substrate in which a fresh competent model with no memory of the current chat can orient from durable project artifacts, route from intended meaning to the single authoritative source owner, perform bounded mutations only in the exact bound Windows environment, autonomously build and inspect the real browser application through the governed Chrome DevTools MCP path, prove behavior through one disciplined verification system, preserve truthful local Git plus dedicated GitHub and Jira lineage, and update semantic memory only when accepted meaning changes.",
  "invariant": "Ordinary bounded project work MUST NOT require reconstructing implementation architecture from the whole repository or chat history, nor require routine operator mouse/keyboard work to test the browser application. The normal route is ABOUT -> semantic route -> relevant typed artifact -> existing authoritative source owner -> bounded mutation -> Vitest and/or governed Chrome DevTools MCP verification -> one canonical verification evidence envelope -> Git lineage -> Jira factual evidence -> minimal semantic delta iff meaning changed. If ordinary work requires whole-repository rediscovery, shadow implementations, override generations, parallel debug/test authorities, ad-hoc acceptance formats, or chat memory as authority, the substrate is not complete.",
  "direction": "Establish for Resort Empire Web a self-sufficient, fail-closed, evidence-governed development substrate in which a fresh competent model with no memory of the current chat can orient from durable project artifacts, route from intended meaning to the single authoritative source owner, perform bounded mutations only in the exact bound Windows environment, autonomously build and inspect the real browser application through the governed Chrome DevTools MCP path, prove behavior through one disciplined verification system, preserve truthful local Git plus dedicated GitHub and Jira lineage, and update semantic memory only when accepted meaning changes. The Mission remains OPEN until closure predicates CP-01 through CP-12 are all factually proven. Do not implement gameplay during this Mission. After closure, authorize exactly one successor Mission: the smallest Prototype gameplay vertical proof for one normal wave.",
  "reminder": "MISSION INVARIANT: Ordinary bounded project work MUST NOT require reconstructing implementation architecture from the whole repository or chat history, nor require routine operator mouse/keyboard work to test the browser application. The normal route is ABOUT -> semantic route -> relevant typed artifact -> existing authoritative source owner -> bounded mutation -> Vitest and/or governed Chrome DevTools MCP verification -> one canonical verification evidence envelope -> Git lineage -> Jira factual evidence -> minimal semantic delta iff meaning changed. If ordinary work requires whole-repository rediscovery, shadow implementations, override generations, parallel debug/test authorities, ad-hoc acceptance formats, or chat memory as authority, the substrate is not complete. PRODUCT AUTHORITY: the current FINAL Resort Empire requirements and their source/authority map govern product truth; examples, e.g. values, TUNING, OPEN questions, proposals, Jira wording, semantic prose and implementation convenience are not hard requirements. SCOPE: Prototype-first; MVP/Later are out of scope except minimal replaceable boundaries factually required by architecture. ARCHITECTURE: pure TypeScript game core owns gameplay state/transitions; React is UI projection; PixiJS is world/render projection; persistence is explicit; simulation is decoupled from render cadence. BROWSER: official Chrome DevTools MCP is the required browser-control/inspection adapter, reached through the Resort-native host boundary and a dedicated non-personal Chrome/Chrome-for-Testing profile; ordinary RRH browser acceptance must not depend on operator mouse/keyboard work. TESTING: Vitest owns deterministic core/contract tests; Chrome DevTools MCP owns real browser/runtime/UI/Pixi/console/network/performance acceptance; manual console probes are RECON only; accepted verification emits one resort-verification-result/v1 envelope. DEBUG: one encapsulated lazy structured debug plane; read-only inspection by default; any developer mutation crosses canonical game-core commands; no parallel gameplay/state path. MUTATION: mutate the existing owner by default. A new wrapper/adapter/store/override/implementation layer requires factual need plus explicit ownership and removal/cutover contract. Global rerender/rebuild and whole-scene recreation are forbidden defaults. GIT/JIRA: local Git is immediate canonical implementation lineage; a dedicated GitHub remote repository must be created without losing existing local history and then maintained; a dedicated Jira project must be created, identified durably, seeded from accepted backlog authority and maintained throughout development. EVIDENCE: semantic artifacts route/remember accepted meaning; repository source is implementation truth; tests/runtime prove behavior; Jira is Work/backlog; Git/GitHub are implementation lineage. FORBIDDEN: wrong host/repo/project mutation, chat-memory authority, unsupported OPEN/TUNING promotion, completion-by-commit, dev/debug bypass of gameplay authority, parallel browser/test stacks without a proven gap, or gameplay before this Mission closes. MISSION_SEALED is invalid unless VG_RESULT includes closureEvidence with schema resort-vibe-mission-closure-evidence/v1, invariantPreserved=true, forbiddenStatesAbsent=true, and PROVEN evidenceRefs for every CP-01..CP-12.",
  "authority": {
    "product_requirements": {
      "file": "RESORT_EMPIRE_REQUIREMENTS_FINAL(2).md",
      "sha256": "50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de",
      "role": "product truth and Prototype/MVP/Later scope authority"
    },
    "development_plan": {
      "file": "RESORT_EMPIRE_WEB_VIBE_SEMANTIC_DEV_PLAN_v1.md",
      "sha256": "c4c139a1a4692801c50967a4ae7259117a06f7062da98e06187360ce99add59e",
      "role": "engineering/semantic development contract, amended by explicit user authority recorded here"
    },
    "implementation_truth": "live repository source on exact bound environment",
    "behavior_truth": "canonical verification evidence backed by tests/runtime/browser observations",
    "work_surface": "dedicated Jira project",
    "lineage_surface": "local Git + dedicated GitHub remote",
    "semantic_role": "accepted meaning/routing; never proof of current implementation behavior"
  },
  "scope": {
    "phase": "BOOTSTRAP_ONLY",
    "prototype_product_authority": "PRESERVED_FOR_SUCCESSOR",
    "mvp": "OUT_OF_SCOPE_UNLESS_MINIMAL_REPLACEABLE_BOUNDARY_REQUIRED",
    "later": "OUT_OF_SCOPE",
    "gameplay_implementation": "FORBIDDEN_UNTIL_MISSION_SEALED",
    "open_tuning_policy": "DO_NOT_PROMOTE_WITHOUT_ACCEPTED_AUTHORITY"
  },
  "architecture_invariants": {
    "gameplay_authority": "pure TypeScript game core",
    "react": "UI projection",
    "pixi": "world/render projection",
    "persistence": "explicit boundary",
    "simulation_render_cadence": "decoupled",
    "headless_core_testing": true,
    "developer_plane": "separate from player surfaces and never gameplay authority",
    "browser": {
      "browser_adapter": "official Chrome DevTools MCP",
      "package_identity": "ChromeDevTools/chrome-devtools-mcp",
      "host_boundary": "Resort-native local bridge/client on the exact host resolved from .vibe/environment.json",
      "browser_profile": "dedicated non-personal Chrome or Chrome for Testing profile",
      "default_url_scope": [
        "http://127.0.0.1:*",
        "http://localhost:*"
      ],
      "workspace_root": "RESOLVE_FROM:.vibe/environment.json#expected.repo_root",
      "required_capabilities": [
        "launch/connect browser",
        "navigate",
        "click/keyboard/forms/drag where needed",
        "evaluate read-only inspection scripts",
        "capture console errors",
        "capture network failures",
        "capture screenshots",
        "collect runtime/performance evidence",
        "clean shutdown/recovery"
      ],
      "dev_inspection_surface": {
        "name": "globalThis.__RRH_DEV__",
        "read_only_by_default": true,
        "allowed_read_examples": [
          "health()",
          "snapshot()",
          "entities()",
          "bounds()",
          "events()",
          "performance()"
        ],
        "mutation_rule": "Any mutation must delegate to canonical game-core command authority; no direct writable state exposure."
      },
      "control_browser": "ChatGPT/VIBE-GO may run in Opera GX or another Chromium control browser; the game-test browser remains a dedicated non-personal Chrome/Chrome-for-Testing instance."
    },
    "testing": {
      "deterministic_engine": "Vitest",
      "browser_runtime_engine": "Chrome DevTools MCP",
      "manual_console_probes": "RECON_ONLY",
      "canonical_evidence_schema": "resort-verification-result/v1",
      "playwright_policy": "DO_NOT_ADD unless Chrome DevTools MCP + existing stack has a proven accepted capability gap requiring a source-controlled browser runner."
    },
    "git_jira": {
      "git": {
        "local_repo": "RESOLVE_FROM:.vibe/environment.json#expected.repo_root",
        "local_history": "canonical immediate implementation lineage",
        "remote_provider": "GitHub",
        "remote_requirement": "Create a dedicated repository during bootstrap; first push must preserve the accumulated local Git history.",
        "after_attachment": "Maintain GitHub remote continuously through development."
      },
      "jira": {
        "requirement": "Create a dedicated Jira project during bootstrap.",
        "identity": "Persist project URL/site/key/id in semantic/environment contracts once factual.",
        "seed": "Seed accepted Epics/Stories/Tasks from product/backlog authority; do not invent product truth.",
        "maintenance": "Maintain active Work/status/evidence/commit references throughout development."
      }
    }
  },
  "engineering_invariants": {
    "semantic_route_before_broad_archaeology": true,
    "modify_existing_owner_by_default": true,
    "new_layer_requires_factual_need": true,
    "new_layer_requires_ownership_contract": true,
    "new_layer_requires_removal_or_cutover_contract": true,
    "global_rerender_default_forbidden": true,
    "global_rebuild_default_forbidden": true,
    "lazy_local_processing": true,
    "shared_lazy_debug_transport": true,
    "semantic_placeholders_before_final_art": true,
    "ordinary_browser_testing_requires_no_operator_input": true,
    "single_verification_evidence_schema": "resort-verification-result/v1"
  },
  "forbidden_states": [
    {
      "id": "FS-01",
      "state": "chat memory or narrative summary treated as implementation/product authority"
    },
    {
      "id": "FS-02",
      "state": "whole-repository archaeology as the normal prerequisite for bounded work"
    },
    {
      "id": "FS-03",
      "state": "mutation on a host/repo/project that does not match the exact environment binding"
    },
    {
      "id": "FS-04",
      "state": "wrapper/override/shadow implementation added instead of mutating the existing owner without factual necessity"
    },
    {
      "id": "FS-05",
      "state": "OPEN/TUNING/example/proposal promoted into a hard product rule without accepted authority"
    },
    {
      "id": "FS-06",
      "state": "generated code, isolated test success, Jira status, or a Git/GitHub commit treated as sufficient completion evidence"
    },
    {
      "id": "FS-07",
      "state": "developer/debug/test tooling bypasses authoritative game-core command/state boundaries"
    },
    {
      "id": "FS-08",
      "state": "gameplay implementation begins before this bootstrap Mission is sealed"
    },
    {
      "id": "FS-09",
      "state": "global rerender/rebuild/whole-scene recreation or broad recomputation used as a default change mechanism"
    },
    {
      "id": "FS-10",
      "state": "semantic corpus becomes a second source-code monolith instead of a small routable meaning layer"
    },
    {
      "id": "FS-11",
      "state": "debug/browser/test tooling creates parallel writable gameplay state, a shadow implementation path, or a second gameplay authority"
    },
    {
      "id": "FS-12",
      "state": "ordinary browser verification depends on operator mouse/keyboard work or a second overlapping browser automation/test stack is introduced without a proven capability gap and explicit architecture decision"
    }
  ],
  "closure_predicates": [
    {
      "id": "CP-01",
      "name": "cold-start continuity",
      "claim": "A fresh competent model can orient from durable project artifacts, start at semantic/ABOUT.md, route through semantic/ROUTES.md and identify the exact authoritative source owner for a bounded responsibility without reading the whole repository or prior chat history.",
      "minimum_evidence": [
        "fresh/reloaded-session acceptance",
        "route trace",
        "resolved source owner"
      ]
    },
    {
      "id": "CP-02",
      "name": "single-owner bounded mutation",
      "claim": "At least one real bounded canary changes an existing authoritative owner directly; no shadow implementation/override generation is introduced unless factual compatibility/architecture requires it and an ownership plus removal/cutover contract exists.",
      "minimum_evidence": [
        "pre-mutation owner resolution",
        "source diff",
        "tests/runtime proof",
        "anti-layering review"
      ]
    },
    {
      "id": "CP-03",
      "name": "exact environment boundary",
      "claim": "Mutation is allowed only for the bound project/environment/host/repository/ChatGPT Project, while a wrong identity fails closed without side effects.",
      "minimum_evidence": [
        "positive preflight",
        "negative mismatch canary",
        "repo-local environment authority"
      ]
    },
    {
      "id": "CP-04",
      "name": "governed local execution",
      "claim": "The Resort-native local execution path can perform allowed filesystem/PowerShell/process operations with typed requests, exact cwd/path fencing, request identity, bounded stdout/stderr/exit evidence, timeout behavior and UNKNOWN-outcome reconciliation without blind replay.",
      "minimum_evidence": [
        "read-only bridge canary",
        "bounded mutation canary",
        "process/dev-server canary",
        "unknown-outcome/reconciliation acceptance"
      ]
    },
    {
      "id": "CP-05",
      "name": "operational semantic corpus",
      "claim": "ABOUT/ROUTES/current/architecture/domain/contracts/evidence/lessons form a decomposable routing corpus that points to factual authority instead of duplicating source, supports cold start and has an explicit stale-semantic repair path.",
      "minimum_evidence": [
        "semantic corpus files",
        "route-to-owner acceptance",
        "stale semantic repair acceptance"
      ]
    },
    {
      "id": "CP-06",
      "name": "architecture boundary",
      "claim": "A minimal runnable shell proves pure TypeScript core authority, React UI projection, Pixi world/render projection, explicit persistence boundary, render/simulation cadence separation and headless core testing without implementing gameplay content.",
      "minimum_evidence": [
        "runnable bootstrap",
        "headless test",
        "boundary inspection/runtime evidence"
      ]
    },
    {
      "id": "CP-07",
      "name": "encapsulated observability boundary",
      "claim": "One shared lazy structured debug transport serves enabled sinks; disabled categories avoid expensive payload construction; an RRH dev inspection facade is read-only by default; any developer mutation traverses canonical authoritative commands; debug/test tooling never creates parallel gameplay or state authority.",
      "minimum_evidence": [
        "debug transport acceptance",
        "disabled-cost acceptance",
        "dev inspection acceptance",
        "developer mutation boundary acceptance"
      ]
    },
    {
      "id": "CP-08",
      "name": "dedicated GitHub and Jira project lineage",
      "claim": "Local Git is maintained from the start; a dedicated GitHub repository is created and receives the existing local history without rewriting/loss, then remains the remote lineage surface; a dedicated Jira project is created, durably identified, seeded from accepted backlog authority and maintained so bounded Work links to source diff, behavioral evidence and Git lineage without making Jira/GitHub product or behavior authority.",
      "minimum_evidence": [
        "local Git history",
        "GitHub remote creation and first full-history push",
        "remote verification",
        "Jira project creation",
        "Jira read/write evidence",
        "Work-to-commit/evidence cross-reference"
      ]
    },
    {
      "id": "CP-09",
      "name": "end-to-end non-gameplay canary",
      "claim": "One complete real bootstrap canary traverses Mission -> semantic route -> existing owner -> governed local mutation -> canonical verification evidence -> Git/GitHub -> Jira -> semantic-delta decision, and remains recoverable after reload/restart without relying on this chat.",
      "minimum_evidence": [
        "end-to-end trace",
        "reload/recovery proof",
        "semantic delta/no-delta decision"
      ]
    },
    {
      "id": "CP-10",
      "name": "no bootstrap blocker remains",
      "claim": "A strategic review finds no unresolved substrate dependency that would force the first gameplay Mission to rebuild environment identity, semantic routing, local execution, browser control, testing discipline, GitHub/Jira integration, architecture boundaries, observability or source-owner discovery.",
      "minimum_evidence": [
        "closure review",
        "open blocker inventory empty or explicitly non-blocking",
        "successor readiness proof"
      ]
    },
    {
      "id": "CP-11",
      "name": "autonomous real-browser verification",
      "claim": "The assistant can autonomously start the RRH dev server, launch/connect a dedicated non-personal Chrome through the official Chrome DevTools MCP path, navigate and interact with the actual app, inspect console/network/runtime state, collect screenshots and performance/runtime evidence, and terminate/recover the stand without routine operator mouse/keyboard work.",
      "minimum_evidence": [
        "Chrome DevTools MCP installation/config evidence",
        "dedicated browser/profile evidence",
        "dev-server lifecycle evidence",
        "navigation/interaction acceptance",
        "console/network capture",
        "screenshot/runtime evidence",
        "clean stop/recovery"
      ]
    },
    {
      "id": "CP-12",
      "name": "single verification discipline",
      "claim": "Deterministic core/contract verification uses Vitest; real browser/runtime acceptance uses Chrome DevTools MCP; manual DevTools snippets are RECON only; accepted runs emit one resort-verification-result/v1 evidence envelope; no overlapping browser automation stack is added unless a concrete capability gap is proven and governed as a deliberate architecture change.",
      "minimum_evidence": [
        "testing contract",
        "Vitest acceptance",
        "browser acceptance",
        "canonical evidence envelope",
        "manual-probe classification",
        "anti-duplication review"
      ]
    }
  ],
  "closure_rule": {
    "logic": "ALL",
    "required_predicate_ids": [
      "CP-01",
      "CP-02",
      "CP-03",
      "CP-04",
      "CP-05",
      "CP-06",
      "CP-07",
      "CP-08",
      "CP-09",
      "CP-10",
      "CP-11",
      "CP-12"
    ],
    "mission_seal_transport_schema": "resort-vibe-mission-closure-evidence/v1",
    "requirements": [
      "invariantPreserved == true",
      "forbiddenStatesAbsent == true",
      "each CP-01..CP-12 has verdict PROVEN",
      "each CP-01..CP-12 has one or more factual evidenceRefs"
    ],
    "procedure_is_not_proof": "Checklist completion, Stage number, Jira status, or Git/GitHub commit alone cannot close the Mission."
  },
  "successor_contract": {
    "authorized_only_after_closure": true,
    "mission_kind": "first-prototype-gameplay-vertical-proof",
    "objective": "Build the smallest user-visible Prototype proof: one player-started normal wave with progressive aggregate demand, finite service and queues, a visible bottleneck, free/immediate Worker reassignment that changes current service, arrival end followed by queue drain, wave completion, rating/result explanation and causal improvement feedback.",
    "authority": "current FINAL Resort Empire requirements"
  },
  "initial_distance": {
    "id": "distance:resort-bootstrap-semantic-routing-v1",
    "activity": "RECON",
    "objective": "Establish the durable repository semantic-understanding layer in the exact repository root resolved from .vibe/environment.json: ABOUT/ROUTES plus the minimum typed corpus needed to route ordinary bounded work to existing authoritative source owners, explicitly including browser/testing/debug and GitHub/Jira contracts, without gameplay implementation.",
    "closure_contract": "ABOUT and ROUTES exist in the currently bound repository with explicit authority hierarchy and source-owner routing; minimum typed semantic corpus includes testing, debug, browser control, local execution and GitHub/Jira contracts; a cold-start routing canary can identify an authoritative owner without whole-repo archaeology; stale-semantic repair and environment-rebind repair are defined; no gameplay code is introduced."
  },
  "installation": {
    "mode": "EXPLICIT_REHYDRATION_OR_AMENDMENT_AFTER_ENVIRONMENT_REBIND",
    "automatic_install": false,
    "automatic_migration": false,
    "session_id": "resort-empire-web-bootstrap-v2",
    "no_session_policy": "Explicit activate() may recreate the same Mission session identity on the new control browser after exact environment preflight.",
    "older_session_policy": "Exact v2/v2.1 session requires explicit amendToV22(); any unrelated Mission fails closed."
  },
  "environment_binding": {
    "authority_file": ".vibe/environment.json",
    "role": "single physical execution authority for environment_id/host/repo/platform/shell/ChatGPT Project; Mission and semantic artifacts reference this authority instead of duplicating mutable physical coordinates",
    "rebind_policy": "Physical host/repo may change only through an explicit fail-closed rebind with factual evidence. Such a rebind does not change product truth or bootstrap Mission semantics.",
    "current_rebind_evidence": {
      "schema": "resort-environment-rebind-result/v1",
      "old_environment_id": "resort-web-mvv-blue",
      "new_environment_id": "resort-web-desktop-qbqu3hp",
      "old_host": "MVV-BLUE",
      "new_host": "DESKTOP-QBQU3HP",
      "old_repo_root": "C:\\Vadim\\RRH",
      "new_repo_root": "D:\\TempleNet\\WorkSpace\\RRH",
      "source_environment_sha256": "40e77cd37b07591a1f8f2c4ffb20d02ee07aa22c70ab65eb39bdaf8562ed0917",
      "new_environment_sha256": "74b5cb350c740b9938bfdff274c6b48e03c07eacbb33a40352a5e58862d17ed8",
      "git_version": "git version 2.45.1.windows.1",
      "git_root": "D:/TempleNet/WorkSpace/RRH"
    }
  }
}
```
