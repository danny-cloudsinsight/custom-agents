<#
.SYNOPSIS
    Validates PowerShell scripts and modules in the repository.

.DESCRIPTION
    Runs PSScriptAnalyzer and other validation checks against PowerShell
    scripts and modules to ensure they meet quality and security standards.

.PARAMETER Path
    The path to validate. Defaults to repository root.

.PARAMETER SettingsPath
    Path to PSScriptAnalyzerSettings.psd1. Defaults to the validation script directory.

.PARAMETER Recurse
    Recursively validate subdirectories.

.PARAMETER Strict
    Fail on any rule violations.

.EXAMPLE
    ./Invoke-Validation.ps1
    ./Invoke-Validation.ps1 -Path './scripts' -Strict
#>

[CmdletBinding()]
param(
    [Parameter(ValueFromPipeline = $true)]
    [ValidateScript({ Test-Path -Path $_ -PathType Container })]
    [string]$Path = '.',

    [Parameter()]
    [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
    [string]$SettingsPath = (Join-Path -Path $PSScriptRoot -ChildPath 'PSScriptAnalyzerSettings.psd1'),

    [Parameter()]
    [switch]$Recurse,

    [Parameter()]
    [switch]$Strict
)

begin {
    $ErrorActionPreference = 'Stop'
    Write-Verbose 'Starting PowerShell validation process.'

    $script:ValidationFailed = $false
    $script:Summaries = [System.Collections.Generic.List[object]]::new()

    $module = Get-Module -ListAvailable -Name 'PSScriptAnalyzer' | Select-Object -First 1
    if (-not $module) {
        Write-Error 'PSScriptAnalyzer is not installed. Install it with: Install-Module PSScriptAnalyzer -Scope CurrentUser'
        $script:ValidationFailed = $true
        return
    }

    Write-Verbose ("Using PSScriptAnalyzer version {0}" -f $module.Version)

    $resolvedSettingsPath = (Resolve-Path -Path $SettingsPath).Path
    try {
        # Ensure the settings file loads as a valid PowerShell data file.
        $script:AnalyzerSettings = Import-PowerShellDataFile -Path $resolvedSettingsPath
        $script:ResolvedSettingsPath = $resolvedSettingsPath
    }
    catch {
        Write-Error ("Unable to load settings file '{0}': {1}" -f $SettingsPath, $_.Exception.Message)
        $script:ValidationFailed = $true
    }
}

process {
    if ($script:ValidationFailed) {
        return
    }

    try {
        $resolvedPath = (Resolve-Path -Path $Path).Path
        Write-Host ("Validating path: {0}" -f $resolvedPath) -ForegroundColor Cyan

        $targetFiles = Get-ChildItem -Path $resolvedPath -File -Recurse:$Recurse |
            Where-Object { $_.Extension -in @('.ps1', '.psm1', '.psd1') }

        if (-not $targetFiles) {
            Write-Warning ("No PowerShell files found at '{0}'." -f $resolvedPath)
            return
        }

        Write-Verbose ("Discovered {0} PowerShell file(s)." -f $targetFiles.Count)

        $results = foreach ($file in $targetFiles) {
            Invoke-ScriptAnalyzer -Path $file.FullName -Settings $script:AnalyzerSettings
        }
        $errorResults = $results | Where-Object { $_.Severity -eq 'Error' }
        $warningResults = $results | Where-Object { $_.Severity -eq 'Warning' }
        $informationResults = $results | Where-Object { $_.Severity -eq 'Information' }

        $summary = [pscustomobject]@{
            Path             = $resolvedPath
            FilesScanned     = $targetFiles.Count
            ErrorCount       = @($errorResults).Count
            WarningCount     = @($warningResults).Count
            InformationCount = @($informationResults).Count
            ResultCount      = @($results).Count
        }

        $null = $script:Summaries.Add($summary)

        if ($summary.ResultCount -eq 0) {
            Write-Host 'No issues found.' -ForegroundColor Green
            return
        }

        Write-Warning (
            "Found {0} issue(s): Errors={1}, Warnings={2}, Information={3}" -f
            $summary.ResultCount,
            $summary.ErrorCount,
            $summary.WarningCount,
            $summary.InformationCount
        )

        $results |
            Sort-Object Severity, ScriptName, Line |
            Select-Object Severity, RuleName, ScriptName, Line, Message |
            Format-Table -AutoSize

        if ($Strict) {
            if ($summary.ResultCount -gt 0) {
                $script:ValidationFailed = $true
            }
        }
        elseif ($summary.ErrorCount -gt 0) {
            $script:ValidationFailed = $true
        }
    }
    catch {
        Write-Error ("Validation failed for path '{0}': {1}" -f $Path, $_.Exception.Message)
        $script:ValidationFailed = $true
    }
}

end {
    if ($script:Summaries.Count -gt 0) {
        Write-Host ''
        Write-Host 'Validation summary:' -ForegroundColor Cyan
        $script:Summaries | Format-Table -AutoSize
    }

    if ($script:ValidationFailed) {
        Write-Error 'Validation failed.'
        exit 1
    }

    Write-Host 'Validation succeeded.' -ForegroundColor Green
    Write-Verbose 'Validation process completed.'
    exit 0
}
