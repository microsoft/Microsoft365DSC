function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $AddedBy,

        [Parameter()]
        [System.String]
        $AddedOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Attributes,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsPendingOnboarding,

        [Parameter()]
        [System.String]
        $OriginId,

        [Parameter()]
        [System.String]
        $OriginSystem,

        [Parameter()]
        [System.String]
        $ResourceType,

        [Parameter()]
        [System.String]
        $Url,
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
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message ($_)
    }

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
    try
    {
        $getValue = $null
        $CatalogIdValue = $catalogId
        if (-not [System.String]::IsNullOrEmpty($CatalogId))
        {
            $resource = ([Hashtable]$PSBoundParameters).clone()
            $ObjectGuid = [System.Guid]::empty
            if (-not [System.Guid]::TryParse($CatalogId, [System.Management.Automation.PSReference]$ObjectGuid))
            {
                $catalogInstance = Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq '$catalogId'"
                $CatalogId = $catalogInstance.Id
                $CatalogIdValue = $catalogInstance.DisplayName
            }

            $getValue = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource `
                -AccessPackageCatalogId  $CatalogId `
                -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Retrieving Resource by Display Name {$DisplayName}"
                $getValue = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource `
                    -AccessPackageCatalogId  $CatalogId `
                    -Filter "DisplayName eq '$DisplayName'" -ErrorAction SilentlyContinue
            }
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "The access package resource with id {$id} was NOT found in catalog {$CatalogId}."
            return $nullResult
        }

        Write-Verbose -Message "The access package resource {$DisplayName} was found in catalog {$CatalogId}."
        $hashAttributes = @()
        foreach ($attribute in ([Array]$getValue.attributes))
        {
            $hashAttribute = @{
                AttributeName                  = $attribute.attributeName
                IsEditable                     = $attribute.isEditable
                IsPersistedOnAssignmentRemoval = $attribute.isPersistedOnAssignmentRemoval
                AttributeSource                = @{
                    odataType = '#microsoft.graph.accessPackageResourceAttributeQuestion'
                    Question  = @{
                        odataType               = $attribute.attributeSource.additionalProperties.question.'@odata.type'
                        Id                      = $attribute.attributeSource.additionalProperties.question.id
                        IsRequired              = $attribute.attributeSource.additionalProperties.question.isRequired
                        Sequence                = $attribute.attributeSource.additionalProperties.question.sequence
                        IsSingleLine            = $attribute.attributeSource.additionalProperties.question.isSingleLine
                        QuestionText            = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject ($attribute.attributeSource.additionalProperties.question.text)
                        AllowsMultipleSelection = $attribute.attributeSource.additionalProperties.question.allowsMultipleSelection
                        Choices                 = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject ([Array]$attribute.attributeSource.additionalProperties.question.choices)
                    }
                }
                AttributeDestination           = @{
                    odataType = '#microsoft.graph.accessPackageUserDirectoryAttributeStore'
                }
            }
            $hashAttributes += $hashAttribute
        }

        $results = [ordered]@{
            Id                    = $Id
            CatalogId             = $CatalogIdValue
            Attributes            = $hashAttributes
            AddedBy               = $getValue.addedBy #Read-Only
            AddedOn               = $getValue.addedOn #Read-Only
            Description           = $getValue.description
            DisplayName           = $getValue.displayName
            IsPendingOnboarding   = $getValue.isPendingOnboarding #Read-Only
            OriginId              = $getValue.originId
            OriginSystem          = $getValue.originSystem
            ResourceType          = $getValue.resourceType
            Url                   = $getValue.url
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $AddedBy,

        [Parameter()]
        [System.String]
        $AddedOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Attributes,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsPendingOnboarding,

        [Parameter()]
        [System.String]
        $OriginId,

        [Parameter()]
        [System.String]
        $OriginSystem,

        [Parameter()]
        [System.String]
        $ResourceType,

        [Parameter()]
        [System.String]
        $Url,
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
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message $_
    }

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
    $PSBoundParameters.Remove('addedBy') | Out-Null
    $PSBoundParameters.Remove('addedOn') | Out-Null
    $PSBoundParameters.Remove('isPendingOnboarding') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $resource = ([Hashtable]$PSBoundParameters).clone()
        $ObjectGuid = [System.Guid]::empty
        if (-not [System.Guid]::TryParse($CatalogId, [System.Management.Automation.PSReference]$ObjectGuid))
        {
            Write-Verbose -Message "Retrieving Catalog by Display Name"
            $catalogInstance = Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq '$($CatalogId)'"
            if ($catalogInstance)
            {
                $CatalogId = $catalogInstance.Id
            }
        }
        Write-Verbose -Message "Assigning resource {$DisplayName} to catalog {$CatalogId}"

        $resource.Remove('Id') | Out-Null
        $resource.Remove('CatalogId') | Out-Null
        $resource.Remove('Verbose') | Out-Null

        #Preparing embedded Cim Instances
        $keys = (([Hashtable]$resource).clone()).Keys
        foreach ($key in $keys)
        {
            $keyName = $key
            $keyValue = $resource.$key
            if ($null -ne $resource.$key -and $resource.$key.getType().Name -like '*cimInstance*')
            {
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $resource.$key
                $resource.$key = $keyValue
            }
        }

        $mapping = @{
            odataType    = '@odata.type'
            questionText = 'text'
        }
        $resource = Rename-M365DSCCimInstanceParameter -Properties $resource `
            -KeyMapping $mapping

        #Preparing parameter splat
        $resourceRequest = @{
            CatalogId             = $CatalogId
            RequestType           = 'AdminAdd'
            AccessPackageresource = $resource
        }
        #region resource generator code
        Write-Verbose -Message "Creating with Values: $(Convert-M365DscHashtableToString -Hashtable $resourceRequest)"
        New-MgBetaEntitlementManagementAccessPackageResourceRequest @resourceRequest

        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating resource {$DisplayName} in catalog {$CatalogId}"

        $resource = ([Hashtable]$PSBoundParameters).clone()
        $ObjectGuid = [System.Guid]::empty
        if (-not [System.Guid]::TryParse($CatalogId, [System.Management.Automation.PSReference]$ObjectGuid))
        {
            Write-Verbose -Message "Retrieving Catalog by Display Name"
            $catalogInstance = Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq '$($CatalogId)'"
            if ($catalogInstance)
            {
                $CatalogId = $catalogInstance.Id
            }
        }
        #$resource.Remove('Id') | Out-Null
        $resource.Remove('CatalogId') | Out-Null
        $resource.Remove('Verbose') | Out-Null

        #Preparing embedded Cim Instances
        $keys = (([Hashtable]$resource).clone()).Keys
        foreach ($key in $keys)
        {
            $keyName = $key
            $keyValue = $resource.$key
            if ($null -ne $resource.$key -and $resource.$key.getType().Name -like '*cimInstance*')
            {
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $resource.$key
                $resource.$key = $keyValue
            }
        }

        $mapping = @{
            odataType    = '@odata.type'
            questionText = 'text'
        }
        $resource = Rename-M365DSCCimInstanceParameter -Properties $resource `
            -KeyMapping $mapping

        #region resource generator code
        $resourceRequest = @{
            CatalogId             = $CatalogId
            RequestType           = 'AdminUpdate'
            AccessPackageresource = $resource
        }
        #region resource generator code
        #write-verbose ($resourceRequest|convertTo-Json -depth 20)
        New-MgBetaEntitlementManagementAccessPackageResourceRequest @resourceRequest

        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing resource {$DisplayName} from catalog {$CatalogId}"

        $resource = ([Hashtable]$PSBoundParameters).clone()

        $resource.Remove('Id') | Out-Null
        $resource.Remove('CatalogId') | Out-Null
        $resource.Remove('Verbose') | Out-Null

        #Preparing embedded Cim Instances
        $keys = (([Hashtable]$resource).clone()).Keys
        foreach ($key in $keys)
        {
            $keyName = $key
            $keyValue = $resource.$key
            if ($null -ne $resource.$key -and $resource.$key.getType().Name -like '*cimInstance*')
            {
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $resource.$key
                $resource.$key = $keyValue
            }
        }

        $mapping = @{
            odataType    = '@odata.type'
            questionText = 'text'
        }
        $resource = Rename-M365DSCCimInstanceParameter -Properties $resource `
            -KeyMapping $mapping

        $resourceRequest = @{
            CatalogId             = $CatalogId
            RequestType           = 'AdminRemove'
            AccessPackageresource = $resource
        }
        New-MgBetaEntitlementManagementAccessPackageResourceRequest @resourceRequest

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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $CatalogId,

        [Parameter()]
        [System.String]
        $AddedBy,

        [Parameter()]
        [System.String]
        $AddedOn,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Attributes,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsPendingOnboarding,

        [Parameter()]
        [System.String]
        $OriginId,

        [Parameter()]
        [System.String]
        $OriginSystem,

        [Parameter()]
        [System.String]
        $ResourceType,

        [Parameter()]
        [System.String]
        $Url,
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

    Write-Verbose -Message "Testing access package resource {$DisplayName} from catalog {$CatalogId}"

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

    $ValuesToCheck.Remove('AddedBy') | Out-Null
    $ValuesToCheck.Remove('AddedOn') | Out-Null
    $ValuesToCheck.Remove('IsPendingOnboarding') | Out-Null
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
        $catalogs = @()
        $catalogs += Get-MgBetaEntitlementManagementAccessPackageCatalog -All -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($catalogs.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        foreach ($catalog in $catalogs)
        {
            $displayedKey = $catalog.id
            if (-not [String]::IsNullOrEmpty($catalog.displayName))
            {
                $displayedKey = $catalog.displayName
            }
            Write-Host "    |---[$i/$($catalogs.Count)] $displayedKey" -NoNewline

            $catalogId = $catalog.id

            [array]$resources = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource -AccessPackageCatalogId  $catalogId -ErrorAction Stop

            $j = 1
            $dscContent = ''

            if ($resources.Length -eq 0)
            {
                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host "`r`n" -NoNewline
            }

            foreach ($resource in $resources)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-Host "        |---[$j/$($resources.Count)] $($resource.DisplayName)" -NoNewline

                $params = @{
                    Id                    = $resource.id
                    DisplayName           = $resource.displayName
                    CatalogId             = $catalogId
                    Ensure                = 'Present'
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Results = Get-TargetResource @Params

                if ($null -ne $Results.Attributes)
                {
                    $complexMapping = @(
                        @{
                            Name            = 'AttributeDestination'
                            CimInstanceName = 'MicrosoftGraphaccesspackageresourceattributedestination'
                        }
                        @{
                            Name            = 'AttributeSource'
                            CimInstanceName = 'MicrosoftGraphaccesspackageresourceattributesource'
                        }
                        @{
                            Name            = 'Question'
                            CimInstanceName = 'MicrosoftGraphaccessPackageResourceAttributeQuestion'
                        }
                        @{
                            Name            = 'QuestionText'
                            CimInstanceName = 'MicrosoftGraphaccessPackageLocalizedContent'
                        }
                        @{
                            Name            = 'Choices'
                            CimInstanceName = 'MicrosoftGraphaccessPackageAnswerChoice'
                        }
                        @{
                            Name            = 'LocalizedTexts'
                            CimInstanceName = 'MicrosoftGraphaccessPackageLocalizedText'
                        }
                        @{
                            Name            = 'DisplayValue'
                            CimInstanceName = 'MicrosoftGraphaccessPackageLocalizedContent'
                        }
                    )
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject ([Array]$Results.Attributes) `
                        -CIMInstanceName MicrosoftGraphaccesspackageresourceattribute `
                        -ComplexTypeMapping $complexMapping

                    $Results.Attributes = $complexTypeStringResult

                    if ([String]::IsNullOrEmpty($complexTypeStringResult))
                    {
                        $Results.Remove('Attributes') | Out-Null
                    }
                }

                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential

                if ($null -ne $Results.Attributes)
                {
                    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Attributes' -IsCIMArray:$true
                }
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $j++
            }

            $i++
        }

        #Removing coma between items in cim instance array
        $dscContent = $dscContent.replace("            ,`r`n", '')
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
