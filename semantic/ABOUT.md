# Resort Empire Web — Semantic Entry

This directory is the durable semantic routing layer for Resort Empire Web.

It is NOT implementation truth and NOT behavior proof.

Normal bounded-work route:

ABOUT
→ ROUTES
→ relevant typed semantic artifact
→ existing factual source owner
→ bounded mutation
→ tests/runtime/browser evidence
→ Git lineage
→ Jira factual Work evidence
→ semantic delta only if accepted meaning changed

Authority:
- product truth: RESORT_EMPIRE_REQUIREMENTS_FINAL(2).md
- implementation truth: live repository source
- behavior truth: accepted tests/runtime/browser evidence
- physical execution authority: .vibe/environment.json
- Work surface: dedicated Jira project once created
- implementation lineage: local Git + dedicated GitHub remote once created

Do not use prior chat as authority.
Do not perform whole-repository archaeology as the normal route.
Do not create wrappers, shadow stores, overrides, or parallel implementations when an existing owner can be mutated directly.

Start with semantic/ROUTES.md.

Staleness rule:
Current-state artifacts are observations, not permanent truth. Before mutation, re-observe the routed factual owner. If semantic text disagrees with source/runtime/environment evidence, repair the semantic artifact rather than overriding the factual owner.
