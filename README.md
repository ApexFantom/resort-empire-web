# Resort Empire

Resort Empire is a browser management-game prototype about keeping a living resort economy flowing across an eight-wave campaign. Guests create demand across resort services; the player manages workers, service capacity, upgrades and area expansion while reacting to queues and bottlenecks.

## Run locally

Requirements: Node.js and npm.

```bash
npm ci
npm run dev
```

Open the local URL printed by Vite in your browser.

No host bridge, browser automation or other developer tooling is required to play the application.

## Checks and production build

```bash
npm test
npm run build
```

The production build is written to `dist/`.

## How to play

1. Before each wave, read the **Service load** forecast.
2. Use **Move worker** to place workers where you expect capacity to be needed. A worker adds service throughput.
3. Press **Start wave** and watch guest flow, queues and building status in the resort world.
4. Reassign workers during a wave when bottlenecks move. Energy boosts become available as the campaign progresses.
5. After waves, spend Coins on building upgrades and unlock the Pool and Bungalows when their offers appear.
6. Complete all eight waves to finish the resort campaign.

The opening wave includes a short in-game hint for the worker/throughput relationship; later waves introduce forecast asymmetry, new services, Sudden Rush pressure and additional workers.

## Persistence

Progress is stored locally in the browser using IndexedDB through Dexie. Reloading the page keeps the local resort state. Clear the site's browser storage if you need a completely fresh campaign.

## Project structure

- `src/core/` — deterministic gameplay state, economy and progression
- `src/runtime/` — simulation clock and inactivity behavior
- `src/app/` — React HUD and player controls
- `src/render/` — Three.js / React Three Fiber resort world, procedural art, environment and activity projection
- `src/persistence/` — browser persistence

## Main technology

React, TypeScript, Three.js, React Three Fiber, Dexie, Vite and Vitest.
