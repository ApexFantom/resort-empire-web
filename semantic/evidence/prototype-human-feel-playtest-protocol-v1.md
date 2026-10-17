# Prototype Human Feel Playtest Protocol v1

## Purpose

Validate only the remaining human-only Prototype questions: AC-002, AC-003, AC-005, AC-006, AC-007 and AC-012, plus descriptive human pacing. Do not revalidate sealed mechanics or add gameplay scope.

The Prototype is a feel-validation build. Its complete eight-wave playtest may take 12–20 minutes; this does not replace the separate 3–7 minute product-session target.

## Evidence boundary

Already mechanically sealed and not under test here: Waves 1–8 complete; staffing versus capacity diagnosis works; staffing exposes Worker guidance; capacity exposes Upgrade Suggestion and a working upgrade; Pool/Bungalows unlock; Sudden Rush and optional Energy work; aggregate-demand UI exists; inactivity/comeback behavior is separately sealed.

Use a normal fresh-state build at or after commit `d3c59c9`, mobile landscape, no proof query, modified save or debug controls.

Minimum diagnostic unit: one real player who has not been told the expected solution. One participant can expose a blocking usability problem but is not population-level UX evidence.

## Moderator rule

Pre-brief only:

> Please play through the available progression as you normally would. I am interested in what makes sense or does not make sense to you. I will mostly stay quiet. If you get stuck, tell me what you are trying to understand, but I will avoid gameplay advice.

Do not mention bottlenecks, Worker strategy, aggregate demand, upgrades, Pool, Bungalows, Sudden Rush, Energy or expected next actions before the player encounters them.

Remain silent while the player can continue unaided. Neutral probes such as “What are you looking at right now?” are allowed only to capture reasoning. If gameplay advice is given before a criterion's natural-discovery window closes, mark that criterion AMBIGUOUS rather than PASS.

Record session start/end, rough wave/time of important observations, short verbatim player statements where useful, moderator interventions and unexpected confusion.

## Phase A — natural eight-wave run

### AC-002 — spontaneous bottleneck recognition

Authority: player identifies a bottleneck and moves a Worker before being explicitly told.

Observe from first visible queue pressure until explicit result guidance first tells the player to reassign a Worker. Record whether the player notices a constrained service, opens Worker Allocation, moves a Worker toward it, and why.

If a move happens without explanation, ask only after the action: “What made you choose that?”

PASS: before explicit reassignment guidance, the player independently identifies a specific bottleneck and moves a Worker because of visible queue/wait/service pressure.

FAIL: the first relevant move occurs only after explicit guidance, or the player requires gameplay advice to identify the constrained service.

AMBIGUOUS: the move could be random exploration, or moderator intervention contaminates the discovery window.

### AC-003 — meaningful Worker allocation

Authority: Worker allocation is a meaningful choice, not a trivial lookup.

After the player has made a natural Worker decision, ask:

1. What other placement were you considering?
2. What did you think you would gain or give up by moving the Worker?
3. Did this feel like a real choice, or was there obviously only one sensible option?

PASS: the player describes plausible alternatives/consequences and a trade-off requiring judgment.

FAIL: the player describes the action as mechanically obvious with no meaningful alternative/downside, or cannot connect placement to consequences.

AMBIGUOUS: consequences are understood but the player still reports the choice as trivial.

### AC-005 — aggregate-demand comprehension

Authority: player understands ordinary guests as aggregate system demand.

Ask after enough exposure to form a model, preferably after Wave 2 or later:

1. What do the guests represent in this game?
2. What do the numbers under Wave Needs mean to you?
3. Are you managing individual guests, or something else?

PASS: in their own words the player describes grouped/aggregate demand, service pressure or queues across needs rather than individual guest micromanagement.

FAIL: the player believes the core interaction is selecting/routing individual normal guests, or cannot explain the aggregate numbers after normal exposure.

AMBIGUOUS: grouping is understood operationally but the underlying aggregate-demand model remains unclear.

### AC-007 — unlocks create forward pull

Authority: Pool and Bungalows unlocks create desire to continue.

Do not announce future unlocks. Observe reaction when Pool and Bungalows become available and whether the player inspects/unlocks them without prompting.

After both opportunities have appeared, ask:

1. Did either new area make you want to keep playing? Which one, if any?
2. What did you expect that unlock to change or give you?

