# powershell-azure

## Purpose
Provide practical Azure automation guidance for PowerShell using Az modules across local scripts, Azure Automation runbooks, and Azure Functions.

## Activation Scenarios
- Implementing or reviewing Az-based resource automation.
- Designing runbook or function automation flows.
- Handling authentication for unattended Azure execution.
- Addressing Azure throttling, retries, and operational resilience.
- Establishing structured operational logging for Azure jobs.

## Scope
This skill covers:
- Az module usage and lifecycle considerations.
- Runtime-aware design for runbooks and Functions.
- Idempotent Azure resource operations.
- Retry, throttling, and transient-failure handling.
- Operational logging and monitoring signals for automation.
- Azure Automation and Azure Functions constraints for PowerShell 7+ workers.

This skill does not cover:
- Full Azure architecture design or landing zone planning.
- Non-Azure PowerShell design details (delegate to powershell-scripting).
- Deep security policy and secret governance (delegate to powershell-security).
- Test implementation details (delegate to powershell-testing).

## Core Guidance
- Use modern Az modules; do not introduce AzureAD or MSOnline in new automation.
- Pin or validate required Az module versions in managed runtimes when behavior depends on specific cmdlet features.
- Design Azure automation to be idempotent:
	- Repeated execution should converge to the same state.
- Prefer managed identity for unattended Azure authentication where supported.
- Avoid interactive prompts in runbooks and function-triggered automation.
- Account for runtime constraints:
	- Azure Automation job environment and module availability.
	- Azure Functions execution timeout and cold-start implications.
	- PowerShell worker version, managed dependency behavior, and sandbox limitations.
- Implement resilient remote call behavior:
	- Detect transient failures and throttle responses.
	- Apply bounded retries with backoff.
- Emit structured objects and consistent status outputs for downstream tooling.
- Include operational context in logs:
	- Resource identifiers.
	- Correlation-friendly operation IDs.
	- Outcome and failure category.

## Recommended Patterns
- Runtime split pattern:
	- Shared core logic in reusable functions.
	- Thin runbook/function entrypoints that bind runtime input.
- Idempotent upsert pattern for resources:
	- Read current state.
	- Compare desired state.
	- Apply only needed changes.
- Retry pattern for Az calls:
	- Retry on 429 and transient transport errors.
	- Cap retry count and total duration.
- Logging pattern:
	- Structured status objects for success and failure.
	- Minimal, non-sensitive diagnostic fields.
- Context pattern:
	- Validate target subscription/tenant context before mutation.
	- Avoid leaking Az context between jobs; set context explicitly in unattended runs.
- Monitoring pattern:
	- Emit records that can be correlated in job output, Application Insights, or Log Analytics.
	- Keep diagnostic fields non-sensitive and stable.

## Anti-Patterns to Detect
- Interactive Connect-AzAccount workflows in unattended automation.
- Assumptions that local modules and cloud runtime modules are identical.
- Relying on ambient Azure context instead of selecting tenant, subscription, and identity intentionally.
- Blind create operations without pre-checks.
- Infinite or unbounded retry loops.
- Parsing human-formatted output instead of object properties.
- Mixing Azure resource mutation with unrelated local machine administration logic.

## Examples to Prefer
- Short examples that show managed identity authentication in unattended context.
- Compact idempotent resource operation examples.
- Small retry/backoff examples for throttled Az calls.
- Brief runbook vs function entrypoint examples showing shared core logic.

## Validation Checks
- Module and command validation:
	- Confirm required Az modules are available in target runtime.
	- Confirm PowerShell worker version and module versions match script requirements.
- Static analysis:
	- Invoke-ScriptAnalyzer -Path . -Recurse
- Operational checks:
	- Verify scripts are non-interactive in unattended paths.
	- Verify idempotency by running workflow twice and comparing terminal state.
	- Verify logs include operation context without sensitive data.
- Runtime checks:
	- For runbooks: validate job success, warnings, and retry behavior.
	- For functions: validate trigger behavior, timeout posture, and observable outputs.

## Related Skills
- powershell-scripting:
	- Delegate for function-level contract and pipeline design.
- powershell-security:
	- Delegate for secret handling, identity hardening, and least-privilege decisions.
- powershell-testing:
	- Delegate for unit and integration testing patterns around Az automation.
- powershell-review:
	- Delegate for analyzer triage and maintainability-driven refactoring.
