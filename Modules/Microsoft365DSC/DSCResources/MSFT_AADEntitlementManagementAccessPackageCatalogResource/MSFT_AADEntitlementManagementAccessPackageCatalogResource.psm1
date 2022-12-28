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
        [System.String]
        $DisplayName,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'

        Select-MgProfile 'beta'
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

        #region resource generator code
        $getValue = Get-MgEntitlementManagementAccessPackageCatalogAccessPackageResource `
            -AccessPackageCatalogId  $CatalogId `
            -Filter "Id eq '$Id'" -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "The access package resource with id {$id} was NOT found in catalog {$CatalogId}."
            return $nullResult
        }
        #endregion

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
            CatalogId             = $CatalogId
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
        [System.String]
        $DisplayName,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'

        Select-MgProfile 'beta' -ErrorAction Stop
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

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Assigning resource {$DisplayName} to catalog {$CatalogId}"

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
            -Mapping $mapping

        #Preparing parameter splat
        $resourceRequest = @{
            CatalogId             = $CatalogId
            RequestType           = 'AdminAdd'
            AccessPackageresource = $resource
        }
        #region resource generator code
        New-MgEntitlementManagementAccessPackageResourceRequest @resourceRequest

        #endregion

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating resource {$DisplayName} in catalog {$CatalogId}"

        $resource = ([Hashtable]$PSBoundParameters).clone()

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
            -Mapping $mapping

        #region resource generator code
        $resourceRequest = @{
            CatalogId             = $CatalogId
            RequestType           = 'AdminUpdate'
            AccessPackageresource = $resource
        }
        #region resource generator code
        #write-verbose ($resourceRequest|convertTo-Json -depth 20)
        New-MgEntitlementManagementAccessPackageResourceRequest @resourceRequest

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
            -Mapping $mapping


        #region resource generator code
        $resourceRequest = @{
            CatalogId             = $CatalogId
            RequestType           = 'AdminRemove'
            AccessPackageresource = $resource
        }
        #region resource generator code
        New-MgEntitlementManagementAccessPackageResourceRequest @resourceRequest

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
        [System.String]
        $Id,

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
        [System.String]
        $DisplayName,

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

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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

    Write-Verbose -Message "Testing access package resource {$DisplayName} from catalog {$CatalogId}"

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
                break;
            }

            $ValuesToCheck.Remove($key) | Out-Null

        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('AddedBy') | Out-Null
    $ValuesToCheck.Remove('AddedOn') | Out-Null
    $ValuesToCheck.Remove('IsPendingOnboarding') | Out-Null

    #Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    #Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta' -ErrorAction Stop

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
        $catalogs += Get-MgEntitlementManagementAccessPackageCatalog -All -ErrorAction Stop

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

            [array]$resources = Get-MgEntitlementManagementAccessPackageCatalogAccessPackageResource -AccessPackageCatalogId  $catalogId -ErrorAction Stop

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
                Write-Host "        |---[$j/$($resources.Count)] $($resource.DisplayName)" -NoNewline

                $params = @{
                    id                    = $resource.id
                    CatalogId             = $catalogId
                    Ensure                = 'Present'
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
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
                Write-Host $Global:M365DSCEmojiGreenCheckMark

                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                $j++
            }

            $i++
            #Write-Host $Global:M365DSCEmojiGreenCheckMark
        }

        #Removing coma between items in cim instance array
        $dscContent = $dscContent.replace("            ,`r`n", '')
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

