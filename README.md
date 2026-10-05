# Zairakai Tooling

Shared development tooling for the Zairakai Dockers.

## Features

- **ShellCheck** - 100% shell script compliance (ZERO warnings tolerated)
- **Hadolint** - Dockerfile best practices validation
- **Markdownlint** - Documentation consistency
- **BATS** - Shell script testing framework
- **Git utilities** - Branch management helpers
- **CI/CD scripts** - Reusable GitLab CI automation

## Quick Start

### Add as Submodule

```bash
git submodule add https://gitlab.com/zairakai/dockers/tooling.git tools/zairakai
git submodule update --init --recursive
```

### Integrate in Your Project

**Makefile:**

```makefile
# Override project metadata (optional)
PROJECT_NAME := My Awesome Project
TWITCH_URL := https://twitch.tv/mychannel
GITLAB_URL := https://gitlab.com/mygroup/myproject

# Include tooling
include tools/zairakai/make/core.mk
```

### Initialize Project Files

```bash
# Generate standard files (CONTRIBUTING.md, SECURITY.md, LICENSE, .editorconfig)
bash tools/zairakai/scripts/init-project.sh
```

### Install Tools

```bash
make install-shellcheck
make install-hadolint
make install-markdownlint
make install-bats
```

## Usage

```bash
make help              # Show all available commands

make quality           # Run all quality checks (markdown + shell + docker)
make ci-full           # Run quality checks + tests (complete validation)

# Individual checks
make shellcheck        # Check shell scripts for errors and warnings
make hadolint          # Check Dockerfile for best practices
make markdownlint      # Check Markdown files for style issues
make markdownlint-fix  # Auto-fix Markdown style issues
make bats              # Run all tests (unit + integration)

# Git utilities
make git-update        # Update all local branches from remote
make git-cleanup       # Delete merged and orphaned branches
```

## Project Structure

```bash
tools/zairakai/
├── .tool-versions      # Tool version specifications
│
├── .gitlab/
│   └── scripts/        # CI/CD scripts (reusable across projects)
│       ├── generate-release-notes.sh
│       ├── docker-build.sh
│       ├── docker-push.sh
│       └── security-scan.sh
│
├── make/               # Modular Makefile targets
│   ├── core.mk         # Main entry point
│   ├── variables.mk    # Shared configuration
│   ├── help.mk         # Help system
│   ├── markdownlint.mk # Markdownlint integration
│   ├── shellcheck.mk   # ShellCheck integration
│   ├── hadolint.mk     # Hadolint integration
│   ├── quality.mk      # Quality aggregation
│   ├── bats.mk         # BATS testing integration
│   └── utils.mk        # Git utilities
│
├── scripts/            # Development scripts (local use)
│   ├── init-project.sh # Initialize project with templates
│   ├── markdownlint.sh
│   ├── shellcheck.sh
│   ├── hadolint.sh
│   ├── install-*.sh    # Idempotent installers
│   ├── git-update.sh
│   └── git-cleanup.sh
│
├── templates/          # Project file templates
│   ├── .editorconfig   # Editor configuration
│   ├── CONTRIBUTING.md # Contribution guidelines
│   ├── SECURITY.md     # Security policy
│   └── LICENSE         # MIT License
│
└── tests/
    └── helpers/
        └── common.bash # Shared BATS helpers
```

## CI/CD Scripts

Reusable scripts for GitLab CI pipelines:

### Generate Release Notes

```bash
# Usage in .gitlab-ci.yml
bash tools/zairakai/.gitlab/scripts/generate-release-notes.sh v1.0.0 v1.1.0 > RELEASE_NOTES.md
```

Features:

- Follows Conventional Commits (feat, fix, docs, etc.)
- Extracts ticket IDs (#1234)
- Detects BREAKING CHANGES
- Lists closed issues

### Security Scan

```bash
# Usage in .gitlab-ci.yml
bash tools/zairakai/.gitlab/scripts/security-scan.sh zairakai/my-image v1.0.0
```

Features:

- Scans with Trivy
- Configurable severity (CRITICAL, HIGH by default)
- Fails pipeline on vulnerabilities

## Tool Versions

Versions are defined in `.tool-versions`:

```bash
shellcheck=0.11.0
hadolint=2.15.1
markdownlint-cli2=latest
bats=1.14.0
```

Override via environment:

```bash
SHELLCHECK_VERSION=0.10.0 make install-shellcheck
```

## Requirements

- **Bash** 4.0+
- **Make** 3.81+
- **Git** 2.0+
- **curl** (for binary downloads)

### OS Support

- ✅ Linux (apt, dnf, pacman, apk)
- ✅ macOS (Homebrew)
- ❌ Windows (use WSL2)

## Best Practices

### Shell Scripts

- Always use `#!/usr/bin/env bash`
- Start with `set -euo pipefail`
- 100% ShellCheck compliance (ZERO warnings)
- Clear logging with emojis and structure

### Documentation

- Markdownlint compliance
- Code blocks with language specification
- Clear examples

### Tests

- Add BATS tests for new features
- Unit tests in `tests/unit/`
- Integration tests in `tests/integration/`

## Links

- [GitLab Repository][gitlab-repository]
- [Dockers][dockers]
- [Twitch Channel][twitch-channel]

## License

MIT License - see [LICENSE][license-link]

---

**Made with ❤️ by [Zairakai][gitlab-link]**

[gitlab-repository]: https://gitlab.com/zairakai/dockers/tooling
[dockers]: https://gitlab.com/zairakai/dockers
[twitch-channel]: https://twitch.tv/zairakai
[license-link]: ./templates/LICENSE
[gitlab-link]: https://gitlab.com/zairakai
