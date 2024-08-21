function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $AllowClickThrough,

        [Parameter()]
        [System.String]
        $CustomNotificationText,

        [Parameter()]
        [Boolean]
        $DeliverMessageAfterScan = $false,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $EnableOrganizationBranding = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForOffice,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForTeams = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForEmail = $false,

        [Parameter()]
        [Boolean]
        $DisableUrlRewrite = $false,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks,

        [Parameter()]
        [Boolean]
        $UseTranslatedNotificationText = $false,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of SafeLinksPolicy for $Identity"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        try
        {
            $SafeLinksPolicy = Get-SafeLinksPolicy -Identity $Identity -ErrorAction Stop
        }
        catch
        {
            $Message = 'Error calling {Get-SafeLinksPolicy}'
            New-M365DSCLogEntry -Message $Message `
                -Exception $_ `
                -Source $MyInvocation.MyCommand.ModuleName
        }
        if (-not $SafeLinksPolicy)
        {
            Write-Verbose -Message "SafeLinksPolicy $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity                      = $SafeLinksPolicy.Identity
                AdminDisplayName              = $SafeLinksPolicy.AdminDisplayName
                AllowClickThrough             = $SafeLinksPolicy.AllowClickThrough
                CustomNotificationText        = $SafeLinksPolicy.CustomNotificationText
                DeliverMessageAfterScan       = $SafeLinksPolicy.DeliverMessageAfterScan
                DoNotRewriteUrls              = $SafeLinksPolicy.DoNotRewriteUrls
                EnableForInternalSenders      = $SafeLinksPolicy.EnableForInternalSenders
                EnableOrganizationBranding    = $SafeLinksPolicy.EnableOrganizationBranding
                EnableSafeLinksForTeams       = $SafeLinksPolicy.EnableSafeLinksForTeams
                EnableSafeLinksForEmail       = $SafeLinksPolicy.EnableSafeLinksForEmail
                EnableSafeLinksForOffice      = $SafeLinksPolicy.EnableSafeLinksForOffice
                DisableUrlRewrite             = $SafeLinksPolicy.DisableUrlRewrite
                ScanUrls                      = $SafeLinksPolicy.ScanUrls
                TrackClicks                   = $SafeLinksPolicy.TrackClicks
                # The Get-SafeLinksPolicy no longer returns this property
                # UseTranslatedNotificationText = $SafeLinksPolicy.UseTranslatedNotificationText
                Ensure                        = 'Present'
                Credential                    = $Credential
                ApplicationId                 = $ApplicationId
                CertificateThumbprint         = $CertificateThumbprint
                CertificatePath               = $CertificatePath
                CertificatePassword           = $CertificatePassword
                Managedidentity               = $ManagedIdentity.IsPresent
                TenantId                      = $TenantId
                AccessTokens                  = $AccessTokens
            }

            Write-Verbose -Message "Found SafeLinksPolicy $($Identity)"
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
        $Identity,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $AllowClickThrough,

        [Parameter()]
        [System.String]
        $CustomNotificationText,

        [Parameter()]
        [Boolean]
        $DeliverMessageAfterScan = $false,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $EnableOrganizationBranding = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForOffice,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForTeams = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForEmail = $false,

        [Parameter()]
        [Boolean]
        $DisableUrlRewrite = $false,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks,

        [Parameter()]
        [Boolean]
        $UseTranslatedNotificationText = $false,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of SafeLinksPolicy for $Identity"
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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $SafeLinksPolicies = Get-SafeLinksPolicy

    $SafeLinksPolicy = $SafeLinksPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $SafeLinksPolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $SafeLinksPolicyParams.Remove('Ensure') | Out-Null
    $SafeLinksPolicyParams.Remove('Credential') | Out-Null
    $SafeLinksPolicyParams.Remove('ApplicationId') | Out-Null
    $SafeLinksPolicyParams.Remove('TenantId') | Out-Null
    $SafeLinksPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $SafeLinksPolicyParams.Remove('CertificatePath') | Out-Null
    $SafeLinksPolicyParams.Remove('CertificatePassword') | Out-Null
    $SafeLinksPolicyParams.Remove('ManagedIdentity') | Out-Null
    $SafeLinksPolicyParams.Remove('AccessTokens') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $SafeLinksPolicy))
    {
        $SafeLinksPolicyParams += @{
            Name = $SafeLinksPolicyParams.Identity
        }
        $SafeLinksPolicyParams.Remove('Identity') | Out-Null
        Write-Verbose -Message "Creating SafeLinksPolicy $($Identity)"

        New-SafeLinksPolicy @SafeLinksPolicyParams
    }
    elseif (('Present' -eq $Ensure ) -and ($null -ne $SafeLinksPolicy))
    {
        Write-Verbose -Message "Setting SafeLinksPolicy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $SafeLinksPolicyParams)"

        Set-SafeLinksPolicy @SafeLinksPolicyParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $SafeLinksPolicy))
    {
        Write-Verbose -Message "Removing SafeLinksPolicy $($Identity) "
        Remove-SafeLinksPolicy -Identity $Identity -Confirm:$false
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
        $Identity,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $AllowClickThrough,

        [Parameter()]
        [System.String]
        $CustomNotificationText,

        [Parameter()]
        [Boolean]
        $DeliverMessageAfterScan = $false,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $EnableOrganizationBranding = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForOffice,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForTeams = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForEmail = $false,

        [Parameter()]
        [Boolean]
        $DisableUrlRewrite = $false,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks,

        [Parameter()]
        [Boolean]
        $UseTranslatedNotificationText = $false,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    Write-Verbose -Message "Testing configuration of SafeLinksPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null
    $ValuesToCheck.Remove('UseTranslatedNotificationText') | Out-Null

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeLinksPolicy)
        {
            [array]$SafeLinksPolicies = Get-SafeLinksPolicy

            if ($SafeLinksPolicies.Length -eq 0)
            {
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "`r`n" -NoNewline
            }
            $i = 1
            foreach ($SafeLinksPolicy in $SafeLinksPolicies)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-Host "    |---[$i/$($SafeLinksPolicies.Length)] $($SafeLinksPolicy.Name)" -NoNewline
                $Params = @{
                    Credential            = $Credential
                    Identity              = $SafeLinksPolicy.Identity
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    CertificatePassword   = $CertificatePassword
                    Managedidentity       = $ManagedIdentity.IsPresent
                    CertificatePath       = $CertificatePath
                    AccessTokens          = $AccessTokens
                }
                $Results = Get-TargetResource @Params
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
        else
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle)The current tenant is not registered to allow for Safe Attachment Rules."
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
