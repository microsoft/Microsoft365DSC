function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $ClassificationID,

        [Parameter()]
        [System.String]
        $DisplayName,
        
        [Parameter()]
        [ValidateSet("Highest","Higher","High","MediumHigh","Medium","MediumLow","Low","Lower","Lowest")]
        [System.String]
        $DisplayPrecedence="Medium",
        
        [Parameter()]
        [System.String]
        $Name,
        
        [Parameter()]
        [System.Boolean]
        $PermissionMenuVisible,
        
        [Parameter()]
        [System.String]
        $RecipientDescription,
        
        [Parameter()]
        [System.Boolean]
        $RetainClassificationEnabled,
        
        [Parameter()]
        [System.String]
        $SenderDescription,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
        )

    Write-Verbose -Message "Getting Message Classification Configuration for $($Identity)"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $MessageClassifications = Get-MessageClassification -ErrorAction Stop

        $MessageClassification = $MessageClassifications | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $MessageClassification)
        {
            Write-Verbose -Message "Message Classification policy $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity                     = $Identity
                ClassificationID             = $MessageClassification.ClassificationID 
                DisplayName                  = $MessageClassification.DisplayName 
                DisplayPrecedence            = $MessageClassification.DisplayPrecedence
                Name                         = $MessageClassification.Name
                PermissionMenuVisible        = $MessageClassification.PermissionMenuVisible
                RecipientDescription         = $MessageClassification.RecipientDescription
                RetainClassificationEnabled  = $MessageClassification.RetainClassificationEnabled
                SenderDescription            = $MessageClassification.SenderDescription
                Credential                   = $Credential
                Ensure                       = 'Present'
                ApplicationId                = $ApplicationId
                CertificateThumbprint        = $CertificateThumbprint
                CertificatePath              = $CertificatePath
                CertificatePassword          = $CertificatePassword
                TenantId                     = $TenantId
            }

            Write-Verbose -Message "Found OME Configuration $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        $Identity,

        [Parameter()]
        [System.String]
        $ClassificationID,

        [Parameter()]
        [System.String]
        $DisplayName,
        
        [Parameter()]
        [ValidateSet("Highest","Higher","High","MediumHigh","Medium","MediumLow","Low","Lower","Lowest")]
        [System.String]
        $DisplayPrecedence="Medium",
        
        [Parameter()]
        [System.String]
        $Name,
        
        [Parameter()]
        [System.Boolean]
        $PermissionMenuVisible,
        
        [Parameter()]
        [System.String]
        $RecipientDescription,
        
        [Parameter()]
        [System.Boolean]
        $RetainClassificationEnabled,
        
        [Parameter()]
        [System.String]
        $SenderDescription,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
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

    Write-Verbose -Message "Setting configuration of Message Classification for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $MessageClassifications = Get-MessageClassification
    $MessageClassification = $MessageClassifications | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $MessageClassificationParams = [System.Collections.Hashtable]($PSBoundParameters)
    $MessageClassificationParams.Remove('Ensure') | Out-Null
    $MessageClassificationParams.Remove('Credential') | Out-Null
    $MessageClassificationParams.Remove('ApplicationId') | Out-Null
    $MessageClassificationParams.Remove('TenantId') | Out-Null
    $MessageClassificationParams.Remove('CertificateThumbprint') | Out-Null
    $MessageClassificationParams.Remove('CertificatePath') | Out-Null
    $MessageClassificationParams.Remove('CertificatePassword') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $OMEConfiguration))
    {
        Write-Verbose -Message "Creating Message Classification policy $($Identity)."
        New-MessageClassification @MessageClassificationParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $MessageClassification))
    {
        Write-Verbose -Message "Setting Message Classication policy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $OMEConfigurationParams)"
        Set-MessageClassification @MessageClassificationParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $MessageClassification))
    {
        Write-Verbose -Message "Removing Message Classification policy $($Identity)"
        Remove-MessageClassification -Identity $Identity -Confirm:$false
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
        $Identity,

        [Parameter()]
        [System.String]
        $ClassificationID,

        [Parameter()]
        [System.String]
        $DisplayName,
        
        [Parameter()]
        [ValidateSet("Highest","Higher","High","MediumHigh","Medium","MediumLow","Low","Lower","Lowest")]
        [System.String]
        $DisplayPrecedence="Medium",
        
        [Parameter()]
        [System.String]
        $Name,
        
        [Parameter()]
        [System.Boolean]
        $PermissionMenuVisible,
        
        [Parameter()]
        [System.String]
        $RecipientDescription,
        
        [Parameter()]
        [System.Boolean]
        $RetainClassificationEnabled,
        
        [Parameter()]
        [System.String]
        $SenderDescription,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
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

    Write-Verbose -Message "Testing configuration of Message Classification policy for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $ClassificationID,

        [Parameter()]
        [System.String]
        $DisplayName,
        
        [Parameter()]
        [ValidateSet("Highest","Higher","High","MediumHigh","Medium","MediumLow","Low","Lower","Lowest")]
        [System.String]
        $DisplayPrecedence="Medium",
        
        [Parameter()]
        [System.String]
        $Name,
        
        [Parameter()]
        [System.Boolean]
        $PermissionMenuVisible,
        
        [Parameter()]
        [System.String]
        $RecipientDescription,
        
        [Parameter()]
        [System.Boolean]
        $RetainClassificationEnabled,
        
        [Parameter()]
        [System.String]
        $SenderDescription,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' -InboundParameters $PSBoundParameters -SkipModuleReload $true

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

        [Array]$MessageClassifications = Get-MessageClassification -ErrorAction Stop

        $dscContent = ""

        if ($OMEConfigurations.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($MessageClassification in $MessageClassifications)
        {
            Write-Host "    |---[$i/$($MessageClassifications.Length)] $($MessageClassification.Identity)" -NoNewline

            $Params = @{
                Identity              = $MessageClassification.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }

            $Results = Get-TargetResource @Params
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
        return $dscContent
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}
Export-ModuleMember -Function *-TargetResource
