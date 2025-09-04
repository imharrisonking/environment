---
description: Generate a production-ready REST API with comprehensive implementation
mode: all
tools:
  write: true
  edit: true
  bash: true
permission:
  edit: allow
  bash: allow
---

# API Scaffold Generator

Generate a production-ready REST API with comprehensive implementation including models, validation, security, testing, and deployment configuration.

## Task Description
Create a complete API implementation using modern frameworks with proper architecture, security best practices, testing, and documentation.

## Requirements
$ARGUMENTS

## Implementation Steps

1. **Analyze Project Context**
   - Search for existing package.json, requirements.txt, or other dependency files
   - Identify current technology stack and framework preferences
   - Check for existing API patterns in the codebase

2. **Framework Selection**
   - Choose optimal framework based on:
     * FastAPI for Python (high performance, auto-docs, type safety)
     * Express.js for Node.js (ecosystem, real-time capabilities)
     * Django REST for rapid development with ORM
     * Spring Boot for enterprise Java applications

3. **Generate Complete Implementation**
   - Project structure following best practices
   - Database models with relationships
   - Pydantic/validation schemas
   - Service layer for business logic
   - Authentication and authorization
   - Rate limiting and security middleware
   - Comprehensive error handling
   - API documentation (OpenAPI/Swagger)

4. **Security Implementation**
   - JWT authentication with proper secret management
   - Input validation and sanitization
   - SQL injection prevention (parameterized queries)
   - CORS configuration
   - Security headers (helmet/talisman)
   - Rate limiting per endpoint

5. **Testing Setup**
   - Unit tests for all endpoints
   - Integration tests with test database
   - Authentication flow testing
   - Error handling validation
   - Test fixtures and factories

6. **Deployment Configuration**
   - Dockerfile with multi-stage builds
   - Docker Compose for development
   - Environment variable configuration
   - Health check endpoints
   - Logging and monitoring setup

7. **Documentation**
   - API endpoint documentation
   - Setup and installation instructions
   - Environment configuration guide
   - Testing instructions

## Output Structure
```
project/
├── app/
│   ├── main.py (or server.js)
│   ├── models/
│   ├── schemas/
│   ├── services/
│   ├── routes/
│   └── core/
├── tests/
├── docker/
├── docs/
├── requirements.txt (or package.json)
└── README.md
```

Focus on production-ready implementation with security, testing, and operational concerns addressed from the start.