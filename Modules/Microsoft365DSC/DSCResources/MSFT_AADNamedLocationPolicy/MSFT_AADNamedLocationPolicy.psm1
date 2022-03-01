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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Getting configuration of AAD Named Location"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = "Absent"
        try
        {
            if ($Id)
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
                if ($NamedLocation.Length -gt 1)
                {
                    throw "More than one instance of a Named Location Policy with name {$DisplayName} was found. Please provide the ID parameter."
                }
            }
            catch
            {
                Write-Error $_
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
                OdataType                         = $NamedLocation.AdditionalProperties.'@odata.type'
                Id                                = $NamedLocation.Id
                DisplayName                       = $NamedLocation.DisplayName
                IpRanges                          = $NamedLocation.AdditionalProperties.ipRanges.cidrAddress
                IsTrusted                         = $NamedLocation.AdditionalProperties.isTrusted
                CountriesAndRegions               = [String[]]$NamedLocation.AdditionalProperties.countriesAndRegions
                IncludeUnknownCountriesAndRegions = $NamedLocation.AdditionalProperties.includeUnknownCountriesAndRegions
                Ensure                            = "Present"
                ApplicationSecret                 = $ApplicationSecret
                ApplicationId                     = $ApplicationId
                TenantId                          = $TenantId
                CertificateThumbprint             = $CertificateThumbprint
                CertificatePath                   = $CertificatePath
                CertificatePassword               = $CertificatePassword
                Credential                        = $Credential
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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of AAD Named Location"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentAADNamedLocation = Get-TargetResource @PSBoundParameters

    $desiredValues = @{
        '@odata.type' = $OdataType
        displayName = $DisplayName
        isTrusted = $IsTrusted
    }
    if ($OdataType -eq '#microsoft.graph.ipNamedLocation')
    {
        $IpRangesValue = @()
        foreach ($IpRange in $IpRanges)
        {
            $ipRangeType = '#microsoft.graph.iPv4CidrRange'
            if ($IpRange.Contains(':'))
            {
                $ipRangeType = '#microsoft.graph.iPv6CidrRange'
            }
            $IpRangesValue += @{
                '@odata.type' = $ipRangeType
                cidrAddress = $IPRange
            }
        }
        if ($IpRangesValue)
        {
            $desiredValues.Add("ipRanges", $IpRangesValue)
        }
    }
    elseif ($OdataType -eq '#microsoft.graph.countryNamedLocation')
    {
        $desiredValues.Add("includeUnknownCountriesAndRegions", $IncludeUnknownCountriesAndRegions)
        $desiredValues.Add("countriesAndRegions", $CountriesAndRegions)
    }

    # Named Location should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADNamedLocation.Ensure -eq "Absent")
    {
        $VerboseAttributes = ($desiredValues | Out-String)
        Write-Verbose -Message "Creating New AAD Named Location {$Displayname)} with attributes: $VerboseAttributes"
        $JSONValue = ConvertTo-Json $desiredValues | Out-String
        Write-Verbose -Message "JSON: $JSONValue"
        $APIUrl = "https://graph.microsoft.com/v1.0/identity/conditionalAccess/namedLocations"
        Invoke-MgGraphRequest -Method POST `
            -Uri $APIUrl `
            -Body $JSONValue | Out-Null
    }
    # Named Location should exist and will be configured to desired state
    elseif ($Ensure -eq 'Present' -and $CurrentAADNamedLocation.Ensure -eq 'Present')
    {
        $desiredValues.Add("NamedLocationId", $currentAADNamedLocation.Id) | Out-Null
        $VerboseAttributes = ($desiredValues | Out-String)
        Write-Verbose -Message "Updating existing AAD Named Location {$Displayname)} with attributes: $VerboseAttributes"

        $VerboseAttributes = ($desiredValues | Out-String)
        Write-Verbose -Message "Updating AAD Named Location {$Displayname)} with attributes: $VerboseAttributes"
        $JSONValue = ConvertTo-Json $desiredValues | Out-String
        Write-Verbose -Message "JSON: $JSONValue"
        $APIUrl = "https://graph.microsoft.com/v1.0/identity/conditionalAccess/namedLocations"
        Invoke-MgGraphRequest -Method PATCH `
            -Uri $APIUrl `
            -Body $JSONValue | Out-Null
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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of AAD Named Location"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove("Id") | Out-Null
    $ValuesToCheck.Remove("ApplicationId") | Out-Null
    $ValuesToCheck.Remove("TenantId") | Out-Null
    $ValuesToCheck.Remove("CertificateThumbprint") | Out-Null
    $ValuesToCheck.Remove("CertificatePath") | Out-Null
    $ValuesToCheck.Remove("CertificatePassword") | Out-Null

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $i = 1

    try
    {

        $AADNamedLocations = Get-MgIdentityConditionalAccessNamedLocation -ErrorAction Stop
        if ($AADNamedLocations.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($AADNamedLocation in $AADNamedLocations)
        {
            Write-Host "    |---[$i/$($AADNamedLocations.Count)] $($AADNamedLocation.DisplayName)" -NoNewline
            $Params = @{
                ApplicationSecret     = $ApplicationSecret
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Credential            = $Credential
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
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
                    -Results $Results `
                    -Credential $Credential
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
        Write-Host $Global:M365DSCEmojiRedX
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
