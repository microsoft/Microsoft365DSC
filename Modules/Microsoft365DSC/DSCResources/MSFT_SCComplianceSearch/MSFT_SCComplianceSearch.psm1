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
        $Case,

        [Parameter()]
        [System.Boolean]
        $AllowNotFoundExchangeLocationsEnabled,

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationExclusion,

        [Parameter()]
        [System.String[]]
        $HoldNames,

        [Parameter()]
        [System.Boolean]
        $IncludeUserAppContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationExclusion,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SCComplianceSearch for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    if ($null -eq $Case)
    {
        $Search = Get-ComplianceSearch -Identity $Name -ErrorAction SilentlyContinue
    }
    else
    {
        $Search = Get-ComplianceSearch -Identity $Name -Case $Case -ErrorAction SilentlyContinue
    }

    if ($null -eq $Search)
    {
        Write-Verbose -Message "SCComplianceSearch $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing SCComplianceSearch $($Name)"
        $result = @{
            Name                                  = $Name
            Case                                  = $Case
            AllowNotFoundExchangeLocationsEnabled = $Search.AllowNotFoundExchangeLocationsEnabled
            ContentMatchQuery                     = $Search.ContentMatchQuery
            Description                           = $Search.Description
            ExchangeLocation                      = $Search.ExchangeLocation
            ExchangeLocationExclusion             = $Search.ExchangeLocationExclusion
            HoldNames                             = $Search.HoldNames
            IncludeUserAppContent                 = $Search.IncludeUserAppContent
            Language                              = $Search.Language.TwoLetterISOLanguageName
            PublicFolderLocation                  = $Search.PublicFolderLocation
            SharePointLocation                    = $Search.SharePointLocation
            SharePointLocationExclusion           = $Search.SharePointLocationExclusion
            GlobalAdminAccount                    = $GlobalAdminAccount
            Ensure                                = 'Present'
        }

        $nullParams = @()
        foreach ($parameter in $result.Keys)
        {
            if ($null -eq $result.$parameter)
            {
                $nullParams += $parameter
            }
        }

        foreach ($paramToRemove in $nullParams)
        {
            $result.Remove($paramToRemove)
        }

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
        $Case,

        [Parameter()]
        [System.Boolean]
        $AllowNotFoundExchangeLocationsEnabled,

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationExclusion,

        [Parameter()]
        [System.String[]]
        $HoldNames,

        [Parameter()]
        [System.Boolean]
        $IncludeUserAppContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationExclusion,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SCComplianceSearch for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter

    $CurrentSearch = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentSearch.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")

        Write-Verbose "Creating new Compliance Search $Name calling the New-ComplianceSearch cmdlet."
        New-ComplianceSearch @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentSearch.Ensure))
    {
        $SetParams = $PSBoundParameters

        #Remove unused parameters for Set-ComplianceTag cmdlet
        $SetParams.Remove("GlobalAdminAccount")
        $SetParams.Remove("Ensure")
        $SetParams.Remove("Name")
        $SetParams.Remove("Case")

        Set-ComplianceSearch @SetParams -Identity $Name
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentSearch.Ensure))
    {
        # If the Search exists and it shouldn't, simply remove it;
        Remove-ComplianceSearch -Identity $Name -Confirm:$false
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
        $Case,

        [Parameter()]
        [System.Boolean]
        $AllowNotFoundExchangeLocationsEnabled,

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationExclusion,

        [Parameter()]
        [System.String[]]
        $HoldNames,

        [Parameter()]
        [System.Boolean]
        $IncludeUserAppContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationExclusion,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SCComplianceSearch for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
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

    $InformationPreference = "Continue"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform SecurityComplianceCenter
    $searches = Get-ComplianceSearch

    Write-Information "    * Searches not assigned to an eDiscovery Case"
    $i = 1
    $DSCContent = ""
    $partialContent = ""
    foreach ($search in $searches)
    {
        Write-Information "        - [$i/$($searches.Name.Count)] $($search.Name)"
        $params = @{
            Name               = $search.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $DSCContent = "        SCComplianceSearch " + (New-GUID).ToString() + "`r`n"
        $DSCContent += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $partialContent += "        }`r`n"
        $DSCContent += $partialContent
        $i++
    }

    $cases = Get-ComplianceCase
    $j = 1

    foreach ($case in $cases)
    {
        $searches = Get-ComplianceSearch -Case $case.Name

        Write-Information "    * [$j/$($cases.Length)] Searches assigned to case $($case.Name)"
        $i = 1
        $partialContent = ""
        foreach ($search in $searches)
        {
            $params = @{
                Name               = $search.Name
                Case               = $case.Name
                GlobalAdminAccount = $GlobalAdminAccount
            }
            Write-Information "        - [$i/$($searches.Name.Count)] $($search.Name)"
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $DSCContent += "        SCComplianceSearch " + (New-GUID).ToString() + "`r`n"
            $DSCContent += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $partialContent += "        }`r`n"
            $DSCContent += $partialContent
            $i++
        }
        $j++
    }

    return $DSCContent
}

Export-ModuleMember -Function *-TargetResource
