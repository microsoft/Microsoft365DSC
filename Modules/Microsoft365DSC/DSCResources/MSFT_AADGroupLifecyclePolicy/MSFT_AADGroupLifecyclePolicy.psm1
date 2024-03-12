function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $GroupLifetimeInDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('All', 'Selected', 'None')]
        $ManagedGroupTypes,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $AlternateNotificationEmails,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $PSBoundParameters

    Write-Verbose -Message 'Getting configuration of AzureAD Groups Lifecycle Policy'

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
        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = 'Absent'

        try
        {
            $Policy = Get-MgGroupLifecyclePolicy -ErrorAction SilentlyContinue
        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error retrieving data:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        if ($null -eq $Policy)
        {
            return $nullReturn
        }
        else
        {
            Write-Verbose 'Found existing AzureAD Groups Lifecycle Policy'
            $result = @{
                IsSingleInstance            = 'Yes'
                GroupLifetimeInDays         = $Policy.GroupLifetimeInDays
                ManagedGroupTypes           = $Policy.ManagedGroupTypes
                AlternateNotificationEmails = $Policy.AlternateNotificationEmails.Split(';')
                Ensure                      = 'Present'
                Credential                  = $Credential
                ApplicationId               = $ApplicationId
                ApplicationSecret           = $ApplicationSecret
                TenantId                    = $TenantId
                CertificateThumbprint       = $CertificateThumbprint
                Managedidentity             = $ManagedIdentity.IsPresent
            }

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
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
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $GroupLifetimeInDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('All', 'Selected', 'None')]
        $ManagedGroupTypes,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $AlternateNotificationEmails,

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

    Write-Verbose -Message 'Setting configuration of Azure AD Groups Lifecycle Policy'

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $PSBoundParameters

    try
    {
        $policy = Get-MgGroupLifecyclePolicy -ErrorAction SilentlyContinue
    }
    catch
    {
        Write-Verbose -Message $_
        return
    }

    $currentPolicy = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "The Group Lifecycle Policy should exist but it doesn't. Creating it."
        $creationParams = $PSBoundParameters
        $creationParams.Remove('IsSingleInstance')
        $creationParams.Remove('Credential')
        $creationParams.Remove('ApplicationId')
        $creationParams.Remove('TenantId')
        $creationParams.Remove('CertificateThumbprint')
        $creationParams.Remove('ManagedIdentity')
        $creationParams.Remove('Ensure')

        $emails = ''
        foreach ($email in $creationParams.AlternateNotificationEmails)
        {
            $emails += $email + ';'
        }
        $emails = $emails.TrimEnd(';')
        $creationParams.AlternateNotificationEmails = $emails
        New-MgGroupLifecyclePolicy @creationParams
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        $updateParams = $PSBoundParameters
        $updateParams.Remove('IsSingleInstance')
        $updateParams.Remove('Credential')
        $updateParams.Remove('ApplicationId')
        $updateParams.Remove('TenantId')
        $updateParams.Remove('CertificateThumbprint')
        $updateParams.Remove('ManagedIdentity')
        $updateParams.Remove('Ensure')

        $emails = ''
        foreach ($email in $updateParams.AlternateNotificationEmails)
        {
            $emails += $email + ';'
        }
        $emails = $emails.TrimEnd(';')
        $updateParams.AlternateNotificationEmails = $emails
        $updateParams.Add('GroupLifecyclePolicyId', (Get-MgGroupLifecyclePolicy).Id)

        Write-Verbose -Message "The Group Lifecycle Policy exists but it's not in the Desired State. Updating it."
        Update-MgGroupLifecyclePolicy @updateParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'The Group Lifecycle Policy should NOT exist but it DOES. Removing it.'
        Remove-MgGroupLifecyclePolicy -GroupLifecyclePolicyId (Get-MgGroupLifecyclePolicy).Id
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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.UInt32]
        $GroupLifetimeInDays,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('All', 'Selected', 'None')]
        $ManagedGroupTypes,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $AlternateNotificationEmails,

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

    Write-Verbose -Message 'Testing configuration of AzureAD Groups Lifecycle Policy'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' -InboundParameters $PSBoundParameters

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

    $organization = ''
    $principal = '' # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    try
    {
        if ($ConnectionMode -eq 'ServicePrincipalWithThumbprint')
        {
            $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId `
                -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
        }
        elseif ($ConnectionMode -eq 'ServicePrincipalWithSecret')
        {
            $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId `
                -TenantId $TenantId -ApplicationSecret $ApplicationSecret
        }
        elseif ($ConnectionMode -eq 'ManagedIdentity')
        {
            $organization = $TenantId
        }
        else
        {
            if ($null -ne $Credential -and $Credential.UserName.Contains('@'))
            {
                $organization = $Credential.UserName.Split('@')[1]
            }
        }
        if ($organization.IndexOf('.') -gt 0)
        {
            $principal = $organization.Split('.')[0]
        }

        try
        {
            $Policy = Get-MgGroupLifecyclePolicy -ErrorAction SilentlyContinue
        }
        catch
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            return ''
        }

        $dscContent = ''

        $Params = @{
            Credential                  = $Credential
            IsSingleInstance            = 'Yes'
            GroupLifetimeInDays         = 1
            ManagedGroupTypes           = 'All'
            AlternateNotificationEmails = 'empty@contoso.com'
            ApplicationId               = $ApplicationId
            ApplicationSecret           = $ApplicationSecret
            TenantId                    = $TenantId
            CertificateThumbprint       = $CertificateThumbprint
            Managedidentity             = $ManagedIdentity.IsPresent
        }
        $Results = Get-TargetResource @Params
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
        }

        Write-Host $Global:M365DSCEmojiGreenCheckMark

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

Export-ModuleMember -Function *-TargetResource
