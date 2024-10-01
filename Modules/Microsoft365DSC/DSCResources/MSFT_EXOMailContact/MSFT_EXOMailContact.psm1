function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalEmailAddress,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 64)]
        $Alias,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.String]
        $Initials,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.String]
        [ValidateSet('BinHex', 'UuEncode', 'AppleSingle', 'AppleDouble')]
        $MacAttachmentFormat = 'BinHex',

        [Parameter()]
        [System.String]
        [ValidateSet('Text', 'Html', 'TextAndHtml')]
        $MessageBodyFormat = 'TextAndHtml',

        [Parameter()]
        [System.String]
        [ValidateSet('Mime', 'Text')]
        $MessageFormat,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications = 'Always',

        [Parameter()]
        [System.Boolean]
        $UsePreferMessageFormat,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute5,

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

    Write-Verbose -Message "Getting configuration of Mail Contact for $Name"

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
        $contact = Get-MailContact -Identity $Name -ErrorAction SilentlyContinue

        if ($null -eq $contact)
        {
            Write-Verbose -Message "Contact $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name                        = $Name
                ExternalEmailAddress        = $contact.ExternalEmailAddress
                Alias                       = $contact.Alias
                DisplayName                 = $contact.DisplayName
                FirstName                   = $contact.FirstName
                Initials                    = $contact.Initials
                LastName                    = $contact.LastName
                MacAttachmentFormat         = $contact.MacAttachmentFormat
                MessageBodyFormat           = $contact.MessageBodyFormat
                MessageFormat               = $contact.MessageFormat
                ModeratedBy                 = $contact.ModeratedBy
                ModerationEnabled           = $contact.ModerationEnabled
                OrganizationalUnit          = $contact.OrganizationalUnit
                SendModerationNotifications = $contact.SendModerationNotifications
                UsePreferMessageFormat      = $contact.UsePreferMessageFormat
                Ensure                      = 'Present'
                Credential                  = $Credential
                ApplicationId               = $ApplicationId
                CertificateThumbprint       = $CertificateThumbprint
                CertificatePath             = $CertificatePath
                CertificatePassword         = $CertificatePassword
                Managedidentity             = $ManagedIdentity.IsPresent
                TenantId                    = $TenantId
                AccessTokens                = $AccessTokens
            }

            foreach ($i in (1..15))
            {
                if ($contact."CustomAttribute$i")
                {
                    $result."CustomAttribute$i" = $contact."CustomAttribute$i"
                }
            }
            foreach ($i in (1..5))
            {
                if ($contact."ExtensionCustomAttribute$i")
                {
                    $result."ExtensionCustomAttribute$i" = $contact."ExtensionCustomAttribute$i"
                }
            }

            Write-Verbose -Message "Found Mail Contact $($Name)"
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
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalEmailAddress,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 64)]
        $Alias,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.String]
        $Initials,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.String]
        [ValidateSet('BinHex', 'UuEncode', 'AppleSingle', 'AppleDouble')]
        $MacAttachmentFormat = 'BinHex',

        [Parameter()]
        [System.String]
        [ValidateSet('Text', 'Html', 'TextAndHtml')]
        $MessageBodyFormat = 'TextAndHtml',

        [Parameter()]
        [System.String]
        [ValidateSet('Mime', 'Text')]
        $MessageFormat,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications = 'Always',

        [Parameter()]
        [System.Boolean]
        $UsePreferMessageFormat,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute5,

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

    $currentContact = Get-TargetResource @PSBoundParameters

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

    # Mail Contact doesn't exist but it should
    if ($Ensure -eq 'Present' -and $currentContact.Ensure -eq 'Absent')
    {
        $parameters = Sync-M365DSCParameter -Command (Get-Command -Name New-MailContact) -Parameters $PSBoundParameters
        Write-Verbose -Message "The Mail Contact '$($Name)' does not exist but it should. Creating Mail Contact."

        try
        {
            New-MailContact @parameters -ErrorAction Stop

            $parameters = Sync-M365DSCParameter -Command (Get-Command -Name Set-MailContact) -Parameters $PSBoundParameters
            $parameters.Identity = $Name
            Set-MailContact @parameters -ErrorAction Stop
        }
        catch
        {
            Write-Error -ErrorRecord $_
        }
    }
    # Mail Contact exists but shouldn't
    elseif ($Ensure -eq 'Absent' -and $currentContact.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Mail Contact'$($Name)' exists but shouldn't. Removing Mail Contact."
        Remove-MailContact -Identity $Name -Confirm:$false
    }
    elseif ($Ensure -eq 'Present' -and $currentContact.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Mail Contact '$($Name)' already exists. Updating settings"
        $parameters = Sync-M365DSCParameter -Command (Get-Command -Name Set-MailContact) -Parameters $PSBoundParameters
        Write-Verbose -Message "Updating Mail Contact '$($Name)' with values: $(Convert-M365DscHashtableToString -Hashtable $parameters)"
        $parameters.Identity = $Name
        Set-MailContact @parameters
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
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ExternalEmailAddress,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 64)]
        $Alias,

        [Parameter()]
        [System.String]
        [ValidateLength(0, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $FirstName,

        [Parameter()]
        [System.String]
        $Initials,

        [Parameter()]
        [System.String]
        $LastName,

        [Parameter()]
        [System.String]
        [ValidateSet('BinHex', 'UuEncode', 'AppleSingle', 'AppleDouble')]
        $MacAttachmentFormat = 'BinHex',

        [Parameter()]
        [System.String]
        [ValidateSet('Text', 'Html', 'TextAndHtml')]
        $MessageBodyFormat = 'TextAndHtml',

        [Parameter()]
        [System.String]
        [ValidateSet('Mime', 'Text')]
        $MessageFormat,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications = 'Always',

        [Parameter()]
        [System.Boolean]
        $UsePreferMessageFormat,

        [Parameter()]
        [System.String]
        $CustomAttribute1,

        [Parameter()]
        [System.String]
        $CustomAttribute2,

        [Parameter()]
        [System.String]
        $CustomAttribute3,

        [Parameter()]
        [System.String]
        $CustomAttribute4,

        [Parameter()]
        [System.String]
        $CustomAttribute5,

        [Parameter()]
        [System.String]
        $CustomAttribute6,

        [Parameter()]
        [System.String]
        $CustomAttribute7,

        [Parameter()]
        [System.String]
        $CustomAttribute8,

        [Parameter()]
        [System.String]
        $CustomAttribute9,

        [Parameter()]
        [System.String]
        $CustomAttribute10,

        [Parameter()]
        [System.String]
        $CustomAttribute11,

        [Parameter()]
        [System.String]
        $CustomAttribute12,

        [Parameter()]
        [System.String]
        $CustomAttribute13,

        [Parameter()]
        [System.String]
        $CustomAttribute14,

        [Parameter()]
        [System.String]
        $CustomAttribute15,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute1,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute2,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute3,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute4,

        [Parameter()]
        [System.String[]]
        $ExtensionCustomAttribute5,

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

    Write-Verbose -Message "Testing Mail Contact configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    [void]$ValuesToCheck.Remove('OrganizationalUnit')

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
    param (
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
        $dscContent = [System.Text.StringBuilder]::new()
        [array]$contactList = Get-MailContact -ResultSize 'Unlimited' -ErrorAction Stop
        if ($contactList.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1

        foreach ($contact in $contactList)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($contactList.Count)] $($contact.Name)" -NoNewline
            $params = @{
                Name                  = $contact.Name
                ExternalEmailAddress  = $contact.ExternalEmailAddress
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
            [void]$dscContent.Append($currentDSCBlock)

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i ++
        }
        return $dscContent.ToString()
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
