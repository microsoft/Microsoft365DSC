@{
    Severity     = @('Error',
        'Warning')
    ExcludeRules = @('PSMissingModuleManifestField',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSAvoidGlobalVars',
        'PSAvoidUsingWriteHost')
}
