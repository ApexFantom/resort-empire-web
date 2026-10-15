# Architecture Boundaries

Required application ownership:

- pure TypeScript game core owns gameplay state and transitions
- React is UI projection
- PixiJS is world/render projection
- persistence is an explicit boundary
- simulation cadence is decoupled from render cadence
- deterministic core behavior is headlessly testable

Mutation discipline:

- mutate an existing source owner by default
- new wrapper/adapter/store/override layers require factual necessity
- every necessary new layer requires an ownership contract and removal/cutover contract
- global rerender, global rebuild, whole-scene recreation, and broad recomputation are forbidden defaults
- prefer local/lazy processing

## Exact bootstrap source owners

The minimal non-gameplay shell now has factual implementation owners.

- canonical bootstrap state + command reducer:
  - src/core/state.ts
- canonical in-memory core runtime / subscriptions / dispatch:
  - src/core/runtime.ts
- headless deterministic core contract test:
  - src/core/runtime.test.ts
- simulation cadence owner:
  - src/runtime/SimulationClock.ts
- persistence contract:
  - src/persistence/PersistencePort.ts
- IndexedDB/Dexie persistence adapter:
  - src/persistence/DexieBootstrapPersistence.ts
- Pixi world/render projection:
  - src/render/PixiProjection.ts
- React UI projection:
  - src/app/App.tsx
- composition root:
  - src/main.tsx
- current read-only developer inspection facade:
  - src/dev/installDevFacade.ts
- shared lazy developer-observability transport + bounded ring buffer:
  - src/debug/DebugTransport.ts
- deterministic observability transport contract test:
  - src/debug/DebugTransport.test.ts

Ownership constraints:

- src/core owns writable bootstrap state transitions.
- React reads/subscribes to core state; it does not own canonical state.
- Pixi reads snapshots on its render ticker; it does not own or mutate canonical state.
- Simulation cadence is driven independently by SimulationClock and is not coupled to the Pixi render ticker.
- Persistence is reached through the explicit BootstrapPersistence port; Dexie is an adapter behind that contract.
- globalThis.__RRH_DEV__ exposes read-only health(), snapshot(), and bounded events() inspection only.
- DebugTransport is observational only; BootstrapCore remains the sole writable bootstrap-state authority.
- Disabled debug categories do not invoke their payload factories; production currently enables no debug categories.
- Debug sink failures cannot block or replace canonical core transitions.
- This is a bootstrap architecture proof, not gameplay implementation.
- These paths are implementation truth only while factual source inspection continues to confirm them; if ownership moves, update this route rather than creating a compatibility shadow layer.

## Render evolution contract

Current Prototype projection:
- PixiJS owns the replaceable 2.5D / isometric world projection.
- 2.5D rendering may derive screen position, layering, depth illusion, animation and visual effects from canonical logical world state.
- Pixi-specific objects and screen-space representation must not become canonical gameplay state.

Long-term visual target:
- true 3D Resort Empire.
- the eventual 3D renderer replaces or supersedes the Pixi projection boundary rather than the pure TypeScript gameplay authority.
- game/economy/simulation/domain state must remain usable independently of either rendering implementation.
- no permanent 3D engine choice is authorized yet.
