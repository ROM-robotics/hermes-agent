---
name: github-repository-naming
description: Apply the mg_embedded prefix when creating GitHub repositories
version: 1.0.0
metadata:
  hermes:
    tags: [github, repository, naming, embedded]
    category: embedded
---

# GitHub Repository Naming

## When to Use

Use whenever asked to create a GitHub repository for `mg_embedded` or one of
its embedded projects.

## Procedure

1. Derive the requested base name, `repo_name`.
2. Set the GitHub repository name to `mg_embedded_<repo_name>`.
3. If the requested name already starts with `mg_embedded_`, keep it unchanged
   rather than adding the prefix twice.
4. Present the final repository name before creation. If the user has not
   clearly authorized creating the repository, ask for confirmation.
5. Use the resulting name consistently in the GitHub repository and any
   related remote URL or setup instructions. Do not rename the local project
   directory unless separately requested.

## Verification

Before creating, confirm that the final name begins with exactly one
`mg_embedded_` prefix and that the suffix matches the requested repository
name.
