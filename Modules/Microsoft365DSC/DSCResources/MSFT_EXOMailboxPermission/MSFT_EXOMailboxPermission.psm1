Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOMailboxPermission'

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
        [ValidateSet('ChangeOwner', 'ChangePermission', 'DeleteItem', 'ExternalAccount', 'FullAccess', 'ReadPermission')]
        [System.String[]]
        $AccessRights,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('None', 'All', 'Children', 'Descendents', 'SelfAndChildren')]
        $InheritanceType,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.Boolean]
        $Deny,

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

    Write-Verbose -Message "Getting permissions for Mailbox {$Identity}"

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

            $nullResult = @{
                Identity = $Identity
                Ensure   = 'Absent'
            }

            [Array]$permissions = Get-MailboxPermission -Identity $Identity -ErrorAction SilentlyContinue
            $permission = $permissions | Where-Object -FilterScript { $_.User -eq $User -and (Compare-Object -ReferenceObject $_.AccessRights.Replace(' ', '').Split(',') -DifferenceObject $AccessRights).Count -eq 0 }

            if ($null -eq $permission)
            {
                Write-Verbose -Message "Permission for mailbox {$($Identity)} do not exist."
                return $nullResult
            }

            $userInfo = (Get-User -Identity $permission.Identity).UserPrincipalName
        }
        else
        {
            $permission = $Script:exportedInstance
            $userInfo = $Script:UsersCache[$permission.Identity]
        }

        $result = @{
            Identity              = $userInfo
            AccessRights          = [System.String[]]$permission.AccessRights.Replace(' ', '').Split(',')
            InheritanceType       = $permission.InheritanceType
            Owner                 = $permission.Owner
            User                  = $permission.User
            Deny                  = [Boolean]$permission.Deny
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

        Write-Verbose -Message "Found permissions for mailbox {$($Identity)}"
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
        [ValidateSet('ChangeOwner', 'ChangePermission', 'DeleteItem', 'ExternalAccount', 'FullAccess', 'ReadPermission')]
        [System.String[]]
        $AccessRights,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('None', 'All', 'Children', 'Descendents', 'SelfAndChildren')]
        $InheritanceType,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.Boolean]
        $Deny,

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

    Write-Verbose -Message "Setting configuration of Mailbox Permissions for {$Identity}"

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

    $currentValues = Get-TargetResource @PSBoundParameters
    $instanceParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Adding new permission for user {$User} on Mailbox {$Identity}"
        Add-MailboxPermission @instanceParams | Out-Null
    }
    elseif ($Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Removing permission for user {$User} on Mailbox {$Identity}"
        Remove-MailboxPermission @instanceParams
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

        [Parameter(Mandatory = $true)]
        [ValidateSet('ChangeOwner', 'ChangePermission', 'DeleteItem', 'ExternalAccount', 'FullAccess', 'ReadPermission')]
        [System.String[]]
        $AccessRights,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('None', 'All', 'Children', 'Descendents', 'SelfAndChildren')]
        $InheritanceType,

        [Parameter()]
        [System.String]
        $Owner,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.Boolean]
        $Deny,

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
        [array]$mailboxes = Get-Mailbox -ResultSize 'Unlimited' -ErrorAction Stop
        if ($mailboxes.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1
        if ($null -eq $Script:UsersCache)
        {
            $Script:UsersCache = [System.Collections.Generic.Dictionary[System.String, System.String]]::new()
            Get-User -ResultSize Unlimited | ForEach-Object {
                $Script:UsersCache[$_.Identity] = $_.UserPrincipalName
            }
        }
        foreach ($mailbox in $mailboxes)
        {
            Write-M365DSCHost -Message "    |---[$i/$($mailboxes.Count)] $($mailbox.UserPrincipalName)" -DeferWrite

            [Array]$permissions = Get-MailboxPermission -Identity $mailbox.UserPrincipalName

            $j = 1
            Write-M365DSCHost -Message "`r`n" -DeferWrite
            foreach ($permission in $permissions)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-M365DSCHost -Message "        |---[$j/$($permissions.Count)] $($permission.Identity)" -DeferWrite
                $Params = @{
                    Identity              = $mailbox.UserPrincipalName
                    AccessRights          = [System.String[]]$permission.AccessRights.Replace(' ', '').Replace('SendAs,', '').Split(',') # ignore SendAs permissions since they are not supported by *-MailboxPermission cmdlets
                    InheritanceType       = $permission.InheritanceType
                    User                  = $permission.User
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    CertificatePassword   = $CertificatePassword
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    CertificatePath       = $CertificatePath
                    AccessTokens          = $AccessTokens
                }

                $Script:exportedInstance = $permission
                $Results = Get-TargetResource @Params
                if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
                {
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    [void]$dscContent.Append($currentDSCBlock)

                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName

                    Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                }
                else
                {
                    Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
                }
                $j++
            }

            $i++
        }
        return $dscContent.ToString()
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
