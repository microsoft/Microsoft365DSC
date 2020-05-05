function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting information for SPO Term Group $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform PnP

    $nullReturn = @{
        Identity           = $Identity
        Description        = $null
        Ensure             = 'Absent'
        GlobalAdminAccount = $GlobalAdminAccount
    }

    Write-Verbose -Message "Getting term group $Identity"
    $termGroup = Get-PnPTermGroup -Identity $Identity -ErrorAction SilentlyContinue
    if ($null -eq $termGroup)
    {
        Write-Verbose -Message "The specified term group doesn't exist."
        return $nullReturn
    }

    return @{
        Identity           = $termGroup.Name
        Description        = $termGroup.Description
        Ensure             = 'Present'
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for SPO Term Group $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Resource', $MyInvocation.MyCommand.ModuleName)
    $data.Add('Method', $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
                      -Platform PnP

    $currentTermGroup = Get-TargetResource @PSBoundParameters
    if ($Ensure -eq 'Present')
    {
        $AddParameters = @{
            Identity    = $Identity
            Description = $Description
        }
        try
        {
            $existingTermGroup = Get-PnPTermGroup -Identity $Identity -ErrorAction SilentlyContinue
        }
        catch
        {
            Write-Verbose -Message "The Term Group $($Identity) does not yet exist."
        }

        if ($null -eq $existingTermGroup)
        {
            Write-Verbose -Message "The Term Group {$Identity} doesn't already exist. Creating it."
            New-PnPTermGroup @AddParameters
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentTermGroup.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Term Group $($Identity)"
        try
        {
            Remove-PnPTermGroup -GroupName $Identity -Force
        }
        catch
        {
            $Message = "The the Term Group $($Identity) does not exist and for that cannot be removed."
            New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
            Write-Error $Message
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
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for the term group $Identity"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove("GlobalAdminAccount") | Out-Null

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
                      -Platform PnP

    $termGroups = Get-PnPTermGroup
    $content = ""
    $i = 1
    foreach ($termGroup in $termGroups)
    {
        $params = @{
            Identity           = $termGroup.Name
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SPOTermGroup " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += $currentDSCBlock
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
