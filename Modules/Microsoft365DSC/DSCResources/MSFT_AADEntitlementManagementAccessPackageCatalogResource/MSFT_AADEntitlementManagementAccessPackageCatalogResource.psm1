Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADEntitlementManagementAccessPackageCatalogResource'

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

    Write-Verbose -Message "Getting configuration of AzureAD Entitlement Management Access Package Catalog Resource for DisplayName {$DisplayName}"

    try
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
            $ObjectGuid = [System.Guid]::empty
            if (-not [System.Guid]::TryParse($CatalogId, [System.Management.Automation.PSReference]$ObjectGuid))
            {
                $catalogInstance = Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq '$($catalogId -replace "'", "''")'"
                $CatalogId = $catalogInstance.Id
                $CatalogIdValue = $catalogInstance.DisplayName
            }

            $getValue = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource `
                -AccessPackageCatalogId $CatalogId `
                -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Retrieving Resource by Display Name {$DisplayName}"
                $getValue = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource `
                    -AccessPackageCatalogId $CatalogId `
                    -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" -ErrorAction SilentlyContinue
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
            OriginId              = $OriginId
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

        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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

    Write-Verbose -Message "Setting configuration of AzureAD Entitlement Management Access Package Catalog Resource for DisplayName {$DisplayName}"

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

    $PSBoundParameters.Remove('addedBy') | Out-Null
    $PSBoundParameters.Remove('addedOn') | Out-Null
    $PSBoundParameters.Remove('isPendingOnboarding') | Out-Null

    $resource = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $ObjectGuid = [System.Guid]::empty
    if ($OriginSystem -eq 'AADGroup' -and `
            -not [System.Guid]::TryParse($OriginId, [System.Management.Automation.PSReference]$ObjectGuid))
    {
        Write-Verbose -Message "The Group reference was provided by name {$OriginId}. Retrieving associated id."
        $groupInfo = Get-MgGroup -Filter "DisplayName eq '$($OriginId -replace "'", "''")'"
        if ($null -ne $groupInfo)
        {
            $resource.OriginId = $groupInfo.Id
        }
    }
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $ObjectGuid = [System.Guid]::empty
        if (-not [System.Guid]::TryParse($CatalogId, [System.Management.Automation.PSReference]$ObjectGuid))
        {
            Write-Verbose -Message 'Retrieving Catalog by Display Name'
            $catalogInstance = Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq '$($CatalogId -replace "'", "''")'"
            if ($catalogInstance)
            {
                $CatalogId = $catalogInstance.Id
            }
        }
        Write-Verbose -Message "Assigning resource {$DisplayName} to catalog {$CatalogId}"

        $resource.Remove('Id') | Out-Null
        $resource.Remove('CatalogId') | Out-Null

        #Preparing embedded Cim Instances
        $keys = (([Hashtable]$resource).Clone()).Keys
        foreach ($key in $keys)
        {
            $keyValue = $resource.$key
            if ($null -ne $resource.$key -and $resource.$key.GetType().Name -like '*cimInstance*')
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

        $resource = ([Hashtable]$PSBoundParameters).Clone()
        $ObjectGuid = [System.Guid]::empty
        if (-not [System.Guid]::TryParse($CatalogId, [System.Management.Automation.PSReference]$ObjectGuid))
        {
            Write-Verbose -Message 'Retrieving Catalog by Display Name'
            $catalogInstance = Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq '$($CatalogId -replace "'", "''")'"
            if ($catalogInstance)
            {
                $CatalogId = $catalogInstance.Id
            }
        }
        #$resource.Remove('Id') | Out-Null
        $resource.Remove('CatalogId') | Out-Null
        $resource.Remove('Verbose') | Out-Null

        #Preparing embedded Cim Instances
        $keys = (([Hashtable]$resource).Clone()).Keys
        foreach ($key in $keys)
        {
            $keyValue = $resource.$key
            if ($null -ne $resource.$key -and $resource.$key.GetType().Name -like '*cimInstance*')
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

        $resource = ([Hashtable]$PSBoundParameters).Clone()

        $resource.Remove('Id') | Out-Null
        $resource.Remove('CatalogId') | Out-Null
        $resource.Remove('Verbose') | Out-Null

        #Preparing embedded Cim Instances
        $keys = (([Hashtable]$resource).Clone()).Keys
        foreach ($key in $keys)
        {
            $keyValue = $resource.$key
            if ($null -ne $resource.$key -and $resource.$key.GetType().Name -like '*cimInstance*')
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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
    return $result
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
        $catalogs += Get-MgBetaEntitlementManagementAccessPackageCatalog -All -Filter $Filter -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($catalogs.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        foreach ($catalog in $catalogs)
        {
            $displayedKey = $catalog.id
            if (-not [String]::IsNullOrEmpty($catalog.displayName))
            {
                $displayedKey = $catalog.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($catalogs.Count)] $displayedKey" -DeferWrite

            $catalogId = $catalog.id

            [array]$resources = Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource -AccessPackageCatalogId $catalogId -ErrorAction Stop

            $j = 1

            if ($resources.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }

            foreach ($resource in $resources)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-M365DSCHost -Message "        |---[$j/$($resources.Count)] $($resource.DisplayName)" -DeferWrite

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

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential `
                    -NoEscape @('Attributes')
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                $j++
            }

            $i++
        }

        # Removing comma between items in cim instance array
        $dscContent = $dscContent.Replace("            ,`r`n", '')
        return $dscContent
    }
    catch
    {
        if ($_.ErrorDetails.Message -like '*User is not authorized to perform the operation.*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) Tenant does not meet license requirement to extract this component."
            return ''
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('AddedBy', 'AddedOn', 'IsPendingOnboarding')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
