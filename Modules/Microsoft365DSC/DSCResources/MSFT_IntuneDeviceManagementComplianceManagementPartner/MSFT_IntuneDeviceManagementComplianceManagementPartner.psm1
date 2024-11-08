function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AndroidEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $AndroidOnboarded,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IosEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $IosOnboarded,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MacOsEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $MacOsOnboarded,

        [Parameter()]
        [ValidateSet('unknown','unavailable','enabled','terminated','rejected','unresponsive')]
        [System.String]
        $PartnerState,

        [Parameter()]
        [System.String]
        $Id,

        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'Intune' `
            -InboundParameters $PSBoundParameters

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        $getValue = Get-MgBetaDeviceManagementComplianceManagementPartner `
            -Filter "DisplayName eq '$DisplayName'" `
            -ErrorAction SilentlyContinue <# | Where-Object `
            -FilterScript {
                $_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.ComplianceManagementPartner"
            } #>

        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Device Management Compliance Management Partner with DisplayName {$DisplayName}."
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Device Management Compliance Management Partner with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        if ($getValue.androidEnrollmentAssignments.Count -gt 0)
        {
            $returnAndroidEnrollmentAssignments = @()
            $returnAndroidEnrollmentAssignments += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter $true `
                -Assignments ($getValue.androidEnrollmentAssignments)
        }
        else
        {
            $returnAndroidEnrollmentAssignments = $null
        }

        if ($getValue.iosEnrollmentAssignments.Count -gt 0)
        {
            $returnIosEnrollmentAssignments = @()
            $returnIosEnrollmentAssignments += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter $true `
                -Assignments ($getValue.iosEnrollmentAssignments)
        }
        else
        {
            $returnIosEnrollmentAssignments = $null
        }

        if ($getValue.macOsEnrollmentAssignments.Count -gt 0)
        {
            $returnMacOsEnrollmentAssignments = @()
            $returnMacOsEnrollmentAssignments += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter $true `
                -Assignments ($getValue.macOsEnrollmentAssignments)
        }
        else
        {
            $returnMacOsEnrollmentAssignments = $null
        }
        #endregion

        #region resource generator code
        $enumPartnerState = $null
        if ($null -ne $getValue.PartnerState)
        {
            $enumPartnerState = $getValue.PartnerState.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AndroidEnrollmentAssignments = $returnAndroidEnrollmentAssignments
            AndroidOnboarded             = $getValue.AndroidOnboarded
            DisplayName                  = $getValue.DisplayName
            IosEnrollmentAssignments     = $returnIosEnrollmentAssignments
            IosOnboarded                 = $getValue.IosOnboarded
            MacOsEnrollmentAssignments   = $returnMacOsEnrollmentAssignments
            MacOsOnboarded               = $getValue.MacOsOnboarded
            PartnerState                 = $enumPartnerState
            Id                           = $getValue.Id
            Ensure                       = 'Present'
            Credential                   = $Credential
            ApplicationId                = $ApplicationId
            TenantId                     = $TenantId
            ApplicationSecret            = $ApplicationSecret
            CertificateThumbprint        = $CertificateThumbprint
            ManagedIdentity              = $ManagedIdentity.IsPresent
            #endregion
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AndroidEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $AndroidOnboarded,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IosEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $IosOnboarded,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MacOsEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $MacOsOnboarded,

        [Parameter()]
        [ValidateSet('unknown','unavailable','enabled','terminated','rejected','unresponsive')]
        [System.String]
        $PartnerState,

        [Parameter()]
        [System.String]
        $Id,

        #endregion
        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters


    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Management Compliance Management Partner with DisplayName {$DisplayName}"

        $createParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        foreach ($key in ($CreateParameters.clone()).Keys)
        {
            if ($CreateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $CreateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        if ($createParameters.AndroidEnrollmentAssignments.Count -gt 0)
        {
            $androidEnrollmentAssignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter $true -Assignments $createParameters.AndroidEnrollmentAssignments #-DataTypeName '@odata.Type'
            $createParameters.AndroidEnrollmentAssignments = $androidEnrollmentAssignmentsHash
        }
        if ($createParameters.IosEnrollmentAssignments.Count -gt 0)
        {
            $iosEnrollmentAssignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter $true -Assignments $createParameters.IosEnrollmentAssignments #-DataTypeName '@odata.Type'
            $createParameters.IosEnrollmentAssignments = $iosEnrollmentAssignmentsHash
        }
        if ($createParameters.MacOsEnrollmentAssignments.Count -gt 0)
        {
            $macOsEnrollmentAssignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter $true -Assignments $createParameters.MacOsEnrollmentAssignments #-DataTypeName '@odata.Type'
            $createParameters.MacOsEnrollmentAssignments = $macOsEnrollmentAssignmentsHash
        }
        #region resource generator code
        $createParameters.Add("@odata.type", "#microsoft.graph.ComplianceManagementPartner")
        $policy = New-MgBetaDeviceManagementComplianceManagementPartner -BodyParameter $createParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Management Compliance Management Partner with Id {$($currentInstance.Id)}"

        $updateParameters = ([Hashtable]$BoundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

        $updateParameters.Remove('Id') | Out-Null

        foreach ($key in ($UpdateParameters.clone()).Keys)
        {
            if ($updateParameters[$key].getType().Fullname -like '*CimInstance*')
            {
                $updateParameters[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters[$key]
            }
        }
        if ($updateParameters.AndroidEnrollmentAssignments.Count -gt 0)
        {
            $androidEnrollmentAssignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter $true -Assignments $updateParameters.AndroidEnrollmentAssignments #-DataTypeName 'odataType'
            $updateParameters.AndroidEnrollmentAssignments = $androidEnrollmentAssignmentsHash
        }
        if ($updateParameters.IosEnrollmentAssignments.Count -gt 0)
        {
            $iosEnrollmentAssignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter $true -Assignments $updateParameters.IosEnrollmentAssignments #-DataTypeName 'odataType'
            $updateParameters.IosEnrollmentAssignments = $iosEnrollmentAssignmentsHash
        }
        if ($updateParameters.MacOsEnrollmentAssignments.Count -gt 0)
        {
            $macOsEnrollmentAssignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter $true -Assignments $updateParameters.MacOsEnrollmentAssignments #-DataTypeName 'odataType'
            $updateParameters.MacOsEnrollmentAssignments = $macOsEnrollmentAssignmentsHash
        }
        #region resource generator code
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.ComplianceManagementPartner")
        Update-MgBetaDeviceManagementComplianceManagementPartner `
            -ComplianceManagementPartnerId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Management Compliance Management Partner with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementComplianceManagementPartner -ComplianceManagementPartnerId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AndroidEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $AndroidOnboarded,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IosEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $IosOnboarded,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $MacOsEnrollmentAssignments,

        [Parameter()]
        [System.Boolean]
        $MacOsOnboarded,

        [Parameter()]
        [ValidateSet('unknown','unavailable','enabled','terminated','rejected','unresponsive')]
        [System.String]
        $PartnerState,

        [Parameter()]
        [System.String]
        $Id,

        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of the Intune Device Management Compliance Management Partner with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'Intune' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceManagementComplianceManagementPartner `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id = $config.Id
                DisplayName           =  $config.DisplayName
                Ensure = 'Present'
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity = $ManagedIdentity.IsPresent
                AccessTokens = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($null -ne $Results.AndroidEnrollmentAssignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AndroidEnrollmentAssignments `
                    -CIMInstanceName 'IntuneDeviceAndAppManagementAssignmentTarget'

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AndroidEnrollmentAssignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AndroidEnrollmentAssignments') | Out-Null
                }
            }
            if ($null -ne $Results.IosEnrollmentAssignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.IosEnrollmentAssignments `
                    -CIMInstanceName 'IntuneDeviceAndAppManagementAssignmentTarget'

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.IosEnrollmentAssignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IosEnrollmentAssignments') | Out-Null
                }
            }
            if ($null -ne $Results.MacOsEnrollmentAssignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.MacOsEnrollmentAssignments `
                    -CIMInstanceName 'IntuneDeviceAndAppManagementAssignmentTarget'

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.MacOsEnrollmentAssignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('MacOsEnrollmentAssignments') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
