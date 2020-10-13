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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
    }
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        $PolicyObject = Get-RetentionCompliancePolicy $Name -ErrorAction SilentlyContinue

        if ($null -eq $PolicyObject)
        {
            Write-Verbose -Message "RetentionCompliancePolicy $($Name) does not exist."
            return $nullReturn
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
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

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
        $CreationParams.Add("Name", $Identity)
        $CreationParams.Remove("Identity") | Out-Null
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        $policies = Get-RetentionCompliancePolicy -ErrorAction Stop

        $i = 1
        Write-Host "`r`n" -NoNewLine
        $dscContent = ''
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Length)] $($policy.Name)" -NoNewLine
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                Name                  = $policy.Name
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