function Rename-M365DSCCimInstanceParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties,

        [Parameter()]
        [System.Collections.Hashtable]
        $Mapping = @{'odataType' = '@odata.Type' }
    )

    $keys = $Properties.clone().keys
    foreach ($key in $keys)
    {
        if ($null -ne $Properties.$key)
        {
            $keyType = $Properties.$key.GetType().Fullname
            if ($keyType -like '*[[\]]')
            {
                foreach ($property in $Properties.$key)
                {
                    $property = Rename-M365DSCCimInstanceParameter `
                        -Properties $property `
                        -Mapping $Mapping
                }
            }
            else
            {
                if ($keyType -like '*Hashtable')
                {
                    if ($key -in $Mapping.keys)
                    {
                        $Properties.add($Mapping.$key, $Properties.$key)
                        $Properties.remove($key)
                        $key = $Mapping.$key
                    }

                    $Properties.$key = Rename-M365DSCCimInstanceParameter `
                        -Properties $Properties.$key `
                        -Mapping $Mapping
                }
                else
                {
                    if ($key -in $Mapping.keys)
                    {
                        $Properties.add($Mapping.$key, $Properties.$key)
                        $Properties.remove($key)
                    }
                }
            }
        }
    }
    return $Properties
}

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }


    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        return $ComplexObject
    }
    if ($ComplexObject.getType().Fullname -like '*hashtable[[\]]')
    {
        return , [hashtable[]]$ComplexObject
    }


    if ($ComplexObject.gettype().fullname -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }

    $results = @{}

    if ($ComplexObject.getType().Name -like 'Dictionary*')
    {
        $ComplexObject = [hashtable]::new($ComplexObject)
        $keys = $ComplexObject.Keys
        foreach ($key in $keys)
        {

            if ($null -ne $ComplexObject.$key)
            {
                $keyName = $key#.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

                $keyType = $ComplexObject.$key.gettype().fullname
                if ($keyType -like '*CimInstance*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' )
                {
                    $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$key

                    $results.Add($keyName, $hash)
                }
                else
                {
                    $results.Add($keyName, $ComplexObject.$key)
                }
            }
        }
        return [hashtable]$results
    }

    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties' }

    foreach ($key in $keys)
    {

        if ($null -ne $ComplexObject.$($key.Name))
        {
            $keyName = $key.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

            if ($ComplexObject.$($key.Name).gettype().fullname -like '*CimInstance*')
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$($key.Name)

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$($key.Name))
            }
        }
    }

    return [hashtable]$results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace = '',

        [Parameter()]
        [System.uint32]
        $IndentLevel = 3,

        [Parameter()]
        [switch]
        $isArray = $false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like '*[[\]]')
    {
        $currentProperty = @()
        $IndentLevel++
        foreach ($item in $ComplexObject)
        {
            $splat = @{
                'ComplexObject'   = $item
                'CIMInstanceName' = $CIMInstanceName
                'IndentLevel'     = $IndentLevel
            }
            if ($ComplexTypeMapping)
            {
                $splat.add('ComplexTypeMapping', $ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @splat

        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , $currentProperty
    }

    $currentProperty = ''
    if ($isArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $currentProperty += "MSFT_$CIMInstanceName{`r`n"
    $IndentLevel++
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent += '    '
    }
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($null -ne $ComplexObject.$key)
        {
            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like 'Microsoft.Graph.PowerShell.Models.*' -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType = $ComplexObject[$key].GetType().Name.tolower()

                #overwrite type if object defined in mapping complextypemapping
                if ($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType = ($ComplexTypeMapping | Where-Object -FilterScript { $_.Name -eq $key }).CimInstanceName
                    $hashProperty = $ComplexObject[$key]
                }
                else
                {
                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }

                if (-not $isArray -or ($isArray -and $key -in $ComplexTypeMapping.Name ))
                {
                    $currentProperty += $indent + $key + ' = '
                    if ($ComplexObject[$key].GetType().FullName -like '*[[\]]')
                    {
                        $currentProperty += '@('
                    }
                }

                $currentProperty += Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $hashProperty `
                    -CIMInstanceName $hashPropertyType `
                    -IndentLevel $IndentLevel `
                    -ComplexTypeMapping $ComplexTypeMapping
                if ($ComplexObject.$key.GetType().FullName -like '*[[\]]')
                {
                    $currentProperty += $indent
                    $currentProperty += ')'
                    $currentProperty += "`r`n"

                }
            }
            else
            {
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($indent)
            }
        }
        else
        {
            $mappedKey = $ComplexTypeMapping | Where-Object -FilterScript { $_.name -eq $key }

            if ($mappedKey -and $mappedKey.isRequired)
            {
                if ($mappedKey.isArray)
                {
                    $currentProperty += "$indent$key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$indent$key = `$null`r`n"
                }
            }
        }
    }
    $indent = ''
    for ($i = 0; $i -lt $IndentLevel - 1 ; $i++)
    {
        $indent += '    '
    }
    $currentProperty += "$indent}`r`n"

    #Indenting last parenthese when the cim instance is an array
    if ($IndentLevel -eq 5)
    {
        $indent = ''
        for ($i = 0; $i -lt $IndentLevel - 2 ; $i++)
        {
            $indent += '    '
        }
        $currentProperty += $indent

    }
    return $currentProperty
}

function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space = '                '

    )

    $returnValue = ''
    switch -Wildcard ($Value.GetType().Fullname )
    {
        '*.Boolean'
        {
            $returnValue = $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        '*.String'
        {
            if ($key -eq '@odata.type')
            {
                $key = 'odataType'
            }
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*.DateTime'
        {
            $returnValue = $Space + $Key + " = '" + $Value + "'`r`n"
        }
        '*[[\]]'
        {
            $returnValue = $Space + $key + ' = @('
            $whitespace = ''
            $newline = ''
            if ($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace = $Space + '    '
                $newline = "`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    '*.String'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    '*.DateTime'
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if ($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue = $Space + $Key + ' = ' + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if ($null -eq $Source -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue = ''
    $targetValue = ''
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if ($null -eq $Source)
        {
            $sourceValue = 'Source is null'
        }

        if ($null -eq $Target)
        {
            $targetValue = 'Target is null'
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if ($Source.getType().FullName -like '*CimInstance[[\]]' -or $Source.getType().FullName -like '*Hashtable[[\]]')
    {
        if ($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if ($source.count -eq 0)
        {
            return $true
        }

        $i = 0
        foreach ($item in $Source)
        {

            $compareResult = Compare-M365DSCComplexObject `
                -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$i]) `
                -Target $Target[$i]

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
            $i++
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #write-verbose -message "Comparing key: {$key}"
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key
        if ($key -eq 'odataType')
        {
            #$skey='@odata.type'
        }
        else
        {
            $tmpkey = $Target.keys | Where-Object -FilterScript { $_ -eq "$key" }
            if ($tkey)
            {
                $tkey = $tmpkey | Select-Object -First 1
            }
        }

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$skey) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$skey)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$skey) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$skey.getType().FullName -like '*CimInstance*' -or $Source.$skey.getType().FullName -like '*hashtable*'  )
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$skey) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {

                    Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$skey

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }

            }

        }
    }

    return $true
}

function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )


    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results += $hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($null -ne $hashComplexObject)
    {

        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.remove($key) | Out-Null
                $results.add($propertyName, $propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
