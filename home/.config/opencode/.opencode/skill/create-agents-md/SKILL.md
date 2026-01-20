---
name: create-agents-md
description: Creates an AGENTS.md file for the current working directory by detecting project type, finding parent AGENTS.md for context, and generating appropriate build/run/validation commands.
triggers:
  - create AGENTS.md
  - generate AGENTS.md file
  - setup AGENTS.md
---

# Create AGENTS.md

This skill creates an AGENTS.md file for the current working directory that follows the operational guide pattern.

## Instructions

When invoked, perform these steps:

### 1. Discover Context

1. **Find nearest parent AGENTS.md**:
   - Search up the directory tree from the current working directory
   - Find the first existing AGENTS.md file (if any)
   - Read its contents to understand broader patterns and guidelines

2. **Analyze current directory structure**:
   - Use `ls` and `glob` to identify project files
   - Look for package managers (package.json, requirements.txt, Cargo.toml, go.mod, etc.)
   - Check for build tools (Makefile, CMakeLists.txt, webpack.config.js, etc.)
   - Identify test frameworks (jest.config.js, pytest.ini, etc.)

### 2. Detect Project Type

Based on the discovered files, determine the project type:

**Node.js/JavaScript/TypeScript**:
- package.json present
- Build: `npm install`, `npm run dev`, `npm run build`
- Validate: `npm test`, `npm run lint`, `npm run typecheck` (if applicable)

**Python**:
- requirements.txt, setup.py, pyproject.toml, or Poetry present
- Build: `pip install -r requirements.txt` or `poetry install`
- Dev: `python main.py` or `uvicorn main:app` (for FastAPI)
- Validate: `pytest`, `ruff check`, `mypy` (if applicable)

**Rust**:
- Cargo.toml present
- Build: `cargo build`
- Dev: `cargo run`
- Validate: `cargo test`, `cargo clippy`

**Go**:
- go.mod present
- Build: `go build`
- Dev: `go run main.go`
- Validate: `go test ./...`, `golangci-lint run`

**Ruby**:
- Gemfile present
- Build: `bundle install`
- Dev: `rails server` or `ruby app.rb`
- Validate: `bundle exec rspec`, `rubocop`

**Shell/DevOps**:
- Shell scripts, Makefile, Dockerfile
- Build: Use Makefile targets or shell scripts
- Dev: `make dev` or specific commands
- Validate: Shellcheck, make test

### 3. Extract Parent Context

If a parent AGENTS.md exists:

- **Read only the relevant sections**:
  - Build & Run: Extract specific commands if they apply to this subdirectory
  - Validation: Keep testing/linting patterns that are relevant
  - Operational Notes: Include notes about env vars, ports, configuration
  - Codebase Patterns: Extract patterns that specifically apply to this directory

- **What NOT to copy**:
  - General project-wide rules that don't apply to this specific directory
  - High-level architectural decisions
  - Documentation about other parts of the codebase

### 4. Generate AGENTS.md

Create AGENTS.md following this template:

```markdown
# AGENTS.md

Single, canonical "heart of the loop" - a concise, operational "how to run/build" guide.

## Build & Run

Succinct rules for how to BUILD the project:
- [Specific install commands for this directory]
- [Specific dev commands for this directory]
- [Specific build commands for this directory]

## Validation

Run these after implementing to get immediate feedback:
- [Test commands specific to this directory]
- [Typecheck/lint commands specific to this directory]

## Operational Notes

Succinct learnings about how to RUN the project (discovered during development):
- [Environment variables needed]
- [Port requirements]
- [Configuration file locations]
- [Dependencies or services needed]

## Codebase Patterns
- [Specific patterns for this directory]
- [Naming conventions used here]
- [Important architectural notes for this directory]
```

### 5. Apply Project-Specific Rules

Fill in the template with detected information:

- **Node.js projects**: Check package.json for scripts and add them
- **Python projects**: Check for pytest.ini, setup.cfg, or pyproject.toml for test/lint configs
- **Rust projects**: Use standard cargo commands
- **Go projects**: Use standard go commands
- **Multi-language projects**: Add sections for each component

### 6. Customization Notes

Add specific notes based on directory analysis:

- **Subdirectories**: If this is a monorepo subdirectory, note how it relates to parent
- **Microservices**: Note specific ports, dependencies, and inter-service communication
- **Libraries**: Note how to test and import the library
- **Applications**: Note how to run the application with different configurations

## Output

After creating AGENTS.md, provide a summary:

1. **Project type detected**
2. **Parent AGENTS.md found** (if applicable)
3. **Build commands added**
4. **Validation commands added**
5. **Key patterns documented**
6. **File location**: `/path/to/AGENTS.md`

## Example Scenarios

### Scenario 1: Subdirectory of Node.js Monorepo

If current directory is `/packages/api` and parent has AGENTS.md at root:
- Extract root-level npm scripts that apply to this package
- Add specific commands for running this package
- Note any port requirements for this specific service
- Keep validation commands that apply

### Scenario 2: Standalone Python Service

If current directory is a Python FastAPI project:
- Detect requirements.txt or Poetry
- Add `poetry install` or `pip install -r requirements.txt`
- Add `uvicorn main:app --reload` for dev
- Add `pytest` for tests
- Note port 8000 if detected in code

### Scenario 3: Rust Library

If current directory is a Rust crate:
- Use `cargo build`, `cargo test`, `cargo clippy`
- Note if it's a library vs binary
- Add documentation build commands if docs/ exists

## Notes

- Always validate commands actually work by checking scripts/sections in config files
- If uncertain about a command, add it but mark it with `[TODO: verify]`
- Keep entries concise and actionable
- Focus on commands that are actually useful, not theoretical ones
- After creating the file, verify it's well-formatted and complete
