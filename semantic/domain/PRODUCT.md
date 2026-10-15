# Product Authority Route

Canonical product authority:

RESORT_EMPIRE_REQUIREMENTS_FINAL(2).md
SHA-256:
50ecd9c802fbe7229504e9e290edfa2bb6b25a923e0d1459fa00eeeacab2b1de

Role:
product truth, evidence hierarchy, supersession rules, and Prototype / MVP / Later scope authority.

This semantic file intentionally does not duplicate the detailed FR/NFR catalogue.

Rules:
- Prototype first
- MVP/Later are out of current implementation scope except a minimal replaceable boundary factually required by architecture
- examples, proposals, OPEN items and TUNING values are not hard requirements unless accepted authority promotes them
- Jira wording, implementation convenience and semantic prose cannot override product authority
- gameplay remains forbidden during the current Bootstrap Mission

## Visual direction — 3D target / 2.5D prototype

Explicit user authority, 2026-10-15:

- Final visual/product direction is a true 3D Resort Empire.
- The first Prototype remains deliberately 2.5D / isometric and uses the existing PixiJS world projection.
- PixiJS is therefore a replaceable Prototype renderer, not permanent gameplay authority.
- Prototype-first remains authoritative: do not introduce a true-3D engine during Bootstrap or before factual Prototype pressure requires the migration.
- The pure TypeScript game core must remain renderer-independent so a later governed migration from PixiJS 2.5D to a true-3D projection does not require rewriting gameplay/economy/simulation authority.
- Product/world semantics must not be encoded as Pixi sprites, screen-space coordinates, containers, fake depth ordering, camera tricks or other renderer-specific state inside the canonical core.
- Selection of the eventual true-3D rendering engine is intentionally OPEN and must be made later from factual requirements/evidence rather than frozen now.
