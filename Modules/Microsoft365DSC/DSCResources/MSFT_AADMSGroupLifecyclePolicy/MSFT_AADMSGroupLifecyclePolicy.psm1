function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $GroupLifetimeInDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('All', 'Selected', 'None')]
        $ManagedGroupTypes,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $AlternateNotificationEmails,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of AzureAD Groups Lifecycle Policy"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    try
    {
        $Policy = Get-AzureADMSGroupLifecyclePolicy -ErrorAction SilentlyContinue
    }
    catch
    {
        Write-Verbose -Message $_
    }

    if ($null -eq $Policy)
    {
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        Write-Verbose "Found existing AzureAD Groups Lifecycle Policy"
        $result = @{
            IsSingleInstance            = 'Yes'
            GroupLifetimeInDays         = $Policy.GroupLifetimeInDays
            ManagedGroupTypes           = $Policy.ManagedGroupTypes
            AlternateNotificationEmails = $Policy.AlternateNotificationEmails.Split(';')
            Ensure                      = "Present"
            GlobalAdminAccount          = $GlobalAdminAccount
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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $GroupLifetimeInDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('All', 'Selected', 'None')]
        $ManagedGroupTypes,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $AlternateNotificationEmails,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Azure AD Groups Lifecycle Policy"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    try
    {
        $policy = Get-AzureADMSGroupLifecyclePolicy -ErrorAction SilentlyContinue
    }
    catch
    {
        Write-Verbose $_
        return
    }

    $currentPolicy = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq "Present" -and $currentPolicy.Ensure -eq "Absent")
    {
        Write-Verbose -Message "The Group Lifecycle Policy should exist but it doesn't. Creating it."
        $creationParams = $PSBoundParameters
        $creationParams.Remove("IsSingleInstance")
        $creationParams.Remove("GlobalAdminAccount")
        $creationParams.Remove("Ensure")

        $emails = ""
        foreach ($email in $creationParams.AlternateNotificationEmails)
        {
            $emails += $email + ";"
        }
        $emails = $emails.TrimEnd(';')
        $creationParams.AlternateNotificationEmails = $emails
        New-AzureADMSGroupLifecyclePolicy @creationParams
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        $updateParams = $PSBoundParameters
        $updateParams.Remove("IsSingleInstance")
        $updateParams.Remove("GlobalAdminAccount")
        $updateParams.Remove("Ensure")

        $emails = ""
        foreach ($email in $updateParams.AlternateNotificationEmails)
        {
            $emails += $email + ";"
        }
        $emails = $emails.TrimEnd(';')
        $updateParams.AlternateNotificationEmails = $emails
        $updateParams.Add("Id", (Get-AzureADMSGroupLifecyclePolicy).Id)

        Write-Verbose -Message "The Group Lifecycle Policy exists but it's not in the Desired State. Updating it."
        Set-AzureADMSGroupLifecyclePolicy @updateParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "The Group Lifecycle Policy should NOT exist but it DOES. Removing it."
        Remove-AzureADMSGroupLifecyclePolicy -Id (Get-AzureADMSGroupLifecyclePolicy).Id
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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $GroupLifetimeInDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('All', 'Selected', 'None')]
        $ManagedGroupTypes,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $AlternateNotificationEmails,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of AzureAD Groups Lifecycle Policy"

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
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Policy = Get-AzureADMSGroupLifecyclePolicy -ErrorAction SilentlyContinue
    }
    catch
    {
        return ""
    }
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
    $params = @{
        GlobalAdminAccount   = $GlobalAdminAccount
        IsSingleInstance     = 'Yes'
        GroupLifetimeInDays = 1
        ManagedGroupTypes = 'All'
        AlternateNotificationEmails = 'empty@contoso.com'
    }
    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content += "        AADMSGroupLifecyclePolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $partialContent = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName "GlobalAdminAccount"

    if ($partialContent.ToLower().Contains("@" + $principal.ToLower()))
    {
        $partialContent = $partialContent -ireplace [regex]::Escape("@" + $principal), "@`$OrganizationName.Split('.')[0])"
    }
    $content += $partialContent
    $content += "        }`r`n"

    return $content
}

Export-ModuleMember -Function *-TargetResource
