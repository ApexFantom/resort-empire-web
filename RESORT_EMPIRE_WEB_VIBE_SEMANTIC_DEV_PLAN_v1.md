# Resort Empire Web · VIBE-GO + Semantic Development Plan v1

**Status:** INITIAL DEVELOPMENT PLAN / EXPERIMENTAL OPERATING CONTRACT  
**Project:** Resort Empire: Paradise Tycoon — Web / Android-capable branch  
**Primary product authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(2).md`  
**Execution environment:** designated **Windows laptop**, PowerShell  
**Operational integrations:** **Jira + Git**  
**Development mode:** ChatGPT-driven development through VIBE-GO with direct PowerShell access to the designated laptop  
**Parallel comparison:** teammate develops an independent Unity implementation from the same product requirements  

---

# 1. Experiment intent

This branch has two simultaneous goals:

1. build a working Resort Empire implementation from the current RRH requirements;
2. test whether a VIBE-GO-driven development process can preserve long-running engineering continuity through a durable semantic layer instead of repeatedly rediscovering the repository from source.

Comparison shape:

```text
same product authority
        │
        ├── Unity implementation
        │
        └── Web implementation
             + VIBE-GO
             + durable semantic layer
             + direct Jira / Git / PowerShell loop
```

The goal is not identical architecture. The common comparison point is the same product authority and observable behavior.

---

# 2. Product authority

The web branch starts from:

`RESORT_EMPIRE_REQUIREMENTS_FINAL(2).md`

That document is treated as current product authority because it contains:

- reconstruction of source/evidence authority from RRH materials;
- reconciled FR/NFR baseline;
- Prototype/MVP phase boundaries;
- conflicts and supersession rules;
- OPEN/TUNING items;
- explicit exclusions;
- acceptance evidence and unresolved client questions.

The implementation must not silently promote:

- `OPEN`;
- `TUNING`;
- `e.g.`;
- illustrative values;
- obsolete UI behavior;
- unsupported assumptions

into hard product truth.

Authority model:

```text
RRH product evidence / FINAL requirements
        ↓ intended product truth

semantic layer
        ↓ preserved understanding and routing

source
        ↓ factual implementation truth

tests / runtime / build
        ↓ factual behavioral evidence

Jira
        ↓ current Work / backlog / status

Git
        ↓ durable implementation lineage
```

The semantic layer never outranks current factual source/runtime evidence.

---

# 3. Hard environment boundary

This project executes on the **designated Windows laptop**.

It is explicitly **not**:

- the Minsk computer;
- the Linux VM used for CC / Cymatics;
- `CC_Recovery`;
- the CC Builder repository;
- any previous Workbench execution environment.

No mutation is allowed until the execution environment has been identified.

## Mandatory preflight

Before the first mutation of a new execution envelope, verify at minimum:

```powershell
hostname
$PSVersionTable
git rev-parse --show-toplevel
git remote -v
git status
Get-Content .vibe/environment.json
```

Repository-local environment identity:

```text
.vibe/environment.json
```

should identify at least:

```text
project_id
environment_id
platform
shell
repo_root
```

Expected conceptual identity:

```text
project_id      = resort-empire-web
platform        = windows
shell           = powershell
execution_host  = designated current laptop
```

If environment identity does not match:

```text
ENVIRONMENT_IDENTITY_MISMATCH
→ no mutation
→ diagnose only
```

Never fall through to another known machine/repository because it happens to be reachable.

---

# 4. Preferred implementation stack

Initial preferred stack:

```text
TypeScript
├── React
├── PixiJS
├── pure TypeScript game core
├── Vite
├── Vitest
├── IndexedDB / Dexie
└── Capacitor-ready packaging boundary
```

The project should first work as a browser build and remain structurally suitable for Android packaging through Capacitor.

No backend is required for the Prototype unless requirements or demonstrated implementation needs make one necessary.

Avoid speculative infrastructure.

---

# 5. Architectural ownership

Gameplay authority must remain separate from presentation.

```text
PLAYER INTENT
     ↓
DOMAIN COMMAND
     ↓
