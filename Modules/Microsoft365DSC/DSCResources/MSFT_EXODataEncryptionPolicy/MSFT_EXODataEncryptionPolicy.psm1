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
        [System.Uri[]]
        $AzureKeyIDs,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $PermanentDataPurgeContact,

        [Parameter()]
        [System.String]
        $PermanentDataPurgeReason,

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
    Write-Verbose -Message "Getting Data encryption policy for $($Identity)"

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
        $DataEncryptionPolicy = Get-DataEncryptionPolicy -Identity $Identity -ErrorAction Stop

        if ($null -eq $DataEncryptionPolicy)
        {
            Write-Verbose -Message "Data encryption policy $($Identity) does not exist."
            $nullReturn.Identity = $null
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity                  = $Identity
                AzureKeyIDs               = $DataEncryptionPolicy.AzureKeyIDs
                Description               = $DataEncryptionPolicy.Description
                Enabled                   = $DataEncryptionPolicy.Enabled
                Name                      = $DataEncryptionPolicy.Name
                PermanentDataPurgeContact = $DataEncryptionPolicy.PermanentDataPurgeContact
                PermanentDataPurgeReason  = $DataEncryptionPolicy.PermanentDataPurgeReason
                Credential                = $Credential
                Ensure                    = 'Present'
                ApplicationId             = $ApplicationId
                CertificateThumbprint     = $CertificateThumbprint
                CertificatePath           = $CertificatePath
                CertificatePassword       = $CertificatePassword
                Managedidentity           = $ManagedIdentity.IsPresent
                TenantId                  = $TenantId
                AccessTokens              = $AccessTokens
            }

            Write-Verbose -Message "Found Data encryption policy $($Identity)"
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
        [System.Uri[]]
        $AzureKeyIDs,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $PermanentDataPurgeContact,

        [Parameter()]
        [System.String]
        $PermanentDataPurgeReason,

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

    Write-Verbose -Message "Setting configuration of Data encryption policy for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $DataEncryptionPolicies = Get-DataEncryptionPolicy
    $DataEncryptionPolicy = $DataEncryptionPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $DataEncryptionPolicyParams = [System.Collections.Hashtable]($PSBoundParameters)
    $DataEncryptionPolicyParams.Remove('Ensure') | Out-Null
    $DataEncryptionPolicyParams.Remove('Credential') | Out-Null
    $DataEncryptionPolicyParams.Remove('ApplicationId') | Out-Null
    $DataEncryptionPolicyParams.Remove('TenantId') | Out-Null
    $DataEncryptionPolicyParams.Remove('CertificateThumbprint') | Out-Null
    $DataEncryptionPolicyParams.Remove('CertificatePath') | Out-Null
    $DataEncryptionPolicyParams.Remove('CertificatePassword') | Out-Null
    $DataEncryptionPolicyParams.Remove('ManagedIdentity') | Out-Null
    $DataEncryptionPolicyParams.Remove('AccessTokens') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $DataEncryptionPolicy))
    {
        Write-Verbose -Message "Creating Data encryption policy $($Identity)."
        $DataEncryptionPolicyParams.Remove('Identity') | Out-Null
        $DataEncryptionPolicyParams.Remove('PermanentDataPurgeContact') | Out-Null
        $DataEncryptionPolicyParams.Remove('PermanentDataPurgeReason') | Out-Null
        New-DataEncryptionPolicy @DataEncryptionPolicyParams
        Write-Verbose -Message 'Data encryption policy created successfully.'
    }
    elseif (('Present' -eq $Ensure ) -and ($null -ne $DataEncryptionPolicy))
    {
        $DataEncryptionPolicyParams.Remove('AzureKeyIDs') | Out-Null
        $verboseMessage = "Setting Data encryption policy $($Identity) with values:" + `
            " $(Convert-M365DscHashtableToString -Hashtable $DataEncryptionPolicyParams)"
        Write-Verbose -Message $verboseMessage
        Set-DataEncryptionPolicy @DataEncryptionPolicyParams -Confirm:$false
        Write-Verbose -Message 'Data encryption policy updated successfully.'
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
        [System.Uri[]]
        $AzureKeyIDs,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $PermanentDataPurgeContact,

        [Parameter()]
        [System.String]
        $PermanentDataPurgeReason,

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

    Write-Verbose -Message "Testing configuration of Data encryption policy for $($Identity)"

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
        [Array]$DataEncryptionPolicies = Get-DataEncryptionPolicy -ErrorAction Stop

        $dscContent = ''

        if ($DataEncryptionPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($DataEncryptionPolicy in $DataEncryptionPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($DataEncryptionPolicies.Length)] $($DataEncryptionPolicy.Identity)" -NoNewline

            $Params = @{
                Identity              = $DataEncryptionPolicy.Identity
                Credential            = $Credential
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
