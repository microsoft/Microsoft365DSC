
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
        [System.Boolean]  
        $IsDefault,  
  
        [Parameter()]  
        [System.Boolean]  
        $IsDefaultArbitrationMailbox,  
  
        [Parameter()]  
        [System.String]  
        $Name,  
  
        [Parameter()]  
        [System.Guid]  
        $RetentionId,  
  
        [Parameter()]  
        [System.String[]]  
        $RetentionPolicyTagLinks,  
  
        [Parameter()]  
        [System.Management.Automation.PSCredential]  
        $Credential,  

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',
  
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
        [Switch]  
        $ManagedIdentity,  
  
        [Parameter()]  
        [System.String[]]  
        $AccessTokens  
    )  
  
    New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters | Out-Null  
  
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
    try  
    {  
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)  
        {  
            $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Identity -eq $Identity}  
        }  
        else  
        {  
            $instance = Get-RetentionPolicy -Identity $Identity -ErrorAction Stop  
        }  
        if ($null -eq $instance)  
        {  
            return $nullResult  
        }  
  
        $results = @{  
            Ensure                = 'Present'  
            Identity              = [System.String]$instance.Identity  
            IsDefault             = [System.Boolean]$instance.IsDefault  
            IsDefaultArbitrationMailbox = [System.Boolean]$instance.IsDefaultArbitrationMailbox  
            Name                  = [System.String]$instance.Name  
            RetentionId           = [System.Guid]$instance.RetentionId  
            RetentionPolicyTagLinks = [System.String[]]$instance.RetentionPolicyTagLinks  
            Credential            = $Credential  
            ApplicationId         = $ApplicationId  
            TenantId              = $TenantId  
            CertificateThumbprint = $CertificateThumbprint  
            ManagedIdentity       = $ManagedIdentity.IsPresent  
            AccessTokens          = $AccessTokens  
        }  
        return [System.Collections.Hashtable] $results  
    }  
    catch  
    {  
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential  
  
        return $nullResult  
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
        [System.Boolean]  
        $IsDefault,  
  
        [Parameter()]  
        [System.Boolean]  
        $IsDefaultArbitrationMailbox,  
  
        [Parameter()]  
        [System.String]  
        $Name,  
  
        [Parameter()]  
        [System.Guid]  
        $RetentionId,  
  
        [Parameter()]  
        [System.String[]]  
        $RetentionPolicyTagLinks,  

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
        [Switch]  
        $ManagedIdentity,  
  
        [Parameter()]  
        [System.String[]]  
        $AccessTokens  
    )  
  
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
  
    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters  
  
    # CREATE  
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')  
    {  
        $setParameters.Remove("Identity")
        New-RetentionPolicy @SetParameters  
    }  
    # UPDATE  
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')  
    {  
        Set-RetentionPolicy @SetParameters -Force 
    }  
    # REMOVE  
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')  
    {  
        Remove-RetentionPolicy -Identity $Identity  -Force
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
        [System.Boolean]  
        $IsDefault,  
  
        [Parameter()]  
        [System.Boolean]  
        $IsDefaultArbitrationMailbox,  
  
        [Parameter()]  
        [System.String]  
        $Name,  
  
        [Parameter()]  
        [System.Guid]  
        $RetentionId,  
  
        [Parameter()]  
        [System.String[]]  
        $RetentionPolicyTagLinks,  

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
        [Switch]  
        $ManagedIdentity,  
  
        [Parameter()]  
        [System.String[]]  
        $AccessTokens  
    )  
  
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
  
    $CurrentValues = Get-TargetResource @PSBoundParameters  
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()  
  
    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"  
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"  
  
    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys  
  
    Write-Verbose -Message "Test-TargetResource returned $testResult"  
  
    return $testResult  
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
        $ManagedIdentity,  
  
        [Parameter()]  
        [System.String[]]  
        $AccessTokens  
    )  
  
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters  
  
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
        $Script:ExportMode = $true  
        [array] $Script:exportedInstances = Get-RetentionPolicy -ErrorAction Stop  
  
        $i = 1  
        $dscContent = ''  
        if ($Script:exportedInstances.Length -eq 0)  
        {  
            Write-Host $Global:M365DSCEmojiGreenCheckMark  
        }  
        else  
        {  
            Write-Host "`r`n" -NoNewline  
        }  
        foreach ($config in $Script:exportedInstances)  
        {  
            $displayedKey = $config.Identity  
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline  
            $params = @{  
                Identity              = $config.Identity  
                Credential            = $Credential  
                ApplicationId         = $ApplicationId  
                TenantId              = $TenantId  
                CertificateThumbprint = $CertificateThumbprint  
                ManagedIdentity       = $ManagedIdentity.IsPresent  
                AccessTokens          = $AccessTokens  
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
            $i++  
            Write-Host $Global:M365DSCEmojiGreenCheckMark  
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
Export-ModuleMember -Function *-TargetResource