AUTHORITATIVE GAME CORE
     ↓
AFFECTED STATE / DOMAIN EVENTS
     ↓
AFFECTED PROJECTIONS ONLY
     ├── React UI
     └── Pixi world
```

## Game core owns

- wave lifecycle;
- demand;
- queues;
- service;
- bottleneck semantics;
- Worker allocation;
- Satisfaction;
- rating;
- Energy gameplay rules;
- rewards/economy;
- progression/unlocks;
- persistence-relevant game state.

The game core must not depend on React, PixiJS, DOM presentation logic, or developer UI.

## React owns

- HUD;
- panels;
- modal/bottom-sheet interactions;
- Wave Complete;
- Upgrade Suggestion;
- Area Unlock;
- later MVP management surfaces.

## PixiJS owns

- persistent island/world projection;
- buildings;
- Worker/guest visualization;
- queue visualization;
- visual effects/animation.

React and Pixi are projections, not gameplay authority.

---

# 6. Mutation-first engineering rule

This project explicitly rejects the historical pattern:

```text
old behavior
↓
new layer
↓
override old behavior
↓
another override
↓
compatibility fix
↓
new override
```

Normal development strategy:

```text
understand semantic owner
↓
locate authoritative source
↓
mutate the existing owner
↓
remove / migrate superseded behavior when safe
↓
test factual result
↓
update semantic meaning if it changed
```

## Forbidden default strategy

Do not solve ordinary changes by adding:

- `rerenderAll()`;
- `refreshEverything()`;
- `rebuildScene()`;
- global recalculation;
- global DOM recreation;
- whole-Pixi-scene recreation;
- new CSS/logic override layers over known obsolete behavior;
- second implementations that shadow the current implementation;
- compatibility wrappers whose only purpose is to avoid editing the true owner.

Compatibility/migration layers are allowed only when there is a factual compatibility requirement and the layer has an explicit ownership/removal contract.

## Core principle

> Prefer correction of the authoritative implementation over accumulation of replacement layers.

When semantic navigation identifies the current owner, future work should go there and change it rather than rediscovering the repository and appending another generation.

---

# 7. Local reactive updates only

A local change should update only affected domain state and projections.

Target flow:

```text
mutation
  ↓
affected authoritative state
  ↓
affected derived values
  ↓
affected subscribers / render objects
```

Not:

```text
something changed
  ↓
recalculate all state
  ↓
rerender all React
  ↓
