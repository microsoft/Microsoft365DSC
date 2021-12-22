function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $GroupTypes = @("Unified"),

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of AzureAD Group"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        if ($PSBoundParameters.ContainsKey("Id"))
        {
            Write-Verbose -Message "GroupID was specified"
            try
            {
                $Group = Get-MgGroup -GroupId $Id -ErrorAction Stop
            }
            catch
            {
                Write-Verbose -Message "Couldn't get group by ID, trying by name"
                $Group = Get-MgGroup -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
                if ($Group.Length -gt 1)
                {
                    throw "Duplicate AzureAD Groups named $DisplayName exist in tenant"
                }
            }
        }
        else
        {
            Write-Verbose -Message "Id was NOT specified"
            ## Can retreive multiple AAD Groups since displayname is not unique
            $Group = Get-MgGroup -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
            if ($Group.Length -gt 1)
            {
                throw "Duplicate AzureAD Groups named $DisplayName exist in tenant"
            }
        }

        if ($null -eq $Group)
        {
            Write-Verbose -Message "Group was null, returning null"
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message "Found existing AzureAD Group"

            $result = @{
                DisplayName                   = $Group.DisplayName
                Id                            = $Group.Id
                Description                   = $Group.Description
                GroupTypes                    = [System.String[]]$Group.GroupTypes
                MembershipRule                = $Group.MembershipRule
                MembershipRuleProcessingState = $Group.MembershipRuleProcessingState
                SecurityEnabled               = $Group.SecurityEnabled
                MailEnabled                   = $Group.MailEnabled
                IsAssignableToRole            = $Group.IsAssignableToRole
                MailNickname                  = $Group.MailNickname
                Visibility                    = $Group.Visibility
                Ensure                        = "Present"
                ApplicationId                 = $ApplicationId
                TenantId                      = $TenantId
                CertificateThumbprint         = $CertificateThumbprint
                ApplicationSecret             = $ApplicationSecret
                Credential                    = $Credential
            }
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD Groups"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentParameters = $PSBoundParameters
    $currentGroup = Get-TargetResource @PSBoundParameters
    $currentParameters.Remove("ApplicationId") | Out-Null
    $currentParameters.Remove("TenantId") | Out-Null
    $currentParameters.Remove("CertificateThumbprint") | Out-Null
    $currentParameters.Remove("ApplicationSecret") | Out-Null
    $currentParameters.Remove("Ensure") | Out-Null
    $currentParameters.Remove("Credential") | Out-Null

    if ($Ensure -eq 'Present' -and `
        ($null -ne $GroupTypes -and $GroupTypes.Contains("Unified")) -and `
        ($null -ne $MailEnabled -and $MailEnabled -eq $false))
    {
        Write-Verbose -Message "Cannot set mailenabled to false if GroupTypes is set to Unified when creating group."
        throw "Cannot set mailenabled to false if GroupTypes is set to Unified when creating a group."
    }
    if (-not $GroupTypes)
    {
        $currentParameters.Add("GroupTypes", @("Unified"))
    }

    if ($Ensure -eq 'Present' -and $currentGroup.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Group {$DisplayName} exists and it should."
        try
        {
            Write-Verbose -Message "Updating settings by ID for group {$DisplayName}"
            if ($true -eq $currentParameters.ContainsKey("IsAssignableToRole"))
            {
                Write-Verbose -Message "Cannot set IsAssignableToRole once group is created."
                $currentParameters.Remove("IsAssignableToRole") | Out-Null
            }
            if ($false -eq $currentParameters.ContainsKey("Id"))
            {
                Update-MgGroup @currentParameters -GroupId $currentGroup.Id | Out-Null
            }
            else
            {
                Write-Verbose -Message "Updating settings for group {$DisplayName}"
                Update-MgGroup @currentParameters | Out-Null
            }
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't set group $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentGroup.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new group {$DisplayName}"
        $currentParameters.Remove("Id") | Out-Null
        try
        {
            New-MgGroup @currentParameters | Out-Null
        }
        catch
        {
            Write-Verbose -Message $_
            New-M365DSCLogEntry -Error $_ -Message "Couldn't create group $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentGroup.Ensure -eq 'Present')
    {
        try
        {
            Remove-MgGroup -GroupId $currentGroup.ID | Out-Null
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't delete group $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of AzureAD Groups"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck.Remove('GroupTypes') | Out-Null

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array] $groups = Get-MgGroup -All -ErrorAction Stop
        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($group in $groups)
        {
            Write-Host "    |---[$i/$($groups.Count)] $($group.DisplayName)" -NoNewline
            $Params = @{
                ApplicationSecret     = $ApplicationSecret
                DisplayName           = $group.DisplayName
                MailNickName          = $group.MailNickName
                Id                    = $group.Id
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Credential            = $Credential
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
