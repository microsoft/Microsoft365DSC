function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message 'Getting configuration of Azure AD ServicePrincipal'
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'Beta'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        try
        {
            if (-not [System.String]::IsNullOrEmpty($ObjectID))
            {
                $AADServicePrincipal = Get-MgServicePrincipal -ServicePrincipalId $ObjectId `
                    -ErrorAction Stop
            }
        }
        catch
        {
            Write-Error -Message "Azure AD ServicePrincipal with ObjectID: $($ObjectID) could not be retrieved"
        }

        if ($null -eq $AADServicePrincipal)
        {
            $AADServicePrincipal = Get-MgServicePrincipal -Filter "AppID eq '$($AppId)'"
        }
        if ($null -eq $AADServicePrincipal)
        {
            return $nullReturn
        }
        else
        {
            $result = @{
                AppId                     = $AADServicePrincipal.AppId
                ObjectID                  = $AADServicePrincipal.Id
                DisplayName               = $AADServicePrincipal.DisplayName
                AlternativeNames          = $AADServicePrincipal.AlternativeNames
                AccountEnabled            = [boolean]$AADServicePrincipal.AccountEnabled
                AppRoleAssignmentRequired = $AADServicePrincipal.AppRoleAssignmentRequired
                ErrorUrl                  = $AADServicePrincipal.ErrorUrl
                Homepage                  = $AADServicePrincipal.Homepage
                LogoutUrl                 = $AADServicePrincipal.LogoutUrl
                PublisherName             = $AADServicePrincipal.PublisherName
                ReplyURLs                 = $AADServicePrincipal.ReplyURLs
                SamlMetadataURL           = $AADServicePrincipal.SamlMetadataURL
                ServicePrincipalNames     = $AADServicePrincipal.ServicePrincipalNames
                ServicePrincipalType      = $AADServicePrincipal.ServicePrincipalType
                Tags                      = $AADServicePrincipal.Tags
                Ensure                    = 'Present'
                Credential                = $Credential
                ApplicationId             = $ApplicationId
                ApplicationSecret         = $ApplicationSecret
                TenantId                  = $TenantId
                CertificateThumbprint     = $CertificateThumbprint
                Managedidentity           = $ManagedIdentity.IsPresent
            }
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        $AppId,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "1 - There are now {$((Get-ChildItem function: | Measure-Object).Count) functions}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters -ProfileName 'Beta'

    Write-Verbose -Message "2 - There are now {$((Get-ChildItem function: | Measure-Object).Count) functions}"
    Write-Verbose -Message 'Setting configuration of Azure AD ServicePrincipal'
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentAADServicePrincipal = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove('ApplicationId') | Out-Null
    $currentParameters.Remove('TenantId') | Out-Null
    $currentParameters.Remove('CertificateThumbprint') | Out-Null
    $currentParameters.Remove('ManagedIdentity') | Out-Null
    $currentParameters.Remove('Credential') | Out-Null
    $currentParameters.Remove('Ensure') | Out-Null
    $currentParameters.Remove('ObjectID') | Out-Null
    $currentParameters.Remove('ApplicationSecret') | Out-Null

    # ServicePrincipal should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADServicePrincipal.Ensure -eq 'Absent')
    {
        Write-Verbose -Message 'Creating new Service Principal'
        New-MgServicePrincipal @currentParameters
    }
    # ServicePrincipal should exist and will be configured to desired state
    if ($Ensure -eq 'Present' -and $currentAADServicePrincipal.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Updating existing Service Principal'
        Write-Verbose -Message "CurrentParameters: $($currentParameters | Out-String)"
        Write-Verbose -Message "ServicePrincipalID: $($currentAADServicePrincipal.ObjectID)"
        Update-MgServicePrincipal -ServicePrincipalId $currentAADServicePrincipal.ObjectID @currentParameters
    }
    # ServicePrincipal exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADServicePrincipal.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Removing Service Principal'
        Remove-MgServicePrincipal -ServicePrincipalId $currentAADServicePrincipal.ObjectID
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
        $AppId,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message 'Testing configuration of Azure AD ServicePrincipal'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null

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
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    try
    {
        $i = 1
        Write-Host "`r`n" -NoNewline
        $AADServicePrincipals = Get-MgServicePrincipal -All:$true -Filter $Filter -ErrorAction Stop
        foreach ($AADServicePrincipal in $AADServicePrincipals)
        {
            Write-Host "    |---[$i/$($AADServicePrincipals.Count)] $($AADServicePrincipal.DisplayName)" -NoNewline
            $Params = @{
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                ApplicationSecret     = $ApplicationSecret
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                AppID                 = $AADServicePrincipal.AppId
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
