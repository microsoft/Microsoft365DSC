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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Organization Relationship configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllOrganizationRelationships = Get-OrganizationRelationship

    $OrganizationRelationship = $AllOrganizationRelationships | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $OrganizationRelationship)
    {
        Write-Verbose -Message "Organization Relationship configuration for $($Name) does not exist."

        $nullReturn = @{
            ArchiveAccessEnabled  = $ArchiveAccessEnabled
            DeliveryReportEnabled = $DeliveryReportEnabled
            DomainNames           = $DomainNames
            Enabled               = $Enabled
            FreeBusyAccessEnabled = $FreeBusyAccessEnabled
            FreeBusyAccessLevel   = $FreeBusyAccessLevel
            FreeBusyAccessScope   = $FreeBusyAccessScope
            MailboxMoveEnabled    = $MailboxMoveEnabled
            MailTipsAccessEnabled = $MailTipsAccessEnabled
            MailTipsAccessLevel   = $MailTipsAccessLevel
            MailTipsAccessScope   = $MailTipsAccessScope
            Name                  = $Name
            OrganizationContact   = $OrganizationContact
            PhotosEnabled         = $PhotosEnabled
            TargetApplicationUri  = $TargetApplicationUri
            TargetAutodiscoverEpr = $TargetAutodiscoverEpr
            TargetOwaURL          = $TargetOwaURL
            TargetSharingEpr      = $TargetSharingEpr
            Ensure                = 'Absent'
            GlobalAdminAccount    = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            ArchiveAccessEnabled  = $OrganizationRelationship.ArchiveAccessEnabled
            DeliveryReportEnabled = $OrganizationRelationship.DeliveryReportEnabled
            DomainNames           = $OrganizationRelationship.DomainNames
            Enabled               = $OrganizationRelationship.Enabled
            FreeBusyAccessEnabled = $OrganizationRelationship.FreeBusyAccessEnabled
            FreeBusyAccessLevel   = $OrganizationRelationship.FreeBusyAccessLevel
            FreeBusyAccessScope   = $OrganizationRelationship.FreeBusyAccessScope
            MailboxMoveEnabled    = $OrganizationRelationship.MailboxMoveEnabled
            MailTipsAccessEnabled = $OrganizationRelationship.MailTipsAccessEnabled
            MailTipsAccessLevel   = $OrganizationRelationship.MailTipsAccessLevel
            MailTipsAccessScope   = $OrganizationRelationship.MailTipsAccessScope
            Name                  = $OrganizationRelationship.Name
            OrganizationContact   = $OrganizationRelationship.OrganizationContact
            PhotosEnabled         = $OrganizationRelationship.PhotosEnabled
            Ensure                = 'Present'
            GlobalAdminAccount    = $GlobalAdminAccount
        }

        if ($OrganizationRelationship.TargetApplicationUri)
        {
            $result.Add("TargetApplicationUri", $($OrganizationRelationship.TargetApplicationUri.ToString()))
        }
        else
        {
            $result.Add("TargetApplicationUri", "")
        }

        if ($OrganizationRelationship.TargetAutodiscoverEpr)
        {
            $result.Add("TargetAutodiscoverEpr", $($OrganizationRelationship.TargetAutodiscoverEpr.ToString()))
        }
        else
        {
            $result.Add("TargetAutodiscoverEpr", "")
        }

        if ($OrganizationRelationship.TargetSharingEpr)
        {
            $result.Add("TargetSharingEpr", $($OrganizationRelationship.TargetSharingEpr.ToString()))
        }
        else
        {
            $result.Add("TargetSharingEpr", "")
        }

        if ($OrganizationRelationship.TargetOwaURL)
        {
            $result.Add("TargetOwaURL", $($OrganizationRelationship.TargetOwaURL.ToString()))
        }
        else
        {
            $result.Add("TargetOwaURL", "")
        }

        Write-Verbose -Message "Found Organization Relationship configuration for $($Name)"
        return $result
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Organization Relationship configuration for $Name"

    $currentOrgRelationshipConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewOrganizationRelationshipParams = @{
        ArchiveAccessEnabled  = $ArchiveAccessEnabled
        DeliveryReportEnabled = $DeliveryReportEnabled
        DomainNames           = $DomainNames
        Enabled               = $Enabled
        FreeBusyAccessEnabled = $FreeBusyAccessEnabled
        FreeBusyAccessLevel   = $FreeBusyAccessLevel
        FreeBusyAccessScope   = $FreeBusyAccessScope
        MailboxMoveEnabled    = $MailboxMoveEnabled
        MailTipsAccessEnabled = $MailTipsAccessEnabled
        MailTipsAccessLevel   = $MailTipsAccessLevel
        MailTipsAccessScope   = $MailTipsAccessScope
        Name                  = $Name
        OrganizationContact   = $OrganizationContact
        PhotosEnabled         = $PhotosEnabled
        TargetApplicationUri  = $TargetApplicationUri
        TargetAutodiscoverEpr = $TargetAutodiscoverEpr
        TargetOwaURL          = $TargetOwaURL
        TargetSharingEpr      = $TargetSharingEpr
        Confirm               = $false
    }

    $SetOrganizationRelationshipParams = @{
        ArchiveAccessEnabled  = $ArchiveAccessEnabled
        DeliveryReportEnabled = $DeliveryReportEnabled
        DomainNames           = $DomainNames
        Enabled               = $Enabled
        FreeBusyAccessEnabled = $FreeBusyAccessEnabled
        FreeBusyAccessLevel   = $FreeBusyAccessLevel
        FreeBusyAccessScope   = $FreeBusyAccessScope
        MailboxMoveEnabled    = $MailboxMoveEnabled
        MailTipsAccessEnabled = $MailTipsAccessEnabled
        MailTipsAccessLevel   = $MailTipsAccessLevel
        MailTipsAccessScope   = $MailTipsAccessScope
        Identity              = $Name
        OrganizationContact   = $OrganizationContact
        PhotosEnabled         = $PhotosEnabled
        TargetApplicationUri  = $TargetApplicationUri
        TargetAutodiscoverEpr = $TargetAutodiscoverEpr
        TargetOwaURL          = $TargetOwaURL
        TargetSharingEpr      = $TargetSharingEpr
        Confirm               = $false
    }

    # CASE: Organization Relationship doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentOrgRelationshipConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Organization Relationship '$($Name)' does not exist but it should. Create and configure it."
        # Create Organization Relationship
        New-OrganizationRelationship @NewOrganizationRelationshipParams
    }
    # CASE: Organization Relationship exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentOrgRelationshipConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Organization Relationship '$($Name)' exists but it shouldn't. Remove it."
        Remove-OrganizationRelationship -Identity $Name -Confirm:$false
    }
    # CASE: Organization Relationship exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentOrgRelationshipConfig.Ensure -eq "Present")
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Organization Relationship configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    [array]$AllOrgRelationships = Get-OrganizationRelationship

    $dscContent = ""
    $i = 1
    foreach ($relationship in $AllOrgRelationships)
    {
        Write-Information "    [$i/$($AllOrgRelationships.Count)] $($relationship.Name)"

        $Params = @{
            Name               = $relationship.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOOrganizationRelationship " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $dscContent += $content
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource

