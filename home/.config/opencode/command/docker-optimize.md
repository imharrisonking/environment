---
description: Optimize Docker containers for production with security and performance
mode: all
tools:
  write: true
  edit: true
  bash: true
permission:
  edit: allow
  bash: allow
---

# Docker Optimization

Optimize Docker containers for production with multi-stage builds, security hardening, and performance improvements.

## Task Description
Create optimized Docker configurations with security best practices, minimal image sizes, and production-ready deployments.

## Requirements  
$ARGUMENTS

## Implementation Steps

1. **Current Configuration Analysis**
   - Review existing Dockerfile(s)
   - Analyze base image choices and versions
   - Identify security vulnerabilities in current setup
   - Measure current image sizes and build times

2. **Multi-Stage Build Optimization**
   - Separate build and runtime environments
   - Use appropriate base images (alpine, distroless)
   - Implement dependency caching strategies
   - Minimize final image layers

3. **Security Hardening**
   - Non-root user implementation
   - Distroless/minimal base images
   - Secret management (no secrets in images)
   - Vulnerability scanning integration
   - Read-only root filesystem where possible

4. **Performance Optimization**
   - BuildKit features utilization
   - Layer caching strategies
   - Parallel build stages
   - Dependency pre-caching
   - Image size reduction techniques

5. **Production Configuration**
   - Health check implementation
   - Proper signal handling
   - Resource constraints
   - Logging configuration
   - Environment-specific builds

6. **Development Experience**
   - Docker Compose for local development
   - Hot reload configuration
   - Debug container variants
   - Development tool integration

## Optimization Techniques
- **Language-Specific Optimizations**:
  * Python: UV for fast installs, poetry, wheel caching
  * Node.js: npm ci, node_modules caching, Bun runtime
  * Go: Multi-stage with scratch base
  * Java: JLink custom JRE, CDS archives

- **Security Practices**:
  * Minimal attack surface
  * Regular base image updates
  * Trivy/Grype scanning integration
  * Runtime security monitoring

## Output Structure
```
docker/
├── Dockerfile.prod
├── Dockerfile.dev
├── docker-compose.yml
├── docker-compose.dev.yml
├── .dockerignore
└── entrypoint.sh
```

Focus on creating lean, secure, and fast containers that follow Docker best practices and security standards.