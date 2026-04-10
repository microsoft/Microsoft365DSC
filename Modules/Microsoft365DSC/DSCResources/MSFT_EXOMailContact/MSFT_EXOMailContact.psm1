Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOMailContact'
$Script:NewParameters = @('Alias', 'DisplayName', 'ExternalEmailAddress', 'FirstName', 'Initials', 'LastName', 'MacAttachmentFormat', 'MessageBodyFormat', 'MessageFormat', 'ModeratedBy', 'ModerationEnabled', 'Name', 'OrganizationalUnit', 'SendModerationNotifications', 'UsePreferMessageFormat')
$Script:SetParameters = @('AcceptMessagesOnlyFrom', 'AcceptMessagesOnlyFromDLMembers', 'AcceptMessagesOnlyFromSendersOrMembers', 'Alias', 'BypassModerationFromSendersOrMembers', 'CustomAttribute1', 'CustomAttribute10', 'CustomAttribute11', 'CustomAttribute12', 'CustomAttribute13', 'CustomAttribute14',
                          'CustomAttribute15', 'CustomAttribute2', 'CustomAttribute3', 'CustomAttribute4', 'CustomAttribute5', 'CustomAttribute6', 'CustomAttribute7', 'CustomAttribute8', 'CustomAttribute9', 'DisplayName', 'EmailAddresses', 'ExtensionCustomAttribute1', 'ExtensionCustomAttribute2',
                          'ExtensionCustomAttribute3', 'ExtensionCustomAttribute4', 'ExtensionCustomAttribute5', 'ExternalEmailAddress', 'ForceUpgrade', 'GrantSendOnBehalfTo', 'HiddenFromAddressListsEnabled', 'Identity', 'MacAttachmentFormat', 'MailTip', 'MailTipTranslations', 'MessageBodyFormat',
                          'MessageFormat', 'ModeratedBy', 'ModerationEnabled', 'Name', 'RejectMessagesFrom', 'RejectMessagesFromDLMembers', 'RejectMessagesFromSendersOrMembers', 'RequireSenderAuthenticationEnabled', 'SendModerationNotifications', 'SimpleDisplayName', 'UseMapiRichTextFormat',
                          'UsePreferMessageFormat', 'UserCertificate', 'UserSMimeCertificate', 'WindowsEmailAddress')

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
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

            $contact = Get-MailContact -Identity $Name -ErrorAction SilentlyContinue
            if ($null -eq $contact)
            {
                Write-Verbose -Message "Contact $($Name) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $contact = $Script:exportedInstance
        }

        Write-Verbose -Message "Found Mail Contact $($Name)"

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
            ManagedIdentity             = $ManagedIdentity.IsPresent
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
            else
            {
                $result."ExtensionCustomAttribute$i" = @()
            }
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

    # Mail Contact doesn't exist but it should
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $boundParameters.Remove('Name') | Out-Null
    if ($Ensure -eq 'Present' -and $currentContact.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "The Mail Contact '$($Name)' does not exist but it should. Creating Mail Contact."
        $createParameters = @{}
        $updateParameters = @{}
        foreach ($param in $Script:NewParameters)
        {
            if (-not $createParameters.ContainsKey($param) -and $boundParameters.ContainsKey($param))
            {
                $createParameters.Add($param, $PSBoundParameters[$param])
            }
        }
        foreach ($param in $Script:SetParameters)
        {
            if (-not $updateParameters.ContainsKey($param) -and $boundParameters.ContainsKey($param))
            {
                $updateParameters.Add($param, $PSBoundParameters[$param])
            }
        }
        $updateParameters.Add('Identity', $Name)

        New-MailContact @createParameters -ErrorAction Stop
        Set-MailContact @updateParameters -ErrorAction Stop
    }
    elseif ($Ensure -eq 'Present' -and $currentContact.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Mail Contact '$($Name)' already exists. Updating settings"
        $updateParameters = @{}
        foreach ($param in $Script:SetParameters)
        {
            if ($updateParameters.ContainsKey($param) -and $boundParameters.ContainsKey($param))
            {
                $updateParameters.Add($param, $PSBoundParameters[$param])
            }
        }
        $updateParameters.Add('Identity', $Name)
        Set-MailContact @updateParameters
    }
    elseif ($Ensure -eq 'Absent' -and $currentContact.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Mail Contact'$($Name)' exists but shouldn't. Removing Mail Contact."
        Remove-MailContact -Identity $Name -Confirm:$false
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
        $dscContent = [System.Text.StringBuilder]::new()
        [array]$contactList = Get-MailContact -ResultSize 'Unlimited' -ErrorAction Stop
        if ($contactList.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1

        foreach ($contact in $contactList)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($contactList.Count)] $($contact.Name)" -DeferWrite
            $params = @{
                Name                  = $contact.Name
                ExternalEmailAddress  = $contact.ExternalEmailAddress
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $contact
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i ++
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
        ExcludedProperties = @('OrganizationalUnit')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
