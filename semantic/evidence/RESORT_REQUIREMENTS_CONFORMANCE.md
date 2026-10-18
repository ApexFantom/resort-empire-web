# Resort Empire Requirements Conformance

Authority: `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`
Runtime cursor authority remains VIBE-GO; this ledger is the durable human/audit-facing evidence index.

> Repository note: FINAL(3) is not yet physically materialized in the RRH root. The active semantic session remains bound to FINAL(3); do not substitute FINAL(2). Materializing the bound FINAL(3) remains requirements-Distance debt.

## FR-001 — IMPLEMENTED_PROVEN

**Verdict:** PASS  
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** player-started normal-wave lifecycle proceeds from preparation/awaiting through arrival/active processing, then drain/resolution, and reaches completed result.

### Evidence

- `src/core/state.ts:471-475` — canonical `START_WAVE` is legal only from `awaiting` and transitions authoritative core state to `incoming`.
- `src/core/state.ts:403-435` — `advanceWave()` releases demand only while `incoming`; when all arrivals are released it transitions to `draining` while queue/active service remains; while draining `releasedNow` is zero; completion requires both queue and active service to be empty; `resultFor(next)` is attached only when phase becomes `complete`.
- `src/core/state.ts:575-580` — `ADVANCE_SIMULATION` delegates to `advanceWave()` and applies completion reward exactly on the transition to `complete`.
- `src/app/App.tsx:127-143` — UI projects awaiting/incoming/draining/complete states; rendered `Start wave` dispatches canonical `START_WAVE`; completed result/rating is rendered from canonical `wave.result`.
- `semantic/evidence/prototype-normal-wave-browser-acceptance-v1.json` — accepted real-browser evidence: `rendered_start_control_reaches_core=true`, `arrivals_end_then_drain_observed=true`, `wave_completion_visible=true`; accepted completion observed with phase `complete`, released demand 6, queues zero and rating/result visible.
- `src/core/fr001Lifecycle.test.ts` — dedicated deterministic regression asserts `awaiting → incoming → draining → complete`, no result during drain, no additional demand release after drain begins, outstanding work exists during drain, and result plus zero queue/active state at completion.
- Fresh targeted validation on 2026-10-18: `vitest run --run src/core/fr001Lifecycle.test.ts` — 1 file / 1 test passed.
- Fresh production validation on 2026-10-18: `npm run build` — TypeScript check and Vite production build PASS.

### Conclusion

FR-001 is implemented and proven across canonical source semantics, deterministic regression and real-browser acceptance. No repair remains for this obligation.

## FR-002 — IMPLEMENTED_PROVEN

**Verdict:** PASS  
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** Normal-wave demand shall be released progressively during the arrival phase rather than appearing all at once.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-002 authority recovered from the bound Project file.
- `src/core/state.ts:403-435` — canonical `advanceWave()` releases demand only while `incoming`; `releasedNow = Math.min(wave.tuning.releasePerTick, totalDemandTarget - wave.releasedDemand)` bounds each arrival tick to the configured increment and remaining target; `releasedDemand` and `releasedByNeed` increase incrementally; phase remains `incoming` until the release target is reached.
- `src/core/state.ts:121-126` — deterministic proof tuning uses `totalDemand: 6` and `releasePerTick: 2`, yielding a multi-tick arrival sequence rather than all-at-once demand injection.
- `src/core/fr002ProgressiveArrival.test.ts` — dedicated deterministic regression proves zero release immediately after `START_WAVE`, then observable `releasedDemand` progression `0 → 2 → 4 → 6`; the first two simulation steps remain `incoming`, per-need release also grows progressively, and the arrival phase ends only after the target is reached.
- Fresh targeted validation on 2026-10-18: `vitest run src/core/fr002ProgressiveArrival.test.ts` — 1 file / 1 test passed.
- Fresh full validation on 2026-10-18: `npm test` — full suite PASS after adding the FR-002 regression.
- Fresh production validation on 2026-10-18: `npm run build` — TypeScript check and Vite production build PASS.

### Conclusion

FR-002 is implemented and proven by canonical source semantics plus a dedicated deterministic regression. No gameplay repair remains for this obligation.

## FR-003 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** When the arrival period ends, only new arrivals shall stop; the wave shall continue until outstanding queues are cleared, with Worker reassignment and applicable Energy actions still available during drain.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-003 authority recovered from the bound Project file.
- `src/core/state.ts:403-435` — canonical `advanceWave()` sets `releasedNow` to zero outside `incoming`, retains unresolved queue/active service during `draining`, and reaches `complete` only when both queues and active service are empty.
- `src/core/state.ts:517-562` — canonical `REASSIGN_WORKER` explicitly permits `awaiting`, `incoming` and `draining`; a legal reassignment during drain mutates canonical worker allocation and records reassignment impact.
- `src/core/state.ts:564-569` — canonical `ACTIVATE_ENERGY_MODE` explicitly permits `incoming` and `draining`; when the target need is active, Energy is available and no boost is already active, activation spends one Energy and installs the canonical Energy mode.
- `src/core/fr003DrainActions.test.ts` — dedicated deterministic regression first completes Wave 1 to earn Energy legally, starts Wave 2, reaches a real drain state with outstanding work, proves Worker reassignment during drain, restores the Worker, activates Energy during drain, proves released demand remains frozen, and continues to completion with queues and active service cleared.
- Fresh targeted validation on 2026-10-18: `vitest run src/core/fr003DrainActions.test.ts` — PASS.
- Fresh enclosing validation on 2026-10-18: full test suite and production build both completed successfully in the same host-validation batch after the corrected FR-003 regression.

