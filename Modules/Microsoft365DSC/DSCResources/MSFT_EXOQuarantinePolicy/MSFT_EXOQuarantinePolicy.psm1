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
        [System.Int32]
        $EndUserQuarantinePermissionsValue,

        [Parameter()]
        [System.Boolean]
        $ESNEnabled,

        [Parameter()]
        [System.String[]]
        $MultiLanguageCustomDisclaimer,

        [Parameter()]
        [System.String[]]
        $MultiLanguageSenderName,

        [Parameter()]
        [System.String[]]
        $MultiLanguageSetting,

        [Parameter()]
        [System.Boolean]
        $OrganizationBrandingEnabled,

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
        [System.String]
        $CustomDisclaimer,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationFrequencyInDays,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.String[]]
        $EsnCustomSubject,

        [Parameter()]
        [System.String]
        $QuarantinePolicyType,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of QuarantinePolicy for $($Identity)"
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
        if ($QuarantinePolicyType -eq 'GlobalQuarantineTag')
        {
            $QuarantinePolicy = Get-QuarantinePolicy -QuarantinePolicyType GlobalQuarantinePolicy -ErrorAction Stop
        }
        else
        {
            $QuarantinePolicies = Get-QuarantinePolicy -ErrorAction Stop
            $QuarantinePolicy = $QuarantinePolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
        }
        if ($null -eq $QuarantinePolicy)
        {
            Write-Verbose -Message "QuarantinePolicy $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            if ($QuarantinePolicy.QuarantinePolicyType -eq 'GlobalQuarantineTag')
            {
                $result = @{
                    CustomDisclaimer                            = $QuarantinePolicy.CustomDisclaimer
                    EndUserSpamNotificationFrequency            = $QuarantinePolicy.EndUserSpamNotificationFrequency
                    EndUserSpamNotificationFrequencyInDays      = $QuarantinePolicy.EndUserSpamNotificationFrequencyInDays
                    EndUserSpamNotificationCustomFromAddress    = $QuarantinePolicy.EndUserSpamNotificationCustomFromAddress
                    MultiLanguageCustomDisclaimer               = $QuarantinePolicy.MultiLanguageCustomDisclaimer
                    EsnCustomSubject                            = $QuarantinePolicy.EsnCustomSubject
                    MultiLanguageSenderName                     = $QuarantinePolicy.MultiLanguageSenderName
                    MultiLanguageSetting                        = $QuarantinePolicy.MultiLanguageSetting
                    OrganizationBrandingEnabled                 = $QuarantinePolicy.OrganizationBrandingEnabled
                    QuarantinePolicyType                        = $QuarantinePolicy.QuarantinePolicyType
                    Identity                                    = $Identity
                    Credential                                  = $Credential
                    Ensure                                      = 'Present'
                    ApplicationId                               = $ApplicationId
                    CertificateThumbprint                       = $CertificateThumbprint
                    CertificatePath                             = $CertificatePath
                    CertificatePassword                         = $CertificatePassword
                    Managedidentity                             = $ManagedIdentity.IsPresent
                    TenantId                                    = $TenantId
                    AccessTokens                                = $AccessTokens
                }
            }
            else
            {
                $EndUserQuarantinePermissionsValueDecimal = 0
                if ($QuarantinePolicy.EndUserQuarantinePermissions)
                    {
                        # Convert string output of EndUserQuarantinePermissions to binary value and then to decimal value
                        # needed for EndUserQuarantinePermissionsValue attribute of New-/Set-QuarantinePolicy cmdlet.
                        # This parameter uses a decimal value that's converted from a binary value.
                        # The binary value corresponds to the list of available permissions in a specific order.
                        # For each permission, the value 1 equals True and the value 0 equals False.

                        $EndUserQuarantinePermissionsBinary = ''
                        if ($QuarantinePolicy.EndUserQuarantinePermissions.Contains('PermissionToViewHeader: True'))
                        {
                            $PermissionToViewHeader = '1'
                        }
                        else
                        {
                            $PermissionToViewHeader = '0'
                        }
                        if ($QuarantinePolicy.EndUserQuarantinePermissions.Contains('PermissionToDownload: True'))
                        {
                            $PermissionToDownload = '1'
                        }
                        else
                        {
                            $PermissionToDownload = '0'
                        }
                        if ($QuarantinePolicy.EndUserQuarantinePermissions.Contains('PermissionToAllowSender: True'))
                        {
                            $PermissionToAllowSender = '1'
                        }
                        else
                        {
                            $PermissionToAllowSender = '0'
                        }
                        if ($QuarantinePolicy.EndUserQuarantinePermissions.Contains('PermissionToBlockSender: True'))
                        {
                            $PermissionToBlockSender = '1'
                        }
                        else
                        {
                            $PermissionToBlockSender = '0'
                        }
                        if ($QuarantinePolicy.EndUserQuarantinePermissions.Contains('PermissionToRequestRelease: True'))
                        {
                            $PermissionToRequestRelease = '1'
                        }
                        else
                        {
                            $PermissionToRequestRelease = '0'
                        }
                        if ($QuarantinePolicy.EndUserQuarantinePermissions.Contains('PermissionToRelease: True'))
                        {
                            $PermissionToRelease = '1'
                        }
                        else
                        {
                            $PermissionToRelease = '0'
                        }
                        if ($QuarantinePolicy.EndUserQuarantinePermissions.Contains('PermissionToPreview: True'))
                        {
                            $PermissionToPreview = '1'
                        }
                        else
                        {
                            $PermissionToPreview = '0'
                        }
                        if ($QuarantinePolicy.EndUserQuarantinePermissions.Contains('PermissionToDelete: True'))
                        {
                            $PermissionToDelete = '1'
                        }
                        else
                        {
                            $PermissionToDelete = '0'
                        }
                        # Concat values to binary value
                        $EndUserQuarantinePermissionsBinary = [System.String]::Concat($PermissionToViewHeader, $PermissionToDownload, $PermissionToAllowSender, $PermissionToBlockSender, $PermissionToRequestRelease, $PermissionToRelease, $PermissionToPreview, $PermissionToDelete)

                        # Convert to Decimal value
                        [int]$EndUserQuarantinePermissionsValueDecimal = [System.Convert]::ToByte($EndUserQuarantinePermissionsBinary, 2)
                    }
                    $result = @{
                        Identity                          = $Identity
                        EndUserQuarantinePermissionsValue = $EndUserQuarantinePermissionsValueDecimal
                        ESNEnabled                        = $QuarantinePolicy.ESNEnabled
                        MultiLanguageCustomDisclaimer     = $QuarantinePolicy.MultiLanguageCustomDisclaimer
                        MultiLanguageSenderName           = $QuarantinePolicy.MultiLanguageSenderName
                        MultiLanguageSetting              = $QuarantinePolicy.MultiLanguageSetting
                        OrganizationBrandingEnabled       = $QuarantinePolicy.OrganizationBrandingEnabled
                        Credential                        = $Credential
                        Ensure                            = 'Present'
                        ApplicationId                     = $ApplicationId
                        CertificateThumbprint             = $CertificateThumbprint
                        CertificatePath                   = $CertificatePath
                        CertificatePassword               = $CertificatePassword
                        Managedidentity                   = $ManagedIdentity.IsPresent
                        TenantId                          = $TenantId
                        AccessTokens                      = $AccessTokens
                    }
            }
            Write-Verbose -Message "Found QuarantinePolicy $($Identity)"
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
        [System.Int32]
        $EndUserQuarantinePermissionsValue,

        [Parameter()]
        [System.Boolean]
        $ESNEnabled,

        [Parameter()]
        [System.String[]]
        $MultiLanguageCustomDisclaimer,

        [Parameter()]
        [System.String[]]
        $MultiLanguageSenderName,

        [Parameter()]
        [System.String[]]
        $MultiLanguageSetting,

        [Parameter()]
        [System.Boolean]
        $OrganizationBrandingEnabled,

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
        [System.String]
        $CustomDisclaimer,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationFrequencyInDays,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.String[]]
        $EsnCustomSubject,

        [Parameter()]
        [System.String]
        $QuarantinePolicyType,

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
    Write-Verbose -Message "Setting configuration of QuarantinePolicy for $($Identity)"
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    if ($QuarantinePolicyType -eq 'GlobalQuarantineTag')
    {
        $QuarantinePolicy = Get-QuarantinePolicy -QuarantinePolicyType GlobalQuarantinePolicy
    }
    else
    {
        $QuarantinePolicies = Get-QuarantinePolicy
        $QuarantinePolicy = $QuarantinePolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    }
    $QuarantinePolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $QuarantinePolicyParams.Remove('Ensure') | Out-Null
    $QuarantinePolicyParams.Remove('Credential') | Out-Null
    $QuarantinePolicyParams.Remove('ApplicationId') | Out-Null
    $QuarantinePolicyParams.Remove('TenantId') | Out-Null
    $QuarantinePolicyParams.Remove('CertificateThumbprint') | Out-Null
    $QuarantinePolicyParams.Remove('CertificatePath') | Out-Null
    $QuarantinePolicyParams.Remove('CertificatePassword') | Out-Null
    $QuarantinePolicyParams.Remove('ManagedIdentity') | Out-Null
    $QuarantinePolicyParams.Remove('QuarantinePolicyType') | Out-Null
    $QuarantinePolicyParams.Remove('AccessTokens') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $QuarantinePolicy))
    {
        Write-Verbose -Message "Creating QuarantinePolicy $($Identity)."
        $QuarantinePolicyParams.Add('Name', $Identity)
        $QuarantinePolicyParams.Remove('Identity') | Out-Null
        New-QuarantinePolicy @QuarantinePolicyParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $QuarantinePolicy))
    {
        Write-Verbose -Message "Setting QuarantinePolicy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $QuarantinePolicyParams)"
        if ($QuarantinePolicyType -eq 'GlobalQuarantineTag') {
            $QuarantinePolicyParams.Remove('Identity') | Out-Null
            Get-QuarantinePolicy -QuarantinePolicyType GlobalQuarantinePolicy | Set-QuarantinePolicy @QuarantinePolicyParams
        }
        else
        {
            $IdentityValue = $Identity.Split('\')
            if ($IdentityValue.Length -gt 1)
            {
                $IdentityValue = $IdentityValue[1]
                $QuarantinePolicyParams.Identity = $IdentityValue
            }
            Set-QuarantinePolicy @QuarantinePolicyParams
        }
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $QuarantinePolicy))
    {
        Write-Verbose -Message "Removing QuarantinePolicy $($Identity)"
        Remove-QuarantinePolicy -Identity $Identity
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
        [System.Int32]
        $EndUserQuarantinePermissionsValue,

        [Parameter()]
        [System.Boolean]
        $ESNEnabled,

        [Parameter()]
        [System.String[]]
        $MultiLanguageCustomDisclaimer,

        [Parameter()]
        [System.String[]]
        $MultiLanguageSenderName,

        [Parameter()]
        [System.String[]]
        $MultiLanguageSetting,

        [Parameter()]
        [System.Boolean]
        $OrganizationBrandingEnabled,

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
        [System.String]
        $CustomDisclaimer,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationFrequency,

        [Parameter()]
        [System.Int32]
        $EndUserSpamNotificationFrequencyInDays,

        [Parameter()]
        [System.String]
        $EndUserSpamNotificationCustomFromAddress,

        [Parameter()]
        [System.String[]]
        $EsnCustomSubject,

        [Parameter()]
        [System.String]
        $QuarantinePolicyType,

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

    Write-Verbose -Message "Testing configuration of QuarantinePolicy for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

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

    try
    {
        [array]$QuarantinePolicies = Get-QuarantinePolicy -ErrorAction Stop
        [array]$QuarantinePolicies += Get-QuarantinePolicy -QuarantinePolicyType GlobalQuarantinePolicy -ErrorAction Stop
        if ($QuarantinePolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = ''
        $i = 1
        foreach ($QuarantinePolicy in $QuarantinePolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($QuarantinePolicies.length)] $($QuarantinePolicy.Identity)" -NoNewline

            $Params = @{
                Identity              = $QuarantinePolicy.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                QuarantinePolicyType  = $QuarantinePolicy.QuarantinePolicyType
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params

            $keysToRemove = @()
            foreach ($key in $Results.Keys)
            {
                if ([System.String]::IsNullOrEmpty($Results.$key))
                {
                    $keysToRemove += $key
                }
            }
            foreach ($key in $keysToRemove)
            {
                $Results.Remove($key) | Out-Null
            }
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
