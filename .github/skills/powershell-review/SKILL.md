# powershell-review

## Purpose
Provide structured quality review for PowerShell code using PSScriptAnalyzer, maintainability heuristics, and production-readiness criteria.

## Activation Scenarios
- Reviewing generated or hand-written PowerShell before merge.
- Interpreting PSScriptAnalyzer results and prioritizing remediation.
- Refactoring code with maintainability debt.
- Evaluating whether code is overengineered or underengineered for the task.
- Assessing production readiness in automation code.

## Scope
This skill covers:
- Static analysis interpretation and remediation planning.
- PSScriptAnalyzer rule selection, configuration, and suppression review.
- Maintainability and readability assessment.
- Refactoring guidance with risk-aware sequencing.
- Review of code quality signals for production use.

This skill does not cover:
- Detailed implementation design of functions (delegate to powershell-scripting).
- Test implementation details (delegate to powershell-testing).
- Security architecture decisions (delegate to powershell-security).
- Azure runtime behavior and service constraints (delegate to powershell-azure).

## Core Guidance
- Treat analyzer output as triage input, not an automatic rewrite order.
- Prefer repository-level analyzer settings when rules or exclusions must be consistent across CI and local runs.
- Classify findings by risk:
	- Correctness and security impact first.
	- Operational reliability second.
	- Style and readability third.
- Remediate with smallest safe change that preserves behavior.
- Require explicit justification for suppressions:
	- Why rule is not applicable.
	- Why alternative remediation is worse.
	- Scope suppression to the narrowest location.
- Review generated code for hidden coupling, weak contracts, and fragile assumptions.
- Evaluate maintainability with practical signals:
	- Function responsibility clarity.
	- Naming consistency and intent.
	- Branching complexity and duplication.
	- Predictable error and output behavior.
- Detect overengineering:
	- Abstractions with no reuse path.
	- Excessive indirection for simple workflows.
- Detect underengineering:
	- Script-level global state for reusable logic.
	- Missing validation and weak error semantics.
- Check PowerShell 7+ and cross-platform assumptions when code is intended for shared or cloud automation.

## Recommended Patterns
- Review workflow:
	- Run analyzer.
	- Confirm the expected analyzer settings file is used.
	- Group findings by risk.
	- Fix high-impact items first.
	- Re-run analyzer and regression tests.
- Suppression hygiene:
	- Localize suppressions to function or line scope.
	- Include reason comments that survive future review.
- Refactor progression:
	- Extract pure helper logic first.
	- Introduce stronger contracts next.
	- Simplify call sites last.
- Review outputs should include:
	- Findings.
	- Risk level.
	- Recommended fix strategy.
	- Validation step.

## Anti-Patterns to Detect
- Blanket suppressions at file scope without rationale.
- Fixing style warnings while leaving correctness defects.
- Refactors that alter behavior without test coverage updates.
- Analyzer-clean but unreadable code.
- Analyzer configuration that hides broad rule categories without documented risk acceptance.
- Excessive script length with mixed concerns.
- Cargo-cult patterns copied from unrelated scenarios.

## Examples to Prefer
- Short finding-to-fix examples:
	- One analyzer warning.
	- Minimal remediation.
	- One validation command.
- Small suppression examples showing narrow scope and reason.
- Refactor examples that reduce complexity without rewriting whole files.
- Review summaries that separate blocking issues from optional improvements.

## Validation Checks
- Static analysis:
	- Invoke-ScriptAnalyzer -Path . -Recurse
	- Use the repository analyzer settings when one exists.
- Review gates:
	- No unresolved high-risk analyzer findings without explicit waiver.
	- Suppressions include documented rationale.
	- Function complexity and duplication reduced or justified.
- Regression safety:
	- Run unit tests after non-trivial remediation.
	- Confirm output contract did not change unintentionally.

## Related Skills
- powershell-scripting:
	- Delegate when remediation requires redesigning function contracts or script structure.
- powershell-testing:
	- Delegate to add or update tests supporting risky refactors.
- powershell-security:
	- Delegate when findings involve secret exposure, unsafe execution, or privilege boundaries.
- powershell-azure:
	- Delegate when review findings depend on Azure runtime behavior.
