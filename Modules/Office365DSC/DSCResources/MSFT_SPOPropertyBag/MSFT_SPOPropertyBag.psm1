function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SPOPropertyBag for $Key"
    Invoke-O365DSCCommand -Arguments $PSBoundParameters -InvokationPath $PSScriptRoot -ScriptBlock {
        $params = $args[0]
        try
        {
            Test-MSCloudLogin -CloudCredential $params.GlobalAdminAccount `
                            -ConnectionUrl $params.Url `
                            -Platform PnP
            $property = Get-PnPPropertyBag
        }
        catch
        {
            Write-Verbose "GlobalAdminAccount specified does not have admin access to site {$params.Url}"
        }

        if ($null -eq $property)
        {
            Write-Verbose -Message "SPOPropertyBag $($params.Key) does not exist at {$($params.Url)}."
            $result = $params
            $result.Ensure = 'Absent'
            return $result
        }
        else
        {
            $property = $property | Where-Object -FilterScript { $_.Key -eq $params.Key }
            Write-Verbose "Found existing SPOPropertyBag Key $($params.Key) at {$($params.Url)}"
            $result = @{
                Ensure             = 'Present'
                Url                = $params.Url
                Key                = $property.Key
                Value              = $property.Value
                GlobalAdminAccount = $params.GlobalAdminAccount
            }

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SPOPropertyBag property for $Key at {$Url}"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -ConnectionUrl $Url `
                      -Platform PnP

    $currentProperty = Get-TargetResource @PSBoundParameters

    if ('Present' -eq $Ensure)
    {
        $CreationParams = @{
            Key   = $Key
            Value = $Value
        }
        Set-PnPPropertyBagValue @CreationParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        Remove-PnPPropertyBagValue -Key $Key
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
        $Url,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Key,

        [Parameter()]
        [System.String]
        $Value,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SPOPropertyBag for $Key at {$Url}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
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
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = "Continue"
    $PSBoundParameters.Add("ScriptRoot", $PSScriptRoot)
    $result = Invoke-O365DSCCommand -Arguments $PSBoundParameters -InvokationPath $PSScriptRoot -ScriptBlock {
        $params = $args[0]
        Test-MSCloudLogin -CloudCredential $params.GlobalAdminAccount `
                          -Platform PnP

        $sites = Get-PnPTenantSite
        $i = 1
        $content = ""
        foreach ($site in $sites)
        {
            Write-Information "    [$i/$($sites.Count)] Scanning Properties in PropertyBag for site {$($site.Url)}"

            try
            {
                Test-MSCloudLogin -CloudCredential $params.GlobalAdminAccount `
                                -ConnectionUrl $site.Url `
                                -Platform PnP
                $properties = Get-PnPPropertyBag

                $j = 1
                foreach($property in $properties)
                {
                    Write-Information "        [$j/$($properties.Count)] $($property.Key)"
                    $getValues = @{
                        Url               = $site.Url
                        Key                = $property.Key
                        Value              = '*'
                        GlobalAdminAccount = $params.GlobalAdminAccount
                    }
                    $result = Get-TargetResource @getValues
                    $result.Value = [System.String]$result.Value
                    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                    $content += "        SPOPropertyBag " + (New-GUID).ToString() + "`r`n"
                    $content += "        {`r`n"
                    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $params.ScriptRoot
                    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
                    $content += "        }`r`n"
                    $j++
                }
                $i++
            }
            catch
            {
                Write-Warning -Message "        The specified GlobalAdminAccount doesn't have access to site {$($site.Url)}"
                $i++
            }
        }

        return $content
    }

    return $result
}

Export-ModuleMember -Function *-TargetResource
