# powershell-security

## Purpose
Provide implementation-focused security guidance for PowerShell automation, including secret handling, credential patterns, least privilege, and auditability.

## Activation Scenarios
- Designing credential and secret flows in automation scripts.
- Reviewing code for sensitive data exposure risk.
- Selecting managed identity, Key Vault, or SecretManagement integration patterns.
- Hardening scripts that interact with privileged operations.
- Evaluating security posture of generated PowerShell code.

## Scope
This skill covers:
- Secret and credential handling patterns.
- Authentication choice guidance for automation contexts.
- Least-privilege access and auditability considerations.
- Detection of unsafe execution patterns.

This skill does not cover:
- Formal threat modeling, penetration testing, security certification, or compliance sign-off.
- Deep test design (delegate to powershell-testing).
- General code quality triage (delegate to powershell-review).
- Azure runtime mechanics beyond security implications (delegate to powershell-azure).

## Core Guidance
- Never hardcode secrets, tokens, passwords, or connection strings.
- Never log secrets or raw credential material.
- Prefer managed identity where runtime support exists.
- When managed identity is unavailable, prefer secure stores and short-lived credential retrieval.
- Use Key Vault or SecretManagement when secrets must be retrieved at runtime.
- Pass credentials via secure objects and scoped parameters, not plaintext strings.
- Prefer certificate, federated, or managed identity flows over long-lived client secrets for unattended automation.
- Treat sensitive inputs and outputs as tainted data:
	- Sanitize logs and error messages.
	- Avoid echoing command lines containing secrets.
- Reject unsafe execution constructs, including Invoke-Expression and dynamic command concatenation from untrusted input.
- Enforce least privilege by default:
	- Grant only required roles/actions.
	- Scope access to required resource boundary.
- Make security-relevant operations auditable through structured logs and clear operation boundaries.

## Recommended Patterns
- Identity-first pattern:
	- Attempt managed identity.
	- Fall back to securely managed credential sources only when required.
- Secret access pattern:
	- Retrieve at point-of-use.
	- Hold in memory for minimum necessary scope.
	- Do not persist to disk unless explicitly encrypted and required.
- Logging pattern:
	- Log operation intent and outcome.
	- Redact secret-bearing fields.
- Input validation pattern:
	- Validate high-risk parameters early.
	- Constrain accepted formats for identifiers and paths.
- Review-boundary pattern:
	- State when a recommendation needs formal security review or owner approval.
	- Document accepted residual risk for exceptions.

## Anti-Patterns to Detect
- Hardcoded secrets in script files, parameters, or defaults.
- Plaintext credentials in variables, environment logs, or transcripts.
- Writing secret values to verbose or error streams.
- Using Invoke-Expression for convenience.
- Over-privileged service principals or broad contributor roles without justification.
- Reusing privileged credentials across unrelated automation contexts.
- Persisting tokens, SecureString values, or decrypted secret material to disk without a documented requirement.

## Examples to Prefer
- Small examples showing secure retrieval from Key Vault or SecretManagement without exposing values.
- Brief managed identity-first authentication examples.
- Minimal redaction examples for log output.
- Short before/after examples replacing unsafe dynamic execution with explicit command invocation.

## Validation Checks
- Static checks:
	- Scan for likely secret literals and insecure execution commands.
	- Run Invoke-ScriptAnalyzer -Path . -Recurse and review security-relevant findings first.
- Review criteria:
	- No secret values in source, logs, or default parameters.
	- Authentication method matches runtime security posture.
	- Access scopes follow least-privilege intent.
	- Sensitive operations are auditable.
	- Exceptions that affect security posture have explicit owner approval.

## Related Skills
- powershell-scripting:
	- Delegate when security remediation requires restructuring function contracts.
- powershell-review:
	- Delegate for broader maintainability and analyzer triage.
- powershell-testing:
	- Delegate to validate security controls through unit and integration tests.
- powershell-azure:
	- Delegate for Azure-specific identity, role assignment, and automation runtime behavior.
