Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXORecipientPermission'

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

            Write-Verbose -Message "Retrieving Recipient Permissions by Identity {$Identity}, Trustee {$Trustee} and AccessRights {$AccessRights}"
            $recipientPermission = Get-RecipientPermission -Identity $Identity -Trustee $Trustee -AccessRights $AccessRights -ErrorAction SilentlyContinue

            if ($null -eq $recipientPermission)
            {
                Write-Verbose -Message "The specified Recipient Permission doesn't exist."
                return $nullReturn
            }
        }
        else
        {
            $recipientPermission = $Script:exportedInstance
        }

        Write-Verbose -Message "Found Recipient Permission for Identity {$Identity}, Trustee {$Trustee} and AccessRights {$AccessRights}"

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
            ManagedIdentity       = $ManagedIdentity.IsPresent
            TenantId              = $TenantId
            AccessTokens          = $AccessTokens
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

    $parameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $parameters.AccessRights = $AccessRights #Parameters with default values are not part PSBoundParameters

    # Receipient Permission doesn't exist but it should
    if ($Ensure -eq 'Present' -and $currentState.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "The Recipient Permission for '$Trustee' with Access Rights '$($AccessRights -join ', ')' on mailbox '$Identity' does not exist but it should. Adding it."
        Add-RecipientPermission @parameters -Confirm:$false
    }
    # Receipient Permission exists but shouldn't
    elseif ($Ensure -eq 'Absent' -and $currentState.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Recipient Permission for '$Trustee' with Access Rights '$($AccessRights -join ', ')' on mailbox '$Identity' exists but shouldn't. Removing it."
        Remove-RecipientPermission @parameters -Confirm:$false
    }
    elseif ($Ensure -eq 'Present' -and $currentState.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Recipient Permission for '$Trustee' with Access Rights '$($AccessRights -join ', ')' on mailbox '$Identity' exists."
        Remove-RecipientPermission @parameters -Confirm:$false
        Add-RecipientPermission @parameters -Confirm:$false
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
        [array]$recipientPermissions = Get-RecipientPermission -ResultSize Unlimited

        $dscContent = ''
        $i = 1
        if ($recipientPermissions.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $ObjectGuid = [System.Guid]::empty
        if ($null -eq $Script:UsersCache)
        {
            $Script:UsersCache = [System.Collections.Generic.Dictionary[System.String, System.Object]]::new()
            Get-User -ResultSize Unlimited | ForEach-Object {
                $Script:UsersCache[$_.Identity] = @{
                    Identity          = $_.Identity
                    UserPrincipalName = $_.UserPrincipalName
                }
            }
        }
        foreach ($recipientPermission in $recipientPermissions)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $IdentityValue = $recipientPermission.Identity
            if ([System.Guid]::TryParse($IdentityValue, [System.Management.Automation.PSReference]$ObjectGuid))
            {
                $IdentityValue = $Script:UsersCache[$IdentityValue].UserPrincipalName
            }
            Write-M365DSCHost -Message "    |---[$i/$($recipientPermissions.Length)] $($IdentityValue)" -DeferWrite

            $params = @{
                Identity              = $IdentityValue
                Trustee               = $recipientPermission.Trustee
                AccessRights          = $recipientPermission.AccessRights
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $recipientPermission
            $Results = Get-TargetResource @Params
            if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
            {
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock

                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
            }

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
