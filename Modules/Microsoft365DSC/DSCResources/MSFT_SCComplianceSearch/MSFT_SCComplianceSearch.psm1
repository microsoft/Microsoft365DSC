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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Getting configuration of SCComplianceSearch for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration of SCComplianceSearch for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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
        $CertificatePassword
    )

    $InformationPreference = "Continue"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters
    $searches = Get-ComplianceSearch

    Write-Information "    * Searches not assigned to an eDiscovery Case"
    $i = 1
    $dscContent = ""
    $partialContent = ""
    foreach ($search in $searches)
    {
        Write-Information "        - [$i/$($searches.Name.Count)] $($search.Name)"
        $params = @{
            Name                  = $search.Name
            GlobalAdminAccount    = $GlobalAdminAccount
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
        }
        $Results = Get-TargetResource @Params
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -GlobalAdminAccount $GlobalAdminAccount
        $i++
    }

    $cases = Get-ComplianceCase
    $j = 1

    foreach ($case in $cases)
    {
        $searches = Get-ComplianceSearch -Case $case.Name

        Write-Information "    * [$j/$($cases.Length)] Searches assigned to case $($case.Name)"
        $i = 1
        foreach ($search in $searches)
        {
            $Params = @{
                Name                  = $search.Name
                Case                  = $case.Name
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            Write-Information "        - [$i/$($searches.Name.Count)] $($search.Name)"
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            $i++
        }
        $j++
    }

    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
