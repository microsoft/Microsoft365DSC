function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [ValidateSet('#microsoft.graph.countryNamedLocation', '#microsoft.graph.ipNamedLocation')]
        [System.String]
        $OdataType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $IpRanges,

        [Parameter()]
        [System.Boolean]
        $IsTrusted,

        [Parameter()]
        [System.String[]]
        $CountriesAndRegions,

        [Parameter()]
        [System.Boolean]
        $IncludeUnknownCountriesAndRegions,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of AAD Named Location"
    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $ApplicationId)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = "Absent"
        try
        {
            if ($null -ne $Id)
            {
                $NamedLocation = Get-MgIdentityConditionalAccessNamedLocation -NamedLocationId $Id
            }
        }
        catch
        {
            Write-Verbose -Message "Could not retrieve AAD Named Location by ID {$Id}"
        }
        if ($null -eq $NamedLocation)
        {
            try
            {
                $NamedLocation = Get-MgIdentityConditionalAccessNamedLocation -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.DisplayName -eq $DisplayName }
            }
            catch
            {
                Write-Verbose -Message $_
                Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source)
            }
        }
        if ($null -eq $NamedLocation)
        {
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing AAD Named Location {$($NamedLocation.DisplayName)}"
            $Result = @{
                OdataType                         = $NamedLocation.OdataType
                Id                                = $NamedLocation.Id
                DisplayName                       = $NamedLocation.DisplayName
                IpRanges                          = $NamedLocation.IpRanges.CidrAddress
                IsTrusted                         = $NamedLocation.IsTrusted
                CountriesAndRegions               = [String[]]$NamedLocation.CountriesAndRegions
                IncludeUnknownCountriesAndRegions = $NamedLocation.IncludeUnknownCountriesAndRegions
                Ensure                            = "Present"
                ApplicationSecret                 = $ApplicationSecret
                ApplicationId                     = $ApplicationId
                TenantId                          = $TenantId
                CertificateThumbprint             = $CertificateThumbprint
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
        [Parameter()]
        [ValidateSet('#microsoft.graph.countryNamedLocation', '#microsoft.graph.ipNamedLocation')]
        [System.String]
        $OdataType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $IpRanges,

        [Parameter()]
        [System.Boolean]
        $IsTrusted,

        [Parameter()]
        [System.String[]]
        $CountriesAndRegions,

        [Parameter()]
        [System.Boolean]
        $IncludeUnknownCountriesAndRegions,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of AAD Named Location"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $ApplicationId)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentAADNamedLocation = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId")  | Out-Null
    $currentParameters.Remove("TenantId")  | Out-Null
    $currentParameters.Remove("CertificateThumbprint")  | Out-Null
    $currentParameters.Remove("ApplicationSecret")  | Out-Null
    $currentParameters.Remove("Ensure")  | Out-Null

    # Named Location should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADNamedLocation.Ensure -eq "Absent")
    {
        $currentParameters.Remove("Id") | Out-Null
        $VerboseAttributes = ($currentParameters | Out-String)
        Write-Verbose -Message "Creating New AAD Named Location {$Displayname)} with attributes: $VerboseAttributes"
        New-MgIdentityConditionalAccessNamedLocation @currentParameters
    }
    # Named Location should exist and will be configured to desired state
    elseif ($Ensure -eq 'Present' -and $CurrentAADNamedLocation.Ensure -eq 'Present')
    {
        $currentParameters["PolicyId"] = $currentAADNamedLocation.ID
        $currentParameters.Add("NamedLocationId", $currentAADNamedLocation.Id) | Out-Null
        $currentParameters.Remove("Id") | Out-Null
        $VerboseAttributes = ($currentParameters | Out-String)
        Write-Verbose -Message "Updating existing AAD Named Location {$Displayname)} with attributes: $VerboseAttributes"
        Update-MgIdentityConditionalAccessNamedLocation @currentParameters
    }
    # Named Location exist but should not
    elseif ($Ensure -eq 'Absent' -and $CurrentAADNamedLocation.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AAD Named Location {$Displayname)}"
        Remove-MgIdentityConditionalAccessNamedLocation -NamedLocationId $currentAADNamedLocation.ID
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [ValidateSet('#microsoft.graph.countryNamedLocation', '#microsoft.graph.ipNamedLocation')]
        [System.String]
        $OdataType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String[]]
        $IpRanges,

        [Parameter()]
        [System.Boolean]
        $IsTrusted,

        [Parameter()]
        [System.String[]]
        $CountriesAndRegions,

        [Parameter()]
        [System.Boolean]
        $IncludeUnknownCountriesAndRegions,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of AAD Named Location"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove("Id") | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null

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
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $ApplicationId)
    $data.Add("TenantId", $TenantId)
    $data.Add("ConnectionMode", $ConnectionMode)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $i = 1
    Write-Host "`r`n" -NoNewline
    try
    {
        $AADNamedLocations = Get-MgIdentityConditionalAccessNamedLocation -ErrorAction Stop
        foreach ($AADNamedLocation in $AADNamedLocations)
        {
            Write-Host "    |---[$i/$($AADNamedLocations.Count)] $($AADNamedLocation.DisplayName)" -NoNewline
            $Params = @{
                ApplicationSecret     = $ApplicationSecret
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                DisplayName           = $AADNamedLocation.DisplayName
                ID                    = $AADNamedLocation.ID
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
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
