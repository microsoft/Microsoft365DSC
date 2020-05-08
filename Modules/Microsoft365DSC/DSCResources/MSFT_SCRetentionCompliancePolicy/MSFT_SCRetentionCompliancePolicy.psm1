function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $DynamicScopeLocation,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation = @(),

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException = @(),

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation = @(),

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException = @(),

        [Parameter()]
        [System.String[]]
        $OneDriveLocation = @(),

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException = @(),

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation = @(),

        [Parameter()]
        [System.Boolean]
        $RestrictiveRetention = $true,

        [Parameter()]
        [System.String[]]
        $SharePointLocation = @(),

        [Parameter()]
        [System.String[]]
        $SharePointLocationException = @(),

        [Parameter()]
        [System.String[]]
        $SkypeLocation = @(),

        [Parameter()]
        [System.String[]]
        $SkypeLocationException = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocation = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocationException = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChatLocation = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChatLocationException = @(),

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of RetentionCompliancePolicy for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $PolicyObject = Get-RetentionCompliancePolicy $Name -ErrorAction SilentlyContinue

    if ($null -eq $PolicyObject)
    {
        Write-Verbose -Message "RetentionCompliancePolicy $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing RetentionCompliancePolicy $($Name)"

        if ($PolicyObject.TeamsPolicy)
        {
            $result = @{
                Ensure                        = 'Present'
                Name                          = $PolicyObject.Name
                Comment                       = $PolicyObject.Comment
                Enabled                       = $PolicyObject.Enabled
                RestrictiveRetention          = $PolicyObject.RestrictiveRetention
                TeamsChannelLocation          = [array]$PolicyObject.TeamsChannelLocation
                TeamsChannelLocationException = $PolicyObject.TeamsChannelLocationException
                TeamsChatLocation             = [array]$PolicyObject.TeamsChatLocation
                TeamsChatLocationException    = $PolicyObject.TeamsChatLocationException
                GlobalAdminAccount            = $GlobalAdminAccount
            }
        }
        else
        {
            $result = @{
                Ensure                        = 'Present'
                Name                          = $PolicyObject.Name
                Comment                       = $PolicyObject.Comment
                DynamicScopeLocation          = [array]$PolicyObject.DynamicScopeLocation
                Enabled                       = $PolicyObject.Enabled
                ExchangeLocation              = [array]$PolicyObject.ExchangeLocation
                ExchangeLocationException     = [array]$PolicyObject.ExchangeLocationException
                ModernGroupLocation           = [array]$PolicyObject.ModernGroupLocation
                ModernGroupLocationException  = [array]$PolicyObject.ModernGroupLocationException
                OneDriveLocation              = [array]$PolicyObject.OneDriveLocation
                OneDriveLocationException     = [array]$PolicyObject.OneDriveLocationException
                PublicFolderLocation          = [array]$PolicyObject.PublicFolderLocation
                RestrictiveRetention          = $PolicyObject.RestrictiveRetention
                SharePointLocation            = [array]$PolicyObject.SharePointLocation
                SharePointLocationException   = $PolicyObject.SharePointLocationException
                SkypeLocation                 = [array]$PolicyObject.SkypeLocation
                SkypeLocationException        = $PolicyObject.SkypeLocationException
                GlobalAdminAccount            = $GlobalAdminAccount
            }
        }

        Write-Verbose -Message "Found RetentionCompliancePolicy $($Name)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
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

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $DynamicScopeLocation,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $OneDriveLocation,

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.Boolean]
        $RestrictiveRetention = $true,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationException,

        [Parameter()]
        [System.String[]]
        $SkypeLocation,

        [Parameter()]
        [System.String[]]
        $SkypeLocationException,

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocation,

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocationException,

        [Parameter()]
        [System.String[]]
        $TeamsChatLocation,

        [Parameter()]
        [System.String[]]
        $TeamsChatLocationException,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    if ($null -eq $SharePointLocation -and $null -eq $ExchangeLocation -and $null -eq $OneDriveLocation -and `
        $null -eq $SkypeLocation -and $null -eq $PublicFolderLocation -and $null -eq $ModernGroupLocation -and `
        $null -eq $TeamsChannelLocation -and $null -eq $TeamsChatLocation -and $Ensure -eq 'Present')
    {
        throw "You need to specify at least one Location for this Policy."
    }

    Write-Verbose -Message "Setting configuration of RetentionCompliancePolicy for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $CurrentPolicy = Get-TargetResource @PSBoundParameters

    if ($null -eq $TeamsChannelLocation -and $null -eq $TeamsChatLocation)
    {
        Write-Verbose -Message "Policy $Name is not a Teams Policy"
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Name")
        $CreationParams.Add("Identity", $Name)
        $CreationParams.Remove("TeamsChannelLocation")
        $CreationParams.Remove("TeamsChannelLocationException")
        $CreationParams.Remove("TeamsChatLocation")
        $CreationParams.Remove("TeamsChatLocationException")
        $CreationParams.Remove("DynamicScopeLocation")

        # Exchange Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.ExchangeLocation -or `
        $null -ne $ExchangeLocation)
        {
            $ToBeRemoved = $CurrentPolicy.ExchangeLocation | `
                Where-Object { $ExchangeLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveExchangeLocation", $ToBeRemoved)
            }

            $ToBeAdded = $ExchangeLocation | `
                Where-Object { $CurrentPolicy.ExchangeLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddExchangeLocation", $ToBeAdded)
            }

            $CreationParams.Remove("ExchangeLocation")
        }

        # Exchange Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.ExchangeLocationException -or `
                $null -ne $ExchangeLocationException)
        {
            $ToBeRemoved = $CurrentPolicy.ExchangeLocationException | `
                Where-Object { $ExchangeLocationException -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveExchangeLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $ExchangeLocationException | `
                Where-Object { $CurrentPolicy.ExchangeLocationException -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddExchangeLocationException", $ToBeAdded)
            }
            $CreationParams.Remove("ExchangeLocationException")
        }

        # Modern Group Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.ModernGroupLocation -or `
                $null -ne $ModernGroupLocation)
        {
            $ToBeRemoved = $CurrentPolicy.ModernGroupLocation | `
                Where-Object { $ModernGroupLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveModernGroupLocation", $ToBeRemoved)
            }

            $ToBeAdded = $ModernGroupLocation | `
                Where-Object { $CurrentPolicy.ModernGroupLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddModernGroupLocation", $ToBeAdded)
            }
            $CreationParams.Remove("ModernGroupLocation")
        }

        # Modern Group Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.ModernGroupLocationException -or `
                $null -ne $ModernGroupLocationException)
        {
            $ToBeRemoved = $CurrentPolicy.ModernGroupLocationException | `
                Where-Object { $ModernGroupLocationException -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveModernGroupLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $ModernGroupLocationException | `
                Where-Object { $CurrentPolicy.ModernGroupLocationException -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddModernGroupLocationException", $ToBeAdded)
            }
            $CreationParams.Remove("ModernGroupLocationException")
        }

        # OneDrive Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.OneDriveLocation -or `
                $null -ne $OneDriveLocation)
        {
            $ToBeRemoved = $CurrentPolicy.OneDriveLocation | `
                Where-Object { $OneDriveLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveOneDriveLocation", $ToBeRemoved)
            }

            $ToBeAdded = $OneDriveLocation | `
                Where-Object { $CurrentPolicy.OneDriveLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddOneDriveLocation", $ToBeAdded)
            }
            $CreationParams.Remove("OneDriveLocation")
        }

        # OneDrive Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.OneDriveLocationException -or `
                $null -ne $OneDriveLocationException)
        {
            $ToBeRemoved = $CurrentPolicy.OneDriveLocationException | `
                Where-Object { $OneDriveLocationException -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveOneDriveLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $OneDriveLocationException | `
                Where-Object { $CurrentPolicy.OneDriveLocationException -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddOneDriveLocationException", $ToBeAdded)
            }
            $CreationParams.Remove("OneDriveLocationException")
        }

        # Public Folder Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.PublicFolderLocation -or `
                $null -ne $PublicFolderLocation)
        {
            $ToBeRemoved = $CurrentPolicy.PublicFolderLocation | `
                Where-Object { $PublicFolderLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemovePublicFolderLocation", $ToBeRemoved)
            }

            $ToBeAdded = $PublicFolderLocation | `
                Where-Object { $CurrentPolicy.PublicFolderLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddPublicFolderLocation", $ToBeAdded)
            }
            $CreationParams.Remove("PublicFolderLocation")
        }

        # SharePoint Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.SharePointLocation -or `
                $null -ne $SharePointLocation)
        {
            $ToBeRemoved = $CurrentPolicy.SharePointLocation | `
                Where-Object { $SharePointLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveSharePointLocation", $ToBeRemoved)
            }

            $ToBeAdded = $SharePointLocation | `
                Where-Object { $CurrentPolicy.SharePointLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddSharePointLocation", $ToBeAdded)
            }
            $CreationParams.Remove("SharePointLocation")
        }

        # SharePoint Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.SharePointLocationException -or `
                $null -ne $SharePointLocationException)
        {
            $ToBeRemoved = $CurrentPolicy.SharePointLocationException | `
                Where-Object { $SharePointLocationException -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveSharePointLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $SharePointLocationException | `
                Where-Object { $CurrentPolicy.SharePointLocationException -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddSharePointLocationException", $ToBeAdded)
            }
            $CreationParams.Remove("SharePointLocationException")
        }

        # Skype Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.SkypeLocation -or `
                $null -ne $SkypeLocation)
        {
            $ToBeRemoved = $CurrentPolicy.SkypeLocation | `
                Where-Object { $SkypeLocation -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveSkypeLocation", $ToBeRemoved)
            }

            $ToBeAdded = $SkypeLocation | `
                Where-Object { $CurrentPolicy.SkypeLocation -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddSkypeLocation", $ToBeAdded)
            }
            $CreationParams.Remove("SkypeLocation")
        }

        # Skype Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CurrentPolicy.SkypeLocationException -or `
                $null -ne $SkypeLocationException)
        {
            $ToBeRemoved = $CurrentPolicy.SkypeLocationException | `
                Where-Object { $SkypeLocationException -NotContains $_ }
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveSkypeLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $SkypeLocationException | `
                Where-Object { $CurrentPolicy.SkypeLocationException -NotContains $_ }
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddSkypeLocationException", $ToBeAdded)
            }
            $CreationParams.Remove("SkypeLocationException")
        }
    }
    else
    {
        Write-Verbose -Message "Policy $Name is a Teams Policy"
        $CreationParams = @{
            Identity                      = $Name
            Comment                       = $Comment
            Enabled                       = $Enabled
            RestrictiveRetention          = $RestrictiveRetention
            TeamsChannelLocation          = $TeamsChannelLocation
            TeamsChannelLocationException = $TeamsChannelLocationException
            TeamsChatLocation             = $TeamsChatLocation
            TeamsChatLocationException    = $TeamsChatLocationException
        }
    }
    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentPolicy.Ensure))
    {
        Write-Verbose -Message "Creating new Retention Compliance Policy $Name"
        New-RetentionCompliancePolicy @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        Write-Verbose "Updating Policy with values: $(Convert-M365DscHashtableToString -Hashtable $CreationParams)"
        Set-RetentionCompliancePolicy @CreationParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # If the Policy exists and it shouldn't, simply remove it;
        Remove-RetentionCompliancePolicy -Identity $Name
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

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $DynamicScopeLocation,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation = @(),

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException = @(),

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation = @(),

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException = @(),

        [Parameter()]
        [System.String[]]
        $OneDriveLocation = @(),

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException = @(),

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation = @(),

        [Parameter()]
        [System.Boolean]
        $RestrictiveRetention = $true,

        [Parameter()]
        [System.String[]]
        $SharePointLocation = @(),

        [Parameter()]
        [System.String[]]
        $SharePointLocationException = @(),

        [Parameter()]
        [System.String[]]
        $SkypeLocation = @(),

        [Parameter()]
        [System.String[]]
        $SkypeLocationException = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocation = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocationException = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChatLocation = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChatLocationException = @(),

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of RetentionCompliancePolicy for $Name"

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
        -Platform SecurityComplianceCenter `
        -ErrorAction SilentlyContinue

    $policies = Get-RetentionCompliancePolicy

    $i = 1
    $content = ''
    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    foreach ($policy in $policies)
    {
        Write-Information "    [$i/$($policies.Length)] $($policy.Name)"
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            Name               = $policy.Name
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SCRetentionCompliancePolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $partialContent = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName "GlobalAdminAccount"
        if ($partialContent.ToLower().Contains($organization.ToLower()) -or `
                        $partialContent.ToLower().Contains($principal.ToLower()))
        {
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$(`$OrganizationName)"
        }
        $content += $partialContent
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
