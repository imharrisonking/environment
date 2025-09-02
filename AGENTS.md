# Agent Guidelines

## Build/Test Commands
This repository is primarily a dotfiles/configuration management system with no JavaScript/TypeScript project structure.
- **Install packages**: `./install` (uses Homebrew on macOS, apt on Linux)
- **Analyze packages**: `./packages/analyse`
- **Clean packages**: `./packages/clean`
- **Host-specific installs**: Check `./packages/group/` for host-specific configurations

## OpenCode Integration
- **Commands**: Available in `home/.opencode/commands/` (api-scaffold, security-scan, test-harness, etc.)
- **Agents**: Specialized agents in `home/.opencode/agents/` (api-developer, security-specialist, etc.)
- **Configuration**: Settings and permissions in `home/.opencode/config/`
- **Global Access**: Use `stow -t ~ home` to symlink to ~/.opencode for system-wide availability

## Code Style
- **Shell scripts**: Follow bash conventions, use proper error handling with `set -e`
- **Configuration files**: Maintain existing format (JSON, YAML, shell configs)
- **Formatting**: Use Prettier config (.prettierrc) for any JS/TS: 4 spaces, single quotes, semicolons
- **Imports**: Not applicable for this dotfiles repository
- **Naming**: Use kebab-case for files, follow existing patterns in configs
- **Error handling**: Use proper exit codes in shell scripts, validate input parameters

## Repository Structure
- `home/`: User dotfiles and configurations (including .opencode/)
- `packages/`: Package management scripts and group definitions
- `custom/`: Environment-specific customizations
- Host-specific configs in `packages/group/[hostname]/`

## Notes
- This is a personal dotfiles repository, not a traditional software project
- Focus on system configuration, shell scripts, and dotfile management
- No traditional build/lint/test cycle - emphasis on functional shell scripts and valid configs
- OpenCode commands provide development workflow automation via stow integration