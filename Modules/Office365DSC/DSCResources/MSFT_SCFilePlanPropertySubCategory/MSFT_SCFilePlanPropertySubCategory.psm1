function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Category,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SCFilePlanPropertySubCategory for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $parent = Get-FilePlanPropertyCategory | Where-Object -FilterScript {$_.DisplayName -eq $Category}
    $empty = $PSBoundParameters
    $empty.Ensure = 'Absent'
    if ($null -eq $parent)
    {
        Write-Warning "Invalid Parent Category {$Category} detected in the Get-TargetResource"
        return $empty
    }
    $parentId = $parent.Id.Replace("CN=","")

    $property = Get-FilePlanPropertySubCategory | Where-Object -FilterScript {$_.DisplayName -eq $Name -and `
                                                 $_.ParentId -eq $parentId}

    if ($null -eq $property)
    {
        Write-Verbose -Message "SCFilePlanPropertySubCategory $($Name) does not exist."
        return $empty
    }
    else
    {
        Write-Verbose "Found existing SCFilePlanPropertySubCategory $($Name)"

        $result = @{
            Name                 = $property.DisplayName
            Category             = $parent.DisplayName
            GlobalAdminAccount   = $GlobalAdminAccount
            Ensure               = 'Present'
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Category,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SCFilePlanPropertySubCategory for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $Current = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $Current.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Add("ParentId", $Category)
        $CreationParams.Remove("Category") | Out-Null
        $CreationParams.Remove("GlobalAdminAccount") | Out-Null
        $CreationParams.Remove("Ensure") | Out-Null

        New-FilePlanPropertySubCategory @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $Current.Ensure))
    {
        # Do Nothing
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $Current.Ensure))
    {
        Remove-FilePlanPropertySubCategory -Identity $Name -Confirm:$false
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Category,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SCFilePlanPropertySubCategory for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
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
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter
    $Properties = Get-FilePlanPropertySubCategory

    $i = 1
    $content = ""
    foreach ($Property in $Properties)
    {
        $parent = Get-FilePlanPropertyCategory | Where-Object -FilterScript{$_.Id -like "*$($property.ParentId)*"}
        Write-Information "    - [$i/$($Properties.Length)] $($Property.Name)"
        $params = @{
            Name               = $Property.DisplayName
            Category           = $parent.DisplayName
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SCFilePlanPropertySubCategory " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
