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
        [System.String]
        $MembershipRule,

        [Parameter()]
        [System.String]
        [ValidateSet('Assigned', 'Dynamic')]
        $MembershipType,

        [Parameter()]
        [System.String]
        [ValidateSet('On', 'Paused')]
        $MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [System.String]
        [ValidateSet('Public', 'HiddenMembership')]
        $Visibility,

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
        $ManagedIdentity
    )

    Write-Verbose -Message 'Getting configuration of Azure AD Administrative Unit'
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'Beta'

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
    try
    {
        $administrativeUnit = $null
        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            $administrativeUnit = Get-MgAdministrativeUnit -AdministrativeUnitId $Id -ExpandProperty Members
        }

        if ($null -eq $administrativeUnit)
        {
            $administrativeUnit = Get-MgAdministrativeUnit -Filter "displayName eq '$DisplayName'" -ExpandProperty Members
        }

        if ($null -eq $administrativeUnit)
        {
            return $nullReturn
        }
        else
        {
            $returnValue = @{
                Description                   = $administrativeUnit.Description
                DisplayName                   = $administrativeUnit.DisplayName
                Id                            = $administrativeUnit.Id
                Visibility                    = $administrativeUnit.Visibility
                Credential                    = $Credential
                ApplicationId                 = $ApplicationId
                TenantId                      = $TenantId
                ApplicationSecret             = $ApplicationSecret
                CertificateThumbprint         = $CertificateThumbprint
                ManagedIdentity               = $ManagedIdentity.IsPresent
                Ensure                        = 'Present'
            }

            if ($administrativeUnit.AdditionalProperties -and $administrativeUnit.AdditionalProperties.membershipType -eq 'Dynamic')
            {
                $returnValue.Add("MembershipRule", $administrativeUnit.AdditionalProperties.membershipRule)
                $returnValue.Add("MembershipType", $administrativeUnit.AdditionalProperties.membershipType)
                $returnValue.Add("MembershipRuleProcessingState", $administrativeUnit.AdditionalProperties.membershipRuleProcessingState)
            }
            elseif ($administrativeUnit.Members)
            {
                $MembersValue = Get-M365DSCAADAdministrativeUnitMembersAsHashtable -Members $administrativeUnit.Members
                $returnValue.Add("Members", $MembersValue)
                $returnValue.Add("MembershipType", 'Assigned')
            }
            return $returnValue
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
        [System.String]
        $MembershipRule,

        [Parameter()]
        [System.String]
        [ValidateSet('Assigned', 'Dynamic')]
        $MembershipType,

        [Parameter()]
        [System.String]
        [ValidateSet('On', 'Paused')]
        $MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [System.String]
        [ValidateSet('Public', 'HiddenMembership')]
        $Visibility,

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
        $ManagedIdentity
    )

    Write-Verbose -Message 'Setting configuration of Azure AD Administrative Unit'

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

    $currentAADAdministrativeUnit = Get-TargetResource @PSBoundParameters

    # Converts back members into Group or User IDs
    <#[Array]$MembersValue = @()
    foreach ($member in $currentParameters.Members)
    {
        if ($member.Type -eq 'User')
        {
            $instance = Get-MgUser -UserID $Member.Name
        }
        elseif ($member.Type -eq 'Group')
        {
            $instance = Get-MgGroup -Filter "DisplayName eq '$($Member.Name)'"
        }
        $currentValue = @{
            Id = $instance.id
        }
        $MembersValue += $currentValue
    }
    $currentParameters.Members = $MembersValue#>
    if ($null -ne $Members)
    {
        Write-Verbose -Message "This resource cannot configure assigned membership. It can only report on them at the moment."
    }

    $BodyParameter = @{
        DisplayName = $DisplayName
    }

    if (-not [System.String]::IsNullOrEmpty($Description))
    {
        $BodyParameter.Add("Description", $Description)
    }

    if (-not [System.String]::IsNullOrEmpty($currentAADAdministrativeUnit.MembershipRule))
    {
        $BodyParameter.Add("MembershipRule", $currentAADAdministrativeUnit.MembershipRule)
    }

    if (-not [System.String]::IsNullOrEmpty($currentAADAdministrativeUnit.MembershipType))
    {
        $BodyParameter.Add("MembershipType", $currentAADAdministrativeUnit.MembershipType)
    }

    if (-not [System.String]::IsNullOrEmpty($currentAADAdministrativeUnit.MembershipRuleProcessingState))
    {
        $BodyParameter.Add("MembershipRuleProcessingState", $currentAADAdministrativeUnit.MembershipRuleProcessingState)
    }

    # Should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADAdministrativeUnit.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating New AzureAD Administrative Unit {$DisplayName}"
        New-MgAdministrativeUnit -BodyParameter $BodyParameter
    }
    # Should exist and will be configured to desired state
    if ($Ensure -eq 'Present' -and $currentAADAdministrativeUnit.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing AzureAD administrative unit {$DisplayName}"
        Update-MgAdministrativeUnit -BodyParameter $BodyParameter -AdministrativeUnitId $currentAADAdministrativeUnit.Id
    }
    # Exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADAdministrativeUnit.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD administrative unit {$DisplayName}"
        Remove-MgAdministrativeUnit -AdministrativeUnitId $currentAADAdministrativeUnit.Id
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
        [System.String]
        $MembershipRule,

        [Parameter()]
        [System.String]
        [ValidateSet('Assigned', 'Dynamic')]
        $MembershipType,

        [Parameter()]
        [System.String]
        [ValidateSet('On', 'Paused')]
        $MembershipRuleProcessingState,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Members,

        [Parameter()]
        [System.String]
        [ValidateSet('Public', 'HiddenMembership')]
        $Visibility,

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
        $ManagedIdentity
    )

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

    Write-Verbose -Message 'Testing configuration of AzureAD role definition'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

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
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'Beta'
    $MaximumFunctionCount = 32000
    Select-MgProfile -Name 'beta'

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

    $dscContent = ''
    $i = 1
    try
    {
        [array]$AADAdministrativeUnits = Get-MgAdministrativeUnit -Filter $Filter -All:$true -ErrorAction Stop
        if ($AADAdministrativeUnits.Length -gt 0)
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($AADAdministrativeUnit in $AADAdministrativeUnits)
        {
            Write-Host "    |---[$i/$($AADAdministrativeUnits.Count)] $($AADAdministrativeUnit.DisplayName)" -NoNewline
            $Params = @{
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                ApplicationSecret     = $ApplicationSecret
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                DisplayName           = $AADAdministrativeUnit.DisplayName
                Id                    = $AADAdministrativeUnit.Id
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                if ($null -ne $Results.Members)
                {
                    $Results.Members = Get-M365DSCAADAdministrativeUnitMembersAsString -Members $Results.Members
                }
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                if ($null -ne $Results.Members)
                {
                        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Members"
                        $currentDSCBlock = $currentDSCBlock.Replace("@`$OrganizationName'", "@' + `$OrganizationName")
                }
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ''
    }
}

function Get-M365DSCAADAdministrativeUnitMembersAsHashtable
{
    [CmdletBinding()]
    [OutPutType([System.Collections.Hashtable[]])]
    param(
        [parameter(Mandatory = $true)]
        [System.Object[]]
        $Members
    )
    $MembersValue = @()
    if ($null -ne $Members)
    {
        foreach ($member in $Members)
        {
            try
            {
                $user = Get-MgUser -UserId $member.Id -ErrorAction SilentlyContinue
                if ($null -ne $user)
                {
                    $entry = @{
                        Name = $user.UserPrincipalName
                        Type = "User"
                    }
                }
                else
                {
                    $group = Get-MgGroup -GroupId $member.Id -ErrorAction Stop
                    $entry = @{
                        Name = $group.DisplayName
                        Type = "Group"
                    }
                }
                $MembersValue += $entry
            }
            catch
            {
                Write-Verbose -Message $_
                Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source)
            }
        }
    }
    return $MembersValue
}

function Get-M365DSCAADAdministrativeUnitMembersAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        $Members
    )

    $StringContent = "@(`r`n"
    foreach ($Member in $Members)
    {
        $StringContent += "                MSFT_AADAdministrativeUnitMember`r`n"
        $StringContent += "                {`r`n"
        $StringContent += "                    Name = '$($member.Name.Replace("'", "''"))'`r`n"
        $StringContent += "                    Type = '$($member.Type.Replace("'", "''"))'`r`n"
        $StringContent += "                }`r`n"
    }
    $StringContent += "            )"
    return $StringContent
}

Export-ModuleMember -Function *-TargetResource
