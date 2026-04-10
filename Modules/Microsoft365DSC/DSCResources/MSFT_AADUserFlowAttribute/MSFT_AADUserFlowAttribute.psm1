Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADUserFlowAttribute'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DataType,

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

    Write-Verbose -Message "Getting configuration of the AAD User Flow Attribute with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            Write-Verbose -Message 'Getting configuration of user flow attribute'

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

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $UserFlowAttribute = Get-MgBetaIdentityUserFlowAttribute -IdentityUserFlowAttributeId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $UserFlowAttribute -and -not [System.String]::IsNullOrEmpty($DisplayName))
            {
                $UserFlowAttribute = Get-MgBetaIdentityUserFlowAttribute -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'"
            }
        }
        else
        {
            $UserFlowAttribute = $Script:exportedInstance
        }

        if ($null -eq $UserFlowAttribute)
        {
            return $nullReturn
        }
        Write-Verbose -Message "Found configuration of user flow attribute $($DisplayName)"
        $result = @{
            Id                    = $UserFlowAttribute.Id
            DisplayName           = $UserFlowAttribute.DisplayName
            Description           = $UserFlowAttribute.Description
            DataType              = $UserFlowAttribute.DataType
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
            Credential            = $Credential
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DataType,

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

    Write-Verbose -Message "Setting configuration of user flow attribute: $DisplayName"

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

    $currentUserFlowAttribute = Get-TargetResource @PSBoundParameters

    # doesn't exist but it should
    if ($Ensure -eq 'Present' -and $currentUserFlowAttribute.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "The user flow attribute '$($DisplayName)' does not exist but it should. Creating it."

        try
        {
            New-MgBetaIdentityUserFlowAttribute -DataType $DataType -Description $Description -DisplayName $DisplayName
        }
        catch
        {
            Write-Error -ErrorRecord $_
        }
    }
    #exists but shouldn't
    elseif ($Ensure -eq 'Absent' -and $currentUserFlowAttribute.Ensure -eq 'Present')
    {
        Write-Verbose -Message "User flow attribute '$($DisplayName)' exists but shouldn't. Removing it."
        Remove-MgBetaIdentityUserFlowAttribute -IdentityUserFlowAttributeId $Id
    }
    elseif ($Ensure -eq 'Present' -and $currentUserFlowAttribute.Ensure -eq 'Present')
    {
        Write-Verbose -Message "User flow attribute '$($DisplayNameName)' already exists. Updating settings"

        if ($currentUserFlowAttribute.DisplayName -ne $DisplayName -or $currentUserFlowAttribute.DataType -ne $DataType)
        {
            Write-Warning -Message "There is a deviation in display name and data type for the resource with ID '$($Id)' but these values are not settable so cannot update them."
        }

        Write-Verbose -Message "Updating description of user flow attribute with display name '$($DisplayName)'"
        Update-MgBetaIdentityUserFlowAttribute -IdentityUserFlowAttributeId $Id -Description $Description
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DataType,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    try
    {
        [array] $Script:exportedInstances = Get-MgBetaIdentityUserFlowAttribute -Filter "userFlowAttributeType ne 'builtIn'" -Sort DisplayName -ErrorAction Stop
        $i = 1
        $dscContent = ''
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($userFlowAttribute in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $($userFlowAttribute.DisplayName)" -DeferWrite
            $Params = @{
                Id                    = $userFlowAttribute.Id
                DisplayName           = $userFlowAttribute.DisplayName
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                ApplicationSecret     = $ApplicationSecret
                Credential            = $Credential
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $userFlowAttribute
            $Results = Get-TargetResource @Params
            if ($Results.Ensure -eq 'Present')
            {
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }
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

Export-ModuleMember -Function *-TargetResource
