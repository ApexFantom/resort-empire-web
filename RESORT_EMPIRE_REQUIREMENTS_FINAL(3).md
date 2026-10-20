# Resort Empire: Paradise Tycoon — Requirements Analysis

**Deliverable:** `RESORT_EMPIRE_REQUIREMENTS.md`  
**Project:** UKF Software Engineering team project for Red Riding Hood Games  
**Evidence base:** bounded RRH authority corpus S1–S6  
**Status:** evidence-grounded coursework synthesis; unresolved client decisions are preserved as questions rather than invented requirements.

# Part I — Semantic Evidence Layer

## 1. Source and authority map

| Source | Role | Authority treatment |
|---|---|---|
| **S1 — RRH presentation** (`xResort Empire — MVP v kocke.pptx`) | High-level client product intent / pitch | Authoritative for product vision, player promise, broad phase split, and high-level constraints. |
| **S2 — Game Design Document, Version IV** | Current game-design overview | Authoritative overview. It explicitly delegates detailed phase/specification truth to companion documents. |
| **S3 — Build Document: Prototype → MVP, Version IV** | Detailed phase, mechanics, state-machine, economy-structure, acceptance source | **Primary detailed authority** for Prototype/MVP scope, hard gameplay rules, phase boundaries and acceptance criteria. Values marked `e.g.` or `TUNING` are not hard requirements. |
| **S4 — UI Screens Handoff** | UI/UX behavioral and screen-contract source | Authoritative for current interaction contracts where consistent with its stated upstream authority (Build + First Session Walkthrough). Obsolete Version III normal-guest Request Board behavior is superseded. |
| **S5 — Course lecture notes** | Coursework/process evidence only | Used to structure the requirements-engineering deliverable and distinguish FR/NFR. **Not product authority.** |
| **S6 — Figma reference + supplied canvas screenshot** | Partial visual evidence | The Figma URL is known and a canvas-level screenshot supplied in chat was reviewed. It confirms high-level presence/composition of S1, S2, S3, S4, S5, S6, S7 and S9, but does not provide full-resolution text or S8 coverage. It is treated as visual evidence, not as authority overriding current Build/UI Handoff documents. |

### Authority rules used

1. S1–S4 may support product requirements; S5 may not.
2. S3 is preferred for detailed phase/mechanics truth when a higher-level source is less specific.
3. S4 governs current UI/interaction behavior unless it contradicts its own upstream authority.
4. Explicit conflicts are recorded rather than silently harmonized.
5. `e.g.`, illustrative, `TUNING`, `OPEN`, and proposed values are not promoted to hard requirements.
6. Later/current version statements supersede obsolete Version II/III behavior only where the documents explicitly support that interpretation.

## 2. Prototype / MVP / Later scope map

| Phase | In scope |
|---|---|
| **Prototype** | Core wave loop; one normal guest type represented as aggregate demand; five wave buildings/needs by the end of the phase; anonymous Worker allocation; Pool and Bungalows unlocks; building levels 1–3; Coins, Energy, Resort Value; Sudden Rush; S1–S5 + S9; 8 scripted prototype waves for playtest coverage. |
| **MVP** | Validated Prototype core plus VIP layer; four VIP types; Managers and Specialists; additional Worker hiring with scarcity; building levels 4–5; Spa as VIP building; Reputation; Materials; Gems; voluntary monetization hooks; S6–S8; MVP progression/content layers. |
| **Later / post-MVP** | Additional guests/buildings/content, broader events, seasons, club/social/live-ops and soft-launch preparation. These are intentionally undefined until MVP data exists. |
| **Cross-phase** | Mobile landscape; calm/non-reflex experience; no inactivity punishment; aggregate management for normal guests; visible cause/effect; optional Energy; 5★/Perfect achievable without payment/Energy; wave state persistence; growth visible in the resort. |

### Scope discipline

Prototype is intentionally a feel-validation build, not an economy, retention, monetization or VIP validation build. The complete 8-wave prototype playtest may take 12–20 minutes; this is explicitly a testing artifact and does not replace the product target of a 3–7 minute normal session.

## 3. Epistemic classification

- **A — client explicit:** directly stated in S1–S4.
- **B — course/task framing:** assignment/process information from S5.
- **C — strong inference:** necessary implication strongly supported by client evidence.
- **D — team proposal / assumption:** idea or implementation proposal not established as client truth.
- **E — open question:** unresolved item requiring RRH clarification.

Only **A** and defensible **C** may enter the final FR/NFR list. In the sealed reconciliation used for this deliverable, every final FR/NFR is supported by Class A client evidence; no C-only requirement is needed.

## 4. Canonical requirement ledger

The extraction ledger (CR-001…CR-200) was reconciled into the following canonical product-obligation clusters. Each row preserves phase, provenance and epistemic class; examples/tuning values were stripped from hard truth.

