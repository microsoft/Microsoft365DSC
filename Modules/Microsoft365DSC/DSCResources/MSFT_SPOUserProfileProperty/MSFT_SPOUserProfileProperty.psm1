function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Getting SPO Profile Properties for user {$UserName}"

    $ConnectionMode = New-M365DSCConnection -Workload 'PNP' -InboundParameters $PSBoundParameters

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

    $nullReturn = @{
        UserName = $UserName
        Ensure   = 'Absent'
    }

    try
    {
        $currentProperties = Get-PnPUserProfileProperty -Account $UserName -ErrorAction Stop

        if ($null -eq $currentProperties.AccountName)
        {
            return $nullReturn
        }
        $currentProperties = $currentProperties.UserProfileProperties
        $propertiesValue = @()

        foreach ($key in $currentProperties.Keys)
        {
            $convertedProperty = Get-SPOUserProfilePropertyInstance -Key $key -Value $currentProperties[$key]
            $propertiesValue += $convertedProperty
        }

        $result = @{
            UserName              = $UserName
            Properties            = $propertiesValue
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            Ensure                = 'Present'
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"

        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}
function Set-TargetResource
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Setting Profile Properties for user {$UserName}"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'PNP' -InboundParameters $PSBoundParameters

    $currentProperties = Get-TargetResource @PSBoundParameters

    foreach ($property in $Properties)
    {
        if ($currentProperties.Properties[$property.Key] -ne $property.Value)
        {
            Write-Verbose "Setting Profile Property {$($property.Key)} as {$($property.Value)}"
            try
            {
                Set-PnPUserProfileProperty -Account $UserName -PropertyName $property.Key -Value $property.Value -ErrorAction Stop
            }
            catch
            {
                Write-Warning "Cannot update property {$($property.Key)}. This value of that key cannot be modified."
            }
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $UserName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Properties,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message 'Testing configuration for SPO Sharing settings'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -DesiredValues $PSBoundParameters `
        -Source $($MyInvocation.MyCommand.Source) `
        -CurrentValues $CurrentValues

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
        [ValidateRange(1, 100)]
        $MaxProcesses = 16,

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
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        # Get all instances;
        $instances = Get-PnPUser | Where-Object -FilterScript { $_.PrincipalType -eq 'User' -and '' -ne $_.Email }
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        $i = 1
        foreach ($instance in $Instances)
        {
            Write-Host "    |---[$i/$($Instances.Count)] $($instance.Email)" -NoNewline
            $Params = @{
                UserName              = $instance.Email
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                Credential            = $Credential
            }

            $Results = Get-TargetResource @Params

            if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
            {
                if ($Results.Properties)
                {
                    $Results.Properties = ConvertTo-M365DSCSPOUserProfilePropertyInstanceString -Properties $Results.Properties
                    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                        -Results $Results
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    if ($null -ne $Results.Properties)
                    {
                        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Properties'
                    }
                    $dscContent += $currentDSCBlock
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                }

                Write-Host $Global:M365DSCEmojiGreenCheckMark
            }
            else
            {
                Write-Host $Global:M365DSCEmojiRedX
            }

            $i++
        }

        $organization = ''
        $principal = '' # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
        $organization = Get-M365DSCOrganization -Credential $Credential -TenantId $Tenantid
        if ($organization.IndexOf('.') -gt 0)
        {
            $principal = $organization.Split('.')[0]
        }
        if ($dscContent.ToLower().Contains($organization.ToLower()) -or `
                $dscContent.ToLower().Contains($principal.ToLower()))
        {
            $dscContent = $dscContent -ireplace [regex]::Escape('https://' + $principal + '.sharepoint.com/'), "https://`$(`$OrganizationName.Split('.')[0]).sharepoint.com/"
            $dscContent = $dscContent -ireplace [regex]::Escape('@' + $organization), "@`$(`$OrganizationName)"
        }

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

<#
.Description
This function converts the custom object array into a string

.Functionality
Internal
#>
function ConvertTo-M365DSCSPOUserProfilePropertyInstanceString
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Properties
    )

    $results = @()
    $content = "@(`r`n"
    foreach ($property in $Properties)
    {
        $content += "             MSFT_SPOUserProfilePropertyInstance`r`n"
        $content += "             {`r`n"
        $content += "                Key   = '$($property.Key)'`r`n"
        $content += "                Value = '$($property.Value)'`r`n"
        $content += "            }`r`n"
    }
    $content += '            )'
    return $content
}

Export-ModuleMember -Function *-TargetResource
