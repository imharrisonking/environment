# OpenCode Commands Summary

Successfully converted **54 Claude commands** to OpenCode format with intelligent agent mapping.

## 🏗️ Architecture & Planning Commands
**Agent: `architect-review`** (Claude Opus for deep thinking)
- `/ai-review` - Architectural code review
- `/full-review` - Comprehensive system review
- `/multi-agent-review` - Multi-perspective architecture analysis

**Agent: `ai-engineer`** (Claude Opus for orchestration)
- `/feature-development` - Complete feature implementation workflow
- `/full-stack-feature` - End-to-end feature with frontend/backend
- `/legacy-modernize` - Legacy system modernization
- `/multi-agent-optimize` - Multi-agent optimization workflow
- `/workflow-automate` - Process automation workflows

## 🛠️ Backend & API Development
**Agent: `backend-architect`** (Claude Sonnet)
- `/api-scaffold` - Production-ready API scaffolding
- `/api-mock` - API mocking and testing setup

**Agent: `data-engineer`** (Claude Sonnet)
- `/data-pipeline` - Data processing pipeline setup
- `/data-validation` - Data quality and validation
- `/db-migrate` - Database migration strategies

## 🔒 Security & Compliance
**Agent: `security-auditor`** (Claude Sonnet, read-only)
- `/security-scan` - Comprehensive vulnerability assessment
- `/compliance-check` - Regulatory compliance validation

## 🚀 DevOps & Deployment
**Agent: `deployment-engineer`** (Claude Sonnet)
- `/deploy-checklist` - Production deployment checklist
- `/docker-optimize` - Container optimization
- `/k8s-manifest` - Kubernetes deployment manifests
- `/monitor-setup` - Monitoring and alerting setup

**Agent: `cloud-architect`** (Claude Sonnet)
- Various cloud infrastructure commands

## 🔍 Code Quality & Review
**Agent: `code-reviewer`** (Claude Sonnet, read-only)
- `/code-explain` - Code analysis and explanation
- `/debug-trace` - Debugging assistance
- `/error-analysis` - Error investigation
- `/error-trace` - Error tracking and resolution
- `/refactor-clean` - Code refactoring suggestions
- `/smart-debug` - Intelligent debugging workflow
- `/tech-debt` - Technical debt analysis
- `/deps-audit` - Dependency security audit
- `/deps-upgrade` - Dependency upgrade planning

## 🧪 Testing & Quality Assurance
**Agent: `test-automator`** (Claude Sonnet)
- `/test-harness` - Comprehensive testing setup

## 📊 Performance & Optimization
**Agent: `performance-engineer`** (Claude Sonnet)
- `/cost-optimize` - Cost optimization analysis
- `/performance-optimization` - Performance tuning workflow

## 🤖 ML & AI Development
**Agent: `ml-engineer`** (Claude Sonnet)
- `/langchain-agent` - LangChain development assistance

## 📚 Documentation & Knowledge
**Agent: `docs-architect`** (Claude Sonnet)
- `/doc-generate` - Documentation generation
- `/onboard` - Team onboarding documentation

## 🔧 General Development
**Agent: `build`** (default Claude Sonnet)
- `/accessibility-audit` - Accessibility compliance check
- `/ai-assistant` - General AI assistance
- `/code-migrate` - Code migration assistance
- `/config-validate` - Configuration validation
- `/context-restore` - Context restoration
- `/context-save` - Context saving
- `/issue` - Issue analysis and resolution
- `/pr-enhance` - Pull request enhancement
- `/prompt-optimize` - Prompt optimization
- `/slo-implement` - SLO implementation
- `/standup-notes` - Standup meeting notes
- `/commit` - Git commit assistance
- Various workflow and utility commands

## 🎯 Key Features

### Smart Agent Selection
- **Planning & Architecture**: Claude Opus for complex thinking
- **Security & Review**: Read-only agents for safety
- **Development**: Claude Sonnet for efficient coding
- **Specialized domains**: Domain-expert agents

### Command Features
- **Arguments support**: All commands accept `$ARGUMENTS`
- **Shell integration**: Commands can use `!command` syntax
- **File references**: Commands support `@filename` syntax
- **Context preservation**: Multi-step workflows maintain context

### Usage Examples
```bash
# API Development
/api-scaffold "User management API with JWT auth"

# Security Review  
/security-scan "Check authentication endpoints for vulnerabilities"

# Feature Development
/feature-development "Shopping cart with payment integration"

# Code Review
/code-explain "Explain this complex algorithm"

# Deployment
/k8s-manifest "Deploy microservices with auto-scaling"
```

All commands are now available in OpenCode with `/command-name` syntax and will automatically use the appropriate specialized agent for optimal results.