rebuild all Pixi
```

For React:

- use bounded component ownership;
- use narrow/selective subscriptions;
- avoid making every component observe one giant mutable game object;
- memoize derived values where useful;
- React reconciliation itself is expected; manually mutating the DOM to avoid React is not the goal.

For Pixi:

- retain persistent display objects;
- mutate only affected `Sprite` / `Container` / `Text` state;
- do not destroy/rebuild the scene for localized game changes.

For the game core:

- explicit commands own mutations;
- derived recomputation should follow affected dependencies where practical;
- avoid recomputing unrelated systems on every simulation tick.

---

# 8. Lazy processing

Prefer lazy/on-demand work.

Examples:

- load assets when current content needs them;
- compute expensive diagnostics only when enabled;
- instantiate content only when active/relevant;
- subscribe UI only to state it consumes;
- do not execute inactive MVP systems during Prototype gameplay;
- do not perform full-state serialization every frame;
- do not scan full scene graphs unless explicitly requested by tooling.

Lazy processing must not weaken gameplay correctness.

---

# 9. Command-oriented state changes

UI and developer tools must not arbitrarily write authoritative state.

Prefer explicit domain operations such as:

```text
startWave()
moveWorker()
useEnergy()
advanceSimulation()
buyUpgrade()
buyArea()
pauseWave()
resumeWave()
```

Conceptual path:

```text
intent
↓
command boundary
↓
game core
↓
accepted state mutation
↓
derived/events
↓
projection
```

---

# 10. Semantic layer: primary purpose

The semantic layer is not conventional documentation.

Its primary operational purpose is:

> allow a future execution of the same development agent to continue from accumulated understanding without re-archaeologizing the whole repository, and route directly to the authoritative source that must be mutated.

It must answer:

```text
what is this subsystem?
why does it exist?
what owns its truth?
where is the authoritative implementation?
what depends on it?
what invariants must survive?
where are the tests/runtime evidence?
what is unresolved?
where should a mutation be made?
```

Successful future workflow:

```text
ABOUT
↓
semantic route
↓
relevant typed artifact
↓
exact source owner
↓
bounded mutation
↓
tests/runtime evidence
```

Not:

```text
new session
↓
read whole repository
↓
reconstruct architecture
↓
guess current owner
↓
add another implementation layer
```

---

# 11. Semantic layer: anti-monolith structure

Do not create one enormous `PROJECT_CONTEXT.md`.

Preferred initial shape:

```text
semantic/
│
├── ABOUT.md
├── ROUTES.md
│
├── current/
│   ├── PROJECT_STATE.md
│   ├── ACTIVE_WORK.md
│   └── RISKS.md
│
├── architecture/
│   ├── GAME_CORE.md
│   ├── STATE_AUTHORITY.md
│   ├── REACT_PROJECTION.md
│   ├── PIXI_PROJECTION.md
│   ├── PERSISTENCE.md
│   └── DEBUG_TRANSPORT.md
│
├── domain/
│   ├── WAVE.md
│   ├── WORKERS.md
│   ├── NEEDS_AND_QUEUES.md
│   ├── SATISFACTION.md
│   ├── ENERGY.md
│   ├── PROGRESSION.md
│   └── VIP.md
│
├── decisions/
│   ├── ADR-001-*.md
│   └── ...
│
├── contracts/
│   ├── MUTATION_MODEL.md
│   ├── LAZY_PROCESSING.md
│   ├── DEBUG_OBSERVABILITY.md
│   └── ASSET_PLACEHOLDERS.md
│
├── evidence/
│   └── INDEX.md
│
└── lessons/
    └── ...
```

This is a starting hypothesis, not immutable ontology.

Required properties:

- decomposable;
- routable;
- incrementally loadable;
- semantically typed;
- suitable for cold start.

---

# 12. ABOUT contract

`semantic/ABOUT.md` is the small entrance.

It should remain concise enough to load routinely.

It contains:

- product identity;
- current scope;
- current phase;
- primary product authority;
- high-level architecture;
- major invariants;
- semantic routes;
- current important unresolved pressures.

It must not contain:

- complete history;
- all source details;
- all evidence;
- every Jira issue;
- every decision;
- full code descriptions.

ABOUT provides orientation, not proof.

---

# 13. ROUTES contract

`semantic/ROUTES.md` is agent-facing semantic navigation.

Examples:

```text
Need to change wave lifecycle?
→ semantic/domain/WAVE.md
→ src/game-core/wave/
→ tests/simulation/wave/

Need to change Worker movement?
→ semantic/domain/WORKERS.md
→ semantic/contracts/MUTATION_MODEL.md
→ authoritative Worker source
→ Worker tests
→ relevant React/Pixi projections

Need to verify save/resume?
→ semantic/architecture/PERSISTENCE.md
→ persistence source
→ persistence tests
→ runtime evidence
```

ROUTES should point to semantic owners and factual authority. It should not duplicate source code.

---

# 14. Semantic truth vs implementation truth

Use the rule:

> Understand top-down, verify bottom-up.

```text
semantic layer
→ explains meaning and routing

source
→ current implementation truth

