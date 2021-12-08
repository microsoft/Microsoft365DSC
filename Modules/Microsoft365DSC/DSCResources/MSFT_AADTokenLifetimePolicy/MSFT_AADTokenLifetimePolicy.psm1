function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [Boolean]
        $IsOrganizationDefault,

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
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of AzureAD Token Lifetime Policy"
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
            if ($null -ne $Id)
            {
                $Policy = Get-MgPolicyTokenLifetimePolicy -TokenLifetimePolicyId $Id
            }
        }
        catch
        {
            Write-Verbose -Message "Could not retrieve AzureAD Token Lifetime Policy by ID {$Id}"
        }
        if ($null -eq $Policy)
        {
            try
            {
                $Policy = Get-MgPolicyTokenLifetimePolicy -Filter "DisplayName eq '$DisplayName'"
            }
            catch
            {
                Write-Verbose -Message $_
                Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source)
            }
        }
        if ($null -eq $Policy)
        {
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing AzureAD Policy {$($Policy.DisplayName)}"
            $Result = @{
                Id                    = $Policy.Id
                Description           = $Policy.Description
                Definition            = $Policy.Definition
                DisplayName           = $Policy.DisplayName
                IsOrganizationDefault = $Policy.IsOrganizationDefault
                Ensure                = "Present"
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                ApplicationSecret     = $ApplicationSecret
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [Boolean]
        $IsOrganizationDefault,

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
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD Policy"

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

    $currentAADPolicy = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId")  | Out-Null
    $currentParameters.Remove("TenantId")  | Out-Null
    $currentParameters.Remove("CertificateThumbprint")  | Out-Null
    $currentParameters.Remove("Credential")  | Out-Null
    $currentParameters.Remove("Ensure")  | Out-Null

    # Policy should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADPolicy.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Creating new AzureAD Token Lifetime Policy {$Displayname)}"
        Write-Verbose -Message "Parameters: $($currentParameters | Out-String)}"
        $currentParameters.Remove("Id") | Out-Null
        New-MgPolicyTokenLifetimePolicy @currentParameters
    }
    # Policy should exist and will be configured to desire state
    elseif ($Ensure -eq 'Present' -and $CurrentAADPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing AzureAD Policy {$Displayname)}"
        $currentParameters.Add("TokenLifetimePolicyId", $currentAADPolicy.ID)
        $currentParameters.Remove("Id") | Out-Null
        Update-MgPolicyTokenLifetimePolicy @currentParameters
    }
    # Policy exist but should not
    elseif ($Ensure -eq 'Absent' -and $CurrentAADPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD Policy {$Displayname)}"
        Remove-MgPolicyTokenLifetimePolicy -TokenLifetimePolicyId $currentAADPolicy.ID
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [Boolean]
        $IsOrganizationDefault,

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
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of AzureAD Policy"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
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
        [array]$AADPolicies = Get-MgPolicyTokenLifetimePolicy -ErrorAction Stop

        if ($AADPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($AADPolicy in $AADPolicies)
        {
            Write-Host "    |---[$i/$($AADPolicies.Count)] $($AADPolicy.DisplayName)" -NoNewline
            $Params = @{
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                ApplicationSecret     = $ApplicationSecret
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                DisplayName           = $AADPolicy.DisplayName
                ID                    = $AADPolicy.ID
            }
            $Results = Get-TargetResource @Params

            # Fix quotes inside the Definition's JSON;
            $NewDefinition = @()
            foreach ($item in $Results.Definition)
            {
                $fixedContent = $item.Replace('"', '`"')
                $NewDefinition += $fixedContent
            }
            $results.Definition = $NewDefinition

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
