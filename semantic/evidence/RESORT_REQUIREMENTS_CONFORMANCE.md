# Resort Empire Requirements Conformance

Authority: `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`
Runtime cursor authority remains VIBE-GO; this ledger is the durable human/audit-facing evidence index.

> Repository authority: `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` is now physically present in the RRH root, verified at 51968 bytes and SHA-256 50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de. Its bytes match the original Project authority reconstruction. `FINAL(2)` has been preserved unchanged.

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

## FR-009 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** During an active normal wave, the system shall not expose per-guest patience countdowns or a live numeric Wave Satisfaction value, and normal guests shall not leave mechanically because of waiting time.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-009 authority.
- Source-wide scan across `src/**/*.ts`, `src/**/*.tsx` and `src/**/*.css` found no patience/countdown/abandon/departure/leave mechanics. The only Satisfaction symbols are the completed-wave model and its FR-008 regression.
- Normal guests are already represented as aggregate demand rather than individual service entities, so there is no per-guest patience state to expose.
- `src/app/App.tsx` active-wave branches (`incoming` / `draining`) expose aggregate waiting/being-served flow and service actions only. Completed `wave.result` data is gated behind the completed branch, so no live numeric Wave Satisfaction is projected during active play.
- `src/core/fr009NonPunitiveActiveWave.test.ts` proves released demand is conserved on every active tick as `served + active + queued = released` per active need while queues exist, proving waiting demand does not disappear through abandonment.
- The same regression proves `normalWave.result` remains `null` throughout active play and only completed-wave state exposes the accumulated-wait Satisfaction result.
- The regression also proves all released normal demand is ultimately served by completion despite sustained queue pressure.
- Fresh validation batch on 2026-10-18 completed successfully: targeted FR-009 regression PASS, full suite PASS (20 files / 52 tests), production TypeScript/Vite build PASS, and `git diff --check` PASS.

### Conclusion

FR-009 is implemented and proven without gameplay repair. Active normal waves have no per-guest patience countdown, expose no live numeric Wave Satisfaction, and retain waiting normal demand in the queue/service system until it is served rather than mechanically removing guests because they waited.

## FR-010 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** The normal-wave rating model shall always produce a non-zero completed result while preserving a meaningful distinction between poor and well-managed play.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md` — exact canonical FR-010 text read from Project authority; rating thresholds remain TUNING.
- `src/core/state.ts:415-463` — canonical `resultFor()` derives average waiting pressure from completed-wave demand, caps `lostStars` at four and calculates `rating: 5 - lostStars`, yielding a non-zero completed rating.
- `src/core/fr010Rating.test.ts` — deterministic comparison of poor Worker allocation against a deliberate reassignment to Food; asserts completed ratings exist, poor rating >= 1, managed rating > poor rating and managed queue pressure < poor queue pressure.
- Fresh native Windows Host execution r95/a1100, request `rrh:resort-empire-web-bootstrap-v2:a1100:1:6cd57c6c`: `npm test -- src/core/fr010Rating.test.ts`, exit code 0, one test file and one test passed.
- Fresh source inspection r95/a1101, request `rrh:resort-empire-web-bootstrap-v2:a1101:0:b915c037`: `resultFor()` formula and completed rating path inspected in bound repository.

- Fresh full repository regression on 2026-10-19: native Host r95/a1102 `npm test` returned exit code 0, 23 test files PASS and 58 tests PASS; request `rrh:resort-empire-web-bootstrap-v2:a1102:1:139e55c5`.
- Fresh production validation on 2026-10-19: native Host r95/a1103 `npm run build` (`tsc --noEmit && vite build`) returned exit code 0; request `rrh:resort-empire-web-bootstrap-v2:a1103:1:b2932682`. Vite reported only a nonfatal bundle-size warning.
- Canonical requirements file materialized on 2026-10-19 through native Host r95/a1103, request `rrh:resort-empire-web-bootstrap-v2:a1103:0:93b6b8d7`: `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, 51968 bytes, SHA-256 50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de, content-verified against original Project authority.

### Conclusion

FR-010 gameplay behavior is supported by the canonical implementation and successful deterministic regression. Exact rating thresholds remain tuning. This evidence does not by itself certify browser-wide behavior or resolve the separate obligation to materialize the original FINAL(3) authority in the repository.

## FR-011 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** Wave Complete presents the achieved rating and Satisfaction outcome, explains what went well and what needs improvement.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:274` — exact canonical FR-011 authority read and verified.
- `src/app/WaveCompletionSummary.tsx` and `src/app/App.tsx` — completed normal-wave review is rendered from canonical core result, not a separate writable gameplay state. Service requests use per-need release totals rather than guest arrivals.
- `src/app/fr011WaveCompletion.test.ts` — targeted deterministic render regression passed in r96/a1112; full Vitest passed 24 files / 59 tests in r96/a1112; TypeScript/Vite production build passed in r96/a1113.
- Live Chrome r96/a1121 (`rrh:resort-empire-web-bootstrap-v2:a1121:0:94afe5ce`) — naturally completed desktop wave displayed rating 5/5, Satisfaction 0 accumulated-wait unit-seconds, all 22 service requests completed, and Reception capacity improvement guidance.
- Live Chrome r96/a1122 (`rrh:resort-empire-web-bootstrap-v2:a1122:1:bca13cd3`) — desktop review was visible, nonclipped and without horizontal document overflow.
- Live Chrome r96/a1126 (`rrh:resort-empire-web-bootstrap-v2:a1126:0:aae028c0`) — independently completed mobile 320x568 wave showed all four mandatory review fields, review bounds x=33..287/y=301.55..461 inside viewport, no internal clipping or horizontal document overflow.
- `semantic/evidence/fr011-wave-completion-browser-acceptance-v1.json` — structured, factual desktop/mobile browser acceptance record.

### Conclusion

FR-011 is implemented and proven through deterministic regression, production build and normal-wave completion in actual desktop and 320px mobile Chrome. The 390px completed-wave view and separate final-wave-specific presentation were not claimed as proven by this evidence.

## FR-012 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** Any depiction of dissatisfied normal guests after a wave must derive from the aggregate wave result and must not impose another mechanical penalty on future play. This is conditional: no separate unhappy-guest depiction is mandated.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:275` — exact governing requirement, verified against the physical authority SHA-256.
- `src/render/ResortGuestFlowActivity.tsx:478-599` — canonical queue, active and served service counters drive guest-flow visuals; served guest figures are projected during incoming/draining only. No independent post-wave dissatisfied-guest depiction or mutable penalty path is present in the inspected renderer.
- `src/core/state.ts:415-469` — rating and accumulated-wait Satisfaction are calculated from aggregate wave results; Coin reward depends on completed demand volume and the achieved rating.
- `src/core/state.ts:289-321,598-605,701-706` — the completion reward applies only on phase transition; the next wave retains legitimate staffing and upgrades but resets queues, accumulated wait, queue pressure and result without an additional dissatisfaction penalty.
- `src/core/fr012Dissatisfaction.test.ts` — low-rating regression demonstrates canonical reward only, economic neutrality of idle completed-wave ticks, cleared next-wave pressure/result and identical next-wave state when completed-wave Satisfaction/explanation/guidance are changed for presentation. Focused result: 2/2 passed at r97/a1134.
- Full Vitest: 25 files / 61 tests passed at `rrh:resort-empire-web-bootstrap-v2:a1135:0:92ac58ff`.
- TypeScript and Vite production build: exit code 0 at `rrh:resort-empire-web-bootstrap-v2:a1135:1:b2932682`.

### Conclusion

The current implementation has no independent post-wave dissatisfied-guest depiction. Under the requirement as written, this conditional presentation constraint is satisfied, and the prohibited extra mechanical penalty is independently regression-tested as absent. This does not claim implementation of an optional unhappy-guest animation.

## FR-013 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** Primary Coin income originates in completed guest-service gameplay rather than passive building ticks. An independently gated comeback grant is a secondary return bonus, not facility production.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:276` — exact physical canonical requirement, SHA-256 verified.
- `src/core/state.ts:541-556` — wave completion requires arrivals to finish and all service queues and active slots to empty; service completion is tracked by servedByNeed.
- `src/core/state.ts:465-469,701-706` — payout equals canonical completed-wave demand/rating reward and is credited only on the transition into complete, never on ordinary elapsed-time ticks.
- `src/core/fr013ActiveIncome.test.ts` — dedicated regression verifies 120 idle ticks before a wave and between waves yield no Coins; active-wave ticks yield no Coins; both completed waves pay once after every released request is served; post-completion ticks cannot pay again. Focused test PASS at r98/a1140.
- `src/core/prototypeEvents.test.ts:31-53` — independent existing assertions for zero income during active service, structural wave-completion payout, no duplicate post-completion payout, and separate fixed comeback reward.
- `src/runtime/SimulationClock.ts:11-21` — only dispatches elapsed-time simulation, with no building-income pathway.
- `src/main.tsx:88-94,132-143` and `src/runtime/PrototypeInactivity.ts:11-29` — comeback grant requires prior recorded inactivity meeting proof-tuned eligibility; checking removes the stored eligibility token, preventing repeated claims from the same recorded absence. It is not a passive building tick.
- Full Vitest PASS: 26 files, 62 tests at `rrh:resort-empire-web-bootstrap-v2:a1141:0:92ac58ff`.
- TypeScript/Vite production build PASS at `rrh:resort-empire-web-bootstrap-v2:a1141:1:b2932682`.

### Conclusion

Primary normal-wave Coin earnings are tied to fully completed guest-service demand; the elapsed-time clock and buildings do not generate passive Coin income. The separately gated comeback grant does not contradict the primary-income requirement. This disposition does not claim that secondary grants can never recur after new qualifying inactivity.

## FR-014 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Bound obligation:** Normal-wave Coin reward scales structurally with completed base demand volume and achieved rating. Worse or slower play cannot inflate the base payable demand volume.

### Evidence

- `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:277` — exact FR-014 authority, checked against the physically present canonical file and its SHA-256.
- `src/core/state.ts:104-109,465-469` — canonical reward is rounded regular releasedDemand multiplied by per-unit Coin value and the achieved rating modifier; proof-tuned rating modifiers increase monotonically from rating 1 to 5.
- `src/core/state.ts:498-522` — regular releasedDemand is capped by tuning.totalDemand regardless of time or queue pressure. Sudden Rush extra demand is released through per-need accounting and is not allowed to inflate this base reward quantity.
- `src/core/state.ts:541-556,701-706` — wave completion requires arrivals to finish and active service/queues to drain, with reward credited once on completion transition.
- `src/core/fr014WaveReward.test.ts` — two targeted deterministic tests at r99/a1145 PASS: poor/slower management under identical configured base demand cannot earn more payable volume or Coins than better management; at rating 5, doubling completed base demand from 12 to 24 doubles payout.
- Full Vitest: 27 files / 64 tests PASS at `rrh:resort-empire-web-bootstrap-v2:a1146:0:92ac58ff`.
- TypeScript and Vite production build PASS at `rrh:resort-empire-web-bootstrap-v2:a1146:1:b2932682`.

### Conclusion

