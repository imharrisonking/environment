---
description: Create comprehensive test suites with unit, integration, and E2E testing
mode: all
tools:
  write: true
  edit: true
  bash: true
permission:
  edit: allow
  bash: allow
---

# Test Suite Generator

Create comprehensive test suites with unit, integration, and end-to-end testing using framework detection and best practices.

## Task Description
Generate complete test implementation covering all application layers with proper mocking, fixtures, and CI/CD integration.

## Requirements
$ARGUMENTS

## Implementation Steps

1. **Test Strategy Analysis**
   - Detect testing frameworks (pytest, jest, mocha, etc.)
   - Identify application architecture patterns
   - Analyze existing test coverage
   - Map testable components and endpoints

2. **Framework-Specific Setup**
   - **Python**: pytest, pytest-asyncio, factoryboy, responses
   - **JavaScript**: Jest, Mocha/Chai, Supertest, Cypress
   - **Go**: testify, httptest, testcontainers
   - **Java**: JUnit 5, Mockito, TestContainers

3. **Test Categories Implementation**
   - **Unit Tests**: Pure function testing, business logic validation
   - **Integration Tests**: Database operations, external API calls
   - **API Tests**: Endpoint testing, authentication flows
   - **E2E Tests**: Full user journey simulation
   - **Performance Tests**: Load testing with appropriate tools

4. **Test Infrastructure**
   - Test database setup (SQLite, TestContainers)
   - Mock services and external dependencies
   - Test data factories and fixtures
   - Parallel test execution configuration
   - Coverage reporting setup

5. **CI/CD Integration**
   - GitHub Actions/GitLab CI configuration
   - Test result reporting
   - Coverage badges and metrics
   - Automated test execution on PR
   - Failure notifications and debugging

6. **Advanced Testing Features**
   - Property-based testing (Hypothesis, fast-check)
   - Mutation testing for test quality
   - Contract testing (Pact)
   - Security testing integration
   - Visual regression testing

## Test Structure
```
tests/
├── unit/
│   ├── test_models.py
│   ├── test_services.py
│   └── test_utils.py
├── integration/
│   ├── test_database.py
│   ├── test_api_endpoints.py
│   └── test_auth_flows.py
├── e2e/
│   ├── test_user_journeys.py
│   └── test_critical_paths.py
├── fixtures/
├── factories/
└── conftest.py
```

## Coverage Goals
- **Unit Tests**: 90%+ coverage
- **Integration Tests**: All database operations
- **API Tests**: All endpoints with auth scenarios
- **E2E Tests**: Critical user paths

Focus on maintainable tests with clear assertions, proper isolation, and meaningful test data.