| Canonical ID | Phase | Canonical obligation | Primary provenance | Class |
|---|---|---|---|---|
| CAN-FR-001 | Prototype / Cross | Wave lifecycle: awaiting/preparation → incoming/active → resolving/drain → complete/result → optional upgrade → next awaiting state; demand is progressively released. | S1-SLIDE-08; S3-P0037–P0055 | A |
| CAN-FR-002 | Cross | Normal guests are aggregate demand; the player manages the resort system rather than individual normal guests. | S1-SLIDE-07,11; S2-P0040; S3-P0076; S4-P0010–P0011 | A |
| CAN-FR-003 | Prototype / Cross | Each need is served with finite simultaneous capacity; excess demand waits in a queue; active service is distinct from waiting. | S3-P0060–P0072 | A |
| CAN-FR-004 | Prototype / Cross | The game exposes bottlenecks and recovery at aggregate service level and makes staffing vs capacity causes distinguishable. | S1-SLIDE-09; S3-P0092–P0100, P0194–P0199; S4-P0077–P0108 | A |
| CAN-FR-005 | Prototype / Cross | Arrival timer ends new arrivals only; unresolved queues drain; normal guests do not leave during an active wave. | S3-P0063–P0067, P0086–P0090, P0200–P0201 | A |
| CAN-FR-006 | Prototype / Cross | Wave Satisfaction derives from accumulated waiting history; no live numeric satisfaction/patience countdown; post-wave dissatisfaction is informational, not an extra penalty. | S3-P0074–P0090; S4-P0081, P0112–P0115 | A |
| CAN-FR-007 | Prototype / Cross | Normal-wave rating has a non-zero floor and must distinguish poor from competent play; exact thresholds remain tuning. | S3-P0081–P0084; S4-P0116 | A |
| CAN-FR-008 | Cross | Post-wave results explain what went well/needs improvement and connect a suggested optional upgrade to the observed bottleneck. | S1-SLIDE-07–09; S2-P0048; S3-P0206; S4-P0110–P0126 | A |
| CAN-FR-009 | Prototype / Cross | Closing/backgrounding during a wave freezes and persists exact wave state; no offline wave advance. | S1-SLIDE-08; S3-P0044, P0051, P0192, P0205; S4-P0076 | A |
| CAN-FR-010 | Cross | Primary income comes from completed waves, not passive building ticks; structural Coin reward is volume × per-unit value × rating modifier. | S1-SLIDE-05; S2-P0020, P0040; S3-P0177–P0183 | A |
| CAN-FR-011 | Prototype / Cross | An eligible but unpurchased area may remain deferred, and its need must not spawn until the area is bought. | S3-P0054, WR9, P0183–P0185; S4-P0071, P0163–P0168 | A |
| CAN-FR-012 | Prototype / Cross | Before a wave, the player sees the upcoming needs/demand forecast sufficiently to prepare Worker placement. | S3-P0046, P0114–P0117; S4-P0072 | A |
| CAN-FR-013 | Prototype / Cross | A newly introduced need debuts softly and established needs do not simultaneously increase in that debut wave; exact ratio is tuning. | S2-P0064; S3-P0161–P0163, P0209 | A |
| CAN-FR-014 | Prototype | Prototype staff consists only of anonymous interchangeable Workers; one Worker slot per wave building; Workers are always assigned and fewer than buildings. | S2-P0043, P0070; S3-P0034–P0035, P0104–P0111 | A |
| CAN-FR-015 | Prototype / Cross | Workers can be reassigned among eligible normal-wave buildings before and during waves, free and immediate, without confirmation. | S2-P0043; S3-P0106, P0114, P0119–P0120; S4-P0092–P0100 | A |
| CAN-FR-016 | Prototype / Cross | A staffed building runs at staffed performance; an unstaffed building remains operational but slower; movement changes current service immediately and visibly. | S2-P0043–P0045; S3-P0073, P0106–P0120; S4-P0104–P0108 | A |
| CAN-FR-017 | Prototype / Cross | Worker assignments persist between waves; a Worker bundled with a newly unlocked normal building starts on that building. | S3-P0112–P0116; S4-P0100 | A |
| CAN-FR-018 | MVP | Worker slots limit occupancy; Workers can move to already staffed buildings only when a slot is free; Workers are never kept unassigned. | S3-P0265, P0269–P0272 | A |
| CAN-FR-019 | MVP | Total Workers remain below total slots; additional Workers are hired for Coins only between waves and placed directly into a free slot. | S3-P0267–P0274; S4-P0125 | A |
| CAN-FR-020 | MVP | Additional Workers on the same building have diminishing marginal effect; exact curve is tuning. | S3-P0266 | A |
| CAN-FR-021 | MVP | Managers are named building-linked specialists, hired once for Coins between waves; they multiply building performance but are never required for building operation. | S2-P0044; S3-P0250–P0255 | A |
| CAN-FR-022 | MVP | Specialists are named VIP roles without wave buildings, hired for Coins; they do not affect ordinary-wave performance. | S2-P0046; S3-P0232, P0250–P0252 | A |
| CAN-FR-023 | MVP | Building level, Worker allocation and Manager/Energy modifiers form distinct nonredundant control layers. | S2-P0067; S3-P0240–P0262 | A |
| CAN-FR-024 | Prototype | Prototype wave buildings have three levels; upgrades change capacity only, not Worker slots, quality or base service speed. | S3-P0186–P0190; S4-P0123 | A |
| CAN-FR-025 | MVP | Five normal wave buildings extend to Lv1–5; Lv4 adds Worker slot/quality without extra capacity; Lv5 adds capacity, slot and quality. | S3-P0275–P0281 | A |
| CAN-FR-026 | Cross | Permanent building upgrades occur between waves only; no permanent upgrade/construction-timer action is available mid-wave. | S2-P0067; S3-P0282–P0286; S4-P0070 | A |
| CAN-FR-027 | Cross | Energy is optional assistance, never a participation/progression gate; zero Energy does not block service, waves or Worker movement. | S1-SLIDE-12; S2-P0054; S3-P0008–P0010, P0259–P0262 | A |
| CAN-FR-028 | Cross | A fully prepared resort can achieve the highest normal-wave rating without Energy. | S1-SLIDE-09; S2-P0054; S3-P0008, WR8 | A |
| CAN-FR-029 | Prototype / MVP | Wave Energy Mode A temporarily increases service speed of one building and does not increase capacity; it works during arrival and drain. | S3-P0141–P0148, P0262; S4-P0083 | A |
| CAN-FR-030 | Cross | Energy is earned from completed gameplay and optional rewarded video; it does not regenerate offline. | S2-P0054; S3-P0010, P0146–P0148 | A |
| CAN-FR-031 | Prototype | Prototype Energy storage is uncapped; later cap activation is an MVP tuning/open item. | S3-P0148; S3-P0333 | A |
| CAN-FR-032 | Prototype | Sudden Rush is extra demand inside the normal wave, does not pause the wave, always has Worker movement as a valid primary response, is not forecast, and is solvable without Energy. | S3-P0133–P0140, P0210; S4-P0173 | A |
| CAN-FR-033 | MVP | MVP VIP flow consists of Preview → Request Board → VIP Complete while the normal-wave core remains active. | S1-SLIDE-11–13; S3-P0230, P0303–P0314; S4-P0128–P0157 | A |
| CAN-FR-034 | MVP | VIP participation is optional and parallel; Accept / Maybe later / Decline are available without punishment. | S1-SLIDE-11; S2-P0050; S3-P0304–P0305; S4-P0131–P0134 | A |
| CAN-FR-035 | MVP | Before acceptance the game presents readiness information, including relevant building/role gaps and their quality impact. | S3-P0310; S4-P0132–P0137 | A |
| CAN-FR-036 | MVP | VIP preparedness is not Worker allocation; the Request Board uses Fix for consumable gaps and Speed Up with Energy where applicable. | S3-P0012, P0307–P0314; S4-P0141–P0148, P0187 | A |
| CAN-FR-037 | MVP | Consumable missing resources are immediately repairable; roster/building gaps lower request quality ceiling instead of blocking the request. | S2-P0052; S3-P0308–P0310; S4-P0142–P0143 | A |
| CAN-FR-038 | MVP | VIP request cards use MISSING, READY, IN_PROGRESS and COMPLETED states; quality cap is an attribute, not a separate state. | S3-P0313; S4-P0148 | A |
| CAN-FR-039 | MVP | Managers/Specialists are reusable roster prerequisites for VIP requests; missing required roles lower attainable quality. | S2-P0046, P0052; S3-P0310 | A |
| CAN-FR-040 | MVP | MVP contains four VIP types: Travel Blogger, Wedding Couple, Investor and Influencer. | S1-SLIDE-11; S2-P0050; S3-P0239 | A |
| CAN-FR-041 | MVP | Spa is a VIP-oriented building with no normal-wave need and no Worker slot; its absence may reduce quality for Spa-dependent VIP requests. | S1-SLIDE-10; S3-P0232, P0311; S4-P0169 | A |
| CAN-FR-042 | MVP | At least two of the four VIP types must contain a Spa-dependent request. | S3-P0311 | A |
| CAN-FR-043 | MVP | The five normal-wave need types remain unchanged in MVP; VIP uses requests rather than additional normal needs. | S3-P0239, P0306–P0307 | A |
| CAN-FR-044 | MVP | VIP completion gives a larger reward spike; Reputation is primary, with Coins/Energy/Materials/Resort Value and possible decor, without devaluing normal waves. | S2-P0050; S3-P0312; S4-P0155–P0156 | A |
| CAN-FR-045 | Cross | Resort Value is a non-spendable prestige/status measure that only increases. | S1-SLIDE-12; S2-P0057; S3-P0315–P0318 | A |
| CAN-FR-046 | MVP | Reputation is cumulative, never spent/decreased, and unlocks content via thresholds. | S1-SLIDE-12; S2-P0058–P0059; S3-P0315–P0318 | A |
| CAN-FR-047 | Prototype / MVP | Unlocking is two-step: an eligibility gate makes content available and Coins purchase it; Prototype uses milestones, MVP uses Reputation thresholds. | S2-P0059; S3-P0015, P0184–P0185, P0318; S4-P0163 | A |
| CAN-FR-048 | MVP | Materials are used as consumables for VIP Fix and together with Coins for Lv4–5 building upgrades. | S2-P0062; S3-P0279, P0319–P0320 | A |
| CAN-FR-049 | MVP | Materials are earned from completed VIP play and may also drop from sufficiently high-rated normal waves; exact amounts/thresholds are tuning. | S3-P0320 | A |
| CAN-FR-050 | MVP | Gems are reserved for permanent premium purchases and cannot accelerate gameplay or convert to Energy. | S2-P0062; S3-P0320–P0321 | A |
| CAN-FR-051 | MVP | Rewarded-video/IAP hooks are voluntary and must not punish nonpayment; exact placements and SKUs are not hard requirements. | S3-P0322–P0326 | A |
| CAN-FR-052 | MVP | Paid staff convenience cannot bypass the Worker population cap. | S3-P0325 | A |
| CAN-FR-053 | Prototype | Prototype economy exposes Coins and Energy plus Resort Value status; Reputation, Materials and Gems are absent. | S1-SLIDE-10,12; S3-P0034–P0035; S4-P0067 | A |
| CAN-FR-054 | Prototype | Prototype starts with Reception/Restaurant/Beach Bar serving Rooms/Food/Drinks; Pool unlock adds Relax after Wave 3; Bungalows adds Ocean View after Wave 6. | S2-P0064; S3-P0034, P0125; S4-P0161 | A |
| CAN-FR-055 | Prototype / Cross | Starting a wave automatically opens/exposes the Wave Needs Panel. | S4-P0057 | A |
| CAN-FR-056 | Prototype | Wave Needs Panel is a side panel over/alongside the island and must accommodate 3→4→5 visible needs without becoming a dense table. | S4-P0022, P0077–P0091 | A |
| CAN-FR-057 | Prototype / Cross | Worker Allocation is a modal/bottom sheet that returns to the context from which it was opened. | S4-P0022, P0058, P0092–P0100 | A |
| CAN-FR-058 | Prototype | Upgrade Suggestion shows the proposed building, before/after capacity, Coin price and Resort Value gain. | S4-P0119–P0124 | A |
| CAN-FR-059 | Prototype | Prototype building upgrades cost Coins only. | S3-P0186–P0187; S4-P0124 | A |
| CAN-FR-060 | MVP | The investment surface presents distinct alternatives for building upgrade, Hire Manager and Hire Worker. | S3-P0251; S4-P0125 | A |
| CAN-FR-061 | MVP | VIP Preview shows a potential reward range consistent in scale with the actual VIP completion reward. | S4-P0132–P0133 | A |
| CAN-FR-062 | Prototype / MVP | Area Unlock supports locked / available / not affordable / unlocked states; an available deferred unlock can be reopened; Prototype communicates new content, included Worker and Coin price. | S3-P0054, P0184–P0185; S4-P0159–P0169 | A |
| CAN-FR-063 | MVP | Home VIP panel is conditional and secondary, appearing only when a VIP is waiting. | S4-P0075, P0186 | A |
| CAN-FR-064 | Prototype / Cross | Reception/Rooms and Bungalows/Ocean View have distinct semantics: standard accommodation vs premium ocean-view experience. | S2-P0064; S3-P0126 | A |
| CAN-FR-065 | Cross | Inactivity cannot degrade the resort or reduce progression. | S1-SLIDE-06–07; S2-P0061 | A |
| CAN-FR-066 | Cross | Return after inactivity provides a fixed comeback reward rather than a reward proportional to elapsed time. | S2-P0061 | A |

