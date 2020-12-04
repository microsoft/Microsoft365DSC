function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsEnabled,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $RolePermissions,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of Azure AD role definition"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        try
        {
            if ($null -ne $Id -or $Id -ne "")
            {
                $AADRoleDefinition = Get-AzureADMSRoleDefinition -Id $Id
            }
        }
        catch
        {
            Write-Verbose -Message "Could not retrieve AAD roledefinition by Id: {$Id}"
        }
        if ($null -eq $AADRoleDefinition)
        {
            $AADRoleDefinition = Get-AzureADMSRoleDefinition -Filter "DisplayName eq '$($DisplayName)'"
        }
        if ($null -eq $AADRoleDefinition)
        {
            return $nullReturn
        }
        else
        {
            $result = @{
                Id                    = $AADRoleDefinition.Id
                DisplayName           = $AADRoleDefinition.DisplayName
                Description           = $AADRoleDefinition.Description
                ResourceScopes        = $AADRoleDefinition.ResourceScopes
                IsEnabled             = $AADRoleDefinition.IsEnabled
                RolePermissions       = $AADRoleDefinition.RolePermissions.AllowedResourceActions
                TemplateId            = $AADRoleDefinition.TemplateId
                Version               = $AADRoleDefinition.Version
                Ensure                = "Present"
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
            }
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsEnabled,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $RolePermissions,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD role definition"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentAADRoleDef = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId")  | Out-Null
    $currentParameters.Remove("RolePermissions")  | Out-Null
    $currentParameters.Remove("ResourceScopes")  | Out-Null
    $currentParameters.Remove("TenantId")  | Out-Null
    $currentParameters.Remove("CertificateThumbprint")  | Out-Null
    $currentParameters.Remove("GlobalAdminAccount")  | Out-Null
    $currentParameters.Remove("Ensure")  | Out-Null

    $rolePermissionsObj = @()
    $rolePermissionsObj += @{'allowedResourceActions' = $rolePermissions }
    $resourceScopesObj = @()
    $resourceScopesObj += $ResourceScopes

    $currentParameters.Add("RolePermissions", $rolePermissionsObj) | Out-Null
    $currentParameters.Add("ResourceScopes", $resourceScopesObj) | Out-Null

    # Role definition should exist but it doesn't
    if ($Ensure -eq "Present" -and $currentAADRoleDef.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Creating New AzureAD role defition {$DisplayName}"
        $currentParameters.Remove("Id") | Out-Null
        New-AzureADMSRoleDefinition @currentParameters
    }
    # Role definition should exist and will be configured to desired state
    if ($Ensure -eq 'Present' -and $currentAADRoleDef.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing AzureAD role definition {$DisplayName}"
        $currentParameters.Id = $currentAADRoleDef.Id
        Set-AzureADMSRoleDefinition @currentParameters
    }
    # Role definition exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADRoleDef.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD role definition {$DisplayName}"
        Remove-AzureADMSRoleDefinition -Id $currentAADRoleDef.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsEnabled,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $RolePermissions,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.String]
        $Version,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of AzureAD role definition"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null
    $ValuesToCheck.Remove("Id") | Out-Null
    $ValuesToCheck.Remove("TemplateId") | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters
    $i = 1
    Write-Host "`r`n" -NoNewline
    try
    {
        [array]$AADRoleDefinitions = Get-AzureADMSRoleDefinition -ErrorAction Stop
        foreach ($AADRoleDefinition in $AADRoleDefinitions)
        {
            Write-Host "    |---[$i/$($AADRoleDefinitions.Count)] $($AADRoleDefinition.DisplayName)" -NoNewline
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                DisplayName           = $AADRoleDefinition.DisplayName
                Id                    = $AADRoleDefinition.Id
                IsEnabled             = $true
                RolePermissions       = @("temp")
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
