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
        $ConditionalCompany,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute1,
        
        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String]
        $ConditionalDepartment,

        [Parameter()]
        [Sys,tem.String]
        $ConditionalStateOrProvince,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $RecipientFilter,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of AddressList for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $AddressLists = Get-AddressList

    $AddressList = $AddressLists | Where-Object -FilterScript { $_.Name -eq $Name }
    if (-not $AddressList)
    {
        Write-Verbose -Message "AddressList $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Name                                 = $Name
            ConditionalCompany                   = $AddressList.ConditionalCompany
            ConditionalCustomeAttribute1         = $AddressList.ConditionalCustomAttribute1
            ConditionalCustomeAttribute10        = $AddressList.ConditionalCustomAttribute10
            ConditionalCustomeAttribute11        = $AddressList.ConditionalCustomAttribute11
            ConditionalCustomeAttribute12        = $AddressList.ConditionalCustomAttribute12
            ConditionalCustomeAttribute13        = $AddressList.ConditionalCustomAttribute13
            ConditionalCustomeAttribute14        = $AddressList.ConditionalCustomAttribute14
            ConditionalCustomeAttribute15        = $AddressList.ConditionalCustomAttribute15
            ConditionalCustomeAttribute2         = $AddressList.ConditionalCustomAttribute2
            ConditionalCustomeAttribute3         = $AddressList.ConditionalCustomAttribute3
            ConditionalCustomeAttribute4         = $AddressList.ConditionalCustomAttribute4
            ConditionalCustomeAttribute5         = $AddressList.ConditionalCustomAttribute5
            ConditionalCustomeAttribute6         = $AddressList.ConditionalCustomAttribute6
            ConditionalCustomeAttribute7         = $AddressList.ConditionalCustomAttribute7
            ConditionalCustomeAttribute8         = $AddressList.ConditionalCustomAttribute8
            ConditionalCustomeAttribute9         = $AddressList.ConditionalCustomAttribute9
            ConditionalDepartment                = $AddressList.ConditionalDepartment
            ConditionalStateOrProvince           = $AddressList.ConditionalStateOrProvince
            DisplayName                          = $AddressList.DisplayName
            IncludedRecipients                   = $AddressList.IncludedRecipients
            RecipientFilter                      = $AddressList.RecipientFilter
            Ensure                               = 'Present'
            GlobalAdminAccount                   = $GlobalAdminAccount
        }

        if (-not [System.String]::IsNullOrEmpty($AddressList.RuleScope))
        {
            $result.Add("RuleScope", $AddressList.RuleScope)
        }

        Write-Verbose -Message "Found AddressList $($Identity)"
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
        $ConditionalCompany,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute1,
        
        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String]
        $ConditionalDepartment,

        [Parameter()]
        [Sys,tem.String]
        $ConditionalStateOrProvince,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $RecipientFilter,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting AddressList configuration for $Identity"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline


    $AddressLists = Get-AddressList

    $AddressList = $AddressLists | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $AddressListParams = $PSBoundParameters
    $AddressListParams.Remove('Ensure') | Out-Null
    $AddressListParams.Remove('GlobalAdminAccount') | Out-Null
   
    if (('Present' -eq $Ensure ) -and ($null -eq $AddressList))
    {
        Write-Verbose -Message "Creating ClientAccessRule $($Identity)."
        $AddressListParams.Add("Name", $Identity)
        $AddressListParams.Remove('Identity') | Out-Null
        New-ClientAccessRule @ClientAccessRuleParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $AddressList))
    {
        Write-Verbose -Message "Setting ClientAccessRule $($Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $AddressListParams)"
        Set-ClientAccessRule @ClientAccessRuleParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $AddressList))
    {
        Write-Verbose -Message "Removing ClientAccessRule $($Identity)"
        Remove-ClientAccessRule -Identity $Identity -Confirm:$false
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
        $ConditionalCompany,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute1,
        
        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute10,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute11,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute12,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute13,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute14,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute15,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute2,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute3,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute4,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute5,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute6,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute7,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute8,

        [Parameter()]
        [System.String]
        $ConditionalCustomAttribute9,

        [Parameter()]
        [System.String]
        $ConditionalDepartment,

        [Parameter()]
        [Sys,tem.String]
        $ConditionalStateOrProvince,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('AllRecipients', 'MailboxUsers', 'MailContacts', 'MailGroups', 'MailUsers', 'Resources')]
        [System.String]
        $IncludedRecipients,

        [Parameter()]
        [System.String]
        $RecipientFilter,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of AddressLists for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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

    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOClientAccessRule " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource