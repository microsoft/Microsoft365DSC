function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $ArchiveAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.String[]]
        $DomainNames,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $FreeBusyAccessEnabled,

        [Parameter()]
        [ValidateSet('None', 'AvailabilityOnly', 'LimitedDetails')]
        [System.String]
        $FreeBusyAccessLevel,

        [Parameter()]
        [System.String]
        $FreeBusyAccessScope,

        [Parameter()]
        [System.Boolean]
        $MailboxMoveEnabled,

        [Parameter()]
        [ValidateSet('Inbound', 'Outbound', 'RemoteInbound', 'RemoteOutbound', 'None')]
        [System.String]
        $MailboxMoveCapability,

        [Parameter()]
        [System.String[]]
        $MailboxMovePublishedScopes = @(),

        [Parameter()]
        [System.Boolean]
        $MailTipsAccessEnabled,

        [Parameter()]
        [ValidateSet('None', 'All', 'Limited')]
        [System.String]
        $MailTipsAccessLevel,

        [Parameter()]
        [System.String]
        $MailTipsAccessScope,

        [Parameter()]
        [System.String]
        $OauthApplicationId,

        [Parameter()]
        [System.String]
        $OrganizationContact,

        [Parameter()]
        [System.Boolean]
        $PhotosEnabled,

        [Parameter()]
        [System.String]
        $TargetApplicationUri,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.String]
        $TargetOwaURL,

        [Parameter()]
        [System.String]
        $TargetSharingEpr,

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

    Write-Verbose -Message "Getting Organization Relationship configuration for $Name"
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
        $AllOrganizationRelationships = Get-OrganizationRelationship -ErrorAction Stop

        $OrganizationRelationship = $AllOrganizationRelationships | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $OrganizationRelationship)
        {
            Write-Verbose -Message "Organization Relationship configuration for $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                ArchiveAccessEnabled       = $OrganizationRelationship.ArchiveAccessEnabled
                DeliveryReportEnabled      = $OrganizationRelationship.DeliveryReportEnabled
                DomainNames                = $OrganizationRelationship.DomainNames
                Enabled                    = $OrganizationRelationship.Enabled
                FreeBusyAccessEnabled      = $OrganizationRelationship.FreeBusyAccessEnabled
                FreeBusyAccessLevel        = $OrganizationRelationship.FreeBusyAccessLevel
                FreeBusyAccessScope        = $OrganizationRelationship.FreeBusyAccessScope
                MailboxMoveEnabled         = $OrganizationRelationship.MailboxMoveEnabled
                MailboxMoveCapability      = $OrganizationRelationship.MailboxMoveCapability
                MailboxMovePublishedScopes = $OrganizationRelationship.MailboxMovePublishedScopes
                MailTipsAccessEnabled      = $OrganizationRelationship.MailTipsAccessEnabled
                MailTipsAccessLevel        = $OrganizationRelationship.MailTipsAccessLevel
                MailTipsAccessScope        = $OrganizationRelationship.MailTipsAccessScope
                Name                       = $OrganizationRelationship.Name
                OauthApplicationId         = $OrganizationRelationship.OauthApplicationId
                OrganizationContact        = $OrganizationRelationship.OrganizationContact
                PhotosEnabled              = $OrganizationRelationship.PhotosEnabled
                Ensure                     = 'Present'
                Credential                 = $Credential
                ApplicationId              = $ApplicationId
                CertificateThumbprint      = $CertificateThumbprint
                CertificatePath            = $CertificatePath
                CertificatePassword        = $CertificatePassword
                Managedidentity            = $ManagedIdentity.IsPresent
                TenantId                   = $TenantId
                AccessTokens               = $AccessTokens
            }

            if ($OrganizationRelationship.TargetApplicationUri)
            {
                $result.Add('TargetApplicationUri', $($OrganizationRelationship.TargetApplicationUri.ToString()))
            }
            else
            {
                $result.Add('TargetApplicationUri', '')
            }

            if ($OrganizationRelationship.TargetAutodiscoverEpr)
            {
                $result.Add('TargetAutodiscoverEpr', $($OrganizationRelationship.TargetAutodiscoverEpr.ToString()))
            }
            else
            {
                $result.Add('TargetAutodiscoverEpr', '')
            }

            if ($OrganizationRelationship.TargetSharingEpr)
            {
                $result.Add('TargetSharingEpr', $($OrganizationRelationship.TargetSharingEpr.ToString()))
            }
            else
            {
                $result.Add('TargetSharingEpr', '')
            }

            if ($OrganizationRelationship.TargetOwaURL)
            {
                $result.Add('TargetOwaURL', $($OrganizationRelationship.TargetOwaURL.ToString()))
            }
            else
            {
                $result.Add('TargetOwaURL', '')
            }

            Write-Verbose -Message "Found Organization Relationship configuration for $($Name)"
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
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $ArchiveAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.String[]]
        $DomainNames,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $FreeBusyAccessEnabled,

        [Parameter()]
        [ValidateSet('None', 'AvailabilityOnly', 'LimitedDetails')]
        [System.String]
        $FreeBusyAccessLevel,

        [Parameter()]
        [System.String]
        $FreeBusyAccessScope,

        [Parameter()]
        [System.Boolean]
        $MailboxMoveEnabled,

        [Parameter()]
        [ValidateSet('Inbound', 'Outbound', 'RemoteInbound', 'RemoteOutbound', 'None')]
        [System.String]
        $MailboxMoveCapability,

        [Parameter()]
        [System.String[]]
        $MailboxMovePublishedScopes = @(),

        [Parameter()]
        [System.Boolean]
        $MailTipsAccessEnabled,

        [Parameter()]
        [ValidateSet('None', 'All', 'Limited')]
        [System.String]
        $MailTipsAccessLevel,

        [Parameter()]
        [System.String]
        $MailTipsAccessScope,

        [Parameter()]
        [System.String]
        $OauthApplicationId,

        [Parameter()]
        [System.String]
        $OrganizationContact,

        [Parameter()]
        [System.Boolean]
        $PhotosEnabled,

        [Parameter()]
        [System.String]
        $TargetApplicationUri,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.String]
        $TargetOwaURL,

        [Parameter()]
        [System.String]
        $TargetSharingEpr,

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

    Write-Verbose -Message "Setting Organization Relationship configuration for $Name"

    $currentOrgRelationshipConfig = Get-TargetResource @PSBoundParameters

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewOrganizationRelationshipParams = @{
        ArchiveAccessEnabled       = $ArchiveAccessEnabled
        DeliveryReportEnabled      = $DeliveryReportEnabled
        DomainNames                = $DomainNames
        Enabled                    = $Enabled
        FreeBusyAccessEnabled      = $FreeBusyAccessEnabled
        FreeBusyAccessLevel        = $FreeBusyAccessLevel
        FreeBusyAccessScope        = $FreeBusyAccessScope
        MailboxMoveEnabled         = $MailboxMoveEnabled
        MailboxMoveCapability      = $MailboxMoveCapability
        MailboxMovePublishedScopes = $MailboxMovePublishedScopes
        MailTipsAccessEnabled      = $MailTipsAccessEnabled
        MailTipsAccessLevel        = $MailTipsAccessLevel
        MailTipsAccessScope        = $MailTipsAccessScope
        Name                       = $Name
        OauthApplicationId         = $OauthApplicationId
        OrganizationContact        = $OrganizationContact
        PhotosEnabled              = $PhotosEnabled
        TargetApplicationUri       = $TargetApplicationUri
        TargetAutodiscoverEpr      = $TargetAutodiscoverEpr
        TargetOwaURL               = $TargetOwaURL
        TargetSharingEpr           = $TargetSharingEpr
        Confirm                    = $false
    }
    # Removes empty properties from Splat to prevent function throwing errors if parameter is null or empty
    Remove-EmptyValue -Splat $NewOrganizationRelationshipParams

    $SetOrganizationRelationshipParams = @{
        ArchiveAccessEnabled       = $ArchiveAccessEnabled
        DeliveryReportEnabled      = $DeliveryReportEnabled
        DomainNames                = $DomainNames
        Enabled                    = $Enabled
        FreeBusyAccessEnabled      = $FreeBusyAccessEnabled
        FreeBusyAccessLevel        = $FreeBusyAccessLevel
        FreeBusyAccessScope        = $FreeBusyAccessScope
        MailboxMoveEnabled         = $MailboxMoveEnabled
        MailboxMoveCapability      = $MailboxMoveCapability
        MailboxMovePublishedScopes = $MailboxMovePublishedScopes
        MailTipsAccessEnabled      = $MailTipsAccessEnabled
        MailTipsAccessLevel        = $MailTipsAccessLevel
        MailTipsAccessScope        = $MailTipsAccessScope
        Identity                   = $Name
        OauthApplicationId         = $OauthApplicationId
        OrganizationContact        = $OrganizationContact
        PhotosEnabled              = $PhotosEnabled
        TargetApplicationUri       = $TargetApplicationUri
        TargetAutodiscoverEpr      = $TargetAutodiscoverEpr
        TargetOwaURL               = $TargetOwaURL
        TargetSharingEpr           = $TargetSharingEpr
        Confirm                    = $false
    }
    # Removes empty properties from Splat to prevent function throwing errors if parameter is null or empty
    Remove-EmptyValue -Splat $SetOrganizationRelationshipParams

    # CASE: Organization Relationship doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentOrgRelationshipConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Organization Relationship '$($Name)' does not exist but it should. Create and configure it."
        # Create Organization Relationship
        New-OrganizationRelationship @NewOrganizationRelationshipParams
    }
    # CASE: Organization Relationship exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentOrgRelationshipConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Organization Relationship '$($Name)' exists but it shouldn't. Remove it."
        Remove-OrganizationRelationship -Identity $Name -Confirm:$false
    }
    # CASE: Organization Relationship exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentOrgRelationshipConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Organization Relationship '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Organization Relationship  $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetOrganizationRelationshipParams)"
        Set-OrganizationRelationship @SetOrganizationRelationshipParams
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.Boolean]
        $ArchiveAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $DeliveryReportEnabled,

        [Parameter()]
        [System.String[]]
        $DomainNames,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.Boolean]
        $FreeBusyAccessEnabled,

        [Parameter()]
        [ValidateSet('None', 'AvailabilityOnly', 'LimitedDetails')]
        [System.String]
        $FreeBusyAccessLevel,

        [Parameter()]
        [System.String]
        $FreeBusyAccessScope,

        [Parameter()]
        [System.Boolean]
        $MailboxMoveEnabled,

        [Parameter()]
        [ValidateSet('Inbound', 'Outbound', 'RemoteInbound', 'RemoteOutbound', 'None')]
        [System.String]
        $MailboxMoveCapability,

        [Parameter()]
        [System.String[]]
        $MailboxMovePublishedScopes = @(),

        [Parameter()]
        [System.Boolean]
        $MailTipsAccessEnabled,

        [Parameter()]
        [ValidateSet('None', 'All', 'Limited')]
        [System.String]
        $MailTipsAccessLevel,

        [Parameter()]
        [System.String]
        $MailTipsAccessScope,

        [Parameter()]
        [System.String]
        $OauthApplicationId,

        [Parameter()]
        [System.String]
        $OrganizationContact,

        [Parameter()]
        [System.Boolean]
        $PhotosEnabled,

        [Parameter()]
        [System.String]
        $TargetApplicationUri,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [System.String]
        $TargetOwaURL,

        [Parameter()]
        [System.String]
        $TargetSharingEpr,

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

    Write-Verbose -Message "Testing Organization Relationship configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
        [array]$AllOrgRelationships = Get-OrganizationRelationship -ErrorAction Stop

        $dscContent = ''

        if ($AllOrganizationRelationships.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($relationship in $AllOrgRelationships)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($AllOrgRelationships.Length)] $($relationship.Name)" -NoNewline

            $Params = @{
                Name                  = $relationship.Name
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

