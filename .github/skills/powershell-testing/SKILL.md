# powershell-testing

## Purpose
Provide practical Pester v5 guidance for reliable unit and integration testing of PowerShell automation code, including CI-oriented validation.

## Activation Scenarios
- Adding tests for new or refactored PowerShell functions.
- Building unit tests with mocks for external dependencies.
- Designing integration tests for environment-facing workflows.
- Improving failure-path and idempotency coverage.
- Setting CI test gates for PowerShell repositories.

## Scope
This skill covers:
- Pester v5 structure and lifecycle hooks.
- Unit versus integration test separation.
- Mocking strategies and dependency isolation.
- Test suite organization and CI execution.
- Cross-platform test reliability for PowerShell 7+.

This skill does not cover:
- Primary script architecture and function design (delegate to powershell-scripting).
- Analyzer rule triage and suppression policy (delegate to powershell-review).
- Security control assessment (delegate to powershell-security).
- Azure runtime-specific diagnostics (delegate to powershell-azure).

## Core Guidance
- Use Describe for feature scope, Context for scenario grouping, and It for single assertions of behavior.
- Use BeforeAll for expensive shared setup, BeforeEach for per-test isolation, and AfterEach for cleanup.
- Keep unit tests isolated from network and cloud dependencies.
- Mock external command calls in unit tests, including Az cmdlets and filesystem side effects when practical.
- Keep real Azure calls in opt-in integration tests with explicit credentials, subscriptions, and cleanup strategy.
- Cover at least four behavior classes:
	- Success path.
	- Failure path.
	- Edge cases (null, empty, invalid combinations).
	- Idempotency behavior for repeat execution.
- Keep integration tests explicit and opt-in; avoid running them by default in fast local loops.
- Assert observable outcomes (returned objects, thrown errors, state changes), not implementation trivia.
- Avoid flaky assertions tied to timing unless explicitly controlled.
- Run tests under pwsh and avoid assumptions about path separators, casing, or Windows-only locations unless the test is runtime-specific.

## Recommended Patterns
- Test layout pattern:
	- tests/unit for isolated behavior.
	- tests/integration for environment interactions.
- Naming pattern:
	- It "does X when Y" style, tied to user-visible behavior.
- Mock pattern:
	- Mock commands at boundary points, not deep internals.
	- Verify call expectations only when behavior requires it.
- Idempotency pattern:
	- Execute action twice in integration-safe scenario.
	- Assert unchanged terminal state on second run.
- CI pattern:
	- Run unit tests on every PR.
	- Run integration tests in controlled pipeline stages.
	- Publish Pester results and coverage when the repository already collects them.

## Anti-Patterns to Detect
- Unit tests making real Azure or internet calls.
- Integration tests that mutate shared Azure resources without isolation or cleanup.
- One massive Describe block covering unrelated functions.
- Shared mutable state leaking across tests.
- Assertions that only check non-null instead of behavior.
- Over-mocking that hides real contract violations.
- Integration tests mixed into default fast unit path.

## Examples to Prefer
- Small Describe/Context/It snippets focused on one behavior.
- Minimal mock examples for external cmdlets.
- Short examples using BeforeEach and AfterEach for isolation.
- Compact idempotency test examples that show repeated execution checks.

## Validation Checks
- Run fast suite:
	- Invoke-Pester -Path ./tests/unit
- Run full suite in CI or gated stage:
	- Invoke-Pester -Path ./tests
- Review criteria:
	- Unit tests have no real Azure calls.
	- Failure and edge case coverage exists for critical functions.
	- Integration tests are clearly labeled and isolated.
	- Tests run consistently on the target operating systems.
	- Test failures are deterministic and reproducible.

## Related Skills
- powershell-scripting:
	- Delegate when tests reveal weak function contracts or mixed concerns.
- powershell-review:
	- Delegate when test results indicate maintainability or analyzer issues.
- powershell-security:
	- Delegate when test fixtures involve sensitive data handling.
- powershell-azure:
	- Delegate for integration tests that depend on runbook or function runtime constraints.
