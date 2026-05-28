# PowerShell Expert Agent for GitHub Copilot

A custom GitHub Copilot agent specialized in PowerShell scripting, automation, security, and Azure integration.

## Overview

This agent provides expert-level guidance for:

- **PowerShell Scripting**: Modern PowerShell 7+ best practices and patterns
- **Code Review**: PSScriptAnalyzer integration and quality assurance
- **Testing**: Pester framework and test-driven development
- **Security**: Secure scripting patterns and compliance
- **Azure Automation**: Azure PowerShell SDK and cloud automation

## Features

- TODO: Agent activation and invocation patterns
- TODO: Skill orchestration workflow
- TODO: Integration with PSScriptAnalyzer and Pester
- TODO: Azure authentication and resource management examples

## Getting Started

TODO: Installation and setup instructions

## Validation

Run local PowerShell validation with `PSScriptAnalyzer`:

1. Install dependency (one-time):

```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser
```

2. Run validation from the repository root:

```powershell
pwsh -NoProfile -File ./validation/Invoke-Validation.ps1 -Path . -Recurse
```

3. Enable strict mode to fail on any findings (errors or warnings):

```powershell
pwsh -NoProfile -File ./validation/Invoke-Validation.ps1 -Path . -Recurse -Strict
```

By default, validation fails only when `Error` severity findings are detected.

## Project Structure

``` markdown
.github/
├── copilot-instructions.md      # Agent configuration and behavior
├── agents/
│   └── powershell-expert.agent.md  # Agent definition
└── skills/                       # Specialized skill modules
    ├── powershell-scripting/
    ├── powershell-review/
    ├── powershell-testing/
    ├── powershell-security/
    └── powershell-azure/

examples/                        # Usage examples and patterns
validation/                      # PSScriptAnalyzer config and validation
```

## Documentation

- [Agent Definition](./github/agents/powershell-expert.agent.md)
- [Skills Documentation](./github/skills/)
- [Examples](./examples/README.md)
- [Validation Guidelines](./validation/)

## Requirements

- PowerShell 7.0+
- PSScriptAnalyzer (latest)
- Pester 5.0+
- TODO: Additional dependencies

## Contributing

TODO: Contribution guidelines

## License

TODO: License information