tests/runtime
→ current behavioral evidence
```

If semantic artifacts and source/runtime disagree:

1. do not trust semantic text as proof;
2. inspect source/runtime;
3. determine whether source is wrong or semantic knowledge is stale;
4. repair the correct authority;
5. update semantic artifacts only after the accepted result is known.

The semantic layer must never become a second codebase expressed in prose.

---

# 15. Semantic maintenance as Definition of Done

Every accepted implementation mutation asks:

```text
Did semantic truth change?
```

If no:

```text
source/test change only
```

If yes:

```text
source
+ tests/evidence
+ minimal semantic delta
```

Examples requiring semantic updates:

- authority moved between modules;
- domain state machine changed;
- command boundary changed;
- persistence contract changed;
- Worker mutation semantics changed;
- Energy model changed;
- debug ownership changed;
- new dependency/invariant appeared;
- an OPEN design decision became accepted.

Examples usually not requiring semantic updates:

- typography;
- spacing;
- localized CSS fix;
- refactor with no authority/contract change;
- mechanical test cleanup.

Semantic maintenance must remain bounded. Do not rewrite all semantic files after every task.

---

# 16. Source comments as semantic navigation

Source comments are part of navigation only when they communicate durable engineering meaning.

Good comments identify:

- ownership;
- invariants;
- contract boundaries;
- mutation boundaries;
- non-obvious causal relationships;
- routes to deeper semantic artifacts when needed.

Bad comments merely restate syntax.

Preferred pattern:

```text
small local semantic marker
→ route to semantic artifact
→ route to authority/tests
```

Do not turn source files into prose documents.

---

# 17. VIBE-GO role

VIBE-GO tracks the active engineering trajectory:

```text
Mission
→ Distance
→ Deepening / investigation
→ mutation
→ evidence
→ validation
→ Return / closure
```

The semantic layer serves a different but complementary role:

```text
VIBE
→ where the work currently is and why

semantic layer
→ what the system already means and where authoritative owners live

source
→ what is actually implemented

tests/runtime
→ whether it actually behaves correctly

Jira
→ what product/work obligation remains open

Git
→ implementation lineage
```

Do not overload VIBE state with the complete product topology.

Do not overload semantic artifacts with every transient VIBE step.

---

# 18. Jira integration

Jira is the operational backlog/work surface.

It should carry, as appropriate:

- Epic;
- Story / Task / Bug;
- requirement traceability;
- acceptance criteria;
- Release;
- current status;
- implementation/result links;
- unresolved blocker/question links.

Preferred loop:

```text
read current Jira Work
↓
select / confirm bounded Work
↓
execute through VIBE
↓
validate
↓
update Jira status/evidence
```

Jira is not product authority above RRH requirements.

Jira is not implementation truth above repository/runtime evidence.

---

# 19. Git integration

Git is durable implementation lineage.

Preferred discipline:

- inspect status before mutation;
- do not overwrite unrelated dirty work;
- bounded commits where practical;
- commit message reflects actual semantic/functional change;
- tests/evidence correspond to the committed result;
- semantic-layer changes that belong to the same accepted architectural mutation travel with that mutation where appropriate.

VIBE must distinguish:

```text
working tree
≠ accepted implementation
≠ committed implementation
≠ runtime-proven behavior
```

No claim of completion solely because code was generated.

---

# 20. Unified debug / observability transport

The game should have one shared debug transport.

Default state:

```text
subsystems
   ↓
lightweight/inert debug boundary
   ↓
no enabled expensive producers/sinks
```

When a debug category is enabled:

```text
selected subsystem producer
        ↓
shared debug transport
        ↓