FR-014 is implemented and deterministically proven for normal-wave base Coin rewards. The payable base volume is a capped regular-demand quantity, not elapsed-time production or an accumulator inflated by slow service. The verdict does not assert that optional Sudden Rush extra demand itself earns a separate reward.

## FR-015 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Binding authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:278` — after each wave, recommend an optional investment linked to the observed bottleneck, allowing deferral.

### Implementation and evidence

- `src/core/state.ts:415-449` calculates the observed dominant bottleneck and distinguishes staffing pressure from service-capacity pressure.
- `src/core/state.ts:383-407,622-637` provides a completed-wave upgrade quote and a separate optional purchase command, with affordability and level guards.
- `src/core/state.ts:598-605` allows CONTINUE_TO_NEXT_WAVE independently of purchasing upgrades. Worker reassignment can occur in the following awaiting phase (`src/core/state.ts:639-646`).
- `src/app/InvestmentRecommendation.tsx` is a React projection of the canonical bottleneck and upgrade quote. Capacity bottlenecks generate a matching optional investment proposal with cost and capacity effects; staffing bottlenecks lead with Worker reassignment and clearly distinguish any longer-term capacity investment from a remedy for missing workers. Both permit deferral.
- `src/app/App.tsx` selects the observed bottleneck after the wave, mounts the cause-aware recommendation, labels upgrade offers optional, and retains an unconditional nonfinal-wave Next wave action.
- `src/app/fr015InvestmentRecommendation.test.ts` — two deterministic regressions PASS at `rrh:resort-empire-web-bootstrap-v2:a1154:0:97fe8530`: capacity-linked recommendation with no purchase required to continue, and staffing-specific recommendation with successful Worker reassignment after deferring.
- Full Vitest 28 files / 66 tests PASS at `rrh:resort-empire-web-bootstrap-v2:a1154:1:78d62b6a`.
- TypeScript and production Vite build PASS at `rrh:resort-empire-web-bootstrap-v2:a1154:2:b2932682`.
- Source SHA-256 and UI integration anchors independently checked at `rrh:resort-empire-web-bootstrap-v2:a1154:3:f3f2f8`.

### Conclusion

FR-015 satisfies its Prototype/Cross obligation with a causally specific optional post-wave investment, honest differentiation of staffing and capacity limitations, and a proven path to defer purchase without losing progression. This verdict covers deterministic state and rendered-component regression plus successful production build; it does not claim a new interactive-browser session for this specific patch.

## FR-016 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:279`, Prototype / Starting resort.

### Evidence

- `src/core/state.ts:2-18` specifies the three baseline needs and their exact building/need pairings: Reception/Rooms, Restaurant/Food and Beach Bar/Drinks. Pool/Relax and Bungalows/Ocean View are distinct optional services.
- `src/core/state.ts:289-305,559-575` creates Wave 1 in the awaiting phase with baseline active needs only, and initializes purchasedAreas with pool=false and bungalows=false.
- `src/app/App.tsx:117-124` renders service-building labels from NORMAL_SERVICE_CATALOG, conditionally including Pool and Bungalows only after purchase.
- `src/render/ResortWorld3D.tsx:831-833` derives active scene services by filtering the service order against state.normalWave.activeNeedIds; no separate mutable gameplay configuration is introduced.
- `src/core/fr016StartingResort.test.ts` provides two deterministic regressions covering fresh state, exact building-to-need mapping, locked optional areas, Wave 1 forecast, and started Wave 1 without prematurely activated Relax or Ocean View. Targeted 2/2 PASS at `rrh:resort-empire-web-bootstrap-v2:a1158:2:5f0b401d`.
- Full Vitest 29 files / 68 tests PASS at `rrh:resort-empire-web-bootstrap-v2:a1158:2:5f0b401d`.
- `npm run build` (`tsc --noEmit && vite build`) PASS at `rrh:resort-empire-web-bootstrap-v2:a1159:0:b2932682`. Earlier failed command incorrectly referenced project-local npm-cli.js, which is not installed there; the corrected advertised npm invocation succeeded.
- Independent authority, source, test and prewrite-ledger hashes confirmed at `rrh:resort-empire-web-bootstrap-v2:a1159:1:9a434d01`.

### Conclusion

FR-016 is implemented and proven at the canonical initialization, forecast and service-projection boundaries. This verdict does not assert a new interactive browser acceptance for this specific requirement.

## FR-017 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:280`, Prototype / Prototype area progression.

### Evidence

- `src/core/state.ts:33-42` binds Pool/Relax/worker-2 to eligibility after completed Wave 3 and Bungalows/Ocean View/worker-3 to eligibility after completed Wave 6.
- `src/core/state.ts:348-362` computes purchased area active needs and checks eligibility from actually completed waves; unaffordable eligible areas cannot be purchased.
- `src/core/state.ts:598-619` enforces purchase timing, deducts Coins, adds exactly the area-associated Worker assignment and purchased status, and activates the newly purchased service in the next awaiting wave or the current awaiting wave.
- `src/app/App.tsx:146-149` exposes only available area purchase offers through core-derived prototypeAreaUnlockView.
- `src/core/areaUnlocks.test.ts` (SHA-256 2221daa1b61b6e1b80be2d96c99ed3a2a1e4a8aceafab98f6afc56327ef87e81) exercises pre-threshold locking, post-Wave-3 Pool eligibility and optional deferral, insufficient Coins, Pool purchase and Relax worker/throughput, post-Wave-6 Bungalows purchase and Ocean View worker/next-wave activation, and persistence. Seven focused tests PASS at `rrh:resort-empire-web-bootstrap-v2:a1162:1:789a73f7`.
- Full repository Vitest 29 files / 68 tests PASS at `rrh:resort-empire-web-bootstrap-v2:a1162:1:789a73f7`.
- TypeScript/Vite production build PASS at `rrh:resort-empire-web-bootstrap-v2:a1162:2:b2932682`.
- Exact authority and relevant core code observed through `rrh:resort-empire-web-bootstrap-v2:a1161:0:1e1070c5`; complete focused test source examined at `rrh:resort-empire-web-bootstrap-v2:a1162:0:18207bc6`.

### Conclusion

FR-017 is implemented and proven through the canonical core, deterministic multi-wave progression/purchase tests, UI purchase-source inspection and successful production build. No new interactive-browser acceptance is claimed for this specific requirement.

## FR-018 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:281`, Prototype / Cross, Deferred unlock behavior.

### Implementation and evidence

- `src/core/state.ts:348-351` builds active service needs exclusively from the three baseline services and actually purchased areas, irrespective of eligibility or later-wave scripted demand profiles.
- `src/core/state.ts:289-318,598-619` creates subsequent-wave demand only for active needs and introduces optional needs through the canonical PURCHASE_AREA transition, preserving the separation between milestone eligibility and purchase.
- `src/core/areaUnlocks.test.ts:39-56` already proves that Pool can remain eligible and unpurchased through Wave 4 without spawning Relax demand, including insufficient-Coins behavior.
- `src/core/fr018DeferredUnlock.test.ts` adds two deterministic full-campaign regressions: eight completed waves with neither area purchased and zero Relax/Ocean View demand, released demand, service, active load and queue; and delayed Pool and Bungalows purchases that activate their corresponding needs and demonstrate Ocean View service on Wave 8.
- Dedicated FR-018 regressions 2/2 PASS and full Vitest 30 files/70 tests PASS at `rrh:resort-empire-web-bootstrap-v2:a1166:0:524a2292`.
- TypeScript (`tsc --noEmit`) and Vite production build PASS at `rrh:resort-empire-web-bootstrap-v2:a1166:1:b2932682`.
- Authority, source, test and original ledger SHA-256 independently recorded at `rrh:resort-empire-web-bootstrap-v2:a1166:2:1985d482`.

### Conclusion

FR-018 is IMPLEMENTED_PROVEN at the canonical simulation boundary. Milestone eligibility alone does not spawn an unpurchased area need, including beyond Wave 6; a later actual purchase activates the corresponding service. This verdict is based on executed deterministic behavior and successful production build; it does not claim a new interactive-browser acceptance for this requirement.

## FR-019 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:282`, Prototype / Prototype Worker model.

### Implementation and evidence

- `src/core/state.ts:29-35` defines opaque Worker IDs and a single canonical assignment record; no separate Worker skills, identities or personnel economy are introduced.
- `src/core/state.ts:270-293` validates one slot per service building, rejects unknown or unassigned Worker records, prevents double occupancy and enforces exactly one fewer assigned Worker than eligible normal-wave buildings, including legitimate purchase-after-completion transitions.
- `src/core/state.ts`, `normalizePrototypeWorkerRoster`, repairs absent or malformed roster entries using existing Worker IDs, purchased-area eligibility and available service slots, while returning the same state for already valid assignments.
- `src/core/state.ts:608-619` creates an additional assigned Worker for each purchased area; no unassigned bench or Worker recruitment action is introduced.
- `src/persistence/DexieBootstrapPersistence.ts:320-321` invokes the canonical roster normalizer when restoring a saved game; its implementation was not duplicated or modified.
- `src/core/workerContract.test.ts` proves the initial three-building/two-Worker contract, active-wave reassignment and legacy one-Worker migration.
- `src/core/fr019WorkerInvariant.test.ts` (SHA-256 b7b982d4887a713061d9163e25ffcf979185802ed6382346c802931216159795) adds five regressions: exact N-1 roster across three/four/five buildings and completed-wave purchases; rejection of under-staffing; rejection of undefined bench entries; restoration of missing purchased-area Workers without resetting progression; and removal of phantom roster entries while preserving valid state identity.
- Five focused FR-019 tests PASS, and full Vitest 31 files / 75 tests PASS at `rrh:resort-empire-web-bootstrap-v2:a1174:1:2f576257`.
- TypeScript typecheck and Vite production build PASS at `rrh:resort-empire-web-bootstrap-v2:a1174:2:b2932682`.
- Corrected core source mutation confirmed at `rrh:resort-empire-web-bootstrap-v2:a1174:0:d57faa19`, SHA-256 `a90ba0175bf2b31923c9b5c2bab9508ee5c78ead17f183dc0ba3036872c53f5f`.

### Conclusion

FR-019 is IMPLEMENTED_PROVEN by the canonical TypeScript state model, persistence-normalization path and executed deterministic regressions. The correction preserves the normal three/four/five-building progression, delayed service activation after completed-wave area purchases and existing assignment semantics. No new interactive-browser acceptance is claimed for this requirement.

## FR-020 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:283`, Prototype / Cross, Worker reassignment.

### Implementation and evidence

