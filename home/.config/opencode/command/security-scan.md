---
description: Comprehensive security analysis with vulnerability assessment and remediation
mode: all
tools:
  write: true
  edit: true
  bash: true
permission:
  edit: allow
  bash: allow
---

# Security Scan and Assessment

Perform comprehensive security analysis to identify vulnerabilities, assess risks, and implement protection measures with actionable remediation steps.

## Task Description
Conduct thorough security audit covering OWASP Top 10, dependency vulnerabilities, secret detection, and security misconfigurations.

## Requirements
$ARGUMENTS

## Implementation Steps

1. **Project Analysis**
   - Detect technology stack (Python, JavaScript, Go, etc.)
   - Identify frameworks (Django, Flask, React, Express)
   - Locate configuration files and dependencies
   - Map application architecture

2. **Multi-Tool Security Scanning**
   - **Static Analysis (SAST)**:
     * Python: Bandit, Semgrep
     * JavaScript: ESLint Security, SonarJS
     * Go: Gosec, StaticCheck
   - **Dependency Scanning**:
     * Python: Safety, pip-audit
     * JavaScript: npm audit, Snyk
     * Container: Trivy, Grype
   - **Secret Detection**:
     * TruffleHog for git history
     * GitLeaks for real-time detection
     * detect-secrets for baseline management

3. **Vulnerability Assessment**
   - OWASP Top 10 compliance check
   - Infrastructure security (Docker, K8s)
   - API security testing
   - Authentication/authorization review
   - Input validation analysis

4. **Security Configuration Review**
   - HTTP security headers
   - CORS configuration
   - TLS/SSL settings
   - Database security
   - Environment variable usage

5. **Generate Comprehensive Report**
   - Vulnerability summary with CVSS scores
   - Risk prioritization matrix
   - Automated remediation suggestions
   - Manual fix instructions
   - Compliance status dashboard

6. **Automated Remediation**
   - Safe dependency updates
   - Security header implementation
   - Configuration improvements
   - Code pattern fixes

## Tools Used
- **Python**: bandit, safety, pip-audit, semgrep
- **JavaScript**: eslint-plugin-security, npm audit, snyk
- **Container**: trivy, docker bench
- **Secrets**: trufflehog, gitleaks
- **Infrastructure**: checkov, tfsec
- **API**: OWASP ZAP, custom security tests

## Output Format
```
Security Assessment Report
├── Executive Summary
├── Vulnerability Details
│   ├── Critical (immediate action)
│   ├── High (short-term fixes)
│   ├── Medium (planned remediation)
│   └── Low (monitoring)
├── Remediation Plan
├── Automated Fixes Applied
└── Compliance Status
```

Focus on actionable findings with clear remediation steps and automated fixes where safe to apply.