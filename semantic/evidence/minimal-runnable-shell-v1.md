# Minimal Runnable Shell v1 — Acceptance Record

Claim:
A non-gameplay Resort Empire application shell establishes the required bootstrap architecture boundaries and runs through the governed local process path.

## Exact implementation owners

- src/core/state.ts
  SHA-256: a22ad206da0129304a6f0f0e5888d51402f98dfa41400071bdf7edee52094ae1
- src/core/runtime.ts
  SHA-256: a145dab25ab351c83b6c685b25535fa6c6b89b057b3619bae47316bb65a0ba02
- src/core/runtime.test.ts
  SHA-256: 693329f6641d64a822c8d19a9e72d15ee82908db1f761410adf8c998f0459cb6
- src/runtime/SimulationClock.ts
  SHA-256: d96ed252fba01516d982a59b687faad039c72df2c63ed51b4fbb92911768e20c
- src/persistence/PersistencePort.ts
  SHA-256: 4bec091d1879ee2f319c20950e92f593d86f8a1ee85fdca1336ccb1093e26b1e
- src/persistence/DexieBootstrapPersistence.ts
  SHA-256: b5ec0dd832a30ccc4ec43380317bc136075de910f992600c0b0da071c599d66f
- src/render/PixiProjection.ts
  SHA-256: f668a686043bf46cc509e4153bb7407692292b6e2b63e143e32ae9ae7c08da62
- src/app/App.tsx
  SHA-256: 2fb53810071c361d15829c0bfa118bd61b515b3ae2ecc8a58441bcf41136f2b4
- src/dev/installDevFacade.ts
  SHA-256: 6060ab753e7e3ccc2a96d01763743e2fb3065b8f23438f45ca6eaee526841707
- src/main.tsx
  SHA-256: 56daa94fa116ffd4795d9b2d49fe6e53752275eeeb18aa6e38f9ce7fc4b433d7

## Architecture inspection

Accepted assertions:

- pureTypeScriptStateOwner=true
- singleCoreRuntimeAuthority=true
- reactIsProjection=true
- pixiIsProjection=true
- explicitPersistencePort=true
- dexieBehindPort=true
- simulationCadenceSeparateFromRender=true
- headlessCoreTestExists=true
- devFacadeReadOnly=true
- compositionRootUsesOwners=true
- requiredRuntimeDependenciesPresent=true
- requiredVerificationDependenciesPresent=true
- noGameplayContent=true

The gameplay-token scan uses lexical boundaries. In particular, the product term "Spa" is not allowed to match the implementation identifier "dispatch".

## Headless verification

Command:
npm test

Observed:
- Vitest 5.0.4
- test files: 1 passed
- tests: 2 passed
- exit code: 0
- src/core/runtime.test.ts passed

## Production build verification

Command:
npm run build

Observed:
- TypeScript noEmit check succeeded
- Vite 8.3.4 production build succeeded
- 737 modules transformed
- dist/ materialized
- exit code: 0

The current bootstrap bundle size is not treated as a gameplay/performance acceptance claim. Browser/runtime performance remains a later governed acceptance surface.

## Governed dev-server lifecycle

Governed process job:
job-db5b67a860e9174fbfecbc32

Observed:
- process.start succeeded
- state before stop: RUNNING
- HTTP GET http://127.0.0.1:4173/ returned status 200
- returned document contained id="root"
- returned document referenced /src/main.tsx
- process.stop returned terminationConfirmed=true
- final process.status state: STOPPED

## Boundary conclusion

The shell establishes:
- pure TypeScript canonical bootstrap state/commands
- React projection
- Pixi render projection
- explicit persistence port + Dexie adapter
- independent simulation and render cadences
- headless Vitest verification
- governed real dev-server lifecycle
- a read-only developer inspection facade

The shell does not implement product gameplay.

Real browser execution/render/interaction is NOT claimed here. That remains governed Chrome DevTools MCP work under the Bootstrap Mission.
