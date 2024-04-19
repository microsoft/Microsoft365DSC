function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Trustee,

        [Parameter()]
        [ValidateSet('SendAs')]
        [System.String[]]
        $AccessRights = 'SendAs',

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

    Write-Verbose -Message "Getting configuration of Office 365 Recipient permission $Identity"
    if ($Script:ExportMode)
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

        if ($null -ne $Script:recipientPermissions -and $Script:ExportMode)
        {
            $recipientPermission = $Script:recipientPermissions | Where-Object -FilterScript {
                $_.Identity -eq $Identity -and $_.Trustee -eq $Trustee -and $_.AccessRights -eq $AccessRights
            }

            if ($null -eq $recipientPermission)
            {
                try
                {
                    $userValue = Get-User -Identity $Identity
                    $recipientPermission = $Script:recipientPermissions | Where-Object -FilterScript {
                        $_.Identity -eq $userValue.Identity -and $_.Trustee -eq $Trustee -and $_.AccessRights -eq $AccessRights
                    }
                }
                catch
                {
                    Write-Verbose -Message $_
                }
            }
        }
        else
        {
            $recipientPermission = Get-RecipientPermission -Identity $Identity -Trustee $Trustee -AccessRights $AccessRights -ErrorAction Stop
        }

        if ($null -eq $recipientPermission)
        {
            Write-Verbose -Message "The specified Recipient Permission doesn't exist."
            return $nullReturn
        }

        #endregion

        [Array]$trustee = $recipientPermission.Trustee

        $result = @{
            Identity              = $Identity
            Trustee               = $trustee[0]
            AccessRights          = $recipientPermission.AccessRights
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            Managedidentity       = $ManagedIdentity.IsPresent
            TenantId              = $TenantId
            AccessTokens          = $AccessTokens
        }

        Write-Verbose -Message "Found an existing instance of Recipient permissions '$($DisplayName)'"
        return $result
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Trustee,

        [Parameter()]
        [ValidateSet('SendAs')]
        [System.String[]]
        $AccessRights = 'SendAs',

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

    Write-Verbose -Message "Setting Mail Contact configuration for $Name"

    $currentState = Get-TargetResource @PSBoundParameters

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

    $parameters = $PSBoundParameters
    $parameters.Remove('Credential') | Out-Null
    $parameters.Remove('ApplicationId') | Out-Null
    $parameters.Remove('TenantId') | Out-Null
    $parameters.Remove('CertificateThumbprint') | Out-Null
    $parameters.Remove('CertificatePath') | Out-Null
    $parameters.Remove('CertificatePassword') | Out-Null
    $parameters.Remove('ManagedIdentity') | Out-Null
    $parameters.Remove('Ensure') | Out-Null
    $parameters.Remove('AccessTokens') | Out-Null
    $parameters.AccessRights = $AccessRights #Parameters with default values are not part PSBoundParameters

    # Receipient Permission doesn't exist but it should
    if ($Ensure -eq 'Present' -and $currentState.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "The Receipient Permission for '$Trustee' with Access Rights '$($AccessRights -join ', ')' on mailbox '$Identity' does not exist but it should. Adding it."
        Add-RecipientPermission @parameters -Confirm:$false
    }
    # Receipient Permission exists but shouldn't
    elseif ($Ensure -eq 'Absent' -and $currentState.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Receipient Permission for '$Trustee' with Access Rights '$($AccessRights -join ', ')' on mailbox '$Identity' exists but shouldn't. Removing it."
        Remove-RecipientPermission @parameters -Confirm:$false
    }
    elseif ($Ensure -eq 'Present' -and $currentState.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Receipient Permission for '$Trustee' with Access Rights '$($AccessRights -join ', ')' on mailbox '$Identity' exists."
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Trustee,

        [Parameter()]
        [ValidateSet('SendAs')]
        [System.String[]]
        $AccessRights = 'SendAs',

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

    $param = $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $param
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Office 365 Recipient permissions $DisplayName"

    $currentValues = Get-TargetResource @param

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $currentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $param)"

    $testResult = Test-M365DSCParameterState -CurrentValues $currentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $param `
        -ValuesToCheck Ensure, Identity, Trustee, AccessRights

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Trustee,

        [Parameter()]
        [ValidateSet('SendAs')]
        [System.String[]]
        $AccessRights = 'SendAs',

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
        $Script:ExportMode = $true

        [array]$Script:recipientPermissions = Get-RecipientPermission -ResultSize Unlimited

        $dscContent = ''
        $i = 1
        if ($recipientPermissions.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $ObjectGuid = [System.Guid]::empty
        foreach ($recipientPermission in $recipientPermissions)
        {
            $IdentityValue = $recipientPermission.Identity
            if ([System.Guid]::TryParse($IdentityValue,[System.Management.Automation.PSReference]$ObjectGuid))
            {
                $user = Get-User -Identity $IdentityValue
                $IdentityValue = $user.UserPrincipalName
            }
            Write-Host "    |---[$i/$($recipientPermissions.Length)] $($IdentityValue)" -NoNewline

            $params = @{
                Identity              = $IdentityValue
                Trustee               = $recipientPermission.Trustee
                AccessRights          = $recipientPermission.AccessRights
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

            if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
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
            }
            else
            {
                Write-Host $Global:M365DSCEmojiRedX
            }

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
