---
description: Global instructions for PowerShell 7+ production scripting, Azure automation, and security-first development
applyTo: ['**/*.ps1', '**/*.psm1', '**/*.psd1']
---

# PowerShell Production Scripting Standards

## Purpose

These instructions enforce enterprise-grade engineering standards for PowerShell 7+ code targeting production environments, Azure automation, and cross-platform compatibility. All guidance prioritizes security, maintainability, and testability.

---

## Core Language Standards

### PowerShell Version & Syntax

- Target PowerShell 7+ (`pwsh`); avoid v5.1-only patterns unless compatibility required
- Use full command names and parameter names in shared/reusable code
- Use `[CmdletBinding()]` for all functions intended for reuse or module exports
- Use typed parameters with validation attributes: `[ValidateScript()]`, `[ValidatePattern()]`, `[ValidateRange()]`
- Use PascalCase for function and parameter names
- Use approved `Verb-Noun` cmdlet naming (validate with `Get-Verb`)

### Functions & Parameters

- Return structured objects (PSCustomObject, typed objects); avoid formatted text output for reusable functions
- Use `begin/process/end` blocks for pipeline input handling
- Implement `SupportsShouldProcess` for state-changing operations; never manually implement `-WhatIf` or `-Confirm`
- Avoid positional parameters in shared/reusable code; always use named parameters
- Avoid aliases in production code; aliases are interactive-only

### Error Handling & Streams

- Use terminating errors (throw) for unrecoverable conditions
- Use `$PSCmdlet.WriteError()` in advanced functions for non-terminating errors
- Never suppress errors with `$null` or `@{}` unless intentionally ignored
- Avoid `Write-Host` except for intentional interactive UX; prefer Write-Output, Write-Verbose, Write-Warning
- Use proper streams: Write-Output (pipeline), Write-Verbose (diagnostics), Write-Warning (important info)

---

## Security Standards

### Credential & Secret Management
- **Never hardcode secrets**: API keys, passwords, connection strings must be sourced from secure stores
- **Never log or expose secrets**: Sanitize error messages and logs of sensitive data
- Use Azure Key Vault, SecretManagement, or PSCredential objects for credentials
- Prefer managed identity for Azure authentication in automation
- Avoid interactive credential prompts in unattended scripts; use service principal or managed identity
- Use `ConvertTo-SecureString` with keys only; never use `-AsPlainText -Force` in production

### Secure Patterns
- Avoid `Invoke-Expression` and dynamic script evaluation
- Avoid passing secrets as plaintext parameters; use SecureString where required
- Enable scriptblock logging in production environments
- Implement audit logging for sensitive operations

---

## Azure Automation Standards

### Module & SDK Selection
- Use modern `Az.*` PowerShell modules; avoid deprecated `AzureAD` and `MSOnline` modules
- Keep Azure PowerShell modules updated; regularly run `Update-Module -Name Az.*`
- Authenticate via managed identity in Azure Automation, App Service, or Functions
- Authenticate via service principal with certificate (not client secret) where managed identity unavailable

### Automation Design
- Write idempotent code: repeated execution produces same state without errors
- Avoid interactive prompts in automation scripts (no `Read-Host`, conditional confirmation)
- Use structured error handling for transient failures (429, timeouts); implement exponential backoff
- Log operations and results for auditing and troubleshooting

---

## Testing & Quality Requirements

### Code Quality
- All production code must pass PSScriptAnalyzer with no rule violations (or documented exclusions)
- Write Pester tests for reusable modules, functions, and automation scripts
- Aim for >80% code coverage on critical paths using Pester

### Cross-Platform & Encoding
- Prefer cross-platform compatible approaches: use `Join-Path`, avoid `C:\` hardcoded paths
- Assume Linux/macOS execution where applicable; avoid Windows-only cmdlets unless justified
- Use UTF-8 encoding for all files; specify `Encoding = 'UTF8'` in `Out-File`, `Add-Content`

---

## Anti-Patterns: Avoid These

- ❌ Aliases in shared/production code (e.g., `gm` instead of `Get-Member`)
- ❌ Positional parameters in function calls within modules
- ❌ `Write-Host` for data pipeline output
- ❌ Suppressing errors with `$null` or `@{} | Out-Null`
- ❌ Hardcoded secrets, API keys, or connection strings
- ❌ Interactive prompts in unattended automation
- ❌ Deprecated Azure modules (`AzureAD`, `MSOnline`)
- ❌ `Invoke-Expression` or `[scriptblock]::Create()`
- ❌ Manual `-WhatIf` / `-Confirm` logic (use `SupportsShouldProcess`)
- ❌ Ignoring pipeline errors; always handle exceptions explicitly

---

## Specialized Guidance

These global standards apply everywhere. For deeper guidance on specific domains, reference specialized skill documentation:

- **powershell-scripting**: Advanced function design, module structure, parameter patterns, performance
- **powershell-review**: PSScriptAnalyzer rules, code quality metrics, maintainability assessment
- **powershell-testing**: Pester patterns, unit/integration testing, mocking, CI/CD integration
- **powershell-security**: Compliance frameworks, hardening, audit logging, secret management patterns
- **powershell-azure**: Azure service integration, runbooks, resource automation, monitoring

Ask for skill-specific guidance when implementing domain expertise beyond global standards.
