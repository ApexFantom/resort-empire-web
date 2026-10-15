# CP-08 GitHub / Jira Lineage Evidence v1

Status: FACTUAL BOOTSTRAP EVIDENCE
Scope: CP-08 - dedicated GitHub and Jira project lineage

## Authority boundary

Mission authority: `semantic/mission/RESORT_EMPIRE_MISSION_CONTRACT_v2.2.json`, closure predicate `CP-08`.

Git/GitHub are implementation-lineage surfaces. Jira is the operational Work/backlog surface. Neither is product-meaning authority or runtime-behavior proof.

## Local Git and GitHub

Repository root: `D:\TempleNet\WorkSpace\RRH`
Branch: `main`
Remote: `origin`
Remote URL: `https://github.com/ApexFantom/resort-empire-web.git`

Pre-reconciliation verification on 2026-10-15:
- local HEAD: `046c0125f04660791fe8c168e123296166208e78`
- upstream: `origin/main`
- ahead/behind: `+0/-0`
- independent `git ls-remote --heads origin main`: `046c0125f04660791fe8c168e123296166208e78`

The dedicated GitHub remote therefore contains the existing local lineage without a history rewrite. The final reconciliation commit containing this evidence is intentionally not self-embedded; its immutable hash is recorded back on Jira Work `CC-1` after commit/push and remote verification.

## Dedicated Jira project

Site: `https://ukfig2.atlassian.net`
Cloud ID: `16d3d05d-a5d7-4b3f-94e1-205eadc528c3`
Project name: `ComCen_SI`
Project key: `CC`
Project ID: `10035`
Project type: `software`
Project style: `next-gen`

The user explicitly identified `ComCen_SI` as the dedicated Jira project created for this Bootstrap Mission. No rename is required by durable authority.

## Accepted Jira seed and read/write proof

Accepted Work identity: Mission closure predicate `CP-08`, `dedicated GitHub and Jira project lineage`.

Created Jira issue:
- key: `CC-1`
- id: `10168`
- issue type: `Task` (`10050`)
- status at readback: `To Do`

The issue description preserves the accepted CP-08 claim and its minimum-evidence contract. Independent `getJiraIssue` readback returned `CC-1` after creation, proving Jira write and read through the authenticated Atlassian MCP route.

## Work -> commit -> evidence cross-reference

`CC-1` is the operational Work identity for CP-08. A first cross-reference comment (`10000`) was written during a failed repository-reconciliation batch while Git remained at `046c0125f04660791fe8c168e123296166208e78`; because this evidence artifact had not materialized, that comment is historical execution evidence rather than the final CP-08 cross-reference.

After this artifact and the stale semantic owners are committed and pushed, comment `10000` is edited in place to contain:
- the exact reconciliation commit hash;
- this evidence path: `semantic/evidence/github-jira-lineage-v1.md`;
- the GitHub repository URL.

The edited comment is then read back independently. This establishes the required Work-to-commit-to-verification-evidence cross-reference without elevating Jira or GitHub above repository/runtime evidence.

## Authentication boundary

The working Atlassian route is `mcp-remote@0.15.1` against `https://mcp.atlassian.com/v2/mcp`, using the existing MCP CLI Client state under the user's `.mcp-auth\mcp-remote-v1` storage. No access token, refresh token, authorization code, client secret, or PKCE material is recorded here.

The separate MCP Inspector / `mcpdo` OAuth branch is unrelated to the accepted Jira control path and is not CP-08 evidence.