- `src/core/state.ts:669-718` accepts REASSIGN_WORKER in awaiting, incoming, and draining phases, validates active and unoccupied target buildings, updates workerAssignments synchronously and records the exact before/after impact. It neither advances simulation time nor modifies Coins, Energy or Resort Value.
- `src/app/App.tsx:72-75,183,191-210` exposes Worker Allocation in each supported wave phase; eligible vacant destinations dispatch REASSIGN_WORKER directly on click with no confirmation workflow.
- `src/core/fr020WorkerReassignment.test.ts` (SHA-256 ef5130497871020cdbc343fccb5c9be21dfdf636035675cdaf6e566ee6b7c8c1) verifies before-wave, incoming and draining reassignment, synchronous assignment change, no tick/time/resource cost, preserved queues and served counts, N-1 roster preservation, idempotent same-destination command, and invalid/occupied destination rejection.
- `src/core/workerContract.test.ts` independently covers live reassignment and its service-speed impact.
- Focused FR-020, complete Vitest, TypeScript typecheck and Vite production build all passed in the conditional host verification immediately preceding this ledger write.
- Core SHA-256 `a90ba0175bf2b31923c9b5c2bab9508ee5c78ead17f183dc0ba3036872c53f5f`; App SHA-256 `37f6e3df37e3dd76ddf90fecfef651b0b7ce971759c2690951872fb7d9e60c5c`; canonical FINAL(3) authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.

### Conclusion

FR-020 is IMPLEMENTED_PROVEN at the deterministic core and direct UI event-wiring boundaries. Source confirms confirmation-free dispatch; this evidence does not assert a newly performed interactive browser-click acceptance.

## FR-021 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:284` — Worker performance effect.

### Implementation and executed evidence

- `src/core/state.ts:334-336` derives service speed from the current Worker assignment; staffed speed is 1 and default unstaffed speed is 0.33.
- `src/core/state.ts:527-530` applies the current speed to every already-active service-progress entry on each simulation slice. Reassignment at `src/core/state.ts:669-718` changes assignments immediately and retains in-progress work and simulation time.
- `src/core/fr021InProgressWorkerEffect.test.ts`, SHA-256 `950dd47cc3922a7ebc1923fe4db6dedfe205383096e422f85d02d9a8e003463c`, proves simultaneous partially serviced guests at source and destination, progress preservation at reassignment, slower source/faster destination progress versus an otherwise identical control on the next 250ms step, and exact restoration after reversing the transfer.
- Two FR-021 focused tests PASS; full Vitest 33 files / 81 tests PASS; TypeScript typecheck and Vite production build PASS. Execution: `rrh:resort-empire-web-bootstrap-v2:a1180:1:e5a684ba`.
- Core source SHA-256 `a90ba0175bf2b31923c9b5c2bab9508ee5c78ead17f183dc0ba3036872c53f5f`; canonical requirements authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.

### Conclusion

FR-021 is IMPLEMENTED_PROVEN by deterministic execution of in-progress service behavior. No production core modification was necessary. This does not assert additional browser visual acceptance.

## FR-022 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:285` — Worker persistence.

### Implementation and evidence

- `src/core/state.ts` preserves canonical workerAssignments when advancing to the next normal wave, including player-customized allocations. `PURCHASE_AREA` immediately introduces the bundled Worker on its purchased building without changing existing assignments; next-wave initialization retains that roster.
- `src/persistence/DexieBootstrapPersistence.ts:320-321` preserves valid canonical Worker assignments during persisted-state normalization.
- `src/core/fr022WorkerPersistence.test.ts` SHA-256 `2e76cff7ce1c3c2b11adb075e35354f956ea1591045bccbc9312ccbb8620165c` covers three cases: custom assignment preservation across consecutive waves; immediate Pool and Bungalows bundled Worker placement and following-wave continuity; restoration of customized allocations through persisted-state normalization and progression.
- Focused FR-022 regressions, full Vitest, TypeScript typecheck and Vite production build all passed in the same guarded host execution before the ledger write.
- Canonical core SHA-256 `a90ba0175bf2b31923c9b5c2bab9508ee5c78ead17f183dc0ba3036872c53f5f`; bound FINAL(3) authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.

### Conclusion

FR-022 is IMPLEMENTED_PROVEN by deterministic progression and persistence-normalization tests. No new browser acceptance is asserted.

## FR-023 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:286` — Managers; bound authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.

### Implementation and executed evidence

- `src/core/state.ts` implements named, building-linked Managers, an independent hired roster, one-time Coin hiring between waves, locked-building and duplicate-hire safeguards, insufficient-Coin rejection and a linked-building service-speed multiplier. SHA-256 `fc5f79380bb50abc8156e429aab75fb304d0cc953c4a0d267a221a99937ed633`.
- `src/app/App.tsx` projects named Manager hiring and hired status from canonical core state. SHA-256 `19aab89fdd3be09b1c558bc609fe1a79e94ac3b5968843bc9bcf94711bd55f43`.
- `src/persistence/DexieBootstrapPersistence.ts` normalizes missing Manager rosters in legacy persisted saves; hired Managers survive wave transitions and current-state restoration. SHA-256 `fdaab5d4fc3280a0ff0dc02837674e0dbb54791819cd0399b7ae80e3e524a4f2`.
- `src/core/fr023Managers.test.ts` tests paid once-only hiring, allowed and rejected phases, linked-building actual service progress, unaffected other buildings, normal-wave continuity, old/new save normalization, and operation without mandatory Managers. SHA-256 `a6afb746f8147d2fccea168316bfae08ecd318495018db57a1231c9ecee70996`.
- Execution evidence `rrh:resort-empire-web-bootstrap-v2:a1197:0:c8e5a3ea`: focused FR-023 Vitest 4/4 PASS; full Vitest 35 files / 88 tests PASS; TypeScript check PASS; Vite production build PASS. Source hash evidence `rrh:resort-empire-web-bootstrap-v2:a1197:1:5c438ab3`.
- Manager hire cost 15 Coins and performance multiplier 1.5 are explicitly provisional MVP proof tuning; final prices and progression remain OPEN/TUNING under Q-08, rather than requirements-level commitments.
- Browser visual acceptance was not executed or claimed.

### Conclusion

FR-023 is IMPLEMENTED_PROVEN by deterministic behavioral evidence, integration, persistence compatibility, and passing project regressions.

## FR-024 — IMPLEMENTED_PROVEN

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN

**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md:287` — named Specialists as independent reusable VIP prerequisites. Authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.

### Implementation and executed evidence

- `src/core/state.ts` defines three named Specialists, the dedicated hired roster, `HIRE_SPECIALIST` with once-only Coin hiring between waves, phase, identity and affordability guards, and `hasSpecialistForVip`. SHA-256 `bf169319d1f1eaa2589acb39d288a2b37c6b3de36a3a033497183040ed7297bf`.
- Specialists are not bound to normal buildings or Workers and do not modify normal-wave simulation, staffing, service speed or queues. Focused tests compare baseline and Specialist-hired progression.
- `src/app/App.tsx` implements a separate VIP Specialist roster/hiring panel with a valid JSX fragment enclosing it alongside the selected-building actions. SHA-256 `467b9a98b4e5a7db76d77d0f7ab07f363f711e1029f24956d3ac3015c20c04d4`.
- `src/persistence/DexieBootstrapPersistence.ts` normalizes current and legacy Specialist rosters and preserves them across persistence. SHA-256 `8a84dc4a617720f88bf860dd727fa99116007209812751bbd80feb625e26f583`.
- `src/core/fr024Specialists.test.ts` covers four scenarios: guarded hiring, zero normal-wave impact, reusable VIP prerequisites across waves and saved state, and legacy/malformed save normalization. SHA-256 `763757d5ceaa2f687126c4140b7fb21b2b621ef9aaaff6580c099ffc12595f43`.
- Focused Vitest, full Vitest regressions, TypeScript noEmit and Vite production build all passed in this guarded host process before ledger mutation.
- Specialist hiring cost 12 Coins is explicitly provisional MVP proof tuning; Q-08 final price/progression is OPEN/TUNING. Browser visual acceptance is not claimed.

### Conclusion

FR-024 is IMPLEMENTED_PROVEN for its binding independent Specialist roster/hiring contract. Integration into actual VIP request lifecycle remains governed by subsequent VIP requirements.

## FR-025 — Additional Worker hiring

- **Canonical authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, FR-025 (MVP). Hire additional Workers for Coins between waves and place each directly in an available Worker slot. Original old FR-057; S3-P0267–P0270. Authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Implementation and executed evidence

- `src/core/state.ts` implements `HIRE_WORKER`, phase/affordability/eligible-building/slot checks, one atomic Coins debit and direct newly created Worker assignment, generated unique hired IDs, reserve capacity maintaining fewer Workers than committed available slots, preservation across waves and area purchases, and legacy roster normalization. SHA-256 `871b3f7a639e0ce16c1cf6ad83c93a0ba806bd8a4b45527bc48041aa2e061895`.
- `src/app/App.tsx` exposes between-wave hiring for the selected building and uses canonical core selector `normalWaveCanHireWorker` for button availability. SHA-256 `c7bee8c493237e130257ac8193bc8be391b16ca460a191b7be50c186dc3437a6`.
- `src/persistence/DexieBootstrapPersistence.ts` retains Worker assignments through serialized state and executes `normalizePrototypeWorkerRoster` upon loading. SHA-256 `8a84dc4a617720f88bf860dd727fa99116007209812751bbd80feb625e26f583`.
- `src/core/fr025WorkerHiring.test.ts`: 5/5 focused tests for baseline scarcity, Coin-funded direct placement, cross-building reserve, phase/affordability/inactive/occupied rejection, stable wave-transition/normalization roster, and two distinct sequential Worker IDs. SHA-256 `73d68473eef62717c3f50a738b66859ab382096225a94b64a085cf2fcd5cba93`.
- Windows Host guarded execution `rrh:resort-empire-web-bootstrap-v2:a1219:2:e3ad66c`: focused Vitest 5/5 PASS; full Vitest 97/97 PASS (37 test files); TypeScript `tsc --noEmit` PASS; Vite production build PASS. Prior FR-019 and upgrade regression checks 8/8 PASS in `rrh:resort-empire-web-bootstrap-v2:a1215:1:e0cbb8d6`.
- MVP Worker hire cost of 12 Coins is explicitly provisional proof tuning. Final Q-08 balance remains OPEN/TUNING; browser visual acceptance is not claimed.

### Conclusion

FR-025 is IMPLEMENTED_PROVEN for its binding Worker hiring and direct-placement contract. Global workforce scarcity and multi-Worker diminishing returns remain independently governed by subsequent FR-026 and FR-027.

## FR-026 — Worker scarcity

- **Canonical authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, FR-026 (MVP): total Worker population must remain strictly below total available Worker slots. Former FR-058; source S3-P0271–P0274. Authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Implementation and executed evidence

- `src/core/state.ts`: `validateWorkerModel` rejects Worker population greater than or equal to available slots, per-building occupancy overflow, invalid identities and under-staffed Prototype rosters. `slotsAfterWorkerHire` retains a global reserve, including where unused capacity belongs to a different building; `HIRE_WORKER` performs atomic guarded hiring and `normalWaveCanHireWorker` exposes the same eligibility to React. Normalization limits imported Worker assignments to at most available slots minus one; committed slots survive wave continuation. SHA-256 `871b3f7a639e0ce16c1cf6ad83c93a0ba806bd8a4b45527bc48041aa2e061895`.
- `src/core/fr026WorkerScarcity.test.ts` covers the initial shortage, sequential hiring with reserved headroom, rejection when headroom would be exhausted, normalization of an overstaffed imported roster and next-wave preservation. SHA-256 `afe02edff419753d2e86643148bb985e6bf478c50ddb2bd3d4ff8f8bf0147a61`.
- Guarded Windows-host execution `rrh:resort-empire-web-bootstrap-v2:a1222:1:81bbd661`: focused FR-026 Vitest 4/4 PASS; full Vitest 101/101 PASS across 38 test files; TypeScript `tsc --noEmit` PASS; Vite production build PASS. FR-025 focused hiring and preceding conformance proofs remain intact.
- Browser visual acceptance is not claimed. Pricing and economy balancing remain OPEN/TUNING where separately governed.

### Conclusion

FR-026 is IMPLEMENTED_PROVEN for the invariant that total Workers remain strictly fewer than available Worker slots, including hired rosters, restored saves and continued waves. FR-027 independently governs multi-Worker diminishing returns.

## FR-027 — Multi-Worker allocation

- **Canonical authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, FR-027 (MVP): when multiple Worker slots exist, additional Workers may join an already staffed building, with diminishing marginal benefit. Canonical CAN-FR-020; S3-P0265–P0270. Authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Implementation and executed evidence

- `src/core/state.ts` provides canonical `serviceSpeed` calculated from assigned Worker count. The first Worker supplies speed 1; second increases speed to 1.5; third to 1.75. Positive marginal contributions decline geometrically. The independent Manager multiplier and existing unstaffed speed are preserved. The wave simulation uses this speed in actual per-tick service progress. Core SHA-256 `d3eeb47d83409b03e65e75dca998017d490d711abfa1464c5174bc5ddb61a522`.
- Existing `REASSIGN_WORKER`, `HIRE_WORKER` and per-building slot guards allow multiple Workers at one eligible building without violating FR-026 global scarcity.
- `src/core/fr027MultiWorker.test.ts` verifies strictly positive and decreasing marginal speed contributions, real 250ms simulation progress, and valid second-Worker reassignment into an already staffed building. Test SHA-256 `a59f290995dc8a27387fd1461743da3874b8f7d765941dc56318afb78dcb1895`.
- Guarded host execution `rrh:resort-empire-web-bootstrap-v2:a1229:1:b3c5195d`: focused Vitest 3/3 PASS, full Vitest 104/104 PASS across 39 files, TypeScript noEmit PASS and Vite production build PASS.
- The `marginalDecay: 0.5` coefficient is provisional MVP balancing, not a frozen product-economy parameter. Browser visual acceptance is not claimed.

### Conclusion

FR-027 is IMPLEMENTED_PROVEN for allocation into an already staffed building and positive, diminishing marginal effect on actual service progress.

## FR-028 — Prototype building progression

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, FR-028, Prototype. Each of five normal Prototype buildings has exactly Levels 1–3; upgrades change simultaneous service capacity only, leaving committed Worker-slot count, base quality and base service speed unchanged. Authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Canonical source and executed behavior

- `src/core/state.ts` (`d3eeb47d83409b03e65e75dca998017d490d711abfa1464c5174bc5ddb61a522`): `PrototypeBuildingLevel = 1 | 2 | 3`; `normalWaveUpgradeQuote` only offers Levels 2 and 3, rejects Level 3 as maximum, and computes service-capacity gains via the provisional `capacityBonusByLevel` table. `UPGRADE_BUILDING` modifies `buildingLevelsByNeed` of the selected building, while spending Coins and increasing resortValue; its normalWave update does not change committed `workerSlotsByNeed`, worker assignments, Manager assignments, base tuning, previous result or service speed.
- `src/core/fr028PrototypeBuildingProgression.test.ts` (`b186c4222c1b038b089e011835912a8c723b76311804076913b67c2e19eb0ffa`): all five normal building IDs are checked through Levels 1→2→3, monotonically increasing simultaneous service capacity, refusal above Level 3, unchanged actual slots/assignments/tuning/service-speed and normalWave state aside from level, and upgrade refusal before wave completion or during active waves.
- Windows Host verification `rrh:resort-empire-web-bootstrap-v2:a1239:1:8fd23b41`: focused Vitest 4/4 PASS; full Vitest 108/108 PASS across 40 files; TypeScript noEmit PASS; Vite production build PASS.
- **Stage boundary:** separate MVP `HIRE_WORKER` can activate additional committed slots in a distinct paid action, and its eligibility currently depends on building level; FR-028 prohibits slot mutation by the Prototype upgrade itself. FR-029 separately governs actual MVP Level 4/5 slot/quality progression and must reconcile that capability. No browser visual acceptance is claimed. Prototype capacity bonuses and prices remain OPEN/TUNING.

### Conclusion

FR-028 is IMPLEMENTED_PROVEN for three-level Prototype progression with capacity-only upgrade effects on the operational model.

## FR-029 — MVP five-level building progression

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, FR-029, MVP: the five normal wave buildings extend to Levels 1–5; Level 4 adds Worker-slot and quality capability without extra capacity; Level 5 adds capacity, slot capacity and quality. Canonical authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de` as previously established in the requirements lineage.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Implementation and executable behavior

