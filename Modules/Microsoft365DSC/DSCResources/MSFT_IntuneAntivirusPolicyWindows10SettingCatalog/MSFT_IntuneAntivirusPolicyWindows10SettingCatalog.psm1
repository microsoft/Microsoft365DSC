function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowdatagramprocessingonwinserver,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allownetworkprotectiondownlevel,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter]
        [System.Int32]
        $archivemaxdepth,

        [Parameter]
        [System.Int32]
        $archivemaxsize,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet('0', '2', '4', '6')]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.String]
        $companyname,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableaccountprotectionui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableappbrowserui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecleartpmbutton,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabledevicesecurityui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablednsovertcpparsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableenhancednotifications,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablefamilyui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehealthui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehttpparsing,

        [Parameter()]
        [ValidateSet('1', '0')]
        [System.String]
        $DisableSshParsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablenetworkui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletpmfirmwareupdatewarning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablevirusui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [System.String]
        $email,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablecustomizedtoasts,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enableinappcustomization,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $enablenetworkprotection,

        [Parameter()]
        [System.String[]]
        $excludedextensions,

        [Parameter()]
        [System.String[]]
        $excludedpaths,

        [Parameter()]
        [System.String[]]
        $excludedprocesses,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hideransomwaredatarecovery,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hidewindowssecuritynotificationareacontrol,

        [Parameter()]
        [System.String]
        $phone,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $engineupdateschannel,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $meteredconnectionupdates,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $platformupdateschannel,

        [Parameter()]
        [ValidateSet('0', '4', '5')]
        [System.String]
        $securityintelligenceupdateschannel,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet('1', '2')]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $schedulescanday,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $schedulescantime,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletlsparsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $randomizescheduletasktimes,

        [Parameter()]
        [ValidateRange(1,23)]
        [System.Int32]
        $schedulerrandomizationtime,

        [Parameter()]
        [System.String[]]
        $signatureupdatefallbackorder,

        [Parameter()]
        [System.String[]]
        $signatureupdatefilesharessources,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $signatureupdateinterval,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3')]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $tamperprotection,

        [Parameter()]
        [System.String]
        $url,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $highseveritythreats,

        [Parameter()]
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $templateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try 
    {
        Write-Verbose -Message "Checking for the Intune Endpoint Protection Policy {$DisplayName}"

        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ErrorAction Stop

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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $templateReferences = "d948ff9b-99cb-4ee0-8012-1fbc09685377_1", "e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1", "45fea5e9-280d-4da1-9792-fb5736da0ca9_1","804339ad-1553-4478-a742-138fb5807418_1"

        #Retrieve policy general settings
        $policy = Get-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $Identity -ErrorAction SilentlyContinue

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find an Intune Antivirus Policy for Windows10 Setting Catalog with Id {$Identity}"

            if (-not [System.String]::IsNullOrEmpty($DisplayName))
            {
                $policy = Get-MgBetaDeviceManagementConfigurationPolicy `
                    -Filter "Name eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue | Where-Object `
                    -FilterScript {
                        $_.TemplateReference.TemplateId -in $templateReferences
                    }
            }
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find an Intune Antivirus Policy for Windows10 Setting Catalog with Name {$DisplayName}"
            return $nullResult
        }
        $Identity = $policy.Id
        Write-Verbose -Message "An Intune Antivirus Policy for Windows10 Setting Catalog with Id {$Identity} and Name {$DisplayName} was found."

        #Retrieve policy specific settings
        [array]$settings = Get-MgBetaDeviceManagementConfigurationPolicySetting `
            -DeviceManagementConfigurationPolicyId $Identity `
            -ExpandProperty 'settingDefinitions' `
            -ErrorAction Stop

        $policySettings = @{}
        $policySettings = Export-IntuneSettingCatalogPolicySettings -Settings $settings -ReturnHashtable $policySettings

        $returnHashtable = @{}
        $returnHashtable.Add('Identity', $Identity)
        $returnHashtable.Add('DisplayName', $policy.name)
        $returnHashtable.Add('Description', $policy.description)
        $returnHashtable.Add('templateId', $policy.templateReference.templateId)
        $returnHashtable += $policySettings

        $returnAssignments = @()
        $graphAssignments = Get-MgBetaDeviceManagementConfigurationPolicyAssignment -DeviceManagementConfigurationPolicyId $Identity
        if ($graphAssignments.Count -gt 0)
        {
            $returnAssignments += ConvertFrom-IntunePolicyAssignment `
                                        -IncludeDeviceFilter:$true `
                                        -Assignments ($graphAssignments)
        }
        $returnHashtable.Add('Assignments', $returnAssignments)

        $returnHashtable.Add('Ensure', 'Present')
        $returnHashtable.Add('Credential', $Credential)
        $returnHashtable.Add('ApplicationId', $ApplicationId)
        $returnHashtable.Add('TenantId', $TenantId)
        $returnHashtable.Add('ApplicationSecret', $ApplicationSecret)
        $returnHashtable.Add('CertificateThumbprint', $CertificateThumbprint)
        $returnHashtable.Add('ManagedIdentity', $ManagedIdentity.IsPresent)
        $returnHashtable.Add('AccessTokens', $AccessTokens)

        return $returnHashtable
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

            $nullResult = Clear-M365DSCAuthenticationParameter -BoundParameters $nullResult
            return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowdatagramprocessingonwinserver,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allownetworkprotectiondownlevel,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter]
        [System.Int32]
        $archivemaxdepth,

        [Parameter]
        [System.Int32]
        $archivemaxsize,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet('0', '2', '4', '6')]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.String]
        $companyname,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableaccountprotectionui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableappbrowserui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecleartpmbutton,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabledevicesecurityui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablednsovertcpparsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableenhancednotifications,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablefamilyui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehealthui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehttpparsing,

        [Parameter()]
        [ValidateSet('1', '0')]
        [System.String]
        $DisableSshParsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablenetworkui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletpmfirmwareupdatewarning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablevirusui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [System.String]
        $email,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablecustomizedtoasts,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enableinappcustomization,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $enablenetworkprotection,

        [Parameter()]
        [System.String[]]
        $excludedextensions,

        [Parameter()]
        [System.String[]]
        $excludedpaths,

        [Parameter()]
        [System.String[]]
        $excludedprocesses,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hideransomwaredatarecovery,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hidewindowssecuritynotificationareacontrol,

        [Parameter()]
        [System.String]
        $phone,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $engineupdateschannel,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $meteredconnectionupdates,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $platformupdateschannel,

        [Parameter()]
        [ValidateSet('0', '4', '5')]
        [System.String]
        $securityintelligenceupdateschannel,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet('1', '2')]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $schedulescanday,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $schedulescantime,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletlsparsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $randomizescheduletasktimes,

        [Parameter()]
        [ValidateRange(1,23)]
        [System.Int32]
        $schedulerrandomizationtime,

        [Parameter()]
        [System.String[]]
        $signatureupdatefallbackorder,

        [Parameter()]
        [System.String[]]
        $signatureupdatefilesharessources,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $signatureupdateinterval,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3')]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $tamperprotection,

        [Parameter()]
        [System.String]
        $url,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $highseveritythreats,

        [Parameter()]
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $templateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

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

    $currentPolicy = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $templateReferenceId = $templateId
    $platforms = 'windows10'
    $technologies = 'mdm,microsoftSense'

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Endpoint Protection Policy {$DisplayName}"
        $BoundParameters.Remove('Identity') | Out-Null
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        $createParameters = @{
            Name                = $DisplayName
            Description         = $Description
            TemplateReferenceId = @{ templateId = $templateReferenceId }
            Platforms           = $platforms
            Technologies        = $technologies
            Settings            = $settings
        }

        $policy = New-MgBetaDeviceManagementConfigurationPolicy -BodyParameter $createParameters

        if ($policy.Id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -Assignments $Assignments -IncludeDeviceFilter:$true
            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId $policy.Id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/configurationPolicies'
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        $BoundParameters.Remove('Identity') | Out-Null
        $BoundParameters.Remove('Assignments') | Out-Null

        $settings = Get-IntuneSettingCatalogPolicySetting `
            -DSCParams ([System.Collections.Hashtable]$BoundParameters) `
            -TemplateId $templateReferenceId

        Update-IntuneDeviceConfigurationPolicy `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Name $DisplayName `
            -Description $Description `
            -TemplateReferenceId $templateReferenceId `
            -Platforms $platforms `
            -Technologies $technologies `
            -Settings $settings

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentPolicy.Identity `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/configurationPolicies'
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Endpoint Protection Policy {$($currentPolicy.DisplayName)}"
        Remove-MgBetaDeviceManagementConfigurationPolicy -DeviceManagementConfigurationPolicyId $currentPolicy.Identity
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowarchivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowbehaviormonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowcloudprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowdatagramprocessingonwinserver,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowemailscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanonmappednetworkdrives,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowfullscanremovabledrivescanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowintrusionpreventionsystem,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowioavprotection,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allownetworkprotectiondownlevel,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowrealtimemonitoring,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscanningnetworkfiles,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowscriptscanning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowuseruiaccess,

        [Parameter()]
        [System.int32]
        $avgcpuloadfactor,

        [Parameter]
        [System.Int32]
        $archivemaxdepth,

        [Parameter]
        [System.Int32]
        $archivemaxsize,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $checkforsignaturesbeforerunningscan,

        [Parameter()]
        [ValidateSet('0', '2', '4', '6')]
        [System.String]
        $cloudblocklevel,

        [Parameter()]
        [System.Int32]
        $cloudextendedtimeout,

        [Parameter()]
        [System.String]
        $companyname,

        [Parameter()]
        [System.Int32]
        $daystoretaincleanedmalware,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableaccountprotectionui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableappbrowserui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecleartpmbutton,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabledevicesecurityui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablednsovertcpparsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disableenhancednotifications,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablefamilyui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehealthui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablehttpparsing,

        [Parameter()]
        [ValidateSet('1', '0')]
        [System.String]
        $DisableSshParsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablenetworkui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletpmfirmwareupdatewarning,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablevirusui,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupfullscan,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablecatchupquickscan,

        [Parameter()]
        [System.String]
        $email,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablecustomizedtoasts,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enableinappcustomization,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $enablelowcpupriority,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $enablenetworkprotection,

        [Parameter()]
        [System.String[]]
        $excludedextensions,

        [Parameter()]
        [System.String[]]
        $excludedpaths,

        [Parameter()]
        [System.String[]]
        $excludedprocesses,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hideransomwaredatarecovery,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $hidewindowssecuritynotificationareacontrol,

        [Parameter()]
        [System.String]
        $phone,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $puaprotection,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $engineupdateschannel,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $meteredconnectionupdates,

        [Parameter()]
        [ValidateSet('0', '2', '3', '4', '5', '6')]
        [System.String]
        $platformupdateschannel,

        [Parameter()]
        [ValidateSet('0', '4', '5')]
        [System.String]
        $securityintelligenceupdateschannel,

        [Parameter()]
        [ValidateSet('0', '1', '2')]
        [System.String]
        $realtimescandirection,

        [Parameter()]
        [ValidateSet('1', '2')]
        [System.String]
        $scanparameter,

        [Parameter()]
        [System.Int32]
        $schedulequickscantime,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3', '4', '5', '6', '7', '8')]
        [System.String]
        $schedulescanday,

        [Parameter()]
        [ValidateRange(0, 1380)]
        [System.Int32]
        $schedulescantime,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disabletlsparsing,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $randomizescheduletasktimes,

        [Parameter()]
        [ValidateRange(1,23)]
        [System.Int32]
        $schedulerrandomizationtime,

        [Parameter()]
        [System.String[]]
        $signatureupdatefallbackorder,

        [Parameter()]
        [System.String[]]
        $signatureupdatefilesharessources,

        [Parameter()]
        [ValidateRange(0, 24)]
        [System.Int32]
        $signatureupdateinterval,

        [Parameter()]
        [ValidateSet('0', '1', '2', '3')]
        [System.String]
        $submitsamplesconsent,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $tamperprotection,

        [Parameter()]
        [System.String]
        $url,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $disablelocaladminmerge,

        [Parameter()]
        [ValidateSet('0', '1')]
        [System.String]
        $allowonaccessprotection,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $lowseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $moderateseveritythreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $severethreats,

        [Parameter()]
        [ValidateSet('clean', 'quarantine', 'remove', 'allow', 'userdefined', 'block')]
        [System.String]
        $highseveritythreats,

        [Parameter()]
        [ValidateSet('d948ff9b-99cb-4ee0-8012-1fbc09685377_1', 'e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1', '45fea5e9-280d-4da1-9792-fb5736da0ca9_1', '804339ad-1553-4478-a742-138fb5807418_1')]
        [System.String]
        $templateId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
    Write-Verbose -Message "Testing configuration of Endpoint Protection Policy {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $CurrentValues))
    {
        Write-Verbose "An error occured in Get-TargetResource, the policy {$displayName} will not be processed"
        throw "An error occured in Get-TargetResource, the policy {$displayName} will not be processed. Refer to the event viewer logs for more information."
    }

    [Hashtable]$ValuesToCheck = @{}
    $MyInvocation.MyCommand.Parameters.GetEnumerator() | ForEach-Object {
        if ($_.Key -notlike '*Variable' -or $_.Key -notin @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction'))
        {
            if ($null -ne $CurrentValues[$_.Key] -or $null -ne $PSBoundParameters[$_.Key])
            {
                $ValuesToCheck.Add($_.Key, $null)
                if (-not $PSBoundParameters.ContainsKey($_.Key))
                {
                    $PSBoundParameters.Add($_.Key, $null)
                }
            }
        }
    }

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Identity') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload:$true

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
    $i = 1

    try
    {
        $templateFamily = 'endpointSecurityAntivirus'
        $templateReferences = "d948ff9b-99cb-4ee0-8012-1fbc09685377_1", "e3f74c5a-a6de-411d-aef6-eb15628f3a0a_1", "45fea5e9-280d-4da1-9792-fb5736da0ca9_1","804339ad-1553-4478-a742-138fb5807418_1"
        [array]$policies = Get-MgBetaDeviceManagementConfigurationPolicy -Filter $Filter -All:$true `
            -ErrorAction Stop | Where-Object -FilterScript {
                $_.TemplateReference.TemplateFamily -eq $templateFamily -and
                $_.TemplateReference.TemplateId -in $templateReferences
            }

        if ($policies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($policies.Count)] $($policy.Name)" -NoNewline

            $params = @{
                Identity              = $policy.Id
                DisplayName           = $policy.Name
                TemplateId            = $policy.TemplateReference.TemplateId
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @params
            if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $Results))
            {
                Write-Verbose "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed"
                throw "An error occured in Get-TargetResource, the policy {$($params.displayName)} will not be processed. Refer to the event viewer logs for more information."
            }

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Assignments) -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential -Verbose

            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -IsCIMArray:$true
            }

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
        $_.Exception -like "*Request not applicable to target tenant*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
