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
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Partner Application configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllPartnerApplications = Get-PartnerApplication

    $PartnerApplication = $AllPartnerApplications | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $PartnerApplication)
    {
        Write-Verbose -Message "Partner Application $($Name) does not exist."

        $nullReturn = @{
            Name                                = $Name
            ApplicationIdentifier               = $ApplicationIdentifier
            AcceptSecurityIdentifierInformation = $AcceptSecurityIdentifierInformation
            AccountType                         = $AccountType
            Enabled                             = $Enabled
            LinkedAccount                       = $LinkedAccount
            Ensure                              = 'Absent'
            GlobalAdminAccount                  = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name                                = $PartnerApplication.Name
            ApplicationIdentifier               = $PartnerApplication.ApplicationIdentifier
            AcceptSecurityIdentifierInformation = $PartnerApplication.AcceptSecurityIdentifierInformation
            AccountType                         = $PartnerApplication.AccountType
            Enabled                             = $PartnerApplication.Enabled
            LinkedAccount                       = $PartnerApplication.LinkedAccount
            Ensure                              = 'Present'
            GlobalAdminAccount                  = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Partner Application $($Name)"
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
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Partner Application configuration for $Name"

    $currentPartnerApplicationConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewPartnerApplicationParams = @{
        Name                                = $Name
        ApplicationIdentifier               = $ApplicationIdentifier
        AcceptSecurityIdentifierInformation = $AcceptSecurityIdentifierInformation
        AccountType                         = $AccountType
        Enabled                             = $Enabled
        LinkedAccount                       = $LinkedAccount
        Confirm                             = $false
    }

    $SetPartnerApplicationParams = @{
        Identity                            = $Name
        Name                                = $Name
        ApplicationIdentifier               = $ApplicationIdentifier
        AcceptSecurityIdentifierInformation = $AcceptSecurityIdentifierInformation
        AccountType                         = $AccountType
        Enabled                             = $Enabled
        LinkedAccount                       = $LinkedAccount
        Confirm                             = $false
    }

    # CASE: Partner Application doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentPartnerApplicationConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Partner Application '$($Name)' does not exist but it should. Create and configure it."
        # Create Partner Application
        New-PartnerApplication @NewPartnerApplicationParams

    }
    # CASE: Partner Application exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentPartnerApplicationConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Partner Application '$($Name)' exists but it shouldn't. Remove it."
        Remove-PartnerApplication -Identity $Name -Confirm:$false
    }
    # CASE: Partner Application exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentPartnerApplicationConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Partner Application '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Partner Application $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetPartnerApplicationParams)"
        Set-PartnerApplication @SetPartnerApplicationParams
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
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Partner Application configuration for $Name"

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

    [array]$AllPartnerApplications = Get-PartnerApplication

    $dscContent = ""
    $i = 1
    foreach ($PartnerApplication in $AllPartnerApplications)
    {
        Write-Information "    [$i/$($AllPartnerApplications.Count)] $($PartnerApplication.Name)"

        $Params = @{
            Name               = $PartnerApplication.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOPartnerApplication " + (New-GUID).ToString() + "`r`n"
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

