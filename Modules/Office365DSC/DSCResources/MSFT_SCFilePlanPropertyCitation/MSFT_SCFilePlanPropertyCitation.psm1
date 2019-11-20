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
        $CitationUrl,

        [Parameter()]
        [System.String]
        $CitationJurisdiction,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SCFilePlanPropertyCitation for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $property = Get-FilePlanPropertyCitation | Where-Object -FilterScript {$_.Name -eq $Name}

    if ($null -eq $property)
    {
        Write-Verbose -Message "SCFilePlanPropertyCitation $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing SCFilePlanPropertyCitation $($Name)"

        $result = @{
            Name                 = $property.Name
            CitationUrl          = $property.CitationUrl
            CitationJurisdiction = $property.CitationJurisdiction
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

        [Parameter()]
        [System.String]
        $CitationUrl,

        [Parameter()]
        [System.String]
        $CitationJurisdiction,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SCFilePlanPropertyCitation for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $Current = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $Current.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount") | Out-Null
        $CreationParams.Remove("Ensure") | Out-Null

        New-FilePlanPropertyCitation @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $Current.Ensure))
    {
        Set-FilePlanPropertyCitation -Name $Name -CitationUrl $CitationUrl -CitationJurisdiction $CitationJurisdiction
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        Remove-FilePlanPropertyCitation -Identity $Name -Confirm:$false
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
        $CitationUrl,

        [Parameter()]
        [System.String]
        $CitationJurisdiction,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SCFilePlanPropertyCitation for $Name"

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
    $Properties = Get-FilePlanPropertyCitation

    $i = 1
    $content = ""
    foreach ($Property in $Properties)
    {
        Write-Information "    - [$i/$($Properties.Length)] $($Property.Name)"
        $params = @{
            Name               = $Property.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SCFilePlanPropertyCitation " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