### Canonical non-functional clusters

| Canonical ID | Phase | Constraint / quality | Primary provenance | Class |
|---|---|---|---|---|
| CAN-NFR-001 | Cross | The product targets mobile landscape orientation. | S1-SLIDE-05; S4-P0014–P0015 | A |
| CAN-NFR-002 | Cross | A normal production session should be a closed 3–7 minute experience, usually one or two waves plus one investment. | S1-SLIDE-05,07; S2-P0018, P0037; S4-P0017 | A |
| CAN-NFR-003 | Cross | Interaction must feel calm and managerial rather than reflex/stress based. | S1-SLIDE-06–07; S2-P0014, P0020; S4-P0019 | A |
| CAN-NFR-004 | Cross | Each screen/focused surface must present one clear primary action. | S1-SLIDE-13; S4-P0018 | A |
| CAN-NFR-005 | Cross | Growth and operational state must be visually legible; important structural differences must be understandable on mobile. | S1-SLIDE-06–07; S3-P0127–P0130; S4-P0084–P0085 | A |
| CAN-NFR-006 | Cross / MVP | The UX must avoid aggressive upgrade/payment pressure and coercive monetization patterns. | S1-SLIDE-06,15; S4-P0126; S3-P0326 | A |
| CAN-NFR-007 | Cross | Returning after inactivity must feel positive rather than punitive. | S1-SLIDE-06–07; S2-P0015, P0061 | A |
| CAN-NFR-008 | Cross | Information density must remain bounded; the UI must not become a dense spreadsheet and must not force warnings/CTAs when no problem exists. | S2-P0020; S3-P0192; S4-P0073, P0079, P0091 | A |

