<#
.SYNOPSIS
    Get the evaluation rules for guarding a given configuration.
.DESCRIPTION
    This function will return all the evaluation rules for a given configuration either as a new configuration file or as a list of rules that can be used in a configuration to guard the resources.
.PARAMETER ConfigurationPath
    The path to the configuration file.
.PARAMETER OutputPath
    The path to the output file. If not provided, the function will return the evaluation rules as a string.
#>
function Get-M365DSCEvaluationRulesForConfiguration
{
    [CmdletBinding()]
    [OutputType([System.String], ParameterSetName = 'Plaintext')]
    [OutputType([System.Void], ParameterSetName = 'Configuration')]
    param (
        [Parameter(ParameterSetName = ('Configuration', 'Plaintext'), Mandatory = $true)]
        [string]
        $ConfigurationPath,

        [Parameter(ParameterSetName = 'Configuration')]
        [string]
        $OutputPath,

        [Parameter(ParameterSetName = ('Configuration', 'Plaintext'), Mandatory = $true)]
        [ValidateSet('ServicePrincipalWithThumbprint', 'ServicePrincipalWithSecret', 'ServicePrincipalWithPath', 'CredentialsWithTenantId', 'CredentialsWithApplicationId', 'Credentials', 'ManagedIdentity')]
        [System.String]
        $ConnectionMode
    )

    $configurationAsObject = ConvertTo-DSCObject -Path $ConfigurationPath

    $groupCondition = {
        $_.ResourceName
    }

    $groupedObjects = $configurationAsObject | Group-Object $groupCondition

    $M365DSCRuleEvaluationBlock = @'
    # region Evaluation Rules
    # This block contains the evaluation rules for the configuration.
    # It is used to guard the resources in the configuration.
    <INSERT_RULES_HERE>
    # endregion
'@

    switch ($ConnectionMode)
    {
        'ServicePrincipalWithThumbprint'
        {
            $authentication = @"
        ApplicationId           = `$ConfigurationData.NonNodeData.ApplicationId
        TenantId                = `$ConfigurationData.NonNodeData.OrganizationName
        CertificateThumbprint   = `$ConfigurationData.NonNodeData.CertificateThumbprint
"@
        }
        'ServicePrincipalWithSecret'
        {
            $authentication = @"
        ApplicationId           = `$ConfigurationData.NonNodeData.ApplicationId
        TenantId                = `$ConfigurationData.NonNodeData.OrganizationName
        CertificatePassword     = `$CertificatePassword
"@
        }
        'ServicePrincipalWithPath'
        {
            $authentication = @"
        ApplicationId           = `$ConfigurationData.NonNodeData.ApplicationId
        TenantId                = `$ConfigurationData.NonNodeData.OrganizationName
        CertificatePath         = `$ConfigurationData.NonNodeData.CertificatePath
"@
        }
        'CredentialsWithTenantId'
        {
            $authentication = @"
        Credential              = `$CredsCredential
        TenantId                = `$ConfigurationData.NonNodeData.OrganizationName
"@
        }
        'CredentialsWithApplicationId'
        {
            $authentication = @"
        Credential              = `$CredsCredential
        ApplicationId           = `$ConfigurationData.NonNodeData.ApplicationId
        TenantId                = `$ConfigurationData.NonNodeData.OrganizationName
"@
        }
        'ManagedIdentity'
        {
            $authentication = @"
        ManagedIdentity         = `$true
"@
        }
        'Credentials'
        {
            $authentication = @"
        Credential              = `$CredsCredential
"@
        }
    }

    $M365DSCRuleEvaluationResourceBlock = @'
    M365DSCRuleEvaluation '<ResourceName>'
    {
        ResourceName            = '<ResourceName>'
        RuleDefinition          = "*"
        AfterRuleCountQuery     = "-eq <Count>"
<Authentication>
    }
'@

    $resultConfiguration = @()
    foreach ($group in $groupedObjects)
    {
        $resultConfiguration += $M365DSCRuleEvaluationResourceBlock -replace '<ResourceName>', $group.Name -replace '<Count>', $group.Count -replace '<Authentication>', $authentication
    }

    $M365DSCRuleEvaluationString = $M365DSCRuleEvaluationBlock -replace '<INSERT_RULES_HERE>', ($resultConfiguration -join "`n")

    if ($PSBoundParameters.Keys.Contains('OutputPath'))
    {
        if (-not (Test-Path -Path $OutputPath))
        {
            New-Item -Path $OutputPath -ItemType File -Force | Out-Null
        }

        $DSCString = @"
        # Generated with Microsoft365DSC
        # For additional information on how to use Microsoft365DSC, please visit https://aka.ms/M365DSC
        param (
        )

        Configuration M365TenantConfig
        {
            param (
            )

            $OrganizationName = $ConfigurationData.NonNodeData.OrganizationName

            Import-DscResource -ModuleName 'Microsoft365DSC'

            Node localhost
            {
               <Instances>
            }
        }

        M365TenantConfig -ConfigurationData .\ConfigurationData.psd1
"@

        $M365DSCRuleEvaluationString = $DSCString -replace '<Instances>', $M365DSCRuleEvaluationString

        $M365DSCRuleEvaluationString | Out-File -FilePath $OutputPath
    }
    else
    {
        return $M365DSCRuleEvaluationString
    }
}

Export-ModuleMember -Function Get-M365DSCEvaluationRulesForConfiguration
