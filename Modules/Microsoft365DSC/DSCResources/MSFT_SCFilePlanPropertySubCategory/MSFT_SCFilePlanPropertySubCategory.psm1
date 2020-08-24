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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
    }

    $parent = Get-FilePlanPropertyCategory | Where-Object -FilterScript { $_.DisplayName -eq $Category }
    $empty = $PSBoundParameters
    $empty.Ensure = 'Absent'
    if ($null -eq $parent)
    {
        Write-Warning "Invalid Parent Category {$Category} detected in the Get-TargetResource"
        return $empty
    }

    $parentId = $parent.Guid
    $property = Get-FilePlanPropertySubCategory | Where-Object -FilterScript { $_.DisplayName -eq $Name -and `
        $_.ParentId -eq $parentId }

    if ($null -eq $property)
    {
        Write-Verbose -Message "SCFilePlanPropertySubCategory $($Name) does not exist."
        return $empty
    }
    else
    {
        Write-Verbose "Found existing SCFilePlanPropertySubCategory $($Name)"

        $result = @{
            Name               = $property.DisplayName
            Category           = $parent.DisplayName
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = 'Present'
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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

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
        try
        {
            $property = Get-FilePlanPropertySubCategory | Where-Object -FilterScript { $_.DisplayName -eq $Name -and `
                $_.ParentId -eq $parentId }
            if ($property.Mode.ToString() -ne 'PendingDeletion')
            {
                Remove-FilePlanPropertySubCategory -Identity $Name -Confirm:$false
            }
            else
            {
                Write-Verbose -Message "Property $Name is already in the process of being deleted."
            }
        }
        catch
        {
            New-M365DSCLogEntry  -Error $_ -Message $_ -Source $MyInvocation.MyCommand.ModuleName
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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true
    [array]$Properties = Get-FilePlanPropertySubCategory

    $i = 1
    $dscContent = ""
    Write-Host "`r`n" -NoNewLine
    foreach ($Property in $Properties)
    {
        $parent = Get-FilePlanPropertyCategory | Where-Object -FilterScript { $_.Guid -like "*$($property.ParentId)*" }
        Write-Host "    |---[$i/$($Properties.Length)] $($Property.Name)" -NoNewLine
        $Params = @{
            Name                  = $Property.DisplayName
            Category              = $parent.DisplayName
            GlobalAdminAccount    = $GlobalAdminAccount
        }
        $Results = Get-TargetResource @Params
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
        $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        $i++
    }
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
