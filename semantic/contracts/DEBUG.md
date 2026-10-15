# Debug Contract

There must be one encapsulated developer-observability plane, never a second gameplay authority.

Target shape:

game/core
→ typed lazy DebugTransport
→ enabled sinks such as ring buffer, console adapter, MCP collector and performance sink

Rules:
- disabled categories should avoid expensive payload construction
- avoid raw console.log outside the debug adapter
- debug observations are evidence, not gameplay authority
- globalThis.__RRH_DEV__ is read-only by default
- expected read examples: health(), snapshot(), entities(), bounds(), eventCount(), events(), performance()
- any developer mutation must delegate to canonical game-core commands
- debug/test/browser tooling must not create parallel writable gameplay state

Current source owners:
- typed lazy transport + bounded ring-buffer sink: src/debug/DebugTransport.ts
- canonical transition observation hook: src/core/runtime.ts
- read-only browser/developer projection: src/dev/installDevFacade.ts
- composition and category enablement: src/main.tsx
- transport behavior canaries: src/debug/DebugTransport.test.ts
- canonical core integration test: src/core/runtime.test.ts

Materialized constraints:
- BootstrapCore remains the only writable bootstrap-state authority.
- DebugTransport observes already-authorized transitions; it does not mutate core state.
- disabled categories return before invoking their payload factory.
- sink failures are isolated from canonical runtime execution.
- ring-buffer history is bounded by composition-owned capacity.
- DebugRingBufferSink.size() reports the current bounded history length without creating parallel state.
- the development build currently enables only core.transition.
- the production build supplies no enabled debug categories.
- globalThis.__RRH_DEV__ exposes health(), snapshot(), eventCount(), and events() as read-only inspection surfaces.
- eventCount() delegates directly to the existing bounded ring-buffer owner and does not gain gameplay mutation authority.

