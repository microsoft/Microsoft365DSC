function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayname,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $PolicyType,

        [Parameter()]
        [System.String]
        $PolicyName,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        Write-Verbose -Message "get GroupPolicyAssignment for $GroupDisplayname"
        $Group = Find-CsGroup -SearchQuery $GroupDisplayname
        if($group.Length -gt 1)
        {
            Write-Verbose -Message "Found $($group.Length) groups with the name $GroupDisplayname"
            $Group = $Group | Where-Object { $_.DisplayName -eq $GroupDisplayname }
        }
        if($null -eq $Group)
        {
            Write-Verbose -Message "Group not found for $GroupDisplayname"
            return $nullReturn
        }
        $GroupPolicyAssignemnt = Get-csGroupPolicyAssignment -GroupId $Group.Id -PolicyType $PolicyType -ErrorAction SilentlyContinue
        if($null -eq $GroupPolicyAssignemnt)
        {
            Write-Verbose -Message "GroupPolicyAssignment not found for $GroupDisplayname"
            return $nullReturn
        }
        Write-Verbose -Message "Found GroupPolicyAssignment $($Group.Displayname) with PolicyType:$($GroupPolicyAssignemnt.PolicyType) and Policy Name:$($GroupPolicyAssignemnt.PolicyName)"
        return @{
            GroupId               = $Group.Id
            GroupDisplayname      = $Group.Displayname
            PolicyType            = $GroupPolicyAssignemnt.PolicyType
            PolicyName            = $GroupPolicyAssignemnt.PolicyName
            Priority              = $GroupPolicyAssignemnt.Priority
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayname,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $PolicyType,

        [Parameter()]
        [System.String]
        $PolicyName,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters
    $CurrentValues = Get-TargetResource @PSBoundParameters

    #check policyname
    $command = "get-cs" + $PolicyType
    $Policys = Invoke-Expression -Command $command -ErrorAction SilentlyContinue
    $policymatch = $false
    if($null -ne $Policys){
        Foreach($policy in $Policys.Identity){
            $match = "^Tag:" + $PolicyName + "$"
            if($policy -match $match){
                $policymatch = $true
            }
        }
    }
    if($null -eq $Policys -or $policymatch -eq $false){
        Write-Verbose -Message "No PolicyType found for $PolicyType"
        return
    }

    #get groupid
    if($GroupId.Length -eq 0)
    {
        $Group = Find-CsGroup -SearchQuery $GroupDisplayname
        if($group.Length -gt 1)
        {
            Write-Verbose -Message "Found $($group.Length) groups with the name $GroupDisplayname"
            $Group = $Group | Where-Object { $_.DisplayName -eq $GroupDisplayname }
        }
        if($null -eq $Group)
        {
            Write-Verbose -Message "Group not found for $GroupDisplayname"
            return
        }
        $GroupId = $Group.Id
    }
    Write-Verbose -Message "Retrieve GroupId for: $($GroupDisplayname)"
    try{
        if($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
        {
            Write-Verbose -Message "Adding GroupPolicyAssignment for $GroupDisplayname"
            new-csGroupPolicyAssignment -GroupId $GroupId -PolicyType $PolicyType -PolicyName $PolicyName -Rank $Priority
        }
        elseif($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Remove GroupPolicyAssignment for $GroupDisplayname"
            Remove-CsGroupPolicyAssignment -GroupId $CurrentValues.GroupId -PolicyType $CurrentValues.PolicyType
            Write-Verbose -Message "Adding GroupPolicyAssignment for $GroupDisplayname"
            new-csGroupPolicyAssignment -GroupId $GroupId -PolicyType $PolicyType -PolicyName $PolicyName -Rank $Priority
        }
        elseif($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Remove GroupPolicyAssignment for $GroupDisplayname"
            Remove-CsGroupPolicyAssignment -GroupId $CurrentValues.GroupId -PolicyType $CurrentValues.PolicyType
        }
    }
    catch{
        Write-Verbose -Message "Error while setting GroupPolicyAssignment for $GroupDisplayname"
        throw $_
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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupDisplayname,

        [Parameter()]
        [System.String]
        $GroupId,

        [Parameter()]
        [System.String]
        $PolicyType,

        [Parameter()]
        [System.String]
        $PolicyName,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('Ensure', `
            'GroupDisplayname', `
            'PolicyType', `
            'PolicyName', `
            'Priority')

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $InformationPreference = 'Continue'
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$instances = Get-CsGroupPolicyAssignment
        if ($instances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = [System.Text.StringBuilder]::new()
        $j = 1
        foreach ($item in $instances)
        {
            try
            {
                $Group = Find-CsGroup -SearchQuery $item.GroupId
                $totalCount = $instances.Length
                if ($null -eq $totalCount)
                {
                    $totalCount = 1
                }
                Write-Host "    > [$j/$totalCount] GroupPolicyAssignment {$($Group.DisplayName)}" -NoNewline
                    $results = @{
                        GroupDisplayname      = $Group.DisplayName
                        GroupId               = $Group.Id
                        PolicyType            = $item.PolicyType
                        PolicyName            = $item.PolicyName
                        Priority              = $item.Priority
                        Ensure                = 'Present'
                        Id                    = $j
                        Credential            = $Credential
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificateThumbprint = $CertificateThumbprint
                    }
                    #$results = Get-TargetResource @getParams
                    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                        -Results $Results
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    $dscContent.Append($currentDSCBlock) | Out-Null
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                    Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            catch
            {
                Write-Verbose -Message $_
                Write-Verbose -Message "The current User doesn't have the required permissions to extract Users for Team {$($team.DisplayName)}."
            }
            $j++
        }
        return $dscContent.ToString()
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message "Error during Export:" `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
