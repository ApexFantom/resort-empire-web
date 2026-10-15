# End-to-End Non-Gameplay Canary v1 — CP-09

Status: ENGINEERING + BROWSER PROOF ACCEPTED; GIT/GITHUB/JIRA LINEAGE PENDING

Claim under validation:
A bounded non-gameplay change can travel through the established Resort operating path from semantic routing to an existing factual owner, governed mutation, deterministic and real-browser verification, durable evidence, Git/GitHub lineage, Jira factual Work evidence, and explicit semantic-delta handling without relying on prior chat history.

## Route and ownership

Bounded responsibility:
extend the existing read-only developer observability surface with an exact bounded event count.

Durable route:
semantic/ROUTES.md
→ semantic/contracts/DEBUG.md
→ src/debug/DebugTransport.ts + src/dev/installDevFacade.ts

Existing test owner:
src/debug/DebugTransport.test.ts

No gameplay source, shadow owner, wrapper layer, second debug plane, or writable developer authority was introduced.

## Governed mutation

Accepted source results:
- src/debug/DebugTransport.ts → DebugRingBufferSink.size(); SHA-256 246e0b56383513480b14094c949e7d8a743086331d466e38b4017055f110f547
- src/debug/DebugTransport.test.ts → bounded size assertions; SHA-256 5504834632782758d86cd4c1501a04ac5292bb02134c1fdc6a8690cb11689bb6
- src/dev/installDevFacade.ts → read-only eventCount(); SHA-256 67f3d62349f1fa83aca72f61361988bc4733d82884458b2ed10a638591524341

## Deterministic verification

Vitest request:
rrh:cp09:test-observability-event-count:v1

Result:
- 2 test files passed
- 5 tests passed

Production build request:
rrh:cp09:build-observability-event-count:v1

Result:
- TypeScript check passed
- Vite production build passed
- exit code 0

## Canonical real-browser verification

Adapter:
chrome-devtools-mcp@1.10.1

Exact structured target:
- URL: http://127.0.0.1:4173/
- pageId: 2

Observation request:
rrh:cp09:browser-observe-event-count:v1

Accepted observation:
- marker: RRH_CP09_BROWSER_OK
- facade keys: eventCount, events, health, snapshot
- facade frozen: true
- global facade writable: false
- eventCount type: function
- eventCount: 64
- events().length: 64
- exact count match: true
- bounded by composition capacity 64: true
- health schema: rrh-dev-health/v1
- health ok: true
- simulation running: true
- simulation period: 200 ms
- latest event category: core.transition
- latest command: ADVANCE_SIMULATION
- console errors: 0
- network requests: 35
- network failures: 0

## Runtime lifecycle

Chrome DevTools MCP stopped with exit code 0.
Governed Vite job job-2044a31f7a42182b58e37ea2 reached STOPPED with termination_confirmed=true.
The Vite stop path produced expected forced-termination EPIPE/file-watcher diagnostics after acceptance; these occurred during controlled shutdown and did not invalidate the already-completed browser observations.

## Semantic delta decision

YES.

Reason:
the durable read-only developer facade contract changes from health()/snapshot()/events() to health()/snapshot()/eventCount()/events(). The new method delegates directly to the existing bounded ring buffer and adds no gameplay or writable-debug authority.

Contract owner updated:
semantic/contracts/DEBUG.md

## Remaining CP-09 lineage debt

Before this evidence can become final ACCEPTED CP-09 proof:
1. commit this bounded implementation + semantic evidence on main;
2. push and independently verify origin/main at the exact commit;
3. record factual commit/evidence lineage in the existing Jira Resort project without inventing product truth;
4. finalize the machine-readable evidence with exact Git/GitHub/Jira references;
5. prove durable reload/recovery from repository artifacts without this chat.

Canonical machine-readable record:
semantic/evidence/end-to-end-nongameplay-canary-v1.json