## 5. Duplicates, supersession and reconciliation

### Explicit supersession

- **Normal-guest Request Board (Version III) → superseded.** Current S3/S4 authority makes normal guests aggregate wave demand and reserves the Request Board for VIP only.
- **Named staff in Prototype → superseded.** Current Prototype contains anonymous Workers only; Managers/Specialists enter in MVP.
- **Shared S3 Worker Allocation for VIP → rejected as an editorial inconsistency.** S4-P0196 says S3 is shared across wave/VIP, but S4-P0187 plus detailed S3 authority explicitly say S3 is ordinary-wave only and VIP uses preparedness/Fix/Speed Up.
- **Older service-speed assumptions → tuning/example only.** Current Build hard rules govern structure; illustrative `6 s`, `12 s`, percentages and prices do not become fixed requirements.

### Major duplicate families merged

Repeated client statements about aggregate normal guests, optional Energy, no inactivity punishment, visible cause/effect, two-step unlocks, Worker scarcity, VIP optionality, VIP preparedness, non-spendable Resort Value, cumulative Reputation and current Prototype/MVP screen scope were merged into the canonical clusters above rather than duplicated as separate product truths.

## 6. Conflicts / inconsistencies

### CF-001 — VIP acceptance eligibility — **OPEN**

Evidence is asymmetric:

- S2-P0052: the player can always accept a VIP; roster/building shortages reduce attainable quality.
- S4-P0136: `Risky` means it is still possible, but with a lower quality ceiling.
- S4-P0138: says that if a VIP *cannot* be accepted, e.g. because of insufficient capacity, that must not feel punitive.

The detailed repeated model favors **non-blocking degradation**, but S4-P0138 introduces a possible acceptance-block condition that is not defined elsewhere. The final requirements therefore do **not** invent a capacity-block rule. RRH clarification is required.

### CF-002 — S3 Worker Allocation shared with VIP — **resolved by authority**

S4-P0196 broadly lists S3 as shared across wave/VIP, but S4-P0187 explicitly states that S3 is only for normal waves, and S3 detailed Build authority defines VIP preparedness through Fix/Speed Up rather than Worker allocation. The detailed current rule is used; P0196 is treated as an editorial summary inconsistency.

## 7. OPEN / TUNING items

The following are deliberately **not** hard-coded into the final FR/NFR list:

1. **VIP acceptance edge case** — whether any condition can make a VIP unaccept-able (CF-001).
2. **VIP rating thresholds** — old VIP scale vs current normal-wave scale.
3. **Coin balancing** — final coefficients/prices so upgrades and unlocks land on intended pacing.
4. **Energy Mode B in normal waves** — explicitly open; VIP READY-stage compensation exists, but no hard normal-wave Mode B requirement is admitted.
5. **Final Worker hiring cap ratio** — scarcity is hard; exact ratio (e.g. 80%) is tuning.
6. **Spa progression** — number of levels and exact effects.
7. **Reputation milestones**.
8. **Manager / Specialist / Worker prices**.
9. **Materials drop rates and amounts**.
10. **Satisfaction curve and exact star thresholds**.
11. **Energy cap activation in MVP**.
12. **Prototype wave/service parameters** such as exact arrival duration, service time, empty utilization, hysteresis and demand tables.
13. **Exact upgrade/unlock prices**, reward coefficients and worked-example numbers.
14. **Exact Sudden Rush timing/amount**, Energy cost/duration/magnitude.
15. **Exact visual mapping** such as colors, icons, animation choices and dissatisfied-guest counts.

## 8. Unsupported assumptions explicitly excluded

This deliverable does **not** claim any of the following unless RRH supplies additional evidence:

- Exact Figma layout, colors, typography, spacing or component geometry.
- A hard fixed total wave duration.
- Individual tracking, control, patience bars or per-guest rating for normal guests.
- Passive/offline Coin income.
- Offline Energy regeneration.
- Mid-wave permanent construction/upgrades.
- Mandatory Energy, payment or rewarded ads to complete core play or achieve 5★/Perfect.
- Prototype VIP, Reputation, Materials, Gems, IAP, Manager/Specialist systems or staff rarity.
- A sixth normal-wave `Spa/Wellness` need in MVP.
- Manager/Specialist rarity/collection/leveling in current MVP.
- Fixed numerical tuning values merely because they appear in examples.
- Event hub, season pass, club/social or post-MVP systems as current requirements.
- Any product rule derived only from S5 lecture reconstruction.

## 9. Figma visual-evidence status

A supplied canvas-level Figma screenshot has now been reviewed. It closes the previous **"Figma not seen at all"** gap at the high-level screen/composition level:

- visible frames include **S1, S2, S3, S4, S5, S6, S7 and S9**;
- the screenshot supports the broad surface hierarchy (island/home, side needs panel, staff/allocation modal, result screen, upgrade suggestion, VIP preview, VIP request board and area unlock);
- **S8 VIP Complete is not visibly covered** in the supplied screenshot;
- the screenshot is not high-resolution enough to treat all small text, numeric values or component-level details as verified;
- some frames appear to reflect an older interaction model (notably named **Assign Staff** treatment around S3/VIP), so current S3/S4 document authority still governs behavior;
- visible economy mock values appear inconsistent with the current Build pacing (for example an approximately `120`-Coin wave reward beside approximately `1,200`-Coin upgrade pricing). These values are therefore treated as mock/obsolete until RRH confirms otherwise.

Figma visual evidence is therefore **partially covered, with explicit version/economy drift**, rather than absent.


## 10. Acceptance evidence retained separately from requirements

The Build document contains validation evidence / exit criteria that are useful for testing but are not copied verbatim into the FR/NFR list:

