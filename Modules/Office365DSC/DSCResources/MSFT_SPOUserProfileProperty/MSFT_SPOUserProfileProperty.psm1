function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting SPO Profile Properties for user {$UserName}"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform PnP

    $nullReturn = @{
        UserName           = $UserName
        Properties         = $Properties
        GlobalAdminAccount = $GlobalAdminAccount
        Ensure             = 'Absent'
    }

    try
    {
        $currentProperties = Get-PnPUserProfileProperty -Account $UserName
        $currentProperties = $currentProperties.UserProfileProperties

        $propertiesValue = @()

        foreach ($key in $currentProperties.Keys)
        {
            $convertedProperty = Get-SPOUserProfilePropertyInstance -Key $key -Value $currentProperties[$key]
            $propertiesValue += $convertedProperty
        }
        $result =  @{
            UserName           = $UserName
            Properties         = $propertiesValue
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = "Present"
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
        return $result
    }
    catch
    {
        return $nullReturn
    }

}
function Set-TargetResource
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Profile Properties for user {$UserName}"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform PnP

    $currentProperties = Get-TargetResource @PSBoundParameters

    foreach ($property in $Properties)
    {
        if ($currentProperties.Properties[$property.Key] -ne $property.Value)
        {
            Write-Verbose "Setting Profile Property {$($property.Key)} as {$($property.Value)}"
            try
            {
                Set-PnPUserProfileProperty -Account $UserName -PropertyName $property.Key -Value $property.Value -ErrorAction Stop
            }
            catch
            {
                Write-Warning "Cannot update property {$($property.Key)}. This value of that key cannot be modified."
            }
        }
    }
}
function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet("Present")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for SPO Sharing settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-SPOUserProfilePropertyInstance -DesiredProperties $Properties `
                                                      -CurrentProperties $CurrentValues.Properties

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
    Test-MSCloudLogin -Platform MSOnline -O365Credential $GlobalAdminAccount

    $users = Get-MsolUser
    $content = ""

    $i = 1
    foreach ($user in $users)
    {
        Write-Information "    [$i/$($users.Count)] Scanning Profile Properties for user {$($user.UserPrincipalName)}"

        $params = @{
            UserName           = $user.UserPrincipalName
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.Properties = ConvertTo-SPOUserProfilePropertyInstanceString -Properties $result.Properties
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SPOUserProfileProperty " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Properties" -IsCIMArray $true
        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += $currentDSCBlock
        $content += "        }`r`n"

        $i++
    }

    return $content
}

function Test-SPOUserProfilePropertyInstance
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $DesiredProperties,

        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $CurrentProperties
    )

    foreach ($property in $DesiredProperties)
    {
        $currentProperty = $CurrentProperties | Where-Object {$_.Key -eq $property.Key}

        if ($null -eq $currentProperty -or $currentProperty.Value -ne $property.Value)
        {
            return $false
        }
        return $true
    }
}

function Get-SPOUserProfilePropertyInstance
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value
    )

    $result = [PSCustomObject]@{
        Key   = $Key
        Value = $Value
    }

    return $result
}

function ConvertTo-SPOUserProfilePropertyInstanceString
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Properties
    )

    $results = @()
    foreach ($property in $Properties)
    {
        $content = "MSFT_SPOUserProfilePropertyInstance`r`n            {`r`n"
        $content += "                Key   = '$($property.Key)'`r`n"
        $content += "                Value = '$($property.Value)'`r`n"
        $content += "            }`r`n"
        $results += $content
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
