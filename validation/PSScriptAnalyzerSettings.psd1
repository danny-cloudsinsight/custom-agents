@{
    # Baseline rules for local and CI validation.
    IncludeRules = @(
        # Security and safe scripting
        'PSAvoidUsingCmdletAliases'
        'PSAvoidUsingConvertToSecureStringWithPlainText'
        'PSAvoidUsingInvokeExpression'
        'PSAvoidUsingUserNameAndPasswordParams'

        # Maintainability and correctness
        'PSAvoidUsingEmptyCatchBlock'
        'PSAvoidUsingPositionalParameters'
        'PSUseApprovedVerbs'
        'PSUseCmdletCorrectly'
        'PSUseNamedParameters'
        'PSUsePSCredentialType'
        'PSUseSingularNouns'

        # Readability
        'PSUseConsistentIndentation'
        'PSUseConsistentWhitespace'
        'PSUseCorrectCasing'
        'PSAvoidUsingWriteHost'
    )

    ExcludeRules = @()

    # Include warning and error findings for the baseline run.
    Severity = @('Error', 'Warning')

    # Keep custom rule tuning intentionally minimal for MVP.
    Rules = @{
        PSUseConsistentIndentation = @{
            Kind = 'space'
            IndentationSize = 4
        }

        PSUseConsistentWhitespace = @{
            CheckInnerBrace = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator = $true
            CheckPipe = $true
            CheckSeparator = $true
        }
    }

    IncludeDefaultRules = $false
}
