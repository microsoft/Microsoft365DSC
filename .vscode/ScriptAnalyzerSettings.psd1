@{
    Severity = @(
        'Error',
        'Warning'
    )
    ExcludeRules = @(
        'PSMissingModuleManifestField',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSAvoidGlobalVars',
        'PSAvoidUsingWriteHost'
    )
    CustomRulePath = @(
        '.vscode\CustomRules\UseCorrectMethodCasing.psm1'
    )
    IncludeDefaultRules = $true
}
