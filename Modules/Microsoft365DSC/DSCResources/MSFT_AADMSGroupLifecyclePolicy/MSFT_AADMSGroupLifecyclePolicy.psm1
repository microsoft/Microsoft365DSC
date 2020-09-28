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

    Write-Verbose -Message "Getting configuration of AzureAD Groups Lifecycle Policy"
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
            $Policy = Get-AzureADMSGroupLifecyclePolicy -ErrorAction SilentlyContinue
        }
        catch
        {
            Write-Verbose -Message $_
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        }

        if ($null -eq $Policy)
        {
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing AzureAD Groups Lifecycle Policy"
            $result = @{
                IsSingleInstance            = 'Yes'
                GroupLifetimeInDays         = $Policy.GroupLifetimeInDays
                ManagedGroupTypes           = $Policy.ManagedGroupTypes
                AlternateNotificationEmails = $Policy.AlternateNotificationEmails.Split(';')
                Ensure                      = "Present"
                GlobalAdminAccount          = $GlobalAdminAccount
                ApplicationId               = $ApplicationId
                TenantId                    = $TenantId
                CertificateThumbprint       = $CertificateThumbprint
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

    Write-Verbose -Message "Setting configuration of Azure AD Groups Lifecycle Policy"
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
        $policy = Get-AzureADMSGroupLifecyclePolicy -ErrorAction SilentlyContinue
    }
    catch
    {
        Write-Verbose $_
        return
    }

    $currentPolicy = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq "Present" -and $currentPolicy.Ensure -eq "Absent")
    {
        Write-Verbose -Message "The Group Lifecycle Policy should exist but it doesn't. Creating it."
        $creationParams = $PSBoundParameters
        $creationParams.Remove("IsSingleInstance")
        $creationParams.Remove("GlobalAdminAccount")
        $creationParams.Remove("ApplicationId")
        $creationParams.Remove("TenantId")
        $creationParams.Remove("CertificateThumbprint")
        $creationParams.Remove("Ensure")

        $emails = ""
        foreach ($email in $creationParams.AlternateNotificationEmails)
        {
            $emails += $email + ";"
        }
        $emails = $emails.TrimEnd(';')
        $creationParams.AlternateNotificationEmails = $emails
        New-AzureADMSGroupLifecyclePolicy @creationParams
    }
    elseif ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present')
    {
        $updateParams = $PSBoundParameters
        $updateParams.Remove("IsSingleInstance")
        $updateParams.Remove("GlobalAdminAccount")
        $updateParams.Remove("ApplicationId")
        $updateParams.Remove("TenantId")
        $updateParams.Remove("CertificateThumbprint")
        $updateParams.Remove("Ensure")

        $emails = ""
        foreach ($email in $updateParams.AlternateNotificationEmails)
        {
            $emails += $email + ";"
        }
        $emails = $emails.TrimEnd(';')
        $updateParams.AlternateNotificationEmails = $emails
        $updateParams.Add("Id", (Get-AzureADMSGroupLifecyclePolicy).Id)

        Write-Verbose -Message "The Group Lifecycle Policy exists but it's not in the Desired State. Updating it."
        Set-AzureADMSGroupLifecyclePolicy @updateParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "The Group Lifecycle Policy should NOT exist but it DOES. Removing it."
        Remove-AzureADMSGroupLifecyclePolicy -Id (Get-AzureADMSGroupLifecyclePolicy).Id
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

    Write-Verbose -Message "Testing configuration of AzureAD Groups Lifecycle Policy"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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

    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    try
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters
        if ($ConnectionMode -eq 'ServicePrincipal')
        {
            $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId `
                -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
        }
        else
        {
            if ($GlobalAdminAccount.UserName.Contains("@"))
            {
                $organization = $GlobalAdminAccount.UserName.Split("@")[1]
            }
        }
        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }

        try
        {
            $Policy = Get-AzureADMSGroupLifecyclePolicy -ErrorAction SilentlyContinue
        }
        catch
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            return ""
        }

        $dscContent = ''

        $Params = @{
                GlobalAdminAccount          = $GlobalAdminAccount
                IsSingleInstance            = 'Yes'
                GroupLifetimeInDays         = 1
                ManagedGroupTypes           = 'All'
                AlternateNotificationEmails = 'empty@contoso.com'
                ApplicationId               = $ApplicationId
                TenantId                    = $TenantId
                CertificateThumbprint       = $CertificateThumbprint
        }
        $Results = Get-TargetResource @Params
        if ($Results.Ensure -eq 'Present')
        {
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
        }
        Write-Host $Global:M365DSCEmojiGreenCheckMark

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
