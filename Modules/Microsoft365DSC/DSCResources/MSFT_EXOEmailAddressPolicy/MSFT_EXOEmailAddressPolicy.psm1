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
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting Email Address Policy configuration for $Name"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AllEmailAddressPolicies = Get-EmailAddressPolicy

    $EmailAddressPolicy = $AllEmailAddressPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

    if ($null -eq $EmailAddressPolicy)
    {
        Write-Verbose -Message "Email Address Policy $($Name) does not exist."

        $nullReturn = @{
            Name                              = $Name
            Priority                          = $Priority
            EnabledEmailAddressTemplates      = $EnabledEmailAddressTemplates
            EnabledPrimarySMTPAddressTemplate = $EnabledPrimarySMTPAddressTemplate
            ManagedByFilter                   = $ManagedByFilter
            Ensure                            = 'Absent'
            GlobalAdminAccount                = $GlobalAdminAccount
        }

        return $nullReturn
    }
    else
    {
        $result = @{
            Name                              = $EmailAddressPolicy.Name
            Priority                          = $EmailAddressPolicy.Priority
            EnabledEmailAddressTemplates      = $EmailAddressPolicy.EnabledEmailAddressTemplates
            EnabledPrimarySMTPAddressTemplate = $EmailAddressPolicy.EnabledPrimarySMTPAddressTemplate
            ManagedByFilter                   = $EmailAddressPolicy.ManagedByFilter
            Ensure                            = 'Present'
            GlobalAdminAccount                = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Email Address Policy $($Name)"
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
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Email Address Policy configuration for $Name"

    $currentEmailAddressPolicyConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $NewEmailAddressPolicyParams = @{
        Name                              = $Name
        Priority                          = $Priority
        EnabledEmailAddressTemplates      = $EnabledEmailAddressTemplates
        EnabledPrimarySMTPAddressTemplate = $EnabledPrimarySMTPAddressTemplate
        ManagedByFilter                   = $ManagedByFilter
        IncludeUnifiedGroupRecipients     = $true
        Confirm                           = $false
    }

    $SetEmailAddressPolicyParams = @{
        Identity                          = $Name
        Priority                          = $Priority
        EnabledEmailAddressTemplates      = $EnabledEmailAddressTemplates
        EnabledPrimarySMTPAddressTemplate = $EnabledPrimarySMTPAddressTemplate
        Confirm                           = $false
    }

    # EnabledEmailAddressTemplates and EnabledPrimarySMTPAddressTemplate cannot used at the same time.
    # If both parameters are specified, EnabledPrimarySMTPAddressTemplate will be removed and only
    # EnabledEmailAddressTemplates will be used.
    if ($null -ne $EnabledEmailAddressTemplates)
    {
        $NewEmailAddressPolicyParams.Remove("EnabledPrimarySMTPAddressTemplate")
        $SetEmailAddressPolicyParams.Remove("EnabledPrimarySMTPAddressTemplate")
    }

    # CASE: Email Address Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentEmailAddressPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Email Address Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create Email Address Policy
        New-EmailAddressPolicy @NewEmailAddressPolicyParams

    }
    # CASE: Email Address Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentEmailAddressPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Email Address Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-EmailAddressPolicy -Identity $Name -Confirm:$false
    }
    # CASE: Email Address Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentEmailAddressPolicyConfig.Ensure -eq "Present")
    {
        if ($Identity -ne 'Default Policy')
        {
            Write-Verbose -Message "Email Address Policy '$($Name)' already exists, but needs updating."
            Write-Verbose -Message "Setting Email Address Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetEmailAddressPolicyParams)"
            Set-EmailAddressPolicy @SetEmailAddressPolicyParams
        }
        else
        {
            Write-Verbose -Message "Cannot update the Default Email Address Policy."
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
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Email Address Policy configuration for $Name"

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

    $organization = ""
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]
    }

    [array]$AllEmailAddressPolicies = Get-EmailAddressPolicy

    $dscContent = ""
    $i = 1
    foreach ($EmailAddressPolicy in $AllEmailAddressPolicies)
    {
        Write-Information "    [$i/$($AllEmailAddressPolicies.Count)] $($EmailAddressPolicy.Name)"

        $Params = @{
            Name               = $EmailAddressPolicy.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content = "        EXOEmailAddressPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
        {
            $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$OrganizationName"
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
        }
        $content += $partialContent
        $content += "        }`r`n"
        $dscContent += $content
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource

