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
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeSenderMemberOf,

        [Parameter()]
        [System.String[]]
        $ExchangeSenderMemberOfException,

        [Parameter()]
        [ValidateSet('Enable','TestWithNotifications','TestWithoutNotifications','Disable','PendingDeletion')]
        [System.String]
        $Mode = "Enable",

        [Parameter()]
        [System.String[]]
        $OneDriveLocation,

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException,

        [Parameter()]
        [ValidateRange(0,1)]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationException,

        [Parameter()]
        [System.String[]]
        $TeamsLocation,

        [Parameter()]
        [System.String[]]
        $TeamsLocationException,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of DLPCompliancePolicy for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $PolicyObjects = Get-DlpCompliancePolicy
    $PolicyObject = $PolicyObjects | Where-Object {$_.Name -eq $Name}

    if ($null -eq $PolicyObject)
    {
        Write-Verbose -Message "DLPCompliancePolicy $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing DLPCompliancePolicy $($Name)"
        $result = @{
            Ensure                                = 'Present'
            Name                                  = $PolicyObject.Name
            Comment                               = $PolicyObject.Comment
            ExchangeLocation                      = $PolicyObject.ExchangeLocation
            ExchangeSenderMemberOf                = $PolicyObject.ExchangeSenderMemberOf
            ExchangeSenderMemberOfException       = $PolicyObject.ExchangeSenderMemberOfException
            Mode                                  = $PolicyObject.Mode
            OneDriveLocation                      = $PolicyObject.OneDriveLocation
            OneDriveLocationException             = $PolicyObject.OneDriveLocationException
            Priority                              = $PolicyObject.Priority
            SharePointLocation                    = $PolicyObject.SharePointLocation.Name
            SharePointLocationException           = $PolicyObject.SharePointLocationException
            TeamsLocation                         = $PolicyObject.TeamsLocation
            TeamsLocationException                = $PolicyObject.TeamsLocationException
            GlobalAdminAccount                    = $GlobalAdminAccount
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
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
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeSenderMemberOf,

        [Parameter()]
        [System.String[]]
        $ExchangeSenderMemberOfException,

        [Parameter()]
        [ValidateSet('Enable','TestWithNotifications','TestWithoutNotifications','Disable','PendingDeletion')]
        [System.String]
        $Mode = "Enable",

        [Parameter()]
        [System.String[]]
        $OneDriveLocation,

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException,

        [Parameter()]
        [System.UInt32]
        [ValidateRange(0,1)]
        $Priority,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationException,

        [Parameter()]
        [System.String[]]
        $TeamsLocation,

        [Parameter()]
        [System.String[]]
        $TeamsLocationException,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of DLPCompliancePolicy for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $CurrentPolicy = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentPolicy.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        New-DLPCompliancePolicy @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        $CreationParams.Remove("Name")
        $CreationParams.Add("Identity", $Name)

        # SharePoint Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CreationParams.SharePointLocation -or `
            $null -ne $SharePointLocation)
        {
            $CreationParams.Remove("SharePointLocation")

            $ToBeRemoved = $CreationParams.SharePointLocation | `
                                Where {$SharePointLocation -NotContains $_}
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveSharePointLocation", $ToBeRemoved)
            }

            $ToBeAdded = $SharePointLocation | `
                                Where {$CreationParams.SharePointLocation -NotContains $_}
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddSharePointLocation", $ToBeAdded)
            }
        }

        # Exchange Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CreationParams.ExchangeLocation -or `
            $null -ne $ExchangeLocation)
        {
            $CreationParams.Remove("ExchangeLocation")

            $ToBeRemoved = $CreationParams.ExchangeLocation | `
                                Where {$ExchangeLocation -NotContains $_}
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveExchangeLocation", $ToBeRemoved)
            }

            $ToBeAdded = $ExchangeLocation | `
                                Where {$CreationParams.ExchangeLocation -NotContains $_}
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddExchangeLocation", $ToBeAdded)
            }
        }

        # OneDrive Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CreationParams.OneDriveLocation -or `
            $null -ne $OneDriveLocation)
        {
            $CreationParams.Remove("OneDriveLocation")

            $ToBeRemoved = $CreationParams.OneDriveLocation | `
                                Where {$OneDriveLocation -NotContains $_}
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveOneDriveLocation", $ToBeRemoved)
            }

            $ToBeAdded = $OneDriveLocation | `
                                Where {$CreationParams.OneDriveLocation -NotContains $_}
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddOneDriveLocation", $ToBeAdded)
            }
        }

        # OneDrive Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CreationParams.OneDriveLocationException -or `
            $null -ne $OneDriveLocationException)
        {
            $CreationParams.Remove("OneDriveLocationException")

            $ToBeRemoved = $CreationParams.OneDriveLocationException | `
                                Where {$OneDriveLocationException -NotContains $_}
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveOneDriveLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $OneDriveLocationException | `
                                Where {$CreationParams.OneDriveLocationException -NotContains $_}
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddOneDriveLocationException", $ToBeAdded)
            }
        }

        # SharePoint Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CreationParams.SharePointLocationException -or `
            $null -ne $SharePointLocationException)
        {
            $CreationParams.Remove("SharePointLocationException")

            $ToBeRemoved = $CreationParams.SharePointLocationException | `
                                Where {$SharePointLocationException -NotContains $_}
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveSharePointLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $SharePointLocationException | `
                                Where {$CreationParams.SharePointLocationException -NotContains $_}
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddSharePointLocationException", $ToBeAdded)
            }
        }

        # Teams Location is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CreationParams.TeamsLocation -or `
            $null -ne $TeamsLocation)
        {
            $CreationParams.Remove("TeamsLocation")

            $ToBeRemoved = $CreationParams.TeamsLocation | `
                                Where {$TeamsLocation -NotContains $_}
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveTeamsLocation", $ToBeRemoved)
            }

            $ToBeAdded = $TeamsLocation | `
                                Where {$CreationParams.TeamsLocation -NotContains $_}
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddTeamsLocation", $ToBeAdded)
            }
        }

        # Teams Location Exception is specified or already existing, we need to determine
        # the delta.
        if ($null -ne $CreationParams.TeamsLocationException -or `
            $null -ne $TeamsLocationException)
        {
            $CreationParams.Remove("TeamsLocationException")

            $ToBeRemoved = $CreationParams.TeamsLocationException | `
                                Where {$TeamsLocationException -NotContains $_}
            if ($null -ne $ToBeRemoved)
            {
                $CreationParams.Add("RemoveTeamsLocationException", $ToBeRemoved)
            }

            $ToBeAdded = $TeamsLocationException | `
                                Where {$CreationParams.TeamsLocationException -NotContains $_}
            if ($null -ne $ToBeAdded)
            {
                $CreationParams.Add("AddTeamsLocationException", $ToBeAdded)
            }
        }

        Set-DLPCompliancePolicy @CreationParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # If the Policy exists and it shouldn't, simply remove it;
        Remove-DLPCompliancePolicy -Identity $Name
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
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeSenderMemberOf,

        [Parameter()]
        [System.String[]]
        $ExchangeSenderMemberOfException,

        [Parameter()]
        [ValidateSet('Enable','TestWithNotifications','TestWithoutNotifications','Disable','PendingDeletion')]
        [System.String]
        $Mode = "Enable",

        [Parameter()]
        [System.String[]]
        $OneDriveLocation,

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException,

        [Parameter()]
        [ValidateRange(0,1)]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationException,

        [Parameter()]
        [System.String[]]
        $TeamsLocation,

        [Parameter()]
        [System.String[]]
        $TeamsLocationException,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of DLPCompliancePolicy for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SCDLPCompliancePolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
