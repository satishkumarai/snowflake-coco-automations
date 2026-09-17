# Contributing

Thank you for your interest in contributing to this repository.

## What to Contribute

- New automation prompt patterns for common Snowflake operational tasks
- SQL monitoring or governance queries
- Bug fixes in existing SQL or prompt files
- Mermaid diagrams for architectural patterns
- Documentation improvements

## How to Contribute

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-automation-pattern`.
3. Make your changes.
4. Ensure SQL files follow the project's SQLFluff configuration (`.sqlfluff`).
5. Update `CHANGELOG.md` with your changes under the `[Unreleased]` section.
6. Open a pull request using the PR template.

## Guidelines

- **SQL:** Use uppercase keywords, lowercase identifiers. Follow the `.sqlfluff` config.
- **Prompts:** Be specific and deterministic. Avoid vague instructions. Specify output file paths.
- **No secrets:** Never include account identifiers, usernames, passwords, tokens, or real object names.
- **Test before submitting:** Run SQL against a Snowflake account. Test prompts interactively with `cortex`.
- **One pattern per PR:** Keep changes focused. One new automation pattern or one fix per PR.

## License

By contributing, you agree that your contributions will be licensed under:
- Apache License 2.0 for code and SQL
- CC BY 4.0 for documentation and article content
