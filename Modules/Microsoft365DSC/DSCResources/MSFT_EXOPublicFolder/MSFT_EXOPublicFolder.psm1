function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String[]]
        $EformsLocaleId,

        [Parameter()]
        [System.String[]]
        $Mailbox,

        [Parameter()]
        [System.Boolean]
        $Path,

        [Parameter()]
        [System.String]
        $IssueWarningQuota,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Getting Public Folder for $Identity"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        Identity             = $Identity
        EformsLocaleId       = $EformsLocaleId
        Mailbox              = $Mailbox
        Path                 = $Path
        IssueWarningQuota    = $IssueWarningQuota
        Ensure               = 'Absent'
        GlobalAdminAccount   = $GlobalAdminAccount
    }

    try
    {
        if ($Global:CurrentModeIsExport)
        {
            $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters `
                -SkipModuleReload $true
        }
        else
        {
            $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
                -InboundParameters $PSBoundParameters
        }
        # Was a folder name provided?
        if ([System.String]::IsNullOrEmpty($Identity)){
            #query the folders
            #$Folders = Get-PublicFolder -Recurse -ErrorAction SilentlyContinue  | Where-Object {$_.Name -ne "IPM_SUBTREE"}
            $Folders = Get-PublicFolder -Recurse -ErrorAction SilentlyContinue  | Where-Object -FilterScript {$_.Name -ne "IPM_SUBTREE"}
            if ($null -eq $Folders)
            {
                return $nullReturn
            }

            # Check to see if more than one folder is returned
            if ($Folders.Length -gt 0)
            { 
                $folder = Get-PublicFolder -Identity $Folders[0].Identity
            }

            # No folder was returned
            if ($null -eq $Folders)
            {
                Write-Verbose -Message "No Public Folers were found."
                return $nullReturn
            }
        }
        else
        {
            $folder = Get-PublicFolder -Identity $Identity
        }
        # end of folder name check
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        $Message = "Error calling {Get-PublicFolder}"
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
    }

    #check to see if the folder we just queried exist
    if ($null -eq $folder)
    {
        Write-Verbose -Message "Public Folder $($Identity) does not exist."
        return $nullReturn
    }
    else
    {
        $result = @{
            Identity             = $folder.Identity
            EformsLocaleId       = $folder.EformsLocaleId
            Mailbox              = $folder.Mailbox
            Path                 = $folder.Path
            IssueWarningQuota    = $folder.IssueWarningQuota
            Ensure               = 'Present'
            GlobalAdminAccount   = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found Public Folder $($folder.Name)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String[]]
        $EformsLocaleId,

        [Parameter()]
        [System.String[]]
        $Mailbox,

        [Parameter()]
        [System.Boolean]
        $Path,

        [Parameter()]
        [System.String]
        $IssueWarningQuota,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Setting Public Folder: $Identity"

    $EXOPublicFolders = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewEXOPublicFolder = @{
        Identity            = $Identity
        EformsLocaleId      = $EformsLocaleId
        Mailbox             = $Mailbox
        Path                = $Path
        IssueWarningQuota   = $IssueWarningQuota
        Confirm             = $false
    }

    # CASE: Public Folder doesn't exist but should;
    if ($Ensure -eq "Present" -and $EXOPublicFolders.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Public Folder '$($Identity)' does not exist but it should. Create and configure it."
        # Create Offline Address Book
        New-PublicFolder @NewEXOPublicFolder

    }
    # CASE: Public Folder exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $EXOPublicFolders.Ensure -eq "Present")
    {
        Write-Verbose -Message "Public Folder '$($Identity)' exists but it shouldn't. Remove it."
        Remove-PublicFolder -Identity $Identity -Confirm:$false -Force
    }
    # CASE: Public Folder exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $EXOPublicFolders.Ensure -eq "Present")
    {
        Write-Verbose -Message "Public Folder '$($Identity)' already exists, but needs updating."
        Write-Verbose -Message "Public Folder $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $EXOPublicFolder)"
        Set-PublicFolder @EXOPublicFolder
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String[]]
        $EformsLocaleId,

        [Parameter()]
        [System.String[]]
        $Mailbox,

        [Parameter()]
        [System.Boolean]
        $Path,

        [Parameter()]
        [System.String]
        $IssueWarningQuota,

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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Testing Public Folder configuration for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null 
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        $content = ""
        $i = 1
        [array]$Folders = Get-PublicFolder -Recurse | Where-Object {$_.Name -ne "IPM_SUBTRE"}

        foreach ($folder in $Folders)
        {
            Write-Information "    [$i/$($Folders.Length)] $($folder.Name)"
            $params = @{
                Identity           = $folder.Identity
                GlobalAdminAccount = $GlobalAdminAccount
            }

            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                Folder                = $folder
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }

            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        EXOPublicFolder " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            $i++
        }
        return $content
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        $Message = "Error calling {Get-PublicFolder}"
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
    }
}

Export-ModuleMember -Function *-TargetResource
