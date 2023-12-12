<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneASRRulesPolicyWindows10 'myASRRulesPolicy'
        {
            Identity                                        = '1902b7f6-ac2c-4c00-bc17-8ada967cc6a8'
            DisplayName                                     = 'test'
            AdditionalGuardedFolders                        = @()
            AdobeReaderLaunchChildProcess                   = 'auditMode'
            AdvancedRansomewareProtectionType               = 'enable'
            Assignments                                     = @()
            AttackSurfaceReductionExcludedPaths             = @('c:\Novo')
            BlockPersistenceThroughWmiType                  = 'auditMode'
            Description                                     = ''
            EmailContentExecutionType                       = 'auditMode'
            GuardedFoldersAllowedAppPaths                   = @()
            GuardMyFoldersType                              = 'enable'
            OfficeAppsExecutableContentCreationOrLaunchType = 'block'
            OfficeAppsLaunchChildProcessType                = 'auditMode'
            OfficeAppsOtherProcessInjectionType             = 'block'
            OfficeCommunicationAppsLaunchChildProcess       = 'auditMode'
            OfficeMacroCodeAllowWin32ImportsType            = 'block'
            PreventCredentialStealingType                   = 'enable'
            ProcessCreationType                             = 'block'
            ScriptDownloadedPayloadExecutionType            = 'block'
            ScriptObfuscatedMacroCodeType                   = 'block'
            UntrustedExecutableType                         = 'block'
            UntrustedUSBProcessType                         = 'block'
            Ensure                                          = 'Present'
            Credential                                      = $Credscredential
        }
    }
}
