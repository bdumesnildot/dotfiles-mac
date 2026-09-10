---
name: create-changeset
description: Create changesets for package releases. Generates properly formatted changeset files with user-facing descriptions. Use when adding a changeset, documenting a change, or preparing a release.
---

# Create Changeset

## Usage

Run `pnpm changeset --empty` to create the changeset file, then edit it.

## File Naming

Name the file: `0000-your-change.md`

## Change Types

| Type    | When to use                                  |
| ------- | -------------------------------------------- |
| `major` | Breaking changes, incompatible API changes   |
| `minor` | New features, backwards-compatible additions |
| `patch` | Bug fixes, small improvements, documentation |

## File Format

```md
---
"@pragma/package-name": patch
---

Description of the change.
```

## Description Guidelines

- **User-facing**: Write for non-technical users
- **Concise**: One sentence preferred
- **Action-oriented**: Start with verb (Add, Fix, Update, Remove)
- **No implementation details**: Focus on what changed, not how

## Examples

### Patch

```md
---
"@pragma/ui": patch
---

Fix button alignment in mobile view.
```

### Minor

```md
---
"@pragma/api": minor
---

Add support for bulk export of user data.
```

### Major

```md
---
"@pragma/core": major
---

Remove deprecated authentication methods.
```

## Checklist

- [ ] Correct package name
- [ ] Appropriate change type (patch/minor/major)
- [ ] User-facing description
- [ ] Concise (one sentence)
- [ ] Starts with action verb
