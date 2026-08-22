# Change fragments

Add one Markdown file per user-visible change under `.changes/unreleased/`,
for example `.changes/unreleased/123-fix-bibliography.md`. Use one or more of these headings:
`Added`, `Changed`, `Fixed`, or `Removed`, followed by at least one non-empty
bullet. The release process can copy these fragments into `CHANGELOG.md`; do
not edit generated release sections by hand.

Example:

```md
## Fixed
- Avoid a duplicate theorem counter on current TeX Live.
```
