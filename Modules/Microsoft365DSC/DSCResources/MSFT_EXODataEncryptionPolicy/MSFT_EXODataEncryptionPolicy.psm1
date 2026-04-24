Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXODataEncryptionPolicy'

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
        [System.String[]]
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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            $DataEncryptionPolicy = Get-DataEncryptionPolicy -Identity $Identity -ErrorAction SilentlyContinue

            if ($null -eq $DataEncryptionPolicy)
            {
                Write-Verbose -Message "Data encryption policy $($Identity) does not exist."
                $nullReturn.Identity = $null
                return $nullReturn
            }
        }
        else
        {
            $DataEncryptionPolicy = $Script:exportedInstance
        }

        Write-Verbose -Message "Found Data encryption policy $($Identity)"

        $result = @{
            Identity                  = $Identity
            AzureKeyIDs               = [System.String[]]$DataEncryptionPolicy.AzureKeyIDs
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
            ManagedIdentity           = $ManagedIdentity.IsPresent
            TenantId                  = $TenantId
            AccessTokens              = $AccessTokens
        }

        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        [System.String[]]
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

    Write-Verbose -Message "Setting configuration of Data encryption policy for $($Identity)"

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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $DataEncryptionPolicies = Get-DataEncryptionPolicy
    $DataEncryptionPolicy = $DataEncryptionPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $DataEncryptionPolicyParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $null -eq $DataEncryptionPolicy)
    {
        Write-Verbose -Message "Creating Data encryption policy $($Identity)."
        $DataEncryptionPolicyParams.Remove('Identity') | Out-Null
        $DataEncryptionPolicyParams.Remove('PermanentDataPurgeContact') | Out-Null
        $DataEncryptionPolicyParams.Remove('PermanentDataPurgeReason') | Out-Null
        New-DataEncryptionPolicy @DataEncryptionPolicyParams
        Write-Verbose -Message 'Data encryption policy created successfully.'
    }
    elseif ($Ensure -eq 'Present' -and $null -ne $DataEncryptionPolicy)
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
        [System.String[]]
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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
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
    try
    {
        [Array]$DataEncryptionPolicies = Get-DataEncryptionPolicy -ErrorAction Stop
        $dscContent = ''

        if ($DataEncryptionPolicies.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($DataEncryptionPolicy in $DataEncryptionPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($DataEncryptionPolicies.Count)] $($DataEncryptionPolicy.Identity)" -DeferWrite

            $Params = @{
                Identity              = $DataEncryptionPolicy.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $DataEncryptionPolicy
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}
Export-ModuleMember -Function *-TargetResource
