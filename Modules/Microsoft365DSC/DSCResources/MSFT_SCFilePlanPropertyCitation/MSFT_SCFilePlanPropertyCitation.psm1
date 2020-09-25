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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $property = Get-FilePlanPropertyCitation -ErrorAction Stop | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $property)
        {
            Write-Verbose -Message "SCFilePlanPropertyCitation $($Name) does not exist."
            return $nullReturn
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

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        $CreationParams.Remove("GlobalAdminAccount") | Out-Null
        $CreationParams.Remove("Ensure") | Out-Null

        New-FilePlanPropertyCitation @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $Current.Ensure))
    {
        Set-FilePlanPropertyCitation -Identity $Name -CitationUrl $CitationUrl -CitationJurisdiction $CitationJurisdiction
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $Current.Ensure))
    {
        try
        {
            $property = Get-FilePlanPropertyCitation | Where-Object -FilterScript { $_.Name -eq $Name }
            if ($property.Mode.ToString() -ne 'PendingDeletion')
            {
                Remove-FilePlanPropertyCitation -Identity $Name -Confirm:$false -ErrorAction Stop
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
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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

    try
    {
        $Properties = Get-FilePlanPropertyCitation -ErrorAction Stop

        $i = 1
        $dscContent = ""
        Write-Host "`r`n" -NoNewLine
        foreach ($Property in $Properties)
        {
            Write-Host "    |---[$i/$($Properties.Length)] $($Property.Name)" -NoNewLine
            $Params = @{
                Name                  = $Property.Name
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
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
