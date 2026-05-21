@{
    # PSScriptAnalyzer Settings for PowerShell Expert Agent

    # TODO: Define included rules
    IncludeRules = @(
        # Design Rules
        'PSAvoidDefaultParameterValues'
        'PSAvoidDefaultTrueValueAssignment'
        'PSAvoidInvokeUsingStringFormat'
        'PSAvoidUsingCmdletAliases'
        'PSAvoidUsingComputerNameHardcoded'
        'PSAvoidUsingConvertToSecureStringWithPlainText'
        'PSAvoidUsingDeprecatedManifestFields'
        'PSAvoidUsingEmptyCatchBlock'
        'PSAvoidUsingInvokeExpression'
        'PSAvoidUsingPositionalParameters'
        'PSAvoidUsingUserNameAndPasswordParams'
        'PSAvoidUsingWildcardCharactersInName'
        'PSDSCUseIdenticalMandatoryParametersForDSC'
        'PSMissingModuleManifestField'
        'PSReservedCmdletChar'
        'PSReservedParams'
        'PSUseApprovedVerbs'
        'PSUseCmdletCorrectly'
        'PSUseConsistentIndentation'
        'PSUseConsistentWhitespace'
        'PSUseCorrectCasing'
        'PSUseNamedParameters'
        'PSUsePSCredentialType'
        'PSUseSingularNouns'
        'PSUseToExportFieldsInManifest'
        'PSUseUTF8EncodingForHelpFile'

        # Performance Rules
        'PSAvoidAssignmentToAutomaticVariable'
        'PSAvoidUsingDoubleQuotedStrings'
        'PSAvoidUsingInvokeWebRequest'
        'PSAvoidUsingWriteHost'
        'PSUseArrayAliasInsteadOfForeach'
    )

    # TODO: Define rules to exclude if needed
    ExcludeRules = @(
        # TODO: Add exclusions as needed
    )

    # TODO: Configure rule severity levels
    Severity = @{
        'PSAvoidUsingCmdletAliases' = 'Warning'
        'PSAvoidUsingWriteHost' = 'Information'
        'PSUseConsistentIndentation' = 'Information'
        'PSUseConsistentWhitespace' = 'Information'
    }

    # TODO: Configure custom rules
    Rules = @{
        # Indentation settings
        PSUseConsistentIndentation = @{
            Enable = $true
            Kind = 'space'
            PipelineIndentation = 'IncreaseIndentationAfterEveryPipeline'
            IndentationSize = 4
        }

        # Whitespace settings
        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckInnerBrace = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator = $true
            CheckPipe = $true
            CheckPipelineIndentation = $true
            CheckSeparator = $true
        }

        # Named parameters
        PSUseNamedParameters = @{
            Enable = $true
        }

        # Avoid using positional parameters
        PSAvoidUsingPositionalParameters = @{
            Enable = $true
            CommandAstTypes = @('System.Management.Automation.Language.CommandAst')
        }

        # Casing rules
        PSUseCorrectCasing = @{
            Enable = $true
        }
    }

    # TODO: Recursion settings
    Recurse = $true

    # TODO: Include test files
    IncludeDefaultRules = $true

    # TODO: Output format
    Format = 'Sarif'
}
