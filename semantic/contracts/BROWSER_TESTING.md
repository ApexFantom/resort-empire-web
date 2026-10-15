# Browser and Verification Contract

Control browser and game-test browser are distinct responsibilities.

Control plane:
Opera GX may host ChatGPT / VIBE-GO and the narrow Resort relay extension.

Game-test plane:
official ChromeDevTools/chrome-devtools-mcp
→ dedicated non-personal Chrome or Chrome for Testing
→ localhost RRH application

Required browser capabilities:
launch/connect, navigate, interact, inspect runtime, capture console/network failures, screenshots, runtime/performance evidence, and clean recovery without routine operator mouse/keyboard work.

Verification discipline:
- Vitest: deterministic core/contract verification
- Chrome DevTools MCP: real browser/UI/Pixi/runtime/network/performance acceptance
- manual DevTools snippets: RECON only
- accepted verification schema: resort-verification-result/v1

Do not add Playwright or another overlapping browser automation stack unless a concrete capability gap is proven and accepted as an architecture change.

Current state:
Chrome DevTools MCP and the dedicated test-browser profile are not yet installed.

## Accepted governed Chrome DevTools MCP adapter

- Exact adapter package: `chrome-devtools-mcp@1.10.1`.
- Official CLI client: `chrome-devtools`; official MCP server: `chrome-devtools-mcp`.
- Execution remains inside the existing governed Resort `npx` process boundary.
- Browser profile is dedicated and non-personal at `.vibe/browser/profile/`; profile/runtime material is machine-local and ignored by Git.
- Durable browser configuration owner: `.vibe/browser/browser-control.json`.
- Development navigation is limited by contract to localhost / 127.0.0.1 surfaces.
- Resolve page identity from structured `new_page` / `list_pages` JSON using the exact target URL. Never infer page identity from console text, regex, list position, or the initial `about:blank` page.
- CLI exception: `evaluate_script` receives the JavaScript function as its required positional argument and page selection through `--pageId <number>`.
- `globalThis.__RRH_DEV__` is read-only by default. Any developer mutation must traverse canonical game-core command authority.
- Vitest remains deterministic core/contract verification. Chrome DevTools MCP remains real browser/runtime/UI/Pixi/console/network/performance verification.
- Manual console snippets and exploratory probes are RECON only.
- Accepted browser runs emit the canonical `resort-verification-result/v1` envelope.
- Playwright or another overlapping browser automation authority remains forbidden unless an accepted factual capability gap is established.