- **AC-001:** `wave_sim.py` must show no WR7/WR8 violation before Prototype playtest.
- **AC-002:** player identifies a bottleneck and moves a Worker before being explicitly told.
- **AC-003:** Worker allocation is a meaningful choice, not a trivial lookup.
- **AC-004:** player distinguishes understaffed vs undersized building and selects Worker move vs upgrade accordingly.
- **AC-005:** player understands ordinary guests as aggregate system demand.
- **AC-006:** wave completion + upgrade feels satisfying rather than obligatory; player can explain what to improve next.
- **AC-007:** Pool and Bungalows unlocks create desire to continue.
- **AC-008:** MVP core remains engaging after several waves.
- **AC-009:** VIP feels like an opportunity/spike, not interruption or punishment.
- **AC-010:** monetization hooks fit without punishing nonpayment.
- **AC-011:** return after inactivity is positive and does not show degradation.
- **AC-012:** player can explain why they want to return.

## 11. Source-coverage audit

Coverage is sufficient for this coursework deliverable because:

- **S1** was used for the product promise, platform/session target, player experience, broad loop, phase framing, VIP concept, currencies and growth direction.
- **S2** was used through its current Version IV overview, including core loop, staff, upgrades, VIP, Energy, prestige/Reputation, inactivity and current decision status.
- **S3** was used through the end of the Prototype and MVP Build sections, including state machines, hard wave rules, Worker/Manager/Specialist model, upgrades, VIP preparedness, economy roles, monetization boundaries, exit criteria and remaining open points.
- **S4** was used across the current S1–S9 interaction contract, including obsolete Version III supersession, normal vs VIP paradigms, navigation, Worker UI, result/upgrade flows, VIP flows, Area Unlock and phase summary.
- **S5** was used only to shape the coursework output and requirements-engineering method.
- **S6** is explicitly recorded as a missing visual source rather than silently inferred.

The candidate extraction closed at **CR-001…CR-200**, and reconciliation accounted for the entire candidate set across four domain passes. Acceptance evidence, conflicts, open/tuning values and non-requirements were kept separate. No known unprocessed current Prototype/MVP product domain remains in S1–S4.

# Part II — Final Coursework Output

## 12. Scope statement

`Resort Empire: Paradise Tycoon` is a mobile landscape casual resort-management game in which the player actively manages aggregate guest demand in discrete waves, diagnoses service bottlenecks, reallocates scarce Workers, earns results/rewards and invests in permanent resort growth. The Prototype validates the normal-wave management feel and two area unlocks. The MVP layers VIP preparedness, named staff, Spa, expanded progression/currencies and voluntary monetization onto the validated core. Post-MVP live-ops/content expansion is outside the current requirement baseline.

The requirements below intentionally state **behavior and constraints supported by current client evidence**. Exact balancing values and unresolved design choices are excluded and appear in the RRH question list.

## 13. Functional Requirements

This pass uses **no target requirement count**. Requirements are grouped only when they share one semantic owner and one practical verification subject. They are split when a single statement would otherwise contain independently failing obligations. The `Previous baseline` column preserves traceability to the earlier 121-item atomic baseline where applicable.

