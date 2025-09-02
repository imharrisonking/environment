# OpenCode Commands and Agents

Production-ready commands and specialized agents for [OpenCode](https://opencode.dev) that accelerate development through intelligent automation and expert guidance.

**10 commands** and **4 specialized agents** organized for comprehensive development workflows.

## Installation

```bash
cd ~/environment
# This will symlink .opencode to your home directory via stow
stow -t ~ home
```

After installation, opencode will automatically discover and use these commands and agents.

## Commands

### 🛠️ Development Tools

- **[api-scaffold](commands/api-scaffold.md)** - Generate production-ready REST APIs with FastAPI, Express.js, or Django
- **[test-harness](commands/test-harness.md)** - Create comprehensive test suites with framework detection
- **[code-explain](commands/code-explain.md)** - Analyze and document complex codebases with architectural insights

### 🔒 Security & Quality

- **[security-scan](commands/security-scan.md)** - Comprehensive vulnerability assessment with automated remediation
- **[docker-optimize](commands/docker-optimize.md)** - Optimize containers for production with security hardening

## Specialized Agents

### 👨‍💻 Expert Specialists

- **[api-developer](agents/api-developer.md)** - REST API development with security and testing focus
- **[security-specialist](agents/security-specialist.md)** - Vulnerability assessment and security best practices  
- **[devops-engineer](agents/devops-engineer.md)** - Containerization, CI/CD, and infrastructure automation
- **test-engineer** - Comprehensive testing strategies and quality assurance

## Configuration

The setup includes:
- **Permissions**: Pre-configured bash command permissions for development tools
- **Agent Settings**: Optimized configurations for specialized agents
- **Directory Access**: Proper access to development environments and tools

## Usage Examples

### API Development Workflow
```bash
# Generate a complete API
Use api-scaffold to create user management API with authentication

# Add comprehensive testing  
Use test-harness to add unit and integration tests

# Security validation
Use security-scan to check for vulnerabilities

# Container optimization
Use docker-optimize to create production-ready containers
```

### Security Assessment
```bash
# Full security scan
Use security-scan to perform comprehensive vulnerability assessment

# Get detailed explanations
Use code-explain to understand security findings and architecture
```

## Integration with Your Dotfiles

This structure mirrors your `.claude` setup for consistency:
- Commands work with your existing stow configuration
- Compatible with your package management system
- Follows your established dotfiles patterns
- Uses similar directory structure and naming conventions

## Command Development

Commands are simple markdown files where:
- Filename becomes the command usage pattern
- Content provides task description and implementation guidance
- `$ARGUMENTS` placeholder captures user input
- Focus on actionable, step-by-step implementation

## Agent Specialization

Agents provide expert guidance for specific domains:
- **Focused Expertise**: Each agent specializes in specific technologies
- **Best Practices**: Implement industry standards and security practices
- **Tool Integration**: Work seamlessly with opencode's tool ecosystem
- **Quality Focus**: Emphasize maintainable, production-ready solutions

## Benefits

- **Consistent Patterns**: Follows established conventions from your Claude setup
- **Global Availability**: Available across all development environments via stow
- **Expert Guidance**: Specialized agents provide domain-specific expertise
- **Production Ready**: Focus on security, testing, and operational concerns
- **Tool Integration**: Works with opencode's comprehensive tool set

This setup gives you the same powerful command and agent system for opencode that you have with Claude, ensuring consistent development workflows across all your projects.