- `src/core/mvpBuildingProgression.ts` (`9eeba678eaa64d31d6b9a4be36e4449b930bc9d833af8f0f84533cb96103b072`): explicit Prototype/MVP ceilings and distinct Level 4/5 capacity, Worker-slot and quality effects. Numerical costs, bonuses and balance coefficients are provisional OPEN/TUNING, not source requirements.
- `src/core/state.ts` (`af80b81753ddd548b5b5b9a3470e8bd55ba8535ce8da0e3b9d145992505d60af`): mode-aware upgrade quotes and command; no Level-4 capacity increase; added Worker slots at Levels 4 and 5; Level-5 capacity increase; quality modifies completed-wave star rating without changing base Worker service speed. Level 1–3 Prototype behavior remains capacity-only.
- `src/main.tsx` (`9d67809e131a6e7df2f4a31646eb8fd48a6a625cefec1661438ca34047cd9a0a`): live product bootstrap and New Resort enable MVP; explicit capacity-upgrade Prototype proof remains isolated.
- `src/app/App.tsx` (`a9dfbe1fc868aa5f358f44f89ad7a54b324a4bab6a8a20fb716528d1c4d7a857`): upgrade offer displays changed capacity, Worker-slot addition and quality delta. Browser visual acceptance is not claimed.
- `src/persistence/DexieBootstrapPersistence.ts` (`3f17a2a3f7047e99ec6eb56176d71977f7e2a03312601bd9811ff87bd3685324`): Level 1–5 saves, stage recovery and canonical identity preservation; inter-wave progression retains committed slots and levels.
- `src/core/fr029MvpBuildingProgression.test.ts` (`4fb8699345ac7c9de21ccb49f1beb9574ffa0257d8ec1007aaa9bf659aa9e63b`): all five buildings through MVP Level 5, Prototype Level-3 ceiling, capacity-only Prototype regressions, slot/quality differences, wave transition and persistence hydration; controlled actual-wave comparison shows Level-4 improved star rating under identical capacity, service speed, demand, staffing, accumulated waiting and queue pressure.
- **Executed evidence:** `rrh:resort-empire-web-bootstrap-v2:a1260:0:30391161` — dedicated 8/8 PASS, full Vitest 116/116 PASS across 41 files, TypeScript noEmit PASS, production Vite build PASS. Earlier persistence-regression repair and validation: `rrh:resort-empire-web-bootstrap-v2:a1254:0:356f7787` (108/108 and build PASS).

### Conclusion

FR-029 is IMPLEMENTED_PROVEN for the MVP five-level progression and its distinct operational capacity, Worker-slot and quality effects. Tuning remains provisional; no real-browser visual acceptance is asserted.

## FR-030 — Permanent upgrade timing

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, FR-030, Cross, physical line 293: Permanent building upgrades shall be available only between waves and shall not be available during WAVE_ACTIVE. Canonical SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Canonical implementation and executed evidence

- `src/core/state.ts` SHA-256 `7c3475de0cec2fc26f80e287276d24f396aa0ba60eb9dd5fa70e832f679b3896`: `normalWaveUpgradeQuote` permits eligible permanent upgrades after a completed wave with a result or during awaiting preparation of Wave 2+; initial Wave-1 awaiting, incoming, draining and incomplete/invalid complete states are denied. `UPGRADE_BUILDING` independently resolves the same quote, rejects illegal commands without mutating canonical state, and applies Coins/resortValue/level/slots only when permitted.
- `src/app/App.tsx`: player-facing upgrade action is projected from `normalWaveUpgradeQuote`, without separate timing authority or an active-wave bypass.
- `src/core/fr030UpgradeTiming.test.ts` SHA-256 `133d5dd882179a857d612bb85362c2a8ef15691f91787c79f787761eaf838052`: six deterministic Prototype/MVP cases prove completed-wave purchases, inter-wave `complete → awaiting → incoming` continuity, correct resource effects, prohibition during initial setup and active incoming/draining, and identity-preserving refusal even when an active state carries a stale result.
- **Host execution:** `rrh:resort-empire-web-bootstrap-v2:a1267:0:cecbd4c` — FR-030 suite 6/6 PASS; full suite 122/122 PASS across 42 files; TypeScript noEmit PASS; Vite production build PASS. Canonical source verification `rrh:resort-empire-web-bootstrap-v2:a1264:0:e577d0db`; initial guard inspection `rrh:resort-empire-web-bootstrap-v2:a1266:0:7e4b8b91`. Real-browser visual acceptance not asserted.

### Conclusion

FR-030 is IMPLEMENTED_PROVEN for the canonical upgrade timing boundary in both Prototype and MVP. Other gameplay costs and balances remain governed separately.

## FR-031 — Optional Energy assistance

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 294, Cross: Energy shall remain optional assistance, never a participation/progression gate; a fully prepared resort must be able to achieve the highest normal-wave result without spending Energy. Authority SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Source and behavior evidence

- `src/core/state.ts` SHA-256 `7c3475de0cec2fc26f80e287276d24f396aa0ba60eb9dd5fa70e832f679b3896`: normal waves start with zero Energy; Energy consumption is optional through `ACTIVATE_ENERGY_MODE`; normal-wave start, simulation, rating, completion, and continuation do not require spending Energy. The completed-wave Energy award is distinct from consumption.
- `src/core/fr031EnergyOptionality.test.ts` SHA-256 `f98781161e5dddd5bd9a642f11d1f6bfe3ca53cb8329b273b2c4da5b599d1849`: enduring four-scenario Prototype/MVP × default/food reassignment regression. Each starts at zero Energy, uses real START_WAVE and ADVANCE_SIMULATION commands with default production proof tuning, serves 22/22 positive released demand, earns the maximum normal-wave 5/5 rating with no Energy mode activation, and starts Wave 2 from an explicitly zeroed Energy balance. Completion adds one earned Energy; this is not consumption.
- **Executed exploratory evidence:** `rrh:resort-empire-web-bootstrap-v2:a1273:0:67332f3d`: four observed 5/5 completions with 22/22 demand served and no Energy expenditure, plus next-wave zero-Energy starts; temporary probe removed.
- **Executed retained regression and integration evidence:** `rrh:resort-empire-web-bootstrap-v2:a1274:0:7a4ab11b`: FR-031 4/4 PASS; full Vitest 126/126 PASS across 43 files; TypeScript noEmit PASS; Vite production build PASS. No new gameplay tuning was introduced. Real-browser visual acceptance is not asserted.

