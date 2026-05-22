# powershell-scripting

## Purpose
Provide implementation guidance for maintainable PowerShell functions and scripts, with emphasis on function contracts, pipeline behavior, error semantics, and reusable structure.

## Activation Scenarios
- Designing or refactoring advanced functions.
- Defining parameter sets, validation, and command contracts.
- Splitting orchestration scripts from reusable logic.
- Improving object output and pipeline compatibility.
- Addressing maintainability or performance concerns in script code.

## Scope
This skill covers:
- Function and script structure.
- Parameter and pipeline design.
- Error handling approach in reusable code.
- Module-friendly layout decisions without full packaging guidance.
- PowerShell 7+ and cross-platform implementation choices.
- Performance-aware scripting patterns.

This skill does not cover:
- Security architecture and secret design (delegate to powershell-security).
- Test strategy and Pester implementation (delegate to powershell-testing).
- Analyzer policy interpretation (delegate to powershell-review).
- Azure runtime specifics (delegate to powershell-azure).

## Core Guidance
- Use [CmdletBinding()] for reusable functions and expose explicit parameters.
- Use SupportsShouldProcess for state-changing operations.
- Prefer typed parameters with targeted validation attributes.
- Avoid positional-only usage in shared code; call functions with named parameters.
- Support pipeline input intentionally, not accidentally.
- Use begin/process/end when pipeline input is part of the contract.
- Return structured objects with stable property names; avoid formatted output in function logic.
- Prefer PowerShell 7+ compatible APIs and cross-platform path handling unless the target runtime is explicitly Windows-only.
- Distinguish orchestration from reusable functions:
	- Orchestration scripts coordinate workflow and environment-specific decisions.
	- Reusable functions implement deterministic units of behavior.
- Use splatting for readability when passing many parameters.
- Use explicit error semantics:
	- Throw terminating errors for invariant violations.
	- Use non-terminating errors only when partial success is acceptable.
- Keep functions focused on one operation; extract nested complexity.

## Recommended Patterns
- Layered layout:
	- Private helper functions for internal transformations.
	- Public entry functions for stable contracts.
	- Orchestration script for sequencing and environment binding.
- Parameter set design that maps to meaningful user intent.
- Output model pattern:
	- Emit one object shape per command purpose.
	- Include machine-readable status fields when needed.
- State-change pattern with ShouldProcess and clear WhatIf behavior.
- Pipeline-safe pattern:
	- Accept pipeline input by value or property name only where needed.
	- Preserve throughput by avoiding excessive per-item setup.
- Performance pattern:
	- Minimize repeated remote calls in loops.
	- Avoid unnecessary array rebuilding in hot paths.
- Cross-platform pattern:
	- Use Join-Path and platform-neutral environment access.
	- Isolate Windows-only behavior behind clear runtime checks.

## Anti-Patterns to Detect
- Monolithic scripts that mix input parsing, business logic, and output formatting.
- Functions that return mixed object types without contract documentation.
- Implicit global state dependencies.
- Hardcoded platform assumptions such as drive-letter paths in reusable code.
- Blind try/catch blocks that mask root errors.
- Positional invocations in reusable automation code.
- Alias usage in committed code.
- begin/process/end blocks added without actual pipeline contract.
- Premature abstraction that increases cognitive load without reuse benefit.

## Examples to Prefer
- Short advanced function examples showing:
	- CmdletBinding with SupportsShouldProcess.
	- Typed parameters with one or two validation attributes.
	- begin/process/end only when pipeline input is supported.
- Before/after refactor snippets that separate orchestration from reusable functions.
- Minimal splatting examples for readability improvements.
- Output examples showing structured objects over formatted text.

## Validation Checks
- Run static analysis:
	- Invoke-ScriptAnalyzer -Path . -Recurse
- Review command contracts:
	- Verify parameter types, sets, defaults, and validation.
	- Verify ShouldProcess behavior for state-changing functions.
- Review output consistency:
	- Confirm predictable object shape across success paths.
- Review maintainability:
	- Function size and responsibility are coherent.
	- Reusable logic is not embedded in orchestration-only scripts.

## Related Skills
- powershell-review:
	- Use for analyzer findings triage, suppression decisions, and maintainability scoring.
- powershell-testing:
	- Use for unit and integration coverage of script behavior.
- powershell-security:
	- Use when credentials, secrets, or sensitive data handling are involved.
- powershell-azure:
	- Use for Azure Automation runbooks, Functions, and Az module runtime behavior.