### Conclusion

FR-003 is implemented and proven. Arrival shutdown stops only new demand release; outstanding service drains to completion while applicable Worker reassignment and Energy actions remain available. No gameplay repair remains for this obligation.

## FR-004 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** Normal guests shall be represented and managed as aggregate demand rather than individually controlled service entities.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-004 authority recovered from the bound Project file.
- `src/core/state.ts:164-188` — canonical `NormalWaveState` represents normal guest demand only as aggregate per-need counters: demand target, released, queued, active-service, served, wait history and pressure; it owns no per-guest identity, position, path or service-entity state.
- `src/core/state.ts:204-212` — canonical `BootstrapCommand` exposes simulation, wave, area, building, Worker, Energy and comeback controls only; there is no command for selecting, moving, assigning or otherwise controlling an individual normal guest.
- `src/core/state.ts:249-277` — normal-wave construction initializes aggregate `NeedCounts` for demand/release/queue/active/served state from the wave demand profile.
- Targeted source scan of `src/core` found zero matches for guest identity, individual-guest control, guest position/path or pathfinding authority (`MATCH_COUNT 0`).
- `src/render/ResortGuestFlowActivity.tsx:86-101` — Three/R3F guest figures are a derived presentation only: their counts are capped projections of canonical `queueByNeed`, `activeByNeed` and `servedByNeed`. They do not own or mutate gameplay state.
- Targeted source scan of `src/render` + `src/app` likewise found zero guest-level command/id/path authority (`MATCH_COUNT 0`).

### Conclusion

FR-004 is implemented and proven. Normal guests are governed exclusively through aggregate demand/service counts in the canonical core; animated guest figures are replaceable read-only projections of that aggregate state, not individually controllable gameplay entities. No repair remains for this obligation.

## FR-005 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** For each active normal need, the system shall track served, active-service and waiting demand against finite simultaneous service capacity, placing excess demand into a queue.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-005 authority recovered from the bound Project file.
- `src/core/state.ts:164-181` — canonical `NormalWaveState` owns distinct aggregate `queueByNeed`, `activeByNeed`, `servedByNeed`, demand and wait/pressure counters for every normal need.
- `src/core/state.ts:280-284` — `capacity(wave, need)` computes finite simultaneous capacity from base service capacity, building-level capacity bonus and currently assigned Workers.
- `src/core/state.ts:413-428` — each simulation step first transfers prior active service into `servedByNeed`, combines prior queue plus newly released demand as waiting demand, admits at most `simultaneousCapacity`, writes admitted demand to `activeByNeed`, and writes the remainder to `queueByNeed`.
- `src/core/state.ts:317-319` — `normalWaveServiceCapacity()` exposes the same canonical finite capacity calculation for deterministic verification.
- `src/core/runtime.test.ts:160-199` — deterministic regression starts a normal wave, proves `food` has excess queued demand while `activeByNeed.food` is simultaneously nonzero and exactly equals its finite service capacity, then advances simulation and proves `servedByNeed.food` increases.
- Fresh targeted validation on 2026-10-18: `vitest run src/core/runtime.test.ts` — 7/7 tests PASS.
- Fresh enclosing validation on 2026-10-18: full suite — 16 files / 48 tests PASS; production `tsc --noEmit && vite build` PASS.

### Conclusion

FR-005 is implemented and proven. For an active normal need, waiting, active-service and served demand are distinct canonical quantities; finite simultaneous service capacity bounds admission and excess demand remains queued until later service cycles. No gameplay repair remains for this obligation.

## FR-006 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** The system shall derive and expose normal-need operational states such as BOTTLENECK, RECOVERING and SATISFIED from queue/service conditions.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-006 authority recovered from the bound Project file.
- Pre-repair inspection proved the requirement was genuinely PARTIAL: `src/core` had no canonical normal-need operational-state type/selector, while `src/app/App.tsx` locally inferred presentation text from raw queue counters.
- `src/core/state.ts` now exports canonical `NormalNeedOperationalState = 'BOTTLENECK' | 'RECOVERING' | 'SATISFIED'`.
- `src/core/state.ts::normalNeedOperationalState()` derives operational state only from canonical active-need, queue and active-service conditions: queued demand => BOTTLENECK; no queue with active service => RECOVERING; otherwise => SATISFIED.
- `src/app/App.tsx` now consumes `normalNeedOperationalState(snapshot, need)` for the per-need service status projection instead of recomputing a separate UI-owned need state from raw counters.
- `src/core/fr006OperationalState.test.ts` deterministically proves a real normal-wave trajectory through SATISFIED before load, BOTTLENECK while queue and active service coexist, RECOVERING once the queue clears but active service remains, and SATISFIED once both queue and active service clear.
- Fresh validation batch on 2026-10-18 completed successfully: targeted FR-006 regression PASS, full test suite PASS, production TypeScript/Vite build PASS, and `git diff --check` PASS.