### Conclusion

FR-031 is IMPLEMENTED_PROVEN: Energy is an optional service accelerator, not a gate to participation, progression or the highest normal-wave rating under the verified gameplay configurations.

## FR-032 — Wave Energy Mode A

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 295, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. Wave Energy Mode A temporarily increases the service speed of one selected building without increasing capacity, applies to work already in progress, and in Prototype permits at most one boost per building per wave.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Source and behavioral evidence

- `src/core/state.ts` SHA-256 `c871ebbd80b239e27b1d934f451b910e0143e477b54d9afc36ee30acf8538c84`: boost multiplier affects existing service-progress entries of only the selected need; service capacity is computed separately and is unaffected. Wave-local `energyBoostedNeedsThisWave` records target buildings and guards repeat activation in Prototype even after temporary effect expiry. Usage resets on next-wave creation. The guard handles previously serialized snapshots missing the field without changing durable schema. MVP is not assigned the Prototype-only reuse restriction.
- `src/app/App.tsx` SHA-256 `203cb74d6e9dc76a298cac9004d20337852b8f0bc52f28837347b292f6b27a37`: Energy activation availability reuses the authoritative core predicate rather than maintaining a divergent UI rule.
- `src/core/fr032EnergyMode.test.ts` SHA-256 `24922ad7e14701dc0e5127b9a8fc668110903907fefcec113eaeb2ad8a792e53`: four deterministic tests cover Prototype/MVP in-progress acceleration, unchanged capacity and unaffected other service, Prototype repeat rejection after expiry including serialization, distinct building eligibility, wave reset and MVP reuse.
- **Executed evidence:** `rrh:resort-empire-web-bootstrap-v2:a1282:0:a52fe0b3`: focused FR-032 4/4 PASS; full Vitest 130/130 PASS across 44 files; TypeScript noEmit PASS; Vite production build PASS. Earlier `rrh:resort-empire-web-bootstrap-v2:a1281:0:61c68d73` confirmed the initial four behavior tests but revealed an erroneous test-only type import, corrected before the final all-green run.
- **Scope:** Gameplay authority remains exclusively in the TypeScript core; numeric boost tuning unchanged. Browser visual acceptance is not claimed.

### Conclusion

FR-032 is IMPLEMENTED_PROVEN: the bounded selected-building speed boost, unchanged capacity, effect on in-progress services, and Prototype per-building-per-wave restriction have executable evidence.

## FR-033 — Energy acquisition

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 296, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. Energy shall be earnable from completed gameplay and may be supplemented by voluntary rewarded video; lack of Energy shall not block the underlying service.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Source and executed behavior

- `src/core/state.ts` SHA-256 `c871ebbd80b239e27b1d934f451b910e0143e477b54d9afc36ee30acf8538c84`: `ADVANCE_SIMULATION` awards the configured `earnedPerCompletedWave` exclusively when `completedNow` transitions from non-complete to complete. Normal services and wave progression do not check positive Energy; only optional Energy Mode activation consumes the resource.
- `src/core/fr033EnergyAcquisition.test.ts` SHA-256 `e6208be7c99e1d305442fd943ca6d22374b9519634fcc47a4aea297b5e140630`: four durable Prototype/MVP regressions prove completed-wave earnings, no premature grant, no repeated grant on subsequent ticks, continued rewards in the next completed wave, and zero-Energy completion with real guest service.
- **Execution:** `rrh:resort-empire-web-bootstrap-v2:a1287:0:1c84d3ed`: focused FR-033 4/4 PASS; entire Vitest 134/134 PASS across 45 files; TypeScript noEmit PASS; Vite production build PASS. Existing energy and zero-balance tests also passed 11/11 in `rrh:resort-empire-web-bootstrap-v2:a1286:1:904a2d46`.
- **Optionality boundary:** The clause `may be supplemented by voluntary rewarded video` is permissive. No rewarded-video provider or reward-verification integration is implemented or claimed; this optional source is not treated as a required gameplay dependency or as a fabricated Energy grant.
- **Scope:** Deterministic gameplay proof; no advertising provider or browser visual acceptance claimed.

### Conclusion

FR-033 is IMPLEMENTED_PROVEN for its mandatory Energy acquisition and non-gating semantics. Rewarded video remains an unimplemented permitted enhancement, not a completed integration.

## FR-034 — Offline Energy

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 297; SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. Energy shall not regenerate or accumulate as a function of offline time.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Audited implementation source identities

- `src/core/state.ts` SHA-256 `c871ebbd80b239e27b1d934f451b910e0143e477b54d9afc36ee30acf8538c84`.
- `src/runtime/SimulationClock.ts` SHA-256 `d96ed252fba01516d982a59b687faad039c72df2c63ed51b4fbb92911768e20c`.
- `src/main.tsx` SHA-256 `9d67809e131a6e7df2f4a31646eb8fd48a6a625cefec1661438ca34047cd9a0a`.
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `3f17a2a3f7047e99ec6eb56176d71977f7e2a03312601bd9811ff87bd3685324`.
- `src/runtime/PrototypeInactivity.ts` SHA-256 `6208a11a84ad6c3e2c4987b3deb5ebfaef2c75fb8f8d0cf29c87f85bedd8dbf7`.
- `src/core/fr034OfflineEnergy.test.ts` SHA-256 `de00c0a20fe5e8514a07b005465e65acc5e81b53b65ba1f7353a2acba29ecd58`.

### Behavioral evidence

- The core grants Energy only when `ADVANCE_SIMULATION` completes a normal wave; no wall-clock or offline-time Energy award is implemented.
- `SimulationClock` dispatches fixed `deltaMs` steps and never converts elapsed wall-clock absence into catch-up ticks. The app stops this clock on hidden/pagehide and starts it again on visible without replay.
- Dexie persistence normalizes the recorded state including its saved Energy balance; `CLAIM_COMEBACK_REWARD` adds only Coins and does not change Energy.
- Four deterministic tests in `src/core/fr034OfflineEnergy.test.ts` cover Prototype and MVP with 30-day paused simulation, longer serialized-state absence, unchanged saved Energy, unchanged simulation ticks while paused, one fixed tick after resume, and no Energy from comeback reward. These exercise the core, clock and normalization path with fake time; an actual browser or IndexedDB round trip is not claimed.
- **Executed verification:** `rrh:resort-empire-web-bootstrap-v2:a1293:0:7727dc9f`: FR-034 4/4 PASS; complete Vitest 138/138 PASS in 46 files; TypeScript noEmit PASS; Vite production build PASS.
- **Source inspection:** `rrh:resort-empire-web-bootstrap-v2:a1291:0:4e76ebc1` and `rrh:resort-empire-web-bootstrap-v2:a1292:0:e2557009` show main lifecycle, clock, persistence and inactivity eligibility paths.

### Conclusion

FR-034 is IMPLEMENTED_PROVEN: Energy has no offline-time accrual, and clock resume does not replay accumulated absence.

## FR-035 — Sudden Rush

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 298; SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. Sudden Rush must inject demand at the currently unstaffed normal-wave building, keep the wave running, and allow resolution through Worker reassignment without Energy.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Audited source identities

- `src/core/state.ts` SHA-256 `5c364b447a6ee3575c03f7a82cba8cde46c04c95d134347b0b06b57f28747a35`.
- `src/core/fr035SuddenRushContract.test.ts` SHA-256 `8990a92c442587727ddf704db226f9d1398bbdab21ecdb7f43bddc3ef4f08066`.
- `src/core/prototypeEvents.test.ts` SHA-256 `d167564ac66e705d60541580dbf4fa8056743c94105903f921d50696bee937f3`.
- `src/core/waveTemporal.test.ts` SHA-256 `f9149a3efc8e582d62536075887fe88fa5f093816940d7092a97c9e131d0b28f`.
- `src/app/App.tsx` SHA-256 `203cb74d6e9dc76a298cac9004d20337852b8f0bc52f28837347b292f6b27a37`.

### Implementation and acceptance evidence

- At the due moment the core selects only an active building with zero assigned Workers. Its former fallback to the first active, possibly staffed, building was removed. If all active buildings have Workers, the scheduled Rush is canceled rather than injecting demand at a staffed target; normal-wave completion remains reachable.
- If an unstaffed building exists, the Rush increases its demand target, progressively releases additional demand, and leaves the wave active. `REASSIGN_WORKER` is accepted during incoming/draining, increases service throughput, and does not consume Energy. Ordinary completion still awards the separately specified wave-earned Energy.
- The player-reachable fully staffed scenario upgrades Food and then hires the third Worker through ordinary commands, preserving the Worker scarcity/slot invariant. No fabricated gameplay state or debug bypass is used.
- `src/core/fr035SuddenRushContract.test.ts` verifies both full zero-Energy resolution of Rush demand and no target/no injection/no wave deadlock when every active building is staffed. Existing prototypeEvents and waveTemporal tests cover demand injection and beneficial Worker reassignment.
- **Execution evidence:** `rrh:resort-empire-web-bootstrap-v2:a1301:0:3070c772`: 13/13 focused tests PASS; full Vitest 140/140 tests PASS in 47 files; TypeScript noEmit PASS; Vite build PASS.
- **Repair evidence:** `rrh:resort-empire-web-bootstrap-v2:a1299:0:a924791`; **scarcity/source inspection:** `rrh:resort-empire-web-bootstrap-v2:a1300:0:d40078d`; **initial counterexample:** `rrh:resort-empire-web-bootstrap-v2:a1298:0:ba2597c3`. The initial counterexample failed at worker hiring due to the intended scarcity invariant; only the subsequently corrected, gameplay-reachable regression is claimed as acceptance.
- This disposition claims source and deterministic execution proof, not a new browser acceptance run.

### Conclusion

FR-035 IMPLEMENTED_PROVEN after targeted core repair and complete regression verification.

## FR-036 — MVP VIP layer

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 299; SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. Four named VIP identities — Travel Blogger, Wedding Couple, Investor and Influencer — form an optional parallel MVP layer, never replacing or pausing ordinary waves.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Audited source identities

- `src/core/state.ts` SHA-256 `ffb69edb300dcb3a23b258ba62566d71766482c93ef632a0f2f6a9151e7fe186`.
- `src/core/vipLayer.ts` SHA-256 `9603cf3a6309254d2e52ffd50d4a61fed8e61d6a6e0e8b74e027697626453420`.
- `src/core/fr036VipParallel.test.ts` SHA-256 `302e64325ef9ad200b7c0ed2c63ac3e4416501f804285b05e9d4e3603518beba`.
- `src/core/fr036VipHydration.test.ts` SHA-256 `b75f25c78a055ebf8999249bbc7a90d696c1ee618461be1a50967cde167a7534`.
- `src/app/App.tsx` SHA-256 `080c05a67569b49dc153e9b41dc0d118a7833ef299ff934cca1968deb2384363`.
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `850f1f2d0587fe84447d2d46c952da03ca2b00fbcf5eacb596ff93a5ca9831e6`.

