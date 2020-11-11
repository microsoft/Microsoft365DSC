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
        $AlternativeIdentifier,

        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [Boolean]
        $IsOrganizationDefault,

        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of AzureAD Policy"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters

    try
    {
        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = "Absent"
        try
        {
            if ($null -ne $Id)
            {
                $Policy = Get-AzureADPolicy -ID $Id
            }
        }
        catch
        {
            Write-Verbose -Message "Could not retrieve AzureAD Policy by ID {$Id}"
        }
        if ($null -eq $Policy)
        {
            try
            {
                $Policy = Get-AzureADPolicy -All $True -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like $DisplayName }
            }
            catch
            {
                Write-Verbose -Message $_
                ADD-M365DSCEvent -Message $_ -EntryType 'Error' `
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
                OdataType             = $Policy.OdataType
                AlternativeIdentifier = $Policy.AlternativeIdentifier
                Definition            = $Policy.Definition
                DisplayName           = $Policy.DisplayName
                IsOrganizationDefault = $Policy.IsOrganizationDefault
                Type                  = $Policy.Type
                Ensure                = "Present"
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
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
        $AlternativeIdentifier,

        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [Boolean]
        $IsOrganizationDefault,

        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD Policy"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentAADPolicy = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("OdataType") | Out-Null
    $currentParameters.Remove("ApplicationId")  | Out-Null
    $currentParameters.Remove("TenantId")  | Out-Null
    $currentParameters.Remove("CertificateThumbprint")  | Out-Null
    $currentParameters.Remove("GlobalAdminAccount")  | Out-Null
    $currentParameters.Remove("Ensure")  | Out-Null

    # Policy should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADPolicy.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Creating New AzureAD Policy {$Displayname)}"
        $currentParameters.Remove("Id") | Out-Null
        New-AzureADPolicy @currentParameters
    }
    # Policy should exist and will be configured to desire state
    elseif ($Ensure -eq 'Present' -and $CurrentAADPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating exisitng AzureAD Policy {$Displayname)}"
        $currentParameters.Id = $currentAADPolicy.ID
        Set-AzureADPolicy @currentParameters
    }
    # Policy exist but should not
    elseif ($Ensure -eq 'Absent' -and $CurrentAADPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD Policy {$Displayname)}"
        Remove-AzureADPolicy -ID $currentAADPolicy.ID
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
        $AlternativeIdentifier,

        [Parameter()]
        [System.String[]]
        $Definition,

        [Parameter()]
        [Boolean]
        $IsOrganizationDefault,

        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of AzureAD Policy"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters
    $i = 1
    Write-Host "`r`n" -NoNewline
    try
    {
        $AADPolicys = Get-AzureADPolicy -ErrorAction Stop
        foreach ($AADPolicy in $AADPolicys)
        {
            Write-Host "    |---[$i/$($AADPolicys.Count)] $($AADPolicy.DisplayName)" -NoNewline
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
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
                $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -GlobalAdminAccount $GlobalAdminAccount
                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
