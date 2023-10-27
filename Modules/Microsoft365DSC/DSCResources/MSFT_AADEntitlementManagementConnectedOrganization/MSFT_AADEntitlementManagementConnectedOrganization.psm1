function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IdentitySources,

        [Parameter()]
        [ValidateSet('configured', 'proposed', 'unknownFutureValue')]
        [System.String]
        $State,

        [Parameter()]
        [String[]]
        $ExternalSponsors,

        [Parameter()]
        [String[]]
        $InternalSponsors,

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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

        $getValue = Get-MgBetaEntitlementManagementConnectedOrganization -ConnectedOrganizationId $id -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Entitlement Management Connected Organization with id {$id} was not found."

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaEntitlementManagementConnectedOrganization `
                    -Filter "displayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue
            }
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Entitlement Management Connected Organization with displayName {$DisplayName} was not found."
            return $nullResult
        }

        Write-Verbose -Message "Entitlement Management Connected Organization with id {$($getValue.id)} and displayName {$($getValue.DisplayName)} was found."
        [Array]$getExternalSponsors = Get-MgBetaEntitlementManagementConnectedOrganizationExternalSponsor -ConnectedOrganizationId $getValue.id

        if ($null -ne $getExternalSponsors -and $getExternalSponsors.count -gt 0)
        {
            $sponsors = @()
            foreach ($sponsor in $getExternalSponsors)
            {
                $sponsors += $sponsor.id
            }
            $getExternalSponsors = $sponsors
        }

        [Array]$getInternalSponsors = Get-MgBetaEntitlementManagementConnectedOrganizationInternalSponsor -ConnectedOrganizationId $getValue.id

        if ($null -ne $getInternalSponsors -and $getInternalSponsors.count -gt 0)
        {
            $sponsors = @()
            foreach ($sponsor in $getInternalSponsors)
            {
                $sponsors += $sponsor.id
            }
            $getInternalSponsors = $sponsors
        }

        $getIdentitySources = $null
        if ($null -ne $getValue.IdentitySources)
        {
            $sources = @()
            foreach ($source in $getValue.IdentitySources)
            {
                $formattedSource = @{
                    odataType = $source.AdditionalProperties.'@odata.type'
                }

                if (-not [String]::IsNullOrEmpty($source.AdditionalProperties.displayName))
                {
                    $formattedSource.Add('DisplayName', $source.AdditionalProperties.displayName)
                }

                if (-not [String]::IsNullOrEmpty($source.AdditionalProperties.tenantId))
                {
                    $formattedSource.Add('tenantId', $source.AdditionalProperties.tenantId)
                }

                if (-not [String]::IsNullOrEmpty($source.AdditionalProperties.cloudInstance))
                {
                    $formattedSource.Add('CloudInstance', $source.AdditionalProperties.cloudInstance)
                }

                if (-not [String]::IsNullOrEmpty($source.AdditionalProperties.domainName))
                {
                    $formattedSource.Add('DomainName', $source.AdditionalProperties.domainName)
                }

                if (-not [String]::IsNullOrEmpty($source.AdditionalProperties.issuerUri))
                {
                    $formattedSource.Add('IssuerUri', $source.AdditionalProperties.issuerUri)
                }
                $sources += $formattedSource
            }
            $getIdentitySources = $sources
        }

        $results = @{
            Id                    = $getValue.id
            Description           = $getValue.description
            DisplayName           = $getValue.displayName
            ExternalSponsors      = $getExternalSponsors
            IdentitySources       = $getIdentitySources
            InternalSponsors      = $getInternalSponsors
            State                 = $getValue.state
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
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
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IdentitySources,

        [Parameter()]
        [ValidateSet('configured', 'proposed', 'unknownFutureValue')]
        [System.String]
        $State,

        [Parameter()]
        [String[]]
        $ExternalSponsors,

        [Parameter()]
        [String[]]
        $InternalSponsors,

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
        $ManagedIdentity
    )

    #Import-Module Microsoft.Graph.DirectoryObjects -Force
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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null

    $keyToRename = @{
        'odataType'        = '@odata.type'
        'ExternalTenantId' = 'tenantId'
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Entitlement Management Connected Organization {$DisplayName}"

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters -KeyMapping $keyToRename

        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('ExternalSponsors') | Out-Null
        $CreateParameters.Remove('InternalSponsors') | Out-Null


        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        $TenantId = $CreateParameters.IdentitySources.tenantId
        $url = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + "beta/tenantRelationships/microsoft.graph.findTenantInformationByTenantId(tenantId='$tenantid')"
        $DomainName = (Invoke-MgGraphRequest -Method 'GET' -Uri $url).defaultDomainName
        $newConnectedOrganization = New-MgBetaEntitlementManagementConnectedOrganization -Description $CreateParameters.Description -DisplayName $CreateParameters.DisplayName -State $CreateParameters.State -DomainName $DomainName

        foreach ($sponsor in $ExternalSponsors)
        {
            $directoryObject = Get-MgBetaDirectoryObject -DirectoryObjectId $sponsor
            $directoryObjectType=$directoryObject.AdditionalProperties."@odata.type"
            $directoryObjectType=($directoryObject.AdditionalProperties."@odata.type").split(".")|select-object -last 1
            $directoryObjectRef=@{
                "@odata.id" = "https://graph.microsoft.com/beta/$($directoryObjectType)s/$($sponsor)"
            }

            New-MgBetaEntitlementManagementConnectedOrganizationExternalSponsorByRef `
                -ConnectedOrganizationId $newConnectedOrganization.id `
                -BodyParameter $directoryObjectRef
        }

        foreach ($sponsor in $InternalSponsors)
        {
            $directoryObject = Get-MgBetaDirectoryObject -DirectoryObjectId $sponsor
            $directoryObjectType=($directoryObject.AdditionalProperties."@odata.type").split(".")|select-object -last 1
            $directoryObjectRef=@{
                "@odata.id" = "https://graph.microsoft.com/beta/$($directoryObjectType)s/$($sponsor)"
            }

            New-MgBetaEntitlementManagementConnectedOrganizationInternalSponsorByRef `
                -ConnectedOrganizationId $newConnectedOrganization.id `
                -BodyParameter $directoryObjectRef
        }

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating a new Entitlement Management Connected Organization {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters -KeyMapping $keyToRename

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('ExternalSponsors') | Out-Null
        $UpdateParameters.Remove('InternalSponsors') | Out-Null


        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }

        Update-MgBetaEntitlementManagementConnectedOrganization -BodyParameter $UpdateParameters `
            -ConnectedOrganizationId $currentInstance.Id

        #region External Sponsors
        $sponsorsDifferences = compare-object -ReferenceObject @($ExternalSponsors|select-object) -DifferenceObject @($currentInstance.ExternalSponsors|select-object)
        $sponsorsToAdd=($sponsorsDifferences | where-object -filterScript {$_.SideIndicator -eq '<='}).InputObject
        $sponsorsToRemove=($sponsorsDifferences | where-object -filterScript {$_.SideIndicator -eq '=>'}).InputObject
        foreach ($sponsor in $sponsorsToAdd)
        {
            $directoryObject = Get-MgBetaDirectoryObject -DirectoryObjectId $sponsor
            $directoryObjectType=$directoryObject.AdditionalProperties."@odata.type"
            $directoryObjectType=($directoryObject.AdditionalProperties."@odata.type").split(".")|select-object -last 1
            $directoryObjectRef=@{
                "@odata.id" = "https://graph.microsoft.com/beta/$($directoryObjectType)s/$($sponsor)"
            }

            New-MgBetaEntitlementManagementConnectedOrganizationExternalSponsorByRef `
                -ConnectedOrganizationId $currentInstance.Id `
                -BodyParameter $directoryObjectRef
        }
        foreach ($sponsor in $sponsorsToRemove)
        {
            Remove-MgBetaEntitlementManagementConnectedOrganizationExternalSponsorByRef `
                -ConnectedOrganizationId $currentInstance.Id `
                -DirectoryObjectId $sponsor
        }
        #endregion

        #region Internal Sponsors
        $sponsorsDifferences = compare-object -ReferenceObject @($InternalSponsors|select-object) -DifferenceObject @($currentInstance.InternalSponsors|select-object)
        $sponsorsToAdd=($sponsorsDifferences | where-object -filterScript {$_.SideIndicator -eq '<='}).InputObject
        $sponsorsToRemove=($sponsorsDifferences | where-object -filterScript {$_.SideIndicator -eq '=>'}).InputObject
        foreach ($sponsor in $sponsorsToAdd)
        {
            $directoryObject = Get-MgBetaDirectoryObject -DirectoryObjectId $sponsor
            $directoryObjectType=$directoryObject.AdditionalProperties."@odata.type"
            $directoryObjectType=($directoryObject.AdditionalProperties."@odata.type").split(".")|select-object -last 1
            $directoryObjectRef=@{
                "@odata.id" = "https://graph.microsoft.com/beta/$($directoryObjectType)s/$($sponsor)"
            }

            New-MgBetaEntitlementManagementConnectedOrganizationInternalSponsorByRef `
                -ConnectedOrganizationId $currentInstance.Id `
                -BodyParameter $directoryObjectRef
        }
        foreach ($sponsor in $sponsorsToRemove)
        {
            Remove-MgBetaEntitlementManagementConnectedOrganizationInternalSponsorByRef `
                -ConnectedOrganizationId $currentInstance.Id `
                -DirectoryObjectId $sponsor
        }
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing a new Entitlement Management Connected Organization  {$($currentInstance.Id)}"
        Remove-MgBetaEntitlementManagementConnectedOrganization -ConnectedOrganizationId $currentInstance.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IdentitySources,

        [Parameter()]
        [ValidateSet('configured', 'proposed', 'unknownFutureValue')]
        [System.String]
        $State,

        [Parameter()]
        [String[]]
        $ExternalSponsors,

        [Parameter()]
        [String[]]
        $InternalSponsors,

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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
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
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

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
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        [array]$getValue = Get-MgBetaEntitlementManagementConnectedOrganization `
            -ErrorAction Stop `
            -All
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
            $displayedKey = $config.id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                id                    = $config.id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            if ($Results.IdentitySources)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.IdentitySources -CIMInstanceName AADEntitlementManagementConnectedOrganizationIdentitySource
                if ($complexTypeStringResult)
                {
                    $Results.IdentitySources = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IdentitySources') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($Results.IdentitySources)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'IdentitySources' -IsCIMArray:$true
            }

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
        if ($_.ErrorDetails.Message -like '*User is not authorized to perform the operation.*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) Tenant does not meet license requirement to extract this component."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
