# Contributing

Welcome! This project teaches payment-system design through small, explained changes. Contributions should help learners understand both the implementation and the reason behind it.

You can contribute by asking a question, improving an explanation, reporting a bug, adding a meaningful test, or implementing a focused part of a lesson.

## Start here

1. Read [the README](README.md) for the current implementation status and learning roadmap.
2. Check existing issues and pull requests, if available, to avoid overlapping work.
3. For a substantial design change or a new lesson, open an issue describing the problem and proposed scope before starting.
4. For a typo or small clarification, a direct pull request is welcome.

Please keep future milestones separate from the current lesson. Learners should be able to follow why each new concept is introduced.

## Local workflow

Use JDK 25 and the repository's Maven Wrapper. Follow the README for current setup details.

```bash
git switch -c your-change-name
./mvnw test
```

Make a focused change, run the relevant checks again, and review your diff:

```bash
./mvnw test
git diff --check
git diff
```

On Windows, use `mvnw.cmd` instead of `./mvnw`.

Database-dependent checks will be documented as persistence is implemented. If a check cannot run, explain what blocked it rather than reporting it as passed. Documentation-only changes do not require application tests unless they change executable instructions or examples that need verification.

## Keep contributions easy to learn from

- Keep each pull request focused on one problem or lesson.
- Use clear domain names and small, readable methods.
- Explain important decisions and failure cases; avoid comments that merely repeat the code.
- Update documentation when behaviour, setup, or the learning milestone changes.
- Clearly distinguish planned behaviour from implemented behaviour.
- Avoid unrelated reformatting, dependency upgrades, or generated files.
- Use the existing application structure; discuss additional services or infrastructure before introducing them.

## Payment correctness principles

These are design expectations for the features as we implement them:

- A checkout can contain multiple payment orders, each intended to produce a separate charge.
- Persist the intended operation before executing external payment work.
- Distinguish a new payment attempt from a retry of the same PSP operation.
- Treat a timeout as an unknown outcome until evidence resolves it.
- Use exact money representations. The initial schema uses integer minor units and EUR only.
- Validate amounts and seller allocations against trusted server-side data when checkout integration is added.
- Do not treat a browser return URL as proof that payment succeeded.
- Design for duplicate requests and duplicate PSP notifications.
- Keep ledger entries balanced within each currency and make financial corrections through additional entries.
- Keep merchant balances consistent with the ledger; document transaction boundaries.

A UUID, a boolean flag, or an annotation alone does not establish these guarantees. Explain which database constraint, transaction, or provider contract makes the behaviour safe.

## Tests that teach

Add tests for meaningful behaviour introduced or changed by your contribution. Useful examples include:

- Failure while inserting an order rolls back the entire checkout creation.
- An identical repeated checkout request returns the existing result.
- Reusing a checkout ID with different instructions is rejected.
- Concurrent requests cannot create duplicate payment instructions.
- Reprocessing a PSP notification does not post the financial effect twice.

The later examples become relevant as those features are introduced. Use MySQL integration tests when the guarantee depends on MySQL transactions or constraints; a mocked repository cannot prove those guarantees.

## Test data and credentials

Use synthetic buyer and seller data and PSP test environments. Never commit API keys, database passwords, real card details, or customer information. Redact sensitive values from screenshots, logs, issue descriptions, and test fixtures as well.

An Adyen test account is not required for documentation contributions or the initial checkout-persistence lesson.

## Submitting a pull request

Include:

- The problem or learning objective.
- What changes and an example of the resulting behaviour.
- The design decision a learner should understand.
- Checks performed and their results.
- Any remaining limitations or follow-up work.

For a bug report, include reproducible steps, expected and actual behaviour, and relevant Java/database versions. Share only sanitised logs.

Ask questions when an explanation is unclear. Discovering where a learner gets stuck is a useful contribution in itself.
