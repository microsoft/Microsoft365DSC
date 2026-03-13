Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADClaimsMappingPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Definition,

        [Parameter()]
        [System.Boolean]
        $IsOrganizationDefault,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,
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

    Write-Verbose -Message "Getting the Azure AD Claims Mapping Policy for DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
            $getValue = Get-MgBetaPolicyClaimMappingPolicy -ClaimsMappingPolicyId $Id -ErrorAction SilentlyContinue

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Claims Mapping Policy with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaPolicyClaimMappingPolicy `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Claims Mapping Policy with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Claims Mapping Policy with Id {$Id} and DisplayName {$DisplayName} was found"

        $complexDefinition = @()
        foreach ($getDefinitionJson in $getValue.Definition)
        {
            $getDefinition = ($getDefinitionJson | ConvertFrom-Json)
            $ClaimsSchema = @()
            foreach ($claimschema in $getDefinition.ClaimsMappingPolicy.ClaimsSchema)
            {
                $ClaimsSchema += @{
                    Source        = $claimschema.Source
                    Id            = $claimschema.Id
                    SamlClaimType = $claimschema.SamlClaimType
                }
            }

            $ClaimsTransformation = @()
            foreach ($claimtransformation in $getDefinition.ClaimsMappingPolicy.ClaimsTransformation)
            {
                $inputparams = @()
                foreach ($inputparam in $claimtransformation.InputParameters)
                {
                    $inputparams += @{
                        Value    = $inputparam.Value
                        Id       = $inputparam.Id
                        DataType = $inputparam.DataType
                    }
                }

                $outputClaimsObj = @()
                foreach ($outclaim in $claimtransformation.OutputClaims)
                {
                    $outputClaimsObj += @{
                        ClaimTypeReferenceId    = $outclaim.ClaimTypeReferenceId
                        TransformationClaimType = $outclaim.TransformationClaimType
                    }
                }
                $ClaimsTransformation += @{
                    Id                   = $claimtransformation.Id
                    TransformationMethod = $claimtransformation.TransformationMethod
                    InputParameters      = $inputparams
                    OutputClaims         = $outputClaimsObj
                }
            }

            $complexDefinition += @{
                ClaimsMappingPolicy = @{
                    Version              = $getDefinition.ClaimsMappingPolicy.Version
                    IncludeBasicClaimSet = [bool]$getDefinition.ClaimsMappingPolicy.IncludeBasicClaimSet
                    ClaimsSchema         = $ClaimsSchema
                    ClaimsTransformation = $ClaimsTransformation
                }
            }
        }

        $results = @{
            #region resource generator code
            Definition            = $complexDefinition
            IsOrganizationDefault = $getValue.IsOrganizationDefault
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Definition,

        [Parameter()]
        [System.Boolean]
        $IsOrganizationDefault,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,
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

    Write-Verbose -Message "Setting the Azure AD Claims Mapping Policy for DisplayName {$DisplayName}"

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
        Write-Verbose -Message "Creating an Azure AD Claims Mapping Policy with DisplayName {$DisplayName}"

        $createParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$createParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $createParameters.$key -and $createParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $createParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $createParameters.$key
            }
        }

        $complexDefinitions = $createParameters.Definition
        $createParameters.Remove('Definition') | Out-Null

        $createParameters.Definition = $complexDefinitions | ConvertTo-Json -Depth 10 -Compress:$true

        $policy = New-MgBetaPolicyClaimMappingPolicy -BodyParameter $createParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Claims Mapping Policy with Id {$($currentInstance.Id)}"

        $updateParameters = ([Hashtable]$BoundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters

        $updateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$updateParameters).Clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $updateParameters.$key -and $updateParameters.$key.GetType().Name -like '*CimInstance*')
            {
                $updateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $updateParameters.ClaimsMappingPolicyId
            }
        }

        $complexDefinitions = $UpdateParameters.Definition
        $UpdateParameters.Remove('Definition') | Out-Null

        $UpdateParameters.Definition = $complexDefinitions | ConvertTo-Json -Depth 10 -Compress:$true

        #region resource generator code
        Update-MgBetaPolicyClaimMappingPolicy `
            -ClaimsMappingPolicyId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Claims Mapping Policy with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaPolicyClaimMappingPolicy -ClaimsMappingPolicyId $currentInstance.Id
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
        $Definition,

        [Parameter()]
        [System.Boolean]
        $IsOrganizationDefault,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

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

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
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
        [array]$getValue = Get-MgBetaPolicyClaimMappingPolicy `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.Definition)
            {
                $complexMapping = @(
                    @{
                        Name            = 'ClaimsMappingPolicy'
                        CimInstanceName = 'MSFT_AADClaimsMappingPolicyDefinitionMappingPolicy'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'ClaimsSchema'
                        CimInstanceName = 'AADClaimsMappingPolicyDefinitionMappingPolicyClaimsSchema'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'ClaimsTransformation'
                        CimInstanceName = 'AADClaimsMappingPolicyDefinitionMappingPolicyClaimsTransformation'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'InputParameters'
                        CimInstanceName = 'AADClaimsMappingPolicyDefinitionMappingPolicyClaimsTransformationInputParameter'
                        IsRequired      = $False
                    },
                    @{
                        Name            = 'OutputClaims'
                        CimInstanceName = 'AADClaimsMappingPolicyDefinitionMappingPolicyClaimsTransformationOutputClaims'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Definition `
                    -CIMInstanceName 'MSFT_AADClaimsMappingPolicyDefinition' `
                    -ComplexTypeMapping $complexMapping

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.Definition = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Definition') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Definition')

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
