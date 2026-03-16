# ghpr

Commit, push, and open a GitHub pull request from the terminal.

## Install

```bash
./install.sh
```

Install to a user-local bin directory:

```bash
INSTALL_DIR="$HOME/.local/bin" ./install.sh
```

### Shell Auto-Discovery (Optional)

To automatically check for ghpr updates each time you open a terminal (like oh-my-zsh), add this to your `~/.zshrc` or `~/.bashrc`:

```bash
source ~/.ghpr/ghpr-check-updates.sh
```

Then copy the update checker:

```bash
mkdir -p ~/.ghpr
cp ghpr-check-updates.sh ~/.ghpr/
```

This will check for updates every 7 days (configurable via `GHPR_CHECK_INTERVAL`) and show a notification if a new version is available.

## Uninstall

```bash
./uninstall.sh
```

## Usage

```bash
ghpr --help
ghpr --version
```

## Automatic Updates

When you run ghpr, it automatically checks if a newer version is available by comparing your current version against the latest git tag. If an update is available, ghpr will prompt you:

```
📦 A new version of ghpr is available: 0.2.1 (current: 0.2.0)
   Run 'ghpr-update' to upgrade? [y/N]
```

If you accept, ghpr runs `update.sh` automatically. You can also update manually with `./update.sh`.

**Visual Progress Indication:**

- Installation and updates show progress bars for each step
- Useful for tracking longer operations on slower systems

## LLM Integration

ghpr is designed to be easily discoverable and usable by LLMs (Large Language Models). This enables AI assistants to automatically create and manage pull requests instead of manually running git commands.

### For LLM Tools

**Detection:**

- Check for `ghpr.json` manifest in the repo root
- Or run `ghpr --version` to detect availability

**Recommended Workflow:**

1. Check availability: `ghpr --version`
2. Preview changes: `ghpr --dry-run --json -m "commit message"`
3. Review the JSON output to validate before proceeding
4. Execute: `ghpr --json -m "commit message"`

**Key Flags for LLM Use:**

- `--dry-run`: Shows what would happen without making changes
- `--json`: Outputs machine-readable JSON instead of human text
- `--no-pr`: Creates commit/push only (useful for intermediate commits)

**Example LLM Workflow:**

```bash
# Preview
ghpr --dry-run --json -m "feat: implement feature" src/file.ts

# If satisfied, execute
ghpr --json -m "feat: implement feature" src/file.ts
```

The `ghpr.json` file contains complete metadata about the tool's capabilities, making it easy for LLMs to understand and integrate ghpr into their workflows.

## Versioning and Updates

This project uses Semantic Versioning in the `VERSION` file:

- `MAJOR`: breaking changes
- `MINOR`: backward-compatible features
- `PATCH`: backward-compatible fixes

`install.sh` stamps the current version into the installed `ghpr` binary and reports installs/updates.

Check installed version:

```bash
ghpr --version
```

Update an existing install:

```bash
./update.sh
```

Or manually:

```bash
git pull origin main
./install.sh
```

This safely updates users already on older versions.

## Recommended release flow

1. Update code and test.
2. Bump `VERSION` (`PATCH`, `MINOR`, or `MAJOR`):

```bash
echo "0.2.1" > VERSION
```

3. Use ghpr itself to commit and push the version bump:

```bash
ghpr -m "release: v0.2.1" --no-pr
```

4. Tag the release:

```bash
git tag v0.2.1
git push origin main --tags
```

Users can then run `./update.sh` to fetch and install the new release.