### Implementation and execution evidence

- `src/core/vipLayer.ts` defines the exact four canonical VIP identities and a distinct core-owned optional visit state with active progress and completed history. Visit duration is explicitly provisional implementation tuning; it is not claimed as authoritative FINAL(3) balance.
- `BootstrapState.vipLayer`, `BEGIN_VIP_VISIT` and the existing `ADVANCE_SIMULATION` reducer integrate VIP progress within the canonical TypeScript game authority. Prototype stage rejects VIP visits; MVP does not start visits automatically.
- Independent deterministic tests run all four VIP identities alongside an active normal wave and compare normal-wave state with the corresponding VIP-free baseline after both half-duration and full-duration advances. Wave progression remains identical; Workers, Energy and Coins are unaffected by the VIP visit. Simultaneous duplicate visit start is guarded.
- `src/app/App.tsx` projects optional VIP controls, identity, live progress and completed-visit count directly from the canonical snapshot; it introduces no shadow game state.
- `src/persistence/DexieBootstrapPersistence.ts` normalizes VIP state on hydration. Tests prove active visit progress resumes after serialization and older VIP-free saves hydrate without losing normal-wave progress, simulation ticks or MVP stage.
- **Fresh execution evidence:** `rrh:resort-empire-web-bootstrap-v2:a1313:0:755edb4a`: focused VIP tests 8/8 PASS in 2 files; full Vitest suite 148/148 PASS in 49 files; TypeScript noEmit PASS; Vite production build PASS.
- **Earlier source/test evidence:** `rrh:resort-empire-web-bootstrap-v2:a1311:0:a7089f96`: independently verified initial VIP core files, focused 6/6 and TypeScript PASS.
- **Scope:** This disposition establishes FR-036 parallel VIP infrastructure and player-accessible activity. Preview acceptance choices, request preparedness, consumable/roster gaps, request states, Speed Up, Spa and VIP rewards are independent FR-037–FR-046 obligations and are not claimed complete. A new browser-level acceptance run is not claimed.

### Conclusion

FR-036 IMPLEMENTED_PROVEN through source, executable concurrency and hydration regressions, full suite, TypeScript and build evidence.

## FR-037 — MVP VIP acceptance controls

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 300, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. VIP Preview must offer Accept/Open Requests, Maybe later, and Decline, without punishment.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Source identities

- `src/core/vipLayer.ts` SHA-256 `f748b41bf5c30a20ea51a18a6ae24a8612b59e04faaab4e40ed9dd4b1f3fe08c`.
- `src/core/state.ts` SHA-256 `d04f28bd59b0a09d42d58f783f65163ebd1fa1b7574ae02de903aa0e7aeeb02a`.
- `src/app/App.tsx` SHA-256 `3e5f01ed09a22d5ee82de1f279c79344ec99350f7352937614e1dd450e1ffa2a`.
- `src/core/fr037VipPreview.test.ts` SHA-256 `7db817fea7a58b171585b223f3e8793ad998ea9f0a9048364760c3dc38fdcff5`.
- `src/core/fr036VipHydration.test.ts` SHA-256 `cbf4f33d0627e814bf2b0dcf706b6dd69c72919d65727b01b6093f3322829138`.
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `850f1f2d0587fe84447d2d46c952da03ca2b00fbcf5eacb596ff93a5ca9831e6`.

### Functional acceptance evidence

- Canonical TypeScript state owns VIP Preview selection, accepted request state, request panel visibility, and last decision. SHOW_VIP_PREVIEW and DECIDE_VIP_PREVIEW are MVP-gated reducer commands.
- Accept/Open Requests transitions from preview to accepted/open requests without automatically starting the visit. A separate Begin VIP visit action is available from the accepted request surface.
- Maybe later and Decline each dismiss Preview without resource changes, reputation/resort-value changes, VIP activity, or disruption to the ordinary wave. Deterministic tests compare the normal wave against the non-VIP baseline, including after simulation advances. The player may preview again without a punitive lockout.
- React displays the selected VIP Preview and three distinct decision buttons, plus the accepted Open Requests panel. The view dispatches canonical commands and maintains no independent gameplay state.
- Persisted pending Preview and accepted Open Requests are recovered by the existing normalization path without loss of normal-wave state. Legacy-save regression uses the expanded canonical default VIP layer.
- **Fresh execution evidence:** `rrh:resort-empire-web-bootstrap-v2:a1319:0:f6ec983a` — FR-036/FR-037 focused 16/16 tests PASS in 3 files; full Vitest suite 156/156 PASS in 50 files; TypeScript noEmit PASS; Vite production build PASS.
- **Scope:** FR-038 Preview content, readiness and reward-range disclosure, and subsequent VIP mechanics remain independently open. A new interactive-browser acceptance run is not claimed.

### Conclusion

FR-037 IMPLEMENTED_PROVEN on exact authority, source, canonical game-state transitions, deterministic no-punishment tests, persistence regression and full project validation.

## FR-038 — MVP VIP Preview information

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 301, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. Before acceptance, display VIP identity/opportunity, potential reward range, readiness and relevant roster/building gaps.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Verified source identities

- `src/core/vipPreview.ts` SHA-256 `584f1dc6157fd2a12db7a07160a8e46c24067d31a77b42196c12f2a52cddd2b2`.
- `src/core/fr038VipPreviewInfo.test.ts` SHA-256 `65a68084bd3247ecbd87888cf1d072f234b4b9a713443c54fa87b7fcc119e72d`.
- `src/app/App.tsx` SHA-256 `8e0a201ff77cfde7519b6e662a84e26fe464c916ad149fafff1cee2cb19a738f`.
- `src/core/state.ts` SHA-256 `d04f28bd59b0a09d42d58f783f65163ebd1fa1b7574ae02de903aa0e7aeeb02a`.

### Behavioral evidence

- `deriveMvpVipPreviewInfo` provides a pure, read-only MVP projection for Travel Blogger, Wedding Couple, Investor and Influencer. Each has its own opportunity description, potential Reputation range, readiness, roster gaps and building gaps.
- Readiness derives from existing hired Specialists, hired Managers and purchased areas in canonical `BootstrapState`. Normal-wave Worker assignments do not determine VIP readiness. Core tests verify initial gaps, preparedness transitions, non-mutation and MVP stage guard for all four VIP types.
- `src/app/App.tsx` renders opportunity, potential reward range, readiness, roster gaps and building gaps within VIP Preview, before Accept/Open Requests. No shadow gameplay authority is introduced.
- Reward ranges and illustrative prerequisite profiles are explicitly provisional MVP presentation tuning. They are not asserted as fixed FINAL(3) values; FR-039–FR-046 preparedness, request lifecycle and actual VIP payout remain separately unproven. The UI explicitly says VIP reward awards are not implemented yet.
- **Fresh host execution:** `rrh:resort-empire-web-bootstrap-v2:a1326:0:1073e0a7`: focused FR-037/FR-038 17/17 PASS (2 files); complete Vitest 165/165 PASS (51 files); TypeScript noEmit PASS; Vite build PASS; all seven React preview information markers verified.
- **Acceptance scope:** deterministic source and integration evidence; interactive browser acceptance has not been independently demonstrated.

### Conclusion

FR-038 IMPLEMENTED_PROVEN for pre-acceptance VIP information visibility with explicit tuning/implementation limitations.

## FR-039 — MVP VIP preparedness model

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 302, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. VIP request resolution must use prior resort preparedness, not live normal-Worker allocation; Workers cannot be assigned to VIP requests through Worker Allocation.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Verified source identities

- `src/core/vipLayer.ts` SHA-256 `d8a04e23b136320cce58e0435f826c87029aa68b550199da44bccf5152a2a602`.
- `src/core/state.ts` SHA-256 `af99bbc9fd3914dce244aa52e15d99685e6ee8298a4b7bad5eb455609f6cecc5`.
- `src/core/vipPreview.ts` SHA-256 `584f1dc6157fd2a12db7a07160a8e46c24067d31a77b42196c12f2a52cddd2b2`.
- `src/core/fr039VipPreparedness.test.ts` SHA-256 `b06f28c6a38e22155eabb0984066baddd0f5893a913115d39db4e9abd3a877d0`.

### Behavioral evidence

- `BEGIN_VIP_VISIT` derives a readiness snapshot from canonical prior hired Specialists, Managers and purchased areas through `deriveMvpVipPreviewInfo`; TypeScript core stores copied roster and building gaps with each newly started visit. The snapshot remains stable as ordinary workers or subsequent investments change.
- `advanceMvpVipLayer` persists a separate preparedness-bearing completion resolution; the established `completed: MvpVipType[]` contract remains unchanged. In legacy saves lacking a visit snapshot, normalization does not fabricate historical preparedness or a completion resolution.
- Worker Allocation `REASSIGN_WORKER` targets only NormalWaveNeedId; compile-time negative assertion and runtime invalid-target rejection prove VIP is not an assignable target. Adversarial tests compare outcomes after normal-Worker changes and verify all four VIP types for prepared and gap-bearing visits, serialization/hydration and legacy behavior.
- Existing canonical-state referential identity and all prior VIP contracts preserved.
- **Host acceptance:** `rrh:resort-empire-web-bootstrap-v2:a1336:1:8b84ee02`: focused 50/50 PASS across eight test files, complete Vitest 175/175 PASS across 52 files, TypeScript noEmit PASS and Vite build PASS.
- **Scope:** readiness resolution is implemented; detailed request quality caps, exact reward computation/payment, tuning and interactive browser acceptance are not claimed here and remain independently governed by later FRs.

### Conclusion

FR-039 IMPLEMENTED_PROVEN for prior resort preparedness-based VIP resolution with exclusion of normal Worker Allocation.

## FR-040 — MVP VIP consumable gaps

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 303, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. A VIP request missing a consumable requirement must follow MISSING → Fix → READY with Fix actually supplying or consuming the required Materials/consumable resource.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Verified source identities

- `src/core/state.ts` SHA-256 `7a3ea4eb7028c9ec32d7500b1dca7517138886da08d2e91aa8116ae8db2709a9`.
- `src/core/vipLayer.ts` SHA-256 `e94a05e35711c0775d292054d55901ed6a0767e5c6be217ae812488ed3edf878`.
- `src/app/App.tsx` SHA-256 `e40ca9bc8d5501eab18d9c35b179cb13b9e66ec2f0a9c40e7b4ee1c9a8955e8d`.
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `92f097b6c52b0c4b85abbac3824bb8455b88cd96006a6d23fe0edc04420e894e`.
- `src/core/fr040VipConsumables.test.ts` SHA-256 `82da67ee7e9e3570b82ba9e05801bc9f3bb0ec62590dfb1e5d3bf441e2d7eaf3`.

### Behavioral evidence

