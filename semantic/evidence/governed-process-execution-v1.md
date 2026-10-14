# Governed Process Execution v1 — Acceptance Record

Claim:
The existing Resort-native host boundary supports typed, repository-confined governed process execution without introducing arbitrary shell authority or a parallel execution layer.

Accepted server/runtime evidence:

- bridge version: resort-host-bridge/1.1.0
- existing host bridge was extended in place
- arbitrary_shell=false
- argument mode=array-only
- cwd policy=repo-confined
- allowlisted project tools: git, node, npm, npx
- process.run harmless Git canary returned exit_code=0
- timeout canary returned timed_out=true and termination_confirmed=true
- process lifecycle canary proved start -> RUNNING -> stop -> STOPPED
- filesystem read regression remained SUCCEEDED after bridge upgrade

Accepted VIBE-GO end-to-end evidence:

Harmless process request:
rrh:process-e2e:git:648d6ddf-730f-4ba4-8538-f265e63773ef

Observed:
- tool=git
- cwd=.
- exit_code=0
- stdout="git version 2.45.1.windows.1"
- durable ledger status=COMMITTED

Transport-UNKNOWN request:
rrh:process-e2e:unknown:d5b744ef-264d-4c84-a4f5-f55d55a87284

Observed causal recovery:
1. process.run was already submitted through VIBE-GO.
2. Client transport intentionally timed out after 1000 ms.
3. VIBE-GO recorded resort-host-mutation-outcome-unknown/v1 for the exact request_id.
4. No new mutation identity was issued.
5. request.get reconciled the exact identity as COMMITTED.
6. Reconciled process result had timed_out=true and termination_confirmed=true.
7. Exact same request_id plus exact same payload was then resubmitted only after reconciliation.
8. Bridge returned cached=true rather than executing the process again.
9. VIBE-GO cleared lastUnknown after exact recovery.

Accepted assertions:
- freshProcessExecuted=true
- exactRepoCwd=true
- durableCommittedLedger=true
- transportUnknownProduced=true
- unknownBoundToExactRequest=true
- noBlindReplayBeforeReconciliation=true
- timeoutOccurredInsideBridge=true
- timedProcessTerminationConfirmed=true
- sameIdentityRecoveryCached=true
- unknownClearedAfterExactRecovery=true

Scope:
This proves the governed process substrate. It does not yet prove a real RRH dev-server lifecycle; that will be exercised once the minimal non-gameplay application shell exists.

No gameplay was implemented.
