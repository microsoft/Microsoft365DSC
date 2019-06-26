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
        $Comment,

        [Parameter()]
        [System.String]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "EventAgeInDays", "ModificationAgeInDays", "TaggedAgeInDays")]
        [System.String]
        $RetentionType,


        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of RetentionComplianceTag for $Name"

    Write-Verbose -Message "Calling Test-SecurityAndComplianceConnection function:"
    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount

    $tagObjects = Get-ComplianceTag
    $tagObjects = $tagObjects | Where-Object { $_.Name -eq $Name }

    if ($null -eq $tagObjects)
    {
        Write-Verbose -Message "RetentionComplianceTag $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing RetentionComplianceTag $($Name)"
        $result = @{
            Ensure = 'Present'
        }
        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object -FilterScript { $_ -ne 'Ensure' }))
        {
            if ($null -ne $tagObjects.$KeyName)
            {
                $result += @{
                    $KeyName = $tagObjects.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }
        }

        Write-Verbose -Message "Found RetentionComplianceTag $($Name)"
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
        $Comment,

        [Parameter()]
        [System.String]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "EventAgeInDays", "ModificationAgeInDays", "TaggedAgeInDays")]
        [System.String]
        $RetentionType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of RetentionComplianceTag for $Name"

    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount
    $CurrentTag = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentTag.Ensure))
    {
        $CreationParams = $PSBoundParameters
        #Convert File plan to JSON before Set
        if ($FilePlanProperty)
        {
            Write-Verbose -Message "Converting fileplan to JSON"
            $FilePlanPropertyJSON = ConvertTo-Json $FilePlanProperty
            $CreationParams["FilePlanProperty"] = $FilePlanPropertyJSON
        }
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        New-ComplianceTag @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        $SetParams = $PSBoundParameters
        #Remove unsed parameters for Set-ComplianceTag cmdlet
        $SetParams.Remove("GlobalAdminAccount")
        $SetParams.Remove("Ensure")
        $SetParams.Remove("Name")
        $SetParams.Remove("IsRecordLabel")
        $SetParams.Remove("Regulatory")
        $SetParams.Remove("RetentionAction")
        $SetParams.Remove("RetentionType")
        #Convert File plan to JSON before Set
        if ($FilePlanProperty)
        {
            Write-Verbose -Message "Converting fileplan to JSON"
            $FilePlanPropertyJSON = ConvertTo-Json $FilePlanProperty
            $SetParams["FilePlanProperty"] = $FilePlanPropertyJSON
        }
        Set-ComplianceTag @SetParams -Identity $Name
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        # If the Rule exists and it shouldn't, simply remove it;
        Remove-ComplianceTag -Identity $Name -ForceDeletion
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
        $Comment,

        [Parameter()]
        [System.String]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet("Delete", "Keep", "KeepAndDelete")]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet("CreationAgeInDays", "EventAgeInDays", "ModificationAgeInDays", "TaggedAgeInDays")]
        [System.String]
        $RetentionType,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of RetentionComplianceTag for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
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
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SCRetentionComplianceTag " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