- Pure TypeScript BootstrapState owns `materials` stock. MVP-only `PURCHASE_VIP_MATERIALS` debits Coins and credits Materials; insufficient Coins rejects the transaction. Unit quantities and acquisition price reside in explicitly provisional tuning and are not claimed to be prescribed by FINAL(3).
- Accepting a VIP Preview creates a request with `consumableReady: false` (MISSING). `FIX_VIP_CONSUMABLE` checks the accepted request and available Materials, atomically debits the required stock and marks that request READY. Insufficient stock cannot mark READY; repeated Fix is rejected.
- `BEGIN_VIP_VISIT` is blocked for an accepted request until its consumable is READY; legacy direct VIP start remains compatible with prior FR-036 contracts. Starting a prepared request clears the pending-request flag without returning consumed Materials. FR-039 roster/building preparedness remains separate from consumable resolution and normal Worker allocation.
- React VIP Requests displays MISSING/READY and Materials stock with supply and Fix controls and disables Begin VIP visit while MISSING. Gameplay writes remain in the canonical core; React presents state only.
- Persistence hydration defaults absent or invalid legacy Materials to zero, hydrates legacy consumable flags without granting a free READY state, preserves valid persisted Materials and readiness, and retains reference identity for already-canonical snapshots.
- Dedicated FR-040 tests exercise all four MVP VIP types, zero-stock and insufficient-Coins denial, exact resource debits, double-Fix protection, stage guarding, state serialization/hydration, old saves, direct-entry compatibility and normal-wave independence.
- **Host acceptance:** `rrh:resort-empire-web-bootstrap-v2:a1345:0:b7e91bdb`: focused 31/31 PASS across five test files; complete Vitest 183/183 PASS across 53 files; TypeScript noEmit PASS; Vite build PASS.
- **Scope:** FR-042 full four-state request lifecycle, FR-041 roster-gap quality ceiling, rewards and independent interactive-browser acceptance are not claimed by this disposition.

### Conclusion

FR-040 IMPLEMENTED_PROVEN for actual consumable-backed MISSING → Fix → READY VIP requests.

## FR-041 — MVP VIP roster and building gaps

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 304; SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. Missing Manager, Specialist and building prerequisites must not become fixable during the VIP stay; the request remains executable with a reduced attainable quality ceiling.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Verified source identities

- `src/core/vipLayer.ts` SHA-256 `7bc843f69b770ab9a0c13db492d0dfe8b1c8ddc6ed8e1faa600acae05c8c311a`.
- `src/app/App.tsx` SHA-256 `a5fa764a0360d8614a0101c20d5aff654d6a1b0be6e33d5c0acc844bde687883`.
- `src/core/fr041VipRosterCeiling.test.ts` SHA-256 `b6b47f4bdcfc9bbc22cc5d8c32b79c3f883244554d721a3c2faf80544678fcaf`.
- `src/core/state.ts` SHA-256 `7a3ea4eb7028c9ec32d7500b1dca7517138886da08d2e91aa8116ae8db2709a9`.
- `src/core/vipPreview.ts` SHA-256 `584f1dc6157fd2a12db7a07160a8e46c24067d31a77b42196c12f2a52cddd2b2`.
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `92f097b6c52b0c4b85abbac3824bb8455b88cd96006a6d23fe0edc04420e894e`.

### Behavioral evidence

- The pure TypeScript VIP preview identifies required Managers, Specialists and buildings using the existing MVP prerequisite profile. Beginning a VIP visit stores the detected roster/building gaps in the visit-start preparedness snapshot, independently of normal-wave Worker assignments. Visits remain executable with such gaps.
- `mvpVipAttainableQualityCeiling` and `capMvpVipQuality` in the pure VIP domain derive and enforce the attainable ceiling from that immutable snapshot. Missing roster/building prerequisites reduce the ceiling; late staffing/building changes do not recalculate it for the active visit or its completed resolution. There is no roster/building Fix command for the active VIP stay.
- React projects the provisional ceiling during the visit and from the persisted completed resolution. Its request panel explains that roster and building shortages cannot be repaired during a stay, whereas FR-040 consumable Fix remains available before starting.
- The provisional 1–5 scale and per-gap reductions are implementation proof tuning, not balance values prescribed by FINAL(3). Legacy visits without preparedness remain unknown, not silently scored at the full ceiling. No payout or final VIP quality award is claimed here; subsequent obligations remain independent.
- **Host proof:** `rrh:resort-empire-web-bootstrap-v2:a1351:1:1e72df85`: 34/34 focused tests PASS across five files; 194/194 complete tests PASS across 54 files; TypeScript noEmit PASS; Vite build PASS. Dedicated FR-041 tests cover four VIP identities, prepared versus gap cases, immutability after later hiring/building, save/load and completed-resolution continuity, lack of free quality for legacy saves, and independence from Materials Fix.
- **Scope:** Real-browser interaction and later complete request-card/scoring/rewards mechanisms have not been independently accepted by this requirement.

### Conclusion

FR-041 IMPLEMENTED_PROVEN for executable VIP stays with an immutable reduced roster/building quality ceiling, as distinct from pre-visit consumable Fix.

## FR-042 — MVP VIP request lifecycle

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 305, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. VIP request cards must support MISSING, READY, IN_PROGRESS and COMPLETED; reduced attainable quality ceiling remains an attribute rather than an additional lifecycle state.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Verified source identities

- `src/core/vipLayer.ts` SHA-256 `c1f20162664b3bbd170c16e40cd444e62ac50db60d863b1688ad333fcbf20905`.
- `src/app/App.tsx` SHA-256 `b54a89ad5eefe53d3f201c2cf9a76bea21a5e59b8bc49e1832c99c8cb11cfb68`.
- `src/core/fr042VipRequestLifecycle.test.ts` SHA-256 `1a1f4beb14d2afb78d36e2d142643f476e0f69f8f55120349f5ac1600de14c54`.
- `src/core/state.ts` SHA-256 `7a3ea4eb7028c9ec32d7500b1dca7517138886da08d2e91aa8116ae8db2709a9`.
- `src/core/vipPreview.ts` SHA-256 `584f1dc6157fd2a12db7a07160a8e46c24067d31a77b42196c12f2a52cddd2b2`.
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `92f097b6c52b0c4b85abbac3824bb8455b88cd96006a6d23fe0edc04420e894e`.

### Behavioral evidence

- Pure TypeScript `deriveMvpVipRequestCards` derives typed request-card phases from canonical accepted request/consumable readiness, active VIP visit and completed visit history. It does not introduce duplicate writable gameplay lifecycle authority.
- Acceptance with missing consumables gives MISSING; consumable-backed Fix gives READY; starting the accepted visit gives IN_PROGRESS; completing the visit produces a persisted COMPLETED card. React projects the four states in VIP request lifecycle cards.
- Attainable quality ceiling is represented as a separate nullable card attribute derived from immutable visit-start preparedness or its completed resolution. Missing roster/building prerequisites never manufacture a fifth status. Legacy history lacking safely aligned preparedness resolutions reports unknown quality instead of inferring full quality.
- Repeated visits of the same VIP retain distinct historical COMPLETED cards while new accepted or active cards are shown separately. Normal-wave state, existing consumable gating and historical persistence contracts remain independently governed.
- **Host proof:** `rrh:resort-empire-web-bootstrap-v2:a1357:0:3e64bcd1` CAS-corrected 15 test call sites; `rrh:resort-empire-web-bootstrap-v2:a1357:1:8ebf86a3` confirmed focused 38/38 PASS across five files, full Vitest 200/200 PASS across 55 files, TypeScript noEmit PASS and Vite build PASS. Dedicated tests cover all four MVP VIP identities, every lifecycle transition, rejected unready visit, save/load, repeated VIP completion history and legacy unknown-quality behavior.
- **Scope:** No independent interactive-browser acceptance or VIP rewards/final nominal quality score is claimed.

### Conclusion

FR-042 IMPLEMENTED_PROVEN: VIP request cards expose the four canonical phases with quality ceiling as an orthogonal attribute.

## FR-043 — MVP Energy-based VIP Speed Up

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 306, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. An applicable VIP request in progress may expose an Energy-based Speed Up action.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Verified source identities

- `src/core/state.ts` SHA-256 `6ad214d0605c3d1b94e31428309cf473746c319f44bf722f6d90fcf51da894ba`.
- `src/app/App.tsx` SHA-256 `942ec5ab963b1b1ea36f06ca3e885bbd57de84b7528eba5e79a09d6c486b6749`.
- `src/core/fr043VipSpeedUp.test.ts` SHA-256 `88fcdeab0554c0b896c1a9595956f7d05df9b453ebb1bacb881e1ac1798c5729`.
- `src/core/vipLayer.ts` SHA-256 `c1f20162664b3bbd170c16e40cd444e62ac50db60d863b1688ad333fcbf20905`.
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `92f097b6c52b0c4b85abbac3824bb8455b88cd96006a6d23fe0edc04420e894e`.

### Behavioral evidence

- The pure TypeScript gameplay dispatcher owns `VIP_SPEED_UP`. Its availability predicate requires MVP progression, an active VIP visit and sufficient existing shared Energy. Core validation rejects invalid stage, absent visit and insufficient Energy before any debit.
- A valid command atomically spends Energy and advances only the active VIP timer through `advanceMvpVipLayer`. The existing VIP lifecycle generates completion and preserved preparedness resolution. Normal-wave state, global simulation tick and elapsed time, Coins and Materials do not advance as a side effect.
- React offers Speed Up during an active VIP visit and disables it when the core availability predicate is false. A completed or absent visit does not expose this action.
- **Provisional tuning:** `MVP_VIP_SPEED_UP_PROVISIONAL` spends 1 Energy and advances VIP time by 10000 ms; the canonical requirement does not prescribe balance magnitudes. No parallel resource or payout model was created.
- **Host proof:** `rrh:resort-empire-web-bootstrap-v2:a1362:0:c5013f75` and `rrh:resort-empire-web-bootstrap-v2:a1362:1:4ea6593b` confirm core and UI writes. `rrh:resort-empire-web-bootstrap-v2:a1363:0:da5a732a` confirms focused 35/35 tests PASS across five files, complete Vitest 207/207 PASS across 56 files, TypeScript noEmit PASS and Vite build PASS. Dedicated regression tests cover all four VIP types, insufficient shared Energy, stage and lifecycle guards, partial-progress hydration, ordinary-wave isolation, and completion without global-time advancement.
- **Scope:** No independent real-browser acceptance or claim about finalized gameplay balance and rewards.

### Conclusion

FR-043 IMPLEMENTED_PROVEN: applicable in-progress VIP visits can use shared Energy for bounded Speed Up, with core-owned guards, deterministic behavior, and no interference with ordinary waves.

## FR-044 — MVP Spa role

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 307, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. Spa shall operate as a VIP-oriented building with no normal-wave need or Worker slot.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Verified source identities

- `src/core/state.ts` SHA-256 `ede5ebc8b9843fd3e6ea5904f83d29b7a10815c44bee69e4ea21879a45832b88`.
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `1cca936d2a22dc75bb81c4e0660614115ad1343533e70d05a027725473ad7eaa`.
- `src/app/App.tsx` SHA-256 `0aa389c71bc58f2cf5aefd73f0e211a20a1fd4953c15bd63d96b1d409f2016d7`.
- `src/render/ResortWorld3D.tsx` SHA-256 `2244ea7e1699ea7fbd8d18d05b799e2793be0eb193cef0965912511b40ad1d8c`.
- `src/core/fr044SpaRole.test.ts` SHA-256 `3faaaeb9a65be2c40ed2d6b82b74a8e7ba98ffabdb94f3d28a45caf2adf6f463`.

