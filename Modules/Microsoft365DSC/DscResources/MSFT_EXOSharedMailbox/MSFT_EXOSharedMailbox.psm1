Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOSharedMailbox'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $PrimarySMTPAddress,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.Boolean]
        $AuditEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSentAsEnabled,

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

    Write-Verbose -Message "Getting configuration of Office 365 Shared Mailbox $DisplayName"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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

            try
            {
                if (-not [System.String]::IsNullOrEmpty($Identity))
                {
                    $mailbox = Get-Mailbox -Identity $Identity `
                        -RecipientTypeDetails 'SharedMailbox' `
                        -ResultSize Unlimited `
                        -ErrorAction SilentlyContinue
                }

                if ($null -eq $mailbox)
                {
                    $mailbox = Get-Mailbox -Identity $DisplayName `
                        -RecipientTypeDetails 'SharedMailbox' `
                        -ResultSize Unlimited `
                        -ErrorAction SilentlyContinue
                }
            }
            catch
            {
                Write-Verbose -Message "Could not retrieve AAD roledefinition by Id: {$Id}"
            }

            if ($null -eq $mailbox)
            {
                Write-Verbose -Message "The specified Shared Mailbox doesn't already exist."
                return $nullReturn
            }
        }
        else
        {
            $mailbox = $Script:exportedInstance
        }

        #region EmailAddresses
        $CurrentEmailAddresses = $mailbox.EmailAddresses | Foreach-Object { $_.Split(':') } | Where-Object { $_ -ne 'smtp' }
        if (-not [System.String]::IsNullOrEmpty($PrimarySMTPAddress))
        {
            $CurrentEmailAddresses = $CurrentEmailAddresses | Where-Object { $_ -ne $PrimarySMTPAddress }
        }
        else
        {
            $CurrentEmailAddresses = $CurrentEmailAddresses | Where-Object { $_ -ne $mailbox.PrimarySMTPAddress }
        }
        #endregion

        $result = @{
            DisplayName                       = $DisplayName
            Identity                          = $mailbox.Identity
            PrimarySMTPAddress                = $mailbox.PrimarySMTPAddress.ToString()
            Alias                             = $mailbox.Alias
            AuditEnabled                      = $mailbox.AuditEnabled
            EmailAddresses                    = Get-M365DSCArrayFromProperty -PropertyValue $CurrentEmailAddresses -ElementType ([System.String])
            MessageCopyForSendOnBehalfEnabled = $mailbox.MessageCopyForSendOnBehalfEnabled
            MessageCopyForSentAsEnabled       = $mailbox.MessageCopyForSentAsEnabled
            Ensure                            = 'Present'
            Credential                        = $Credential
            ApplicationId                     = $ApplicationId
            CertificateThumbprint             = $CertificateThumbprint
            CertificatePath                   = $CertificatePath
            CertificatePassword               = $CertificatePassword
            ManagedIdentity                   = $ManagedIdentity.IsPresent
            TenantId                          = $TenantId
            AccessTokens                      = $AccessTokens
        }

        Write-Verbose -Message "Found an existing instance of Shared Mailbox '$($DisplayName)'"
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $PrimarySMTPAddress,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String[]]
        $EmailAddresses = @(),

        [Parameter()]
        [System.Boolean]
        $AuditEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSentAsEnabled,

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

    Write-Verbose -Message "Setting configuration of Office 365 Shared Mailbox $DisplayName"
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

    $currentMailbox = Get-TargetResource @PSBoundParameters

    #region Validation
    foreach ($secondaryAlias in $EmailAddresses)
    {
        if ($secondaryAlias.ToLower() -eq $PrimarySMTPAddress.ToLower())
        {
            throw 'You cannot have the EmailAddresses list contain the PrimarySMTPAddress'
        }
    }
    #endregion

    # CASE: Mailbox doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentMailbox.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Shared Mailbox '$($DisplayName)' does not exist but it should. Creating it."

        $NewMailBoxParameters = @{
            Name               = $DisplayName
            Shared             = $true
        }

        if ($PSBoundParameters.ContainsKey("Alias"))
        {
            $NewMailBoxParameters.Add('Alias', $Alias)
        }

        if ($PSBoundParameters.ContainsKey("PrimarySMTPAddress"))
        {
            $NewMailBoxParameters.Add('PrimarySMTPAddress', $PrimarySMTPAddress)
        }

        New-MailBox @NewMailBoxParameters

        if ($PSBoundParameters.ContainsKey("AuditEnabled") -or $PSBoundParameters.ContainsKey("EmailAddresses") -or $PSBoundParameters.ContainsKey("MessageCopyForSendOnBehalfEnabled") -or $PSBoundParameters.ContainsKey("MessageCopyForSentAsEnabled"))
        {
            $SetParameters = @{
                Identity = $DisplayName
            }

            if ($PSBoundParameters.ContainsKey("AuditEnabled"))
            {
                $SetParameters.Add("AuditEnabled", $AuditEnabled)
            }

            if ($PSBoundParameters.ContainsKey("EmailAddresses"))
            {
                $SetParameters.Add("EmailAddresses", @{ add = $EmailAddresses })
            }

            if ($PSBoundParameters.ContainsKey("MessageCopyForSendOnBehalfEnabled"))
            {
                $SetParameters.Add("MessageCopyForSendOnBehalfEnabled", $MessageCopyForSendOnBehalfEnabled)
            }

            if ($PSBoundParameters.ContainsKey("MessageCopyForSentAsEnabled"))
            {
                $SetParameters.Add("MessageCopyForSentAsEnabled", $MessageCopyForSentAsEnabled)
            }

            Set-Mailbox @SetParameters
        }
    }
    # CASE: Mailbox exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentMailbox.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Shared Mailbox '$($DisplayName)' exists but it shouldn't. Deleting it."
        Remove-Mailbox -Identity $DisplayName -Confirm:$false
    }
    # CASE: Mailbox exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentMailbox.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Shared Mailbox '$($DisplayName)' already exists, but needs updating."

        if ($PSBoundParameters.ContainsKey("PrimarySMTPAddress"))
        {
            if ($currentMailbox.PrimarySMTPAddress -ne $PrimarySMTPAddress)
            {
                Write-Verbose -Message "Updating PrimarySMTPAddress for the Shared Mailbox '$($DisplayName)' from $($currentMailbox.PrimarySMTPAddress) to $PrimarySMTPAddress"
                Set-Mailbox -Identity $DisplayName -WindowsEmailAddress $PrimarySMTPAddress -MicrosoftOnlineServicesID $PrimarySMTPAddress
            }
        }

        $SetParameters = @{
            Identity = $DisplayName
        }

        if ($PSBoundParameters.ContainsKey("Alias"))
        {
            if ($currentMailbox.Alias -ne $Alias)
            {
                Write-Verbose -Message "Updating Alias for the Shared Mailbox '$($DisplayName)' from $($currentMailbox.Alias) to $Alias"
                $SetParameters.Add("Alias", $Alias)
            }
        }

        if ($PSBoundParameters.ContainsKey("AuditEnabled"))
        {
            if ($AuditEnabled -ne $currentMailbox.AuditEnabled)
            {
                Write-Verbose -Message "AuditEnabled for Shared Mailbox '$($DisplayName)' needs to be updated from $($currentMailbox.AuditEnabled) to $AuditEnabled"
                $SetParameters.Add("AuditEnabled", $AuditEnabled)
            }
        }

        # CASE: EmailAddresses need to be updated
        if ($PSBoundParameters.ContainsKey("EmailAddresses"))
        {
            $current = $currentMailbox.EmailAddresses
            $desired = $EmailAddresses

            $emailAddressesToAdd = $desired | Where-Object { $_ -notin $current } | Sort-Object -Unique
            if ($null -ne $PrimarySMTPAddress)
            {
                $emailAddressesToAdd = $emailAddressesToAdd | Where-Object { $_ -ne $PrimarySMTPAddress }
            }
            else
            {
                $emailAddressesToAdd = $emailAddressesToAdd | Where-Object { $_ -ne $currentMailbox.PrimarySMTPAddress }
            }

            $emailAddressesToRemove = $current | Where-Object { $_ -notin $desired } | Sort-Object -Unique
            if ($null -ne $PrimarySMTPAddress)
            {
                $emailAddressesToRemove = $emailAddressesToRemove | Where-Object { $_ -ne $PrimarySMTPAddress }
            }
            else
            {
                $emailAddressesToRemove = $emailAddressesToRemove | Where-Object { $_ -ne $currentMailbox.PrimarySMTPAddress }
            }

            if ($null -ne $emailAddressesToAdd -or $null -ne $emailAddressesToRemove)
            {
                $SetParameters.Add("EmailAddresses", @{})

                # Add EmailAddresses
                Write-Verbose -Message "Updating the list of EmailAddresses for the Shared Mailbox '$($DisplayName)'"
                if ($null -ne $emailAddressesToAdd)
                {
                    Write-Verbose -Message "Adding the following EmailAddresses: $($emailAddressesToAdd | Out-String)"
                    $SetParameters.EmailAddresses.Add("add", $emailAddressesToAdd)
                }
                # Remove EmailAddresses
                if ($null -ne $emailAddressesToRemove)
                {
                    Write-Verbose -Message "Removing the following EmailAddresses: $($emailAddressesToRemove | Out-String)"
                    $SetParameters.EmailAddresses.Add("remove", $emailAddressesToRemove)
                }
            }
        }

        if ($PSBoundParameters.ContainsKey("MessageCopyForSendOnBehalfEnabled"))
        {
            if ($currentMailbox.MessageCopyForSendOnBehalfEnabled -ne $MessageCopyForSendOnBehalfEnabled)
            {
                Write-Verbose -Message "Updating MessageCopyForSendOnBehalfEnabled for the Shared Mailbox '$($DisplayName)' from $($currentMailbox.MessageCopyForSendOnBehalfEnabled) to $MessageCopyForSendOnBehalfEnabled"
                $SetParameters.Add("MessageCopyForSendOnBehalfEnabled", $MessageCopyForSendOnBehalfEnabled)
            }
        }

        if ($PSBoundParameters.ContainsKey("MessageCopyForSentAsEnabled"))
        {
            if ($currentMailbox.MessageCopyForSentAsEnabled -ne $MessageCopyForSentAsEnabled)
            {
                Write-Verbose -Message "Updating MessageCopyForSentAsEnabled for the Shared Mailbox '$($DisplayName)' from $($currentMailbox.MessageCopyForSentAsEnabled) to $MessageCopyForSentAsEnabled"
                $SetParameters.Add("MessageCopyForSentAsEnabled", $MessageCopyForSentAsEnabled)
            }
        }

        Set-Mailbox @SetParameters
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $PrimarySMTPAddress,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.String[]]
        $EmailAddresses,

        [Parameter()]
        [System.Boolean]
        $AuditEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSendOnBehalfEnabled,

        [Parameter()]
        [System.Boolean]
        $MessageCopyForSentAsEnabled,

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

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
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
        [array] $exportedInstances = Get-Mailbox -RecipientTypeDetails 'SharedMailbox' `
            -ResultSize Unlimited `
            -ErrorAction Stop
        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1
        if ($exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($mailbox in $exportedInstances)
        {
            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Length)] $($mailbox.Name)" -DeferWrite
            $mailboxName = $mailbox.Name
            if ($mailboxName)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                $params = @{
                    Identity              = $mailbox.Identity
                    Credential            = $Credential
                    DisplayName           = $mailboxName
                    Alias                 = $mailbox.Alias
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    CertificatePassword   = $CertificatePassword
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    CertificatePath       = $CertificatePath
                    AccessTokens          = $AccessTokens
                }
                $Script:exportedInstance = $mailbox
                $Results = Get-TargetResource @Params
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                [void]$dscContent.Append($currentDSCBlock)
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        IncludedProperties = @('DisplayName')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
