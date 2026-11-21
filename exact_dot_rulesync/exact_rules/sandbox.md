---
root: false
targets:
  - '*'
description: Sandbox network blocks GitHub; fetch through the Artifactory github remote
---
# Sandbox network

The sandbox blocks github.com, api.github.com, and raw.githubusercontent.com. Fetch GitHub files through the Artifactory `github` remote instead:

- Release asset: `https://artifactory.eng.qops.net/artifactory/github/<owner>/<repo>/releases/download/<tag>/<asset>`
- Repo file (`/blob/` or raw.githubusercontent.com): `https://artifactory.eng.qops.net/artifactory/github/<owner>/<repo>/raw/<ref>/<path>`

For tools, schema URLs, and release versions, load the `artifactory-github` skill.
