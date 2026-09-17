# Repository Maintenance

Inspect the cloned repository at /workspace/repo and produce a maintenance report.

Check the following:

1. Dependency staleness:
   - If requirements.txt or pyproject.toml exists, list any pinned versions
     and note packages that may have known security advisories.
   - If package.json exists, check for outdated major version pins.

2. Open pull requests:
   - Use the GitHub CLI (gh) to list open PRs older than 7 days.
   - For each, note the PR number, title, author, and days since last update.

3. Branch hygiene:
   - List branches that have been merged but not deleted.
   - List branches with no commits in the last 30 days.

4. README and documentation:
   - Check if README.md exists and is non-empty.
   - Check if CONTRIBUTING.md exists.
   - Note any broken relative links in README.md (files referenced that don't exist).

Write the maintenance report to /workspace/repo-maintenance-report.md with:
- Report date
- Repository name and default branch
- Sections for each check above
- A priority-ordered action list at the top with the most important items first

Do not make any changes to the repository. This is a read-only inspection.
