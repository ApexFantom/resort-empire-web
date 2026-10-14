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
- expected read examples: health(), snapshot(), entities(), bounds(), events(), performance()
- any developer mutation must delegate to canonical game-core commands
- debug/test/browser tooling must not create parallel writable gameplay state

Current source owner:
NOT YET MATERIALIZED. Bind this contract to exact source paths when observability is implemented.