### Conclusion

FR-006 was repaired and is now implemented and proven. Operational state is a pure canonical-core derivation of queue/service conditions and the React UI exposes that derived authority rather than maintaining a shadow presentation model. No repair remains for this obligation.

## FR-007 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** The player shall be able to distinguish a staffing shortage from insufficient building capacity when either causes a growing queue.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-007 authority recovered from the bound Project file.
- Pre-repair inspection established a real PARTIAL gap: canonical simulation accumulated separate `staffingWaitByNeed` and `capacityWaitByNeed`, but `bottleneckCause` and causal guidance were derived only in `resultFor()` after wave completion.
- `src/core/state.ts::advanceWave()` already classifies queued waiting pressure by staffing topology: queued demand with zero assigned Workers increments staffing pressure; queued demand with staffing present increments capacity pressure.
- `src/core/state.ts::normalNeedBottleneckCause()` now exposes the live canonical diagnosis while a need has queued demand, returning `staffing` when the need has no assigned Worker, `capacity` when it is staffed but saturated, and `null` when no queue remains.
- `src/app/App.tsx` consumes that selector in the active per-need building status, exposing `BOTTLENECK · STAFFING` versus `BOTTLENECK · CAPACITY` to the player during the queue rather than waiting for end-of-wave results.
- `src/core/fr007BottleneckDiagnosis.test.ts` deterministically proves both active-wave causes using the same finite-capacity model and proves the diagnosis clears once the queue resolves.
- Existing completed-wave regression in `src/core/runtime.test.ts` continues to prove historical result diagnosis and worker-vs-upgrade guidance for staffing and capacity causes respectively.
- Fresh validation batch on 2026-10-18 completed successfully: targeted FR-007 regression PASS, full test suite PASS, production TypeScript/Vite build PASS, and `git diff --check` PASS.

### Conclusion

FR-007 was repaired and is now implemented and proven. Staffing shortage and insufficient building capacity are distinct canonical live diagnoses while a queue is present, and the active player-facing service projection exposes that distinction without a shadow UI-owned cause model.

## FR-008 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** Normal-wave Satisfaction shall be derived from accumulated waiting time of need units, and a unit shall stop accumulating waiting once service begins.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-008 authority. FINAL(3) also explicitly keeps the final Satisfaction curve and exact star thresholds OPEN/TUNING, so this repair does not invent a percentage scale, curve or thresholds.
- Pre-repair source-wide inspection found no canonical Satisfaction symbol/model, establishing a real PARTIAL gap, while the existing queue/service accounting already retained the required waiting history.
- `src/core/state.ts::advanceWave()` admits waiting demand into active service first, computes `remaining = waiting - admitted`, and increments `accumulatedWaitByNeed[need]` only by that remaining queued demand. Units admitted to active service therefore cease adding waiting immediately.
- `src/core/state.ts` now defines canonical `NormalWaveSatisfaction` and records it in `NormalWaveResult`. Its explicit basis is `accumulated_wait`, with total accumulated waiting and immutable per-need waiting history.
- `src/core/state.ts::satisfactionFor()` derives completed-wave Satisfaction exclusively from `accumulatedWaitByNeed`; no new gameplay tuning or shadow UI calculation was introduced.
- `src/core/fr008Satisfaction.test.ts` deterministically proves: Food has one queued and one active unit; accumulated wait rises to 1; on the following tick the queued unit is admitted while accumulated wait remains 1; after service completes it still remains 1; completed Satisfaction preserves exactly that accumulated-wait history.
- Fresh validation batch on 2026-10-18 completed successfully: targeted FR-008 regression PASS, full test suite PASS, production TypeScript/Vite build PASS, and `git diff --check` PASS.
- No live numeric Satisfaction UI was added. This preserves adjacent FINAL(3) FR-009, which forbids a live numeric Wave Satisfaction value during an active normal wave; post-wave Satisfaction presentation remains the responsibility of FR-011.

### Conclusion

FR-008 was repaired and is now implemented and proven. Satisfaction has an explicit canonical accumulated-wait basis, and queue-to-service accounting proves that waiting ceases as soon as a demand unit enters active service. The final Satisfaction curve/star thresholds remain intentionally unresolved OPEN/TUNING authority rather than being invented here.