| ID | Phase | Domain | Requirement | Previous baseline | Traceability |
|---|---|---|---|---|---|
| FR-001 | Cross | Wave lifecycle | The system shall structure normal gameplay as player-started guest waves that move through preparation, arrival/active service, drain/resolution and completion/result states. | old FR-001–FR-004, FR-016 | S1-SLIDE-08; S2-P0040; S3-P0037–P0055 |
| FR-002 | Prototype / Cross | Demand arrival | Normal-wave demand shall be released progressively during the arrival phase rather than appearing all at once. | old FR-005 | S3-P0060–P0065 |
| FR-003 | Prototype / Cross | Wave drain | When the arrival period ends, only new arrivals shall stop; the wave shall continue until outstanding queues are cleared, with Worker reassignment and applicable Energy actions still available during drain. | old FR-013–FR-015 | S3-P0050–P0052, P0063–P0067, P0200–P0201; S4-P0082; WR3 |
| FR-004 | Cross | Normal guest model | Normal guests shall be represented and managed as aggregate demand rather than individually controlled service entities. | old FR-006 | S1-SLIDE-07,11; S2-P0040; S3-P0076; S4-P0010–P0011 |
| FR-005 | Prototype / Cross | Need service model | For each active normal need, the system shall track served, active-service and waiting demand against finite simultaneous service capacity, placing excess demand into a queue. | old FR-007–FR-008 | S3-P0062, P0068–P0072; S4-P0080 |
| FR-006 | Prototype / Cross | Bottleneck state model | The system shall derive and expose normal-need operational states such as BOTTLENECK, RECOVERING and SATISFIED from queue/service conditions. | old FR-009–FR-012 | S3-P0092–P0100; S4-P0088–P0089 |
| FR-007 | Prototype / Cross | Bottleneck diagnosis | The player shall be able to distinguish a staffing shortage from insufficient building capacity when either causes a growing queue. | old FR-116 | S3-P0029, P0199; S4-P0102–P0104, P0189 |
| FR-008 | Prototype / Cross | Satisfaction model | Normal-wave Satisfaction shall be derived from accumulated waiting time of need units, and a unit shall stop accumulating waiting once service begins. | old FR-017–FR-018 | S3-P0069–P0080, P0195 |
| FR-009 | Prototype / Cross | Non-punitive active wave | During an active normal wave, the system shall not expose per-guest patience countdowns or a live numeric Wave Satisfaction value, and normal guests shall not leave mechanically because of waiting time. | old FR-019–FR-021 | S3-P0085–P0089; S4-P0081; WR4 |
| FR-010 | Prototype / Cross | Wave rating | The normal-wave rating model shall always produce a non-zero completed result while preserving a meaningful distinction between poor and well-managed play. | old FR-022–FR-023 | S3-P0081–P0084; S4-P0116; WR1 |
| FR-011 | Prototype / Cross | Wave result explanation | Wave Complete shall present the achieved rating and Satisfaction outcome and explain both what went well and what needs improvement. | old FR-024–FR-025 | S1-SLIDE-07; S3-P0206; S4-P0110–P0117 |
| FR-012 | Prototype / Cross | Dissatisfaction visualization | Any post-wave depiction of dissatisfied normal guests shall be derived from the aggregate wave result and shall not apply an additional mechanical penalty to future play. | old FR-026–FR-027 | S3-P0088–P0090; S4-P0113 |
| FR-013 | Cross | Active income | Primary Coin income shall come from completed guest-service gameplay rather than passive building ticks. | old FR-028 | S1-SLIDE-05; S2-P0020, P0040 |
| FR-014 | Prototype / Cross | Wave Coin reward | Normal-wave Coin reward shall scale structurally with completed demand volume and rating, and worse or slower play shall not increase the base payable demand volume. | old FR-029–FR-030 | S3-P0177–P0183 |
| FR-015 | Prototype / Cross | Causal investment recommendation | After a wave, the system shall recommend an optional investment linked to the observed bottleneck and shall allow the player to defer it. | old FR-031–FR-032 | S2-P0048; S3-P0042–P0043, P0206; S4-P0120–P0121 |
| FR-016 | Prototype | Starting resort | The Prototype shall start with Reception, Restaurant and Beach Bar serving Rooms, Food and Drinks respectively. | old FR-033–FR-036 | S3-P0034, P0125–P0126 |
| FR-017 | Prototype | Prototype area progression | Completing Wave 3 shall make Pool eligible for purchase and completing Wave 6 shall make Bungalows eligible; purchasing them shall introduce Relax/Ocean View respectively and add one Worker with each building. | old FR-037–FR-038 | S3-P0184–P0185, P0207–P0208 |
| FR-018 | Prototype / Cross | Deferred unlock behavior | A need associated with an eligible but unpurchased area shall not spawn until that area is purchased. | old FR-039 | S3-P0054; WR9 |
| FR-019 | Prototype | Prototype Worker model | Prototype staff shall consist only of anonymous, interchangeable Workers, with one Worker slot per normal-wave building, no unassigned Worker bench and a Worker pool exactly one below the number of normal-wave buildings. | old FR-040–FR-043 | S2-P0043, P0070; S3-P0034, P0104–P0111 |
| FR-020 | Prototype / Cross | Worker reassignment | The player shall be able to reassign Workers among eligible normal-wave buildings before and during waves; reassignment shall be free, immediate and require no confirmation. | old FR-044–FR-047 | S2-P0043; S3-P0106, P0114, P0196; S4-P0096, P0100; WR5 |
| FR-021 | Prototype / Cross | Worker performance effect | Moving a Worker shall immediately change current service performance at both source and destination, including service already in progress. | old FR-048–FR-049 | S3-P0073, P0196–P0197 |
| FR-022 | Prototype / Cross | Worker persistence | Worker assignments shall persist between waves, and a Worker bundled with a newly unlocked normal building shall initially be assigned to that building. | old FR-050 plus canonical CAN-FR-017 | S3-P0112–P0116; S4-P0100 |
| FR-023 | MVP | Managers | MVP shall support named building-linked Managers that are hired once for Coins between waves, multiply the performance of their linked building and are never required for that building to operate. | old FR-051–FR-053 | S2-P0044; S3-P0250–P0255 |
| FR-024 | MVP | Specialists | MVP shall support named Specialists that are hired for Coins between waves, are not attached to normal-wave buildings, do not affect normal-wave service and act as reusable VIP roster prerequisites. | old FR-054–FR-056 | S2-P0046; S3-P0232, P0250–P0252 |
| FR-025 | MVP | Additional Worker hiring | The player shall be able to hire additional Workers for Coins between waves and place each newly hired Worker directly into an available Worker slot. | old FR-057 | S3-P0267–P0270 |
| FR-026 | MVP | Worker scarcity | The system shall preserve Worker scarcity by keeping the total Worker population below total available Worker slots. | old FR-058 | S3-P0271–P0274 |
| FR-027 | MVP | Multi-Worker allocation | Where multiple Worker slots exist, additional Workers may be allocated to an already staffed building, but additional Workers on the same building shall have diminishing marginal effect. | canonical CAN-FR-020 / source detail | S3-P0265–P0270 |
| FR-028 | Prototype | Prototype building progression | Each normal Prototype building shall have three levels, and Prototype upgrades shall change simultaneous service capacity only, without changing Worker-slot count, base quality or base service speed. | old FR-059–FR-062 | S3-P0186–P0189; S4-P0123 |
| FR-029 | MVP | MVP building progression | The five normal wave buildings shall extend to Levels 1–5 in MVP; Level 4 shall add Worker-slot/quality capability without extra capacity, and Level 5 shall add further capacity, slot capacity and quality. | old FR-063–FR-065 | S3-P0237, P0275–P0281 |
| FR-030 | Cross | Upgrade timing | Permanent building upgrades shall be available only between waves and shall not be available during WAVE_ACTIVE. | old FR-066 | S2-P0067; S3-P0282–P0286; S4-P0070; WR6 |
| FR-031 | Cross | Energy role | Energy shall remain an optional assistance resource rather than a participation/progression gate, and a fully prepared resort shall be able to achieve the highest normal-wave result without spending Energy. | old FR-067–FR-068 | S1-SLIDE-09,12; S2-P0054; S3-P0008–P0010; WR8 |
| FR-032 | Prototype / MVP | Wave Energy Mode A | Wave Energy Mode A shall temporarily increase the service speed of one selected building without increasing capacity, shall affect service already in progress and, in Prototype, shall be limited to one boost per building per wave. | old FR-069–FR-072 | S3-P0017, P0073, P0141–P0145, P0192, P0262 |
| FR-033 | Cross | Energy acquisition | Energy shall be earnable from completed gameplay and may be supplemented by voluntary rewarded video; lack of Energy shall not block the underlying service. | old FR-073–FR-074 | S2-P0054; S3-P0010, P0146–P0147 |
| FR-034 | Cross | Offline Energy | Energy shall not regenerate or accumulate as a function of offline time. | old FR-075 | S2-P0054; S3-P0010, P0192 |
| FR-035 | Prototype | Sudden Rush | Sudden Rush shall add unexpected demand to the currently unstaffed normal-wave building without pausing the wave and shall remain solvable through Worker reassignment without requiring Energy. | old FR-076–FR-077 | S3-P0133–P0140, P0210; S4-P0173 |
| FR-036 | MVP | VIP layer | MVP shall support Travel Blogger, Wedding Couple, Investor and Influencer as an optional parallel VIP layer that does not replace or pause the normal-wave core. | old FR-078–FR-080 | S1-SLIDE-11; S2-P0050; S3-P0239, P0304–P0305 |
| FR-037 | MVP | VIP acceptance controls | VIP Preview shall provide Accept/Open Requests, Maybe later and Decline paths without punishment. | part of old FR-081 | S3-P0305; S4-P0131–P0134 |
| FR-038 | MVP | VIP Preview information | Before acceptance, VIP Preview shall present the VIP identity/opportunity, potential reward range, readiness and relevant roster/building gaps. | old FR-082–FR-085 | S3-P0310; S4-P0132–P0137 |
| FR-039 | MVP | VIP preparedness model | VIP requests shall be resolved from prior resort preparedness rather than live normal-Worker allocation; normal Workers shall not be assigned to VIP requests through Worker Allocation. | old FR-086–FR-087 | S2-P0051; S3-P0012, P0307; S4-P0141, P0187 |
| FR-040 | MVP | VIP consumable gaps | A VIP request missing a consumable requirement shall use the MISSING → Fix → READY path, with Fix consuming/supplying the required Materials/consumable resource. | old FR-088–FR-089 | S3-P0308, P0313; S4-P0142, P0148–P0149 |
| FR-041 | MVP | VIP roster gaps | Missing roster prerequisites such as a required Manager, Specialist or building shall not be fixable during the stay; the request shall remain executable with a reduced attainable quality ceiling. | old FR-090–FR-091 | S2-P0046, P0052; S3-P0308–P0310; S4-P0142–P0143 |
| FR-042 | MVP | VIP request lifecycle | VIP request cards shall support MISSING, READY, IN_PROGRESS and COMPLETED states, while any reduced quality ceiling remains an attribute rather than a lifecycle state. | old FR-092–FR-093 | S3-P0313; S4-P0143, P0148 |
| FR-043 | MVP | VIP Speed Up | An applicable VIP request in progress may expose an Energy-based Speed Up action. | old FR-094 | S3-P0307, P0313; S4-P0146 |
| FR-044 | MVP | Spa role | Spa shall operate as a VIP-oriented building with no normal-wave need or Worker slot. | old FR-095–FR-096 | S3-P0232, P0239, P0311 |
| FR-045 | MVP | Spa dependency | At least two of the four VIP types shall include a request whose attainable quality depends on Spa availability. | old FR-097 | S3-P0311 |
| FR-046 | MVP | VIP rewards | VIP completion shall produce a larger reward spike than an ordinary wave, with Reputation as the primary reward and possible Coins, Energy, Materials, Resort Value and decor, without making ordinary waves irrelevant. | canonical CAN-FR-044 / source detail | S2-P0050; S3-P0312; S4-P0155–P0156 |
| FR-047 | Cross | Resort Value | Resort Value shall represent non-spendable resort prestige/status and shall only increase. | old FR-098–FR-099 | S1-SLIDE-12; S2-P0057; S3-P0316 |
| FR-048 | MVP | Reputation | Reputation shall be a cumulative non-spendable progression value whose thresholds make new content eligible for purchase. | old FR-100–FR-101 | S1-SLIDE-12; S2-P0058–P0059; S3-P0316, P0318 |
| FR-049 | Prototype / MVP | Two-step unlocks | Content unlocks shall use a two-step model in which an eligibility gate first exposes the purchase and Coins complete the transaction; Prototype shall use fixed progression milestones while MVP shall use Reputation thresholds. | old FR-102–FR-104 | S2-P0059; S3-P0015, P0185, P0318; S4-P0163 |
| FR-050 | MVP | Materials uses | Materials shall be used for VIP Fix and together with Coins for Levels 4–5 normal-building upgrades. | old FR-105–FR-106 | S2-P0062; S3-P0279, P0320 |
| FR-051 | MVP | Materials acquisition | Materials shall be earned from completed VIP play and may additionally drop from sufficiently high-rated normal waves, with exact rates/amounts remaining tunable. | old FR-107–FR-108 | S3-P0320 |
| FR-052 | MVP | Gems | Gems shall be reserved for permanent premium purchases and shall not convert to Energy or provide temporary gameplay acceleration. | old FR-109–FR-110 | S2-P0062; S3-P0320–P0321 |
| FR-053 | MVP | Paid staff convenience | Any premium staff convenience shall remain subject to the same Worker population cap as non-paying progression. | canonical CAN-FR-052 / source detail | S3-P0325 |
| FR-054 | Prototype | Prototype economy scope | Prototype shall expose Coins and Energy as spendable resources plus Resort Value as status, and shall not include Reputation, Materials or Gems. | canonical CAN-FR-053 / source detail | S1-SLIDE-10,12; S3-P0034–P0035; S4-P0067 |
| FR-055 | Prototype / Cross | Wave Needs Panel | Starting a normal wave shall expose the Wave Needs Panel alongside the island, and the panel shall accommodate the Prototype progression from three to five active needs. | old FR-111–FR-113 | S4-P0022, P0057, P0077–P0091 |
| FR-056 | Prototype / Cross | Worker Allocation surface | Worker Allocation shall open as a modal/bottom sheet from the relevant need/building context, show current Worker assignments and eligible destinations, and return the player to the originating context after reassignment. | old FR-114–FR-115 | S4-P0022, P0058, P0092–P0100 |
| FR-057 | Prototype | Wave-to-upgrade flow | After rewards are claimed, Wave Complete shall lead into the Upgrade Suggestion flow. | old FR-117 | S4-P0041–P0059, P0111 |
| FR-058 | Prototype | Upgrade Suggestion content | Upgrade Suggestion shall identify the proposed building and show the relevant before/after capacity, Coin price and Resort Value gain. | canonical CAN-FR-058 / source detail | S4-P0119–P0124 |
| FR-059 | MVP | Investment choices | In MVP, the investment surface shall present building upgrade, Hire Manager and Hire Worker as distinct spending alternatives. | canonical CAN-FR-060 / source detail | S3-P0251; S4-P0125 |
| FR-060 | Prototype / MVP | Area Unlock surface | Area Unlock shall support locked, available, not-affordable and unlocked states; an eligible deferred unlock shall remain accessible from the map, and Prototype unlocks shall communicate the added content, included Worker and Coin price. | old FR-118 plus canonical CAN-FR-062 | S3-P0054, P0184–P0185; S4-P0159–P0169 |
| FR-061 | MVP | Conditional VIP panel | The Home/Island view shall show the VIP panel only when a VIP opportunity is waiting, keeping it a conditional secondary element rather than an always-on primary control. | old FR-119 | S4-P0075, P0186 |
| FR-062 | Cross | Accommodation semantics | Reception/Rooms and Bungalows/Ocean View shall remain semantically distinct as standard accommodation versus a premium ocean-view experience. | canonical CAN-FR-064 / source detail | S2-P0064; S3-P0126 |
| FR-063 | Cross | No inactivity degradation | Inactivity shall not degrade the resort, expire progress or reduce previously earned progression. | old FR-120 | S1-SLIDE-06–07; S2-P0061 |
| FR-064 | Cross | Comeback reward | Returning after inactivity shall provide a fixed comeback reward that is not proportional to elapsed offline time. | old FR-121 | S2-P0061 |