enabled sinks
```

Possible categories:

```text
wave
demand
queue
service
workers
satisfaction
economy
progression
persistence
render
performance
```

Possible semantic events:

```text
wave.phase.changed
queue.bottleneck.entered
worker.assignment.changed
service.capacity.changed
save.state.restored
```

Possible sinks:

```text
developer console
developer inspector
bounded trace buffer
test recorder
performance/debug export
```

Subsystems do not own sinks. They emit through the common transport.

---

# 21. Debug laziness

When a debug category is disabled:

- do not build expensive payloads;
- do not serialize whole state;
- do not scan full scene trees;
- do not retain unbounded histories;
- do not perform per-frame tracing for inactive categories.

Debugging follows the same bounded/lazy model as gameplay architecture.

The debug plane is observation, not gameplay authority.

---

# 22. Developer surfaces are not player surfaces

Developer-only functionality must be encapsulated.

Examples:

```text
debug inspector
simulation controls
state editor
save inspector
profiling
test hooks
mock providers
developer endpoints
remote debug bridge
```

Prefer explicit boundaries such as:

```text
devtools/
debug/
internal/
```

Production/player UI must not accidentally expose developer controls.

Do not implement player-hidden developer features merely through CSS visibility.

Where practical, gate developer surfaces through build/environment configuration.

The game must function correctly with developer tooling disabled.

---

# 23. Developer mutations still go through authority boundaries

A devtool that changes game state must not bypass the game core.

Bad:

```text
React debug button
→ state.coins += 100
```

Preferred:

```text
debug tool
→ explicit dev command
→ game-core command boundary
→ authoritative mutation
→ projection
```

Developer tooling may have additional privileges, but they must remain explicit and attributable.

---

# 24. Asset strategy: semantic placeholders first

The web branch should not depend on final raster art during core implementation.

Use placeholders that preserve layout and semantic identity.

Example:

```text
┌────────────────────┐
│       POOL         │
│       ≋≋≋          │
│   [asset:pool]     │
└────────────────────┘
```

or bounded ASCII/emoji silhouettes.

A placeholder should preserve, where relevant:

```text
asset_id
bounding box
aspect ratio
anchor
interaction footprint
layer/depth
animation slots
semantic role
```

Example conceptual record:

```text
asset_id: building.pool
width: 320
height: 220
anchor: bottom-center
placeholder: "POOL\n≈≈≈"
```

Final visual asset replacement should not change gameplay semantics.

Principle:

```text
semantic entity
≠ visual asset
```

The user will later process/replace placeholders with final visual assets.

---

# 25. Content and tuning separation

Where practical, keep tunable content outside core mechanics:

```text
content/
├── buildings
├── waves
├── unlocks
└── balancing
```

This is not permission to freeze uncertain values.

OPEN/TUNING values remain explicitly non-authoritative until decided.

---

# 26. Simulation and rendering cadence

Gameplay simulation should not be coupled to render FPS.

Preferred direction:

```text
bounded simulation tick
        ↓
authoritative state
        ↓
