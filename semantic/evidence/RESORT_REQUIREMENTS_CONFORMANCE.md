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