## 14. Non-Functional Requirements

The NFR set was rebuilt from the client sources rather than inherited from the earlier eight-item compression. Distinct usability, interaction-quality, presentation and return-experience constraints are kept separate when they require different validation evidence.

| ID | Quality area | Requirement | Previous baseline | Traceability |
|---|---|---|---|---|
| NFR-001 | Platform | The product shall target mobile devices in landscape orientation. | old NFR-001 | S1-SLIDE-05; S4-P0014–P0015 |
| NFR-002 | Session shape | A normal production session should form a closed 3–7 minute experience, typically one or two waves plus an investment action. | old NFR-002 | S1-SLIDE-05,07; S2-P0018, P0037; S4-P0017 |
| NFR-003 | Interaction pace | The experience shall support calm managerial decision-making and avoid reflex-pressure, stressful countdown framing and 'you failed because you were too slow' interaction patterns. | old NFR-003 expanded | S1-SLIDE-06–07; S2-P0014, P0020; S4-P0019 |
| NFR-004 | Learnability | Core interactions should be understandable without requiring the player to infer hidden interaction rules or depend on tutorial-style instruction for basic operation. | split from product success criteria | S1-SLIDE-06,15; S3-P0217–P0220 |
| NFR-005 | Primary-action clarity | Each screen or focused interaction surface shall present one clear primary action. | old NFR-004 | S1-SLIDE-13; S4-P0018 |
| NFR-006 | Touch ergonomics | Primary actions, including major CTAs and Worker movement controls, shall be positioned within practical thumb reach for a landscape phone held in both hands. | newly separated UX constraint | S4-P0014 |
| NFR-007 | Visible progression | Resort growth shall be visually perceivable on the island rather than communicated only through numeric progression values. | split from old NFR-005 | S1-SLIDE-06–07; S2-P0013 |
| NFR-008 | Operational legibility | Operational state changes and the effect of player decisions shall be visually legible and provide prompt feedback at mobile viewing distance. | split from old NFR-005 | S1-SLIDE-06,15; S2-P0016; S3-P0127–P0130; S4-P0089, P0108 |
| NFR-009 | Diagnostic legibility | The UI shall make an understaffed service visually distinguishable from a structurally undersized service so the player can choose Worker movement versus upgrade without guessing. | separated from old NFR-005 / old FR-116 | S3-P0029, P0199; S4-P0102–P0104, P0189 |
| NFR-010 | Information density | The UI shall favor overview clarity over density, avoid spreadsheet-like presentation and avoid exposing large collections of simultaneous numeric stats. | old NFR-008 split | S2-P0011, P0020; S4-P0016, P0073, P0091 |
| NFR-011 | Context preservation | During normal-wave management, the island/resort context shall remain visible rather than being unnecessarily replaced by full-screen management UI. | separated UI quality constraint | S4-P0015, P0022 |
| NFR-012 | Quiet-state behavior | When no actionable bottleneck/problem exists, the UI shall not force warnings or unnecessary primary CTAs. | old NFR-008 split | S3-P0192; S4-P0079 |
| NFR-013 | Non-coercive monetization | Monetization and upgrade presentation shall avoid aggressive pressure and shall not punish the player for declining payment or optional monetization. | old NFR-006 | S1-SLIDE-06,15; S3-P0326; S4-P0126 |
| NFR-014 | Positive return experience | Returning after inactivity shall feel positive rather than punitive and shall not frame absence as a loss or failure. | old NFR-007 | S1-SLIDE-06–07; S2-P0015, P0061; S3-P0338 |

