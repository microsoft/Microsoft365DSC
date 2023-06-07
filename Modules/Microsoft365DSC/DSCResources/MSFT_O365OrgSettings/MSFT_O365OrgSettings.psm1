function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $CortanaEnabled,

        [Parameter()]
        [System.Boolean]
        $M365WebEnableUsersToOpenFilesFrom3PStorage,

        [Parameter()]
        [System.Boolean]
        $AdminCenterReportDisplayConcealedNames,

        [Parameter()]
        [System.String]
        [ValidateSet('current', 'monthlyEnterprise', 'semiAnnual')]
        $InstallationOptionsUpdateChannel,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isVisioEnabled', 'isSkypeForBusinessEnabled', 'isProjectEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForWindows,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isSkypeForBusinessEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForMac,

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

    if ($PSBoundParameters.ContainsKey('Ensure') -and $Ensure -eq 'Absent')
    {
        throw 'This resource is not able to remove Org Settings settings and therefore only accepts Ensure=Present.'
    }

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

    $nullReturn = @{
        IsSingleInstance = $IsSingleInstance
        Ensure           = 'Absent'
    }

    try
    {
        $OfficeOnlineId = 'c1f33bc0-bdb4-4248-ba9b-096807ddb43e'
        $M365WebEnableUsersToOpenFilesFrom3PStorageValue = Get-MgServicePrincipal -Filter "appId eq '$OfficeOnlineId'" -Property 'AccountEnabled'

        $CortanaId = '0a0a29f9-0a25-49c7-94bf-c53c3f8fa69d'
        $CortanaEnabledValue = Get-MgServicePrincipal -Filter "appId eq '$CortanaId'" -Property 'AccountEnabled'

        $MRODeviceManagerService = 'ebe0c285-db95-403f-a1a3-a793bd6d7767'
        try
        {
            $servicePrincipal = Get-MgServicePrincipal -Filter "appid eq 'ebe0c285-db95-403f-a1a3-a793bd6d7767'"
            if ($null -eq $servicePrincipal)
            {
                Write-Verbose -Message "Registering the MRO Device Manager Service Principal"
                New-MgServicePrincipal -AppId 'ebe0c285-db95-403f-a1a3-a793bd6d7767' -ErrorAction Stop | Out-Null
            }
        }
        catch
        {
            Write-Verbose -Message $_
        }

        $AdminCenterReportDisplayConcealedNamesValue = Get-M365DSCOrgSettingsAdminCenterReport

        $installationOptions = Get-M365DSCOrgSettingsInstallationOptions
        $appsForWindowsValue = @()
        foreach ($key in $installationOptions.appsForWindows.Keys)
        {
            if ($installationOptions.appsForWindows.$key)
            {
                $appsForWindowsValue += $key
            }
        }
        $appsForMacValue = @()
        foreach ($key in $installationOptions.appsForMac.Keys)
        {
            if ($installationOptions.appsForMac.$key)
            {
                $appsForMacValue += $key
            }
        }

        return @{
            IsSingleInstance                           = 'Yes'
            CortanaEnabled                             = $CortanaEnabledValue.AccountEnabled
            M365WebEnableUsersToOpenFilesFrom3PStorage = $M365WebEnableUsersToOpenFilesFrom3PStorageValue.AccountEnabled
            AdminCenterReportDisplayConcealedNames     = $AdminCenterReportDisplayConcealedNamesValue.displayConcealedNames
            InstallationOptionsUpdateChannel           = $installationOptions.updateChannel
            InstallationOptionsAppsForWindows          = $appsForWindowsValue
            InstallationOptionsAppsForMac              = $appsForMacValue
            Ensure                                     = 'Present'
            Credential                                 = $Credential
            ApplicationId                              = $ApplicationId
            TenantId                                   = $TenantId
            ApplicationSecret                          = $ApplicationSecret
            CertificateThumbprint                      = $CertificateThumbprint
            Managedidentity                            = $ManagedIdentity.IsPresent
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $CortanaEnabled,

        [Parameter()]
        [System.Boolean]
        $M365WebEnableUsersToOpenFilesFrom3PStorage,

        [Parameter()]
        [System.Boolean]
        $AdminCenterReportDisplayConcealedNames,

        [Parameter()]
        [System.String]
        [ValidateSet('current', 'monthlyEnterprise', 'semiAnnual')]
        $InstallationOptionsUpdateChannel,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isVisioEnabled', 'isSkypeForBusinessEnabled', 'isProjectEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForWindows,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isSkypeForBusinessEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForMac,

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

    if ($PSBoundParameters.ContainsKey('Ensure') -and $Ensure -eq 'Absent')
    {
        throw 'This resource is not able to remove the Org settings and therefore only accepts Ensure=Present.'
    }

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

    Write-Verbose -Message 'Setting configuration of Office 365 Settings'
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    $OfficeOnlineId = 'c1f33bc0-bdb4-4248-ba9b-096807ddb43e'
    $M365WebEnableUsersToOpenFilesFrom3PStorageValue = Get-MgServicePrincipal -Filter "appId eq '$OfficeOnlineId'" -Property 'AccountEnabled, Id'
    if ($M365WebEnableUsersToOpenFilesFrom3PStorage -ne $M365WebEnableUsersToOpenFilesFrom3PStorageValue.AccountEnabled -and `
        $M365WebEnableUsersToOpenFilesFrom3PStorage.Id -ne $null)
    {
        Write-Verbose -Message "Updating the Microsoft 365 On the Web setting to {$M365WebEnableUsersToOpenFilesFrom3PStorage}"
        Update-MgServicePrincipal -ServicePrincipalId $($M365WebEnableUsersToOpenFilesFrom3PStorageValue.Id) `
            -AccountEnabled:$M365WebEnableUsersToOpenFilesFrom3PStorage
    }

    $CortanaId = '0a0a29f9-0a25-49c7-94bf-c53c3f8fa69d'
    $CortanaEnabledValue = Get-MgServicePrincipal -Filter "appId eq '$CortanaId'" -Property 'AccountEnabled, Id'
    if ($CortanaEnabled -ne $CortanaEnabledValue.AccountEnabled -and `
        $CortanaEnabledValue.Id -ne $null)
    {
        Write-Verbose -Message "Updating the Cortana setting to {$CortanaEnabled}"
        Update-MgServicePrincipal -ServicePrincipalId $($CortanaEnabledValue.Id) `
            -AccountEnabled:$CortanaEnabled
    }

    $AdminCenterReportDisplayConcealedNamesEnabled = Get-M365DSCOrgSettingsAdminCenterReport
    Write-Verbose "$($AdminCenterReportDisplayConcealedNamesEnabled.displayConcealedNames) = $AdminCenterReportDisplayConcealedNames"
    if ($AdminCenterReportDisplayConcealedNames -ne $AdminCenterReportDisplayConcealedNamesEnabled.displayConcealedNames)
    {
        Write-Verbose -Message "Updating the Admin Center Report Display Concealed Names setting to {$AdminCenterReportDisplayConcealedNames}"
        Update-M365DSCOrgSettingsAdminCenterReport -DisplayConcealedNames $AdminCenterReportDisplayConcealedNames
    }

    if ($PSBoundParameters.ContainsKey("InstallationOptionsAppsForWindows") -or $PSBoundParameters.ContainsKey("InstallationOptionsAppsForMac"))
    {
        $InstallationOptions = Get-M365DSCOrgSettingsInstallationOptions
        $InstallationOptionsToUpdate = @{
            updateChannel = ""
            appsForWindows = @{
                isMicrosoft365AppsEnabled = $false
                isProjectEnabled          = $false
                isSkypeForBusinessEnabled = $false
                isVisioEnabled            = $false
            }
            appsForMac = @{
                isMicrosoft365AppsEnabled = $false
                isSkypeForBusinessEnabled = $false
            }
        }

        if ($PSBoundParameters.ContainsKey("InstallationOptionsUpdateChannel") -and `
            ($InstallationOptionsUpdateChannel -ne $InstallationOptions.updateChannel))
        {
            $InstallationOptionsToUpdate.updateChannel = $InstallationOptionsUpdateChannel
        }
        else
        {
            $InstallationOptionsToUpdate.Remove('updateChannel') | Out-Null
        }

        if ($PSBoundParameters.ContainsKey("InstallationOptionsAppsForWindows"))
        {
            foreach ($key in $InstallationOptionsAppsForWindows)
            {
                $InstallationOptionsToUpdate.appsForWindows.$key = $true
            }
        }
        else
        {
            $InstallationOptionsToUpdate.Remove('appsForWindows') | Out-Null
        }

        if ($PSBoundParameters.ContainsKey("InstallationOptionsAppsForMac"))
        {
            foreach ($key in $InstallationOptionsAppsForMac)
            {
                $InstallationOptionsToUpdate.appsForMac.$key = $true
            }
        }
        else
        {
            $InstallationOptionsToUpdate.Remove('appsForMac') | Out-Null
        }

        if ($InstallationOptionsToUpdate.Keys.Count -gt 0)
        {
            Write-Verbose -Message "Updating O365 Installation Options with $(Convert-M365DscHashtableToString -Hashtable $InstallationOptionsToUpdate)"
            Update-M365DSCOrgSettingsInstallationOptions -Options $InstallationOptionsToUpdate
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $CortanaEnabled,

        [Parameter()]
        [System.Boolean]
        $M365WebEnableUsersToOpenFilesFrom3PStorage,

        [Parameter()]
        [System.Boolean]
        $AdminCenterReportDisplayConcealedNames,

        [Parameter()]
        [System.String]
        [ValidateSet('current', 'monthlyEnterprise', 'semiAnnual')]
        $InstallationOptionsUpdateChannel,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isVisioEnabled', 'isSkypeForBusinessEnabled', 'isProjectEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForWindows,

        [Parameter()]
        [System.String[]]
        [ValidateSet('isSkypeForBusinessEnabled', 'isMicrosoft365AppsEnabled')]
        $InstallationOptionsAppsForMac,

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

    Write-Verbose -Message 'Testing configuration for Org Settings.'

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

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

    try
    {
        $Params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
        }

        $Results = Get-TargetResource @Params

        $dscContent = ''
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
        }
        Write-Host $Global:M365DSCEmojiGreenCheckMark

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

function Get-M365DSCOrgSettingsAdminCenterReport
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    $url = 'https://graph.microsoft.com/beta/admin/reportSettings'
    $results = Invoke-MgGraphRequest -Method GET -Uri $url
    return $results
}

function Update-M365DSCOrgSettingsAdminCenterReport
{
    [CmdletBinding()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $DisplayConcealedNames
    )
    $url = 'https://graph.microsoft.com/beta/admin/reportSettings'
    $body = @{
        "@odata.context"      ="https://graph.microsoft.com/beta/$metadata#admin/reportSettings/$entity"
        displayConcealedNames = $DisplayConcealedNames
    }
    Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $body | Out-Null
}

function Get-M365DSCOrgSettingsInstallationOptions
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    $url = 'https://graph.microsoft.com/beta/admin/microsoft365Apps/installationOptions'
    $results = Invoke-MgGraphRequest -Method GET -Uri $url
    return $results
}

function Update-M365DSCOrgSettingsInstallationOptions
{
    [CmdletBinding()]
    [OutputType([Void])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Options
    )
    $url = 'https://graph.microsoft.com/beta/admin/microsoft365Apps/installationOptions'
    Invoke-MgGraphRequest -Method PATCH -Uri $url -Body $Options | Out-Null
}

Export-ModuleMember -Function *-TargetResource