### Behavioral evidence

- Core-owned `vipBuildings.spa` records independent VIP building ownership. `PURCHASE_VIP_SPA` is MVP-only, requires available Coins and does not create normal-wave service demand or Worker slots. Repeat purchase is idempotent.
- Spa is absent from `NORMAL_SERVICE_IDS` and `PROTOTYPE_AREA_IDS`; ordinary building purchases and Worker allocations remain unchanged. Dedicated tests verify that Spa purchase preserves normalWave, purchasedAreas, hiredSpecialists, vipLayer, Energy, simulationTick and elapsedSimulationMs.
- Persistence normalizes legacy or corrupt Spa ownership to unbuilt and preserves valid saved ownership. React projects the purchase action and built status from core state. React Three Fiber renders a dedicated Spa mesh at existing calibrated expansion.slot07 only when owned in MVP, outside the normal-service building loop and Worker activity.
- **Provisional economics:** `MVP_VIP_SPA_PROVISIONAL.coinCost = 25` Coins is a temporary implementation balance, not a canonical fixed price. The subsequent FR-045 Spa-dependent attainable VIP quality requirement is separately pending.
- **Execution evidence:** `rrh:resort-empire-web-bootstrap-v2:a1371:0:5f986e84`, `rrh:resort-empire-web-bootstrap-v2:a1371:1:fd6fb637`, `rrh:resort-empire-web-bootstrap-v2:a1374:0:5f9630f7` and `rrh:resort-empire-web-bootstrap-v2:a1375:0:ce8f34ab` document implementation and JSX repair. `rrh:resort-empire-web-bootstrap-v2:a1375:1:39560688` confirms focused Vitest 20/20 PASS across four files, full Vitest 211/211 PASS across 57 files, TypeScript noEmit PASS and Vite build PASS.
- **Acceptance scope:** Actual interactive-browser purchase and 3D rendering have not been independently observed; no such claim is made.

### Conclusion

FR-044 IMPLEMENTED_PROVEN: Spa exists as separately owned, purchasable, persisted and projected VIP-only infrastructure, without a normal-wave need or Worker slot.


## FR-045 — MVP Spa dependency

- **Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 308; canonical SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`. At least two of four VIP types must have Spa-dependent attainable request quality.
- **Verdict:** PASS. **Disposition:** IMPLEMENTED_PROVEN.

### Verified source identities

- `src/core/vipPreview.ts` SHA-256 `3246259bb320ec7a9426c5ed44a2336580f2a7f326d583517018266d1dd3e7a2`.
- `src/core/fr045SpaVipQuality.test.ts` SHA-256 `ab525317808f37c2cd320e2502f2ca7addf96b7a8f7283ba41c331fa448f5f63`.
- `src/core/fr038VipPreviewInfo.test.ts` SHA-256 `65f9ac7a67b58beb75b8b84b1bb6af5d9de1fb23686fb15d17dea1ca0ceffb42`.
- `src/core/fr039VipPreparedness.test.ts` SHA-256 `b2e18bacad2f152386d111fc88bb2801df0086a4aa49522a6b1832a54b5da3f8`.
- `src/core/fr041VipRosterCeiling.test.ts` SHA-256 `c979ed78ecd94311ec52d6fb030cceb86717f0a1389550020d7d9feaab9a352d`.
- `src/core/vipLayer.ts` SHA-256 `c1f20162664b3bbd170c16e40cd444e62ac50db60d863b1688ad333fcbf20905`.
- `src/core/state.ts` SHA-256 `ede5ebc8b9843fd3e6ea5904f83d29b7a10815c44bee69e4ea21879a45832b88`.

### Behavioral proof

- `MVP_VIP_TYPES` contains exactly four types. `MVP_VIP_PREVIEW_PROOF_CATALOG` selects `weddingCouple` and `influencer` as Spa-dependent, with `travelBlogger` and `investor` independent. These profile pairings are provisional design selections, not fixed by the canonical requirement.
- Core-owned `vipBuildings.spa` feeds the typed VIP building prerequisites in `deriveMvpVipPreviewInfo`; when Spa is unavailable to a dependent VIP type, `buildingGaps` contains `Spa`. The existing `mvpVipAttainableQualityCeiling` strictly reduces its possible quality. With all other prerequisites met, absence gives 4 and presence gives 5 on the provisional quality scale; `capMvpVipQuality(5, preparedness)` enforces the same ceiling.
- Spa ownership has no effect on preparedness or attainable quality for either independent VIP type. Purchasing Spa does not change normalWave, purchasedAreas or hiredSpecialists.
- `BEGIN_VIP_VISIT` captures preparedness once; purchasing Spa during an active visit does not retroactively improve its quality ceiling. Persistence hydration preserves that snapshot; a subsequently started visit reflects the now-built Spa.
- Historical fully-prepared FR-038, FR-039 and FR-041 test fixtures now correctly provide Spa ownership for dependent VIP profiles while retaining their exact readiness, quality and persistence assertions.
- **Test evidence:** `rrh:resort-empire-web-bootstrap-v2:a1384:0:bdb75184` records CAS-guarded fixture updates. `rrh:resort-empire-web-bootstrap-v2:a1384:1:4d766f15` records FR-045 dedicated 7/7 PASS, historical VIP regressions 40/40 PASS, full Vitest 218/218 PASS across 58 files, TypeScript noEmit PASS and Vite build PASS.
- **Scope:** The 1–5 quality scale and magnitude of its missing-building penalty are provisional tuning, not canonical fixed values. No independent interactive-browser observation is claimed.

### Conclusion

FR-045 IMPLEMENTED_PROVEN: at least two of the four VIP types have a genuine Spa-dependent request-quality ceiling, with preserved visit-start snapshots, persistence and normal-wave isolation.


## FR-046 — VIP rewards

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN
**Canonical authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 309, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.
**Binding:** VIP completion shall produce a larger reward spike than an ordinary wave, with Reputation primary; Coins, Energy, Materials, Resort Value and decor are optional secondary awards, not mandatory simultaneous payouts. Ordinary waves must remain economically relevant.

**Implementation:** `BootstrapState.reputation` is a pure-core, persistent resource separate from non-spendable Resort Value. `settleMvpVipCompletion` settles only a new active-to-completed visit, both from `ADVANCE_SIMULATION` and `VIP_SPEED_UP`, using the immutable visit-start preparedness snapshot and the VIP preview provisional Reputation range. `lastVipReward` records actual receipt and quality; no repeat tick can reaward a completed visit. Ordinary wave completion continues to award rating- and throughput-dependent Coins and Energy and a smaller rating-based Reputation amount. The React HUD and VIP panel project actual core balances/receipts; preview now truthfully reports implemented awards. Legacy snapshots normalize missing Reputation to zero and missing receipt to null, without retrospectively rewarding historical completions. No secondary VIP resources are claimed as implemented. Exact numeric reward values are provisional tuning, not a FINAL(3) mandate.

**Source identities:**
- `src/core/state.ts` SHA-256 `4fcd9e65fb8bb566c8b0b15a44acb36d9fc25710573b066c2fedd486fc152a70`
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `bb2aca719debe7d7b727cb069ed7078936140e31dfeed3435529ae3c2c2830a9`
- `src/app/App.tsx` SHA-256 `9013ba04dc8dd18ba4568789ef7d560ac505d17979ccae16c54d7b6d8823fc98`
- `src/core/vipPreview.ts` SHA-256 `fbc3305c235d66b1b23992a10e3a363663d232f3280c6e5f4a69aca2f1e30c39`
- `src/core/fr038VipPreviewInfo.test.ts` SHA-256 `73e22752297fa0dc27ec98265513ce16d16e80ed4c61ff679442492618f6e01b`
- `src/core/fr046VipRewards.test.ts` SHA-256 `74a3b796442a9e73146b390d1f97f7cc771af14f8e7b64d13cb92beb16d79bac`

**Execution evidence:** `rrh:resort-empire-web-bootstrap-v2:a1394:0:f0cdf7b3` guarded core/persistence mutation; `rrh:resort-empire-web-bootstrap-v2:a1397:0:d219895e` guarded UI/preview update; `rrh:resort-empire-web-bootstrap-v2:a1398:0:e3d04f1f` test fixture validation; `rrh:resort-empire-web-bootstrap-v2:a1398:1:aba1331e` independent final execution. Dedicated FR-046 7/7 PASS; combined FR-046 and FR-038 16/16 PASS; full Vitest 225/225 PASS across 59 files; TypeScript noEmit PASS; Vite production build PASS. Behavioral tests cover the quality-sensitive spike, normal and speed-up completion, idempotence, immutable prerequisites, persisted receipt roundtrip, no historical back-pay and ordinary-wave economic relevance.

**Final disposition:** IMPLEMENTED_PROVEN.

## FR-047 — Resort Value

**Verdict:** PASS
**Disposition:** IMPLEMENTED_PROVEN
**Authority:** `RESORT_EMPIRE_REQUIREMENTS_FINAL(3).md`, physical line 310, SHA-256 `50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de`.
**Canonical obligation:** Resort Value represents non-spendable resort prestige/status and shall only increase.

**Implementation:** `BootstrapState.resortValue` is pure-core prestige projected in the React HUD and result panel, not a spendable balance. Successful `UPGRADE_BUILDING` deducts Coins and adds a strictly positive prestige gain. Prototype upgrade quotes reject negative, zero, nonfinite and unsafe persisted gain tuning by using the known-positive provisional fallback. The upgrade reducer rejects negative/unsafe starting prestige and numeric overflow rather than committing a decreasing or invalid value. The persistence normalizer repairs malformed prestige to the initial value while retaining valid nonnegative safe-integer prestige and ordinary state progress. Other purchases and simulation do not spend prestige. Numeric gain constants remain provisional tuning.

**Verified source SHA-256:**
- `src/core/state.ts` SHA-256 `dc9e29839b6f2fb7c78139b365a0ff309eb63f821d73f8b89b0023aa878d3142`
- `src/persistence/DexieBootstrapPersistence.ts` SHA-256 `c3fb51e34c611870c495894b81952d6e7ad3d7ff841cadd1e546b83882479998`
- `src/core/fr047ResortValue.test.ts` SHA-256 `aa09f5efbb0534be4ec0927c002dad5d3342065d716ab731637db0eef3496477`

**Host execution evidence:** `rrh:resort-empire-web-bootstrap-v2:a1405:0:7b68e217` guarded implementation; `rrh:resort-empire-web-bootstrap-v2:a1406:0:c126fcc4` independently verified the three file identities; `rrh:resort-empire-web-bootstrap-v2:a1406:1:98f0ad2` independently ran FR-047 targeted tests PASS, complete Vitest PASS across 60 test files, TypeScript noEmit PASS and Vite production build PASS. Deterministic FR-047 tests cover prototype and MVP upgrade levels, separation of Coins expenditure from prestige, malformed saved gain tuning, invalid persisted prestige and overflow/negative reducer inputs.

**Final disposition:** IMPLEMENTED_PROVEN.