PASS: at least one unlock creates a concrete stated desire to continue/discover/use the new area, tied to gameplay or progression.

FAIL: both are described as irrelevant, cosmetic-only or providing no reason to continue.

AMBIGUOUS: the player interacts with them but reports no clear forward motivation, or states interest without corresponding engagement.

### Human pacing

Record rough times for first completed wave, first meaningful Worker decision, Pool availability/unlock, Sudden Rush, Bungalows availability/unlock and Wave 8 completion.

At the end ask:

1. Where, if anywhere, did the session feel too slow?
2. Where, if anywhere, did it feel rushed?
3. Did you feel you were making enough decisions between waves?

Compare descriptively with the 12–20 minute Prototype-playtest framing. Being outside that range is a pacing finding, not automatically a functional failure and not evidence about the 3–7 minute normal-session target.

## Phase B — upgrade feel, only if needed

If the natural run already presents and the player uses an Upgrade Suggestion, use that event. Otherwise, only after Phase A is complete, use the existing `?proof=capacity-upgrade` scenario solely to expose the already-sealed capacity-to-upgrade interaction. It must not retroactively affect AC-002/003/005/007.

Allow the player to complete the short branch and choose the visible upgrade without explaining its intended meaning.

### AC-006 — completion, upgrade satisfaction and next improvement

Authority: wave completion + upgrade feels satisfying rather than obligatory; player can explain what to improve next.

Immediately after a real upgrade ask, in order:

1. How did finishing that wave and making that upgrade feel?
2. Did the upgrade feel like something you chose because it helped, or something the game simply required you to click?
3. What would you improve next, and why?

PASS: the player describes the completion/upgrade loop as rewarding/useful/satisfying or meaningfully chosen, and names a plausible next improvement connected to observed staffing, capacity, queues, waits, unlocks or progression.

FAIL: the upgrade is described as obligatory/no-choice busywork or provides no perceived value, or the player cannot explain what to improve next despite seeing result information.

AMBIGUOUS: satisfaction passes but next-improvement reasoning does not, or vice versa.

## Final interview — AC-012

Authority: player can explain why they want to return.

Only after the gameplay questions are complete ask:

1. Would you want to come back and play this again?
2. What specifically would make you return?
3. What would you hope to do, improve or unlock next?

PASS: the player gives a concrete game-specific return motive tied to progression, improvement, areas, better wave performance, experimentation or another identifiable Prototype loop.

FAIL: the player would not return, or cannot give a game-specific reason beyond politeness/generic curiosity.

AMBIGUOUS: willingness is positive but the reason is vague or unrelated to the actual loop.

## Findings sheet

| Item | Evidence | Verdict |
|---|---|---|
| AC-002 | first bottleneck recognition; first Worker move; whether explicit guidance had appeared; reason | PASS / FAIL / AMBIGUOUS |
| AC-003 | alternatives; trade-off; meaningful vs obvious | PASS / FAIL / AMBIGUOUS |
| AC-005 | player's explanation of guests and Wave Needs | PASS / FAIL / AMBIGUOUS |
| AC-006 | completion+upgrade reaction; obligatory vs chosen; next improvement + reason | PASS / FAIL / AMBIGUOUS |
| AC-007 | Pool/Bungalows reaction and continuation motive | PASS / FAIL / AMBIGUOUS |
| AC-012 | return intention and concrete reason | PASS / FAIL / AMBIGUOUS |
| Pacing | duration, milestone times, slow/rushed/decision-density comments | descriptive |

Do not average criteria into a score. PASS requires direct evidence for that participant. FAIL directly contradicts or fails to exhibit the criterion. AMBIGUOUS means contaminated, mixed or insufficient evidence.

A FAIL or AMBIGUOUS is a validation finding, not an automatic redesign mandate. First determine whether it is repeatable and whether it is an affordance/comprehension, tuning or participant-specific issue.

If all six human criteria PASS and no severe pacing/comprehension issue appears, record a bounded human Prototype PASS for that session. It is still not population-level UX validation.

## Durable session result

Create a separate result record containing: protocol id `prototype-human-feel-playtest-protocol-v1`; build commit; anonymous session id; duration/milestones; each AC verdict with concise evidence; short player quotations/paraphrases where useful; moderator interventions; unexpected observations; overall PASS/FAIL/AMBIGUOUS; and the next action justified by observed evidence only.