## 15. Questions for RRH

| ID | Question | Reason / evidence |
|---|---|---|
| Q-01 | Can a VIP ever be impossible to accept (for example because of capacity), or should every VIP always be accept-able with roster/building deficiencies represented only as a lower quality ceiling? | CF-001: S2-P0052 + S4-P0136 vs S4-P0138 |
| Q-02 | Should VIP rating thresholds use the same scale as normal waves, or intentionally keep a different VIP scale? | S3-P0331; S4-P0145 |
| Q-03 | What final Coin-income coefficients and upgrade/unlock prices should be used so progression lands on the intended beats? | S3-P0177–P0191 |
| Q-04 | What, if anything, is Energy Mode B for normal waves in MVP? | S3-P0330; S4-P0181 |
| Q-05 | What final Worker cap ratio should MVP use? | S3-P0271–P0273 |
| Q-06 | How many Spa levels should MVP contain, and what does each Spa level change? | S3-P0281; S3-P0332 |
| Q-07 | What are the final Reputation milestones for VIPs, areas and services? | S3-P0333 |
| Q-08 | What are the final hiring prices/progression for Managers, Specialists and additional Workers? | S3-P0333 |
| Q-09 | What are the final Materials drop rules and quantities from VIP and high-rated normal waves? | S3-P0320; S3-P0333 |
| Q-10 | What final Satisfaction curve and normal/VIP rating thresholds should economy/QA use? | S3-P0331–P0333 |
| Q-11 | When should an Energy storage cap become active in MVP, and what should the final cap be? | S2-P0072; S3-P0333 |
| Q-12 | Can RRH provide the current full-resolution Figma frames, especially S8 VIP Complete, and confirm which visible S3/Assign Staff treatment is current versus obsolete? | Partial Figma coverage / version drift |
| Q-13 | Are the Coin reward and upgrade-price numbers currently visible in Figma placeholders/obsolete values? The visible ~120 reward vs ~1,200 upgrade price does not match the current Build pacing model. | Figma economy drift vs S3-P0177–P0185 |
| Q-14 | What should create variety between waves once the player has mastered Worker allocation? | Long-term variety / core-loop depth |
| Q-15 | How should the decisions of an experienced player differ from those of a new player? | Skill expression / mastery |
| Q-16 | Should later waves introduce new types of constraints or interactions, or mainly increase demand? | Progression depth / difficulty model |
| Q-17 | To what extent should VIP gameplay function as a second gameplay loop to counter repetition in normal waves? | VIP role / secondary gameplay loop |
| Q-18 | What new decision patterns—not merely new buildings or resources—should emerge as progression advances? | Progression depth / decision-space expansion |

## 16. Final status

- Functional Requirements: **64**
- Non-Functional Requirements: **14**
- Count policy: **no target count; grouped/split only by semantic ownership and independent verifiability**
- Client clarification questions: **18**
- Final FR/NFR evidence classes: **Class A client evidence**
- Figma visual evidence: **partially reviewed; S8/full-resolution detail still open; version/economy drift recorded**
- Known unresolved product conflict: **CF-001 VIP acceptance eligibility**
- Known resolved editorial inconsistency: **CF-002 S3/Worker Allocation sharing**
- `e.g.` / `TUNING` / `OPEN` values: **not promoted to hard requirements**
