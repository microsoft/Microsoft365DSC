Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SCComplianceTag'

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
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet('Delete', 'Keep', 'KeepAndDelete')]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet('CreationAgeInDays', 'EventAgeInDays', 'ModificationAgeInDays', 'TaggedAgeInDays')]
        [System.String]
        $RetentionType,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of ComplianceTag for $Name"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            $null = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            $tagObject = Get-ComplianceTag -Identity $Name -ErrorAction SilentlyContinue

            if ($null -eq $tagObject)
            {
                Write-Verbose -Message "ComplianceTag $($Name) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $tagObject = $Script:exportedInstance
        }

        Write-Verbose "Found existing ComplianceTag $($Name)"
        $result = @{
            Name                  = $tagObject.Name
            Comment               = $tagObject.Comment
            RetentionDuration     = $tagObject.RetentionDuration
            IsRecordLabel         = $tagObject.IsRecordLabel
            Regulatory            = $tagObject.Regulatory
            Notes                 = $tagObject.Notes
            ReviewerEmail         = $tagObject.ReviewerEmail
            RetentionAction       = $tagObject.RetentionAction
            EventType             = $tagObject.EventType
            RetentionType         = $tagObject.RetentionType
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            Ensure                = 'Present'
            AccessTokens          = $AccessTokens
        }

        if (-not [System.String]::IsNullOrEmpty($tagObject.FilePlanMetadata))
        {
            $ConvertedFilePlanProperty = Get-SCFilePlanProperty $tagObject.FilePlanMetadata
            $result.Add('FilePlanProperty', $ConvertedFilePlanProperty)
        }

        return $result
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet('Delete', 'Keep', 'KeepAndDelete')]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet('CreationAgeInDays', 'EventAgeInDays', 'ModificationAgeInDays', 'TaggedAgeInDays')]
        [System.String]
        $RetentionType,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of ComplianceTag for $Name"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentTag = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentTag.Ensure))
    {
        $CreationParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        #Convert File plan to JSON before Set
        if ($FilePlanProperty)
        {
            Write-Verbose -Message 'Converting FilePlan to JSON'
            $FilePlanPropertyJSON = ConvertTo-Json (Get-SCFilePlanPropertyObject $FilePlanProperty)
            $CreationParams.FilePlanProperty = $FilePlanPropertyJSON
        }
        Write-Verbose "Creating new Compliance Tag $Name calling the New-ComplianceTag cmdlet."
        New-ComplianceTag @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        # Remove unused parameters for Set-ComplianceTag cmdlet
        $SetParams.Remove('Name')
        $SetParams.Remove('IsRecordLabel')
        $SetParams.Remove('Regulatory')
        $SetParams.Remove('RetentionAction')
        $SetParams.Remove('RetentionType')

        # Once set, a label can't be removed;
        if ($SetParams.IsRecordLabel -eq $false -and $CurrentTag.IsRecordLabel -eq $true)
        {
            throw "Can't remove label on the existing Compliance Tag {$Name}. " + `
                'You will need to delete the tag and recreate it.'
        }

        if ($null -ne $PsBoundParameters['Regulatory'] -and
            $Regulatory -ne $CurrentTag.Regulatory)
        {
            throw "SPComplianceTag can't change the Regulatory property on " + `
                "existing tags {$Name} from $Regulatory to $($CurrentTag.Regulatory)." + `
                ' You will need to delete the tag and recreate it.'
        }

        if ($RetentionAction -ne $CurrentTag.RetentionAction)
        {
            throw "SPComplianceTag can't change the RetentionAction property on " + `
                "existing tags {$Name} from $RetentionAction to $($CurrentTag.RetentionAction)." + `
                ' You will need to delete the tag and recreate it.'
        }

        if ($RetentionType -ne $CurrentTag.RetentionType)
        {
            throw "SPComplianceTag can't change the RetentionType property on " + `
                "existing tags {$Name} from $RetentionType to $($CurrentTag.RetentionType)." + `
                ' You will need to delete the tag and recreate it.'
        }

        #Convert File plan to JSON before Set
        if ($FilePlanProperty)
        {
            Write-Verbose -Message 'Converting FilePlan properties to JSON'
            $FilePlanPropertyJSON = ConvertTo-Json (Get-SCFilePlanPropertyObject $FilePlanProperty)
            $SetParams['FilePlanProperty'] = $FilePlanPropertyJSON
        }
        Set-ComplianceTag @SetParams -Identity $Name
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        # If the Rule exists and it shouldn't, simply remove it;
        Remove-ComplianceTag -Identity $Name -Confirm:$false
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
        $Comment,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FilePlanProperty,

        [Parameter()]
        [System.String]
        $RetentionDuration,

        [Parameter()]
        [System.Boolean]
        $IsRecordLabel,

        [Parameter()]
        [System.Boolean]
        $Regulatory,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String[]]
        $ReviewerEmail,

        [Parameter()]
        [ValidateSet('Delete', 'Keep', 'KeepAndDelete')]
        [System.String]
        $RetentionAction,

        [Parameter()]
        [System.String]
        $EventType,

        [Parameter()]
        [ValidateSet('CreationAgeInDays', 'EventAgeInDays', 'ModificationAgeInDays', 'TaggedAgeInDays')]
        [System.String]
        $RetentionType,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$tags = Get-ComplianceTag -ErrorAction Stop

        $totalTags = $tags.Length
        if ($null -eq $totalTags)
        {
            $totalTags = 1
        }
        $i = 1
        if ($tags.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $dscContent = ''
        foreach ($tag in $tags)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($totalTags)] $($tag.Name)" -DeferWrite
            $Script:exportedInstance = $tag
            $Results = Get-TargetResource @PSBoundParameters -Name $tag.Name
            if ($Results.FilePlanProperty)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.FilePlanProperty `
                    -CIMInstanceName 'SCFilePlanProperty'
                if (-not [String]::IsNullOrEmpty($complexTypeStringResult))
                {
                    $Results.FilePlanProperty = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('FilePlanProperty') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('FilePlanProperty')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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

function Get-SCFilePlanPropertyObject
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter()]
        $Properties
    )

    if ($null -eq $Properties)
    {
        return $null
    }

    $result = [PSCustomObject]@{
        Settings = @(
            @{Key = 'FilePlanPropertyDepartment'; Value = $properties.FilePlanPropertyDepartment },
            @{Key = 'FilePlanPropertyCategory'; Value = $properties.FilePlanPropertyCategory },
            @{Key = 'FilePlanPropertySubcategory'; Value = $properties.FilePlanPropertySubcategory },
            @{Key = 'FilePlanPropertyCitation'; Value = $properties.FilePlanPropertyCitation },
            @{Key = 'FilePlanPropertyReferenceId'; Value = $properties.FilePlanPropertyReferenceId },
            @{Key = 'FilePlanPropertyAuthority'; Value = $properties.FilePlanPropertyAuthority }
        )
    }

    return $result
}

function Get-SCFilePlanProperty
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Metadata
    )

    if ($null -eq $Metadata)
    {
        return $null
    }
    $JSONObject = ConvertFrom-Json $Metadata

    $result = @{}

    foreach ($item in $JSONObject.Settings)
    {
        $result.Add($item.Key, $item.Value)
    }

    return $result
}

Export-ModuleMember -Function *-TargetResource
