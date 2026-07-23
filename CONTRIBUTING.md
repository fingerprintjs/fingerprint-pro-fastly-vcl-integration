# Contributing to Fingerprint Pro Fastly VCL Proxy Integration

## Working with code

We prefer using [pnpm](https://pnpm.io/) for installing dependencies and running scripts.

For proposing changes, use the standard [pull request approach](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request). It's recommended to discuss fixes or new functionality in the Issues first.

- The `main` branch is locked for the push action.
- Releases are created from the `main` branch.

### How to build

- After cloning the repository, run `pnpm install` to install dependencies.
- To build the VCL template, please see the [Customizing the template](https://github.com/fingerprintjs/fastly-vcl-proxy#customizing-the-template) section in [README.md](README.md).

The build scripts run directly on Node.js (v24, see [`.node-version`](.node-version)) using its native TypeScript support, so no separate compile step is required.

### Commit style

You are required to follow [conventional commits](https://www.conventionalcommits.org) rules.

### How to lint

Run `pnpm lint` to check for issues, or `pnpm lint:fix` to automatically fix them. Linting is also enforced on staged files via a pre-commit hook.

### How to test

End-to-end tests run against a mock application and are executed automatically by the `mock-e2e.yml` workflow on every PR. You don't need to run them locally.

### Changing API URLs

You can use the `--fpjs-domain` build flag to change the domain that the integration uses for making identification requests (default: `api.fpjs.io`). This should only be used for local development and not in production.

### How to publish

We use [changesets](https://github.com/changesets/changesets) for handling release notes. If there are relevant changes, please add them to a changeset via `pnpm exec changeset`. You need to run `pnpm install` before doing so.