render projection at browser animation cadence
```

This supports:

- deterministic/controlled tests;
- pause/resume;
- headless simulation;
- stable behavior across device performance;
- clear debug traces.

Exact tick rate remains an implementation choice until factual evidence justifies it.

---

# 27. Headless testing

The pure game core must be testable without React/Pixi.

Important validation areas:

- wave lifecycle;
- progressive arrivals;
- queue drain;
- Worker movement effect;
- bottleneck transitions;
- Satisfaction/rating invariants;
- Energy invariants;
- unlock progression;
- save/resume;
- no offline progression where forbidden.

Tests must prove actual claims, not merely increase coverage.

---

# 28. First bootstrap Mission

Initial VIBE Mission:

> Establish the Resort Empire Web development environment on the designated Windows laptop, bind exact execution identity, ingest current product authority, establish the repository semantic-understanding layer, connect Jira and Git operational surfaces, and produce the smallest running vertical proof without inventing unsupported product behavior.

## Bootstrap closure evidence

Before sustained gameplay construction proceeds, establish factual evidence for:

```text
[ ] designated Windows laptop identity proven
[ ] exact repository established
[ ] PowerShell read/write/mutation path works
[ ] Git repository/status/commit path works
[ ] Jira work surface is addressable
[ ] FINAL requirements available as product authority
[ ] ABOUT exists
[ ] ROUTES exists
[ ] initial typed semantic corpus exists
[ ] mutation contract exists
[ ] lazy-processing contract exists
[ ] debug transport contract/skeleton exists
[ ] asset-placeholder contract exists
[ ] React + Pixi + pure TS core bootstrap runs
[ ] headless tests run
[ ] browser build runs
```

Only after this boundary is established should the project enter sustained gameplay implementation.

---

# 29. First gameplay vertical proof

The first implementation proof should be thin and user-visible.

Target shape:

```text
start one normal wave
↓
progressive aggregate demand
↓
service / waiting queues
↓
visible bottleneck
↓
Worker reassignment
↓
immediate service effect
↓
drain
↓
wave completion
↓
rating/result
```

It should validate architecture and semantic routing before breadth is added.

Do not begin by implementing the entire MVP.

---

# 30. Anti-layering review rule

Before adding a new abstraction, adapter, wrapper, override, store, compatibility layer, or rendering layer, ask:

```text
1. What existing semantic owner should this behavior belong to?
2. Is the current owner incorrect, or merely inconvenient to edit?
3. Can the authoritative implementation be mutated directly?
4. Would the new layer duplicate or shadow existing behavior?
5. What factual compatibility requirement requires the extra layer?
6. How will the layer be removed or remain owned long-term?
```

If questions 1–3 identify a valid existing owner and no factual compatibility need exists:

> mutate the owner instead of adding the layer.

This is a primary project invariant.

---

# 31. Cold-start success criterion

A future fresh execution should be able to:

1. load `semantic/ABOUT.md`;
2. identify current project state and authority;
3. route through `semantic/ROUTES.md`;
4. open only relevant semantic artifacts;
5. locate the authoritative source owner;
6. inspect source/tests/runtime as needed;
7. perform a bounded mutation;
8. validate it;
9. update semantic artifacts only if meaning changed;
10. continue without repository-wide archaeology.

If a competent fresh execution repeatedly needs to reread the full repository to understand ordinary work, the semantic layer is failing its purpose.

---

# 32. Experiment success criteria

The experiment is successful if, over sustained development:

- VIBE continuity survives chat/session boundaries;
- semantic navigation materially reduces repeated source archaeology;
- new work modifies existing authoritative code instead of accreting override generations;
- product requirements remain traceable to implementation;
- Jira reflects current work rather than becoming a stale parallel plan;
- Git preserves truthful implementation lineage;
- semantic artifacts stay smaller than the code and route to it rather than duplicate it;
- implementation/runtime evidence can correct stale semantic understanding;
- debug tooling remains unified, lazy, and player-invisible;
- raster art can be replaced later without changing gameplay architecture;
- a fresh execution can resume meaningful work from semantic routes with bounded source inspection.

---

# 33. Explicit non-goals

This plan does **not** require:

- cloning CC/Cymatics ontology into the game;
- building a general-purpose semantic database;
- building a backend before gameplay needs it;
- implementing the full MVP before Prototype evidence;
- final raster art during engineering bootstrap;
- global rerender/recalculation infrastructure;
- preplanning all future sprints;
- preserving obsolete implementation merely to avoid source mutation;
- treating generated code as accepted work without tests/runtime evidence.

---

# 34. Compact operating formula

```text
PRODUCT AUTHORITY
        ↓
JIRA WORK
        ↓
VIBE TRAJECTORY
        ↓
SEMANTIC ROUTING
        ↓
AUTHORITATIVE SOURCE OWNER
        ↓
BOUNDED MUTATION
        ↓
TEST / RUNTIME EVIDENCE
        ↓
GIT
        ↓
JIRA RESULT
        ↓
SEMANTIC DELTA only if meaning changed
```

Architectural anti-regression formula:

```text
UNDERSTAND
→ ROUTE
→ MUTATE OWNER
→ VERIFY
→ CONTINUE
```

not:

```text
RE-READ EVERYTHING
→ ADD NEW LAYER
→ OVERRIDE OLD LAYER
→ FORGET WHY
→ REPEAT
```

---

# 35. Current decision summary

Accepted for this branch:

- web-first implementation;
- Windows laptop execution via PowerShell;
- Jira + Git operational integration;
- VIBE-GO-driven development;
- durable semantic layer maintained during development;
- semantic layer optimized for agent cold-start and direct mutation routing;
- mutation-first / anti-override-layer discipline;
- local reactive updates only;
- lazy processing;
- pure TypeScript game authority separated from React/Pixi projections;
- unified lazy debug transport;
- developer surfaces encapsulated from players;
- placeholder assets instead of raster-authoring dependency;
- final asset replacement performed later by the user;
- Prototype-first thin vertical evidence before MVP breadth.

This document is the initial development-plan authority for the web branch until explicitly superseded.
