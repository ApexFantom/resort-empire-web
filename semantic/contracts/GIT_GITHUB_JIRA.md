# Git / GitHub / Jira Contract

Git:
- local Git is the immediate canonical implementation-lineage surface
- inspect status before mutation
- preserve unrelated dirty work
- distinguish working tree, staged state, commit state and runtime behavior
- a commit is lineage, not behavior proof

Current observed Git state:
- branch `main`
- local history is materialized
- upstream is `origin/main`
- dedicated GitHub remote is attached at `https://github.com/ApexFantom/resort-empire-web.git`
- local/remote equality must be verified from live Git before relying on a current head

GitHub:
- one dedicated Resort Empire repository is established during Bootstrap
- first attachment/push preserved accumulated local history without rewrite/loss
- maintain the remote continuously afterwards
- GitHub does not become product or behavior authority

Jira:
- one dedicated Jira project is established during Bootstrap
- factual site: `https://ukfig2.atlassian.net`
- project: `ComCen_SI`
- key: `CC`
- id: `10035`
- seed accepted Epics/Stories/Tasks only from backlog/product/Mission Work authority; do not invent product truth
- accepted initial Bootstrap Work seed: `CC-1`, Task for Mission predicate `CP-08`
- maintain Work status and evidence/commit references
- Jira is the Work/backlog surface, not product truth or behavior proof

Current state:
GitHub remote and dedicated Jira project are MATERIALIZED. Jira read/write for `CC-1` is proven. Canonical CP-08 evidence is `semantic/evidence/github-jira-lineage-v1.md`; current commit/remote identity must still be read from Git rather than copied from this descriptive contract.
