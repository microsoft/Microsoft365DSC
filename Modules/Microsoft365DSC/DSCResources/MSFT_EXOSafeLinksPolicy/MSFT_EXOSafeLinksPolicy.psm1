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
        [System.String]
        $CustomNotificationText,

        [Parameter()]
        [Boolean]
        $DeliverMessageAfterScan = $false,

        [Parameter()]
        [Boolean]
        $DoNotAllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $DoNotTrackUserClicks = $true,

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $EnableOrganizationBranding = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForTeams = $false,

        [Parameter()]
        [Boolean]
        $IsEnabled,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

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
        $CertificatePassword
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        Write-Verbose -Message "Global ExchangeOnlineSession status:"
        Write-Verbose -Message "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq 'ExchangeOnline' } | Out-String)"

        try
        {
            $SafeLinksPolicies = Get-SafeLinksPolicy -ErrorAction Stop
        }
        catch
        {
            Close-SessionsAndReturnError -ExceptionMessage $_.Exception
            $Message = "Error calling {Get-SafeLinksPolicy}"
            New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
        }

        $SafeLinksPolicy = $SafeLinksPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
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
                CustomNotificationText        = $SafeLinksPolicy.CustomNotificationText
                DeliverMessageAfterScan       = $SafeLinksPolicy.DeliverMessageAfterScan
                DoNotAllowClickThrough        = $SafeLinksPolicy.DoNotAllowClickThrough
                DoNotRewriteUrls              = $SafeLinksPolicy.DoNotRewriteUrls
                DoNotTrackUserClicks          = $SafeLinksPolicy.DoNotTrackUserClicks
                EnableForInternalSenders      = $SafeLinksPolicy.EnableForInternalSenders
                EnableOrganizationBranding    = $SafeLinksPolicy.EnableOrganizationBranding
                EnableSafeLinksForTeams       = $SafeLinksPolicy.EnableSafeLinksForTeams
                IsEnabled                     = $SafeLinksPolicy.IsEnabled
                ScanUrls                      = $SafeLinksPolicy.ScanUrls
                UseTranslatedNotificationText = $SafeLinksPolicy.UseTranslatedNotificationText
                Ensure                        = 'Present'
                Credential            = $Credential
                ApplicationId                 = $ApplicationId
                CertificateThumbprint         = $CertificateThumbprint
                CertificatePath               = $CertificatePath
                CertificatePassword           = $CertificatePassword
                TenantId                      = $TenantId
            }

            Write-Verbose -Message "Found SafeLinksPolicy $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        [System.String]
        $CustomNotificationText,

        [Parameter()]
        [Boolean]
        $DeliverMessageAfterScan = $false,

        [Parameter()]
        [Boolean]
        $DoNotAllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $DoNotTrackUserClicks = $true,

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $EnableOrganizationBranding = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForTeams = $false,

        [Parameter()]
        [Boolean]
        $IsEnabled,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration of SafeLinksPolicy for $Identity"
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
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
        [System.String]
        $CustomNotificationText,

        [Parameter()]
        [Boolean]
        $DeliverMessageAfterScan = $false,

        [Parameter()]
        [Boolean]
        $DoNotAllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $DoNotTrackUserClicks = $true,

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $EnableOrganizationBranding = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForTeams = $false,

        [Parameter()]
        [Boolean]
        $IsEnabled,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

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
        $CertificatePassword
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
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
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null
    $ValuesToCheck.Remove('Verbose') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null

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
        $CertificatePassword
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
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
                Write-Host "    |---[$i/$($SafeLinksPolicies.Length)] $($SafeLinksPolicy.Name)" -NoNewline
                $Params = @{
                    Credential    = $Credential
                    Identity              = $SafeLinksPolicy.Identity
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    CertificatePassword   = $CertificatePassword
                    CertificatePath       = $CertificatePath
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
