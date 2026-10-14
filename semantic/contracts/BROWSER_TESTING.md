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
