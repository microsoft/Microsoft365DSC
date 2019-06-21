function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $DynamicScopeLocation,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation = @(),

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException = @(),

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation = @(),

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException = @(),

        [Parameter()]
        [System.String[]]
        $OneDriveLocation = @(),

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException = @(),

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation = @(),

        [Parameter()]
        [System.Boolean]
        $RestrictiveRetention = $true,

        [Parameter()]
        [System.String[]]
        $SharePointLocation = @(),

        [Parameter()]
        [System.String[]]
        $SharePointLocationException = @(),

        [Parameter()]
        [System.String[]]
        $SkypeLocation = @(),

        [Parameter()]
        [System.String[]]
        $SkypeLocationException = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocation = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocationException = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChatLocation = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChatLocationException = @(),

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of RetentionCompliancePolicy for $Name"

    Write-Verbose -Message "Calling Test-SecurityAndComplianceConnection function:"
    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount

    $PolicyObjects = Get-RetentionCompliancePolicy
    $PolicyObject = $PolicyObjects | Where-Object {$_.Name -eq $Name}

    if ($null -eq $PolicyObject)
    {
        Write-Verbose -Message "RetentionCompliancePolicy $($Name) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        Write-Verbose "Found existing RetentionCompliancePolicy $($Name)"
        $result = @{
            Ensure                        = 'Present'
            Name                          = $PolicyObject.Name
            Comment                       = $PolicyObject.Comment
            DynamicScopeLocation          = $PolicyObject.DynamicScopeLocation
            Enabled                       = $PolicyObject.Enabled
            ExchangeLocation              = $PolicyObject.ExchangeLocation
            ExchangeLocationException     = $PolicyObject.ExchangeLocationException
            ModernGroupLocation           = $PolicyObject.ModernGroupLocation
            ModernGroupLocationException  = $PolicyObject.ModernGroupLocationException
            OneDriveLocation              = $PolicyObject.OneDriveLocation
            OneDriveLocationException     = $PolicyObject.OneDriveLocationException
            PublicFolderLocation          = $PolicyObject.PublicFolderLocation
            RestrictiveRetention          = $PolicyObject.RestrictiveRetention
            SharePointLocation            = $PolicyObject.SharePointLocation
            SharePointLocationException   = $PolicyObject.SharePointLocationException
            SkypeLocation                 = $PolicyObject.SkypeLocation
            SkypeLocationException        = $PolicyObject.SkypeLocationException
            TeamsChannelLocation          = $PolicyObject.TeamsChannelLocation
            TeamsChannelLocationException = $PolicyObject.TeamsChannelLocationException
            TeamsChatLocation             = $PolicyObject.TeamsChatLocation
            TeamsChatLocationException    = $PolicyObject.TeamsChatLocationException
        }

        Write-Verbose -Message "Found RetentionCompliancePolicy $($Name)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $DynamicScopeLocation,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation,

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException,

        [Parameter()]
        [System.String[]]
        $OneDriveLocation,

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.Boolean]
        $RestrictiveRetention = $true,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationException,

        [Parameter()]
        [System.String[]]
        $SkypeLocation,

        [Parameter()]
        [System.String[]]
        $SkypeLocationException,

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocation,

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocationException,

        [Parameter()]
        [System.String[]]
        $TeamsChatLocation,

        [Parameter()]
        [System.String[]]
        $TeamsChatLocationException ,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of RetentionCompliancePolicy for $Name"

    Test-SecurityAndComplianceConnection -GlobalAdminAccount $GlobalAdminAccount
    $CurrentPolicy = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentPolicy.Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        New-RetentionCompliancePolicy @CreationParams
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # Easier to delete the Policy and recreate it from scratch;
        Remove-RetentionCompliancePolicy -Identity $Name
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")
        New-RetentionCompliancePolicy @CreationParams
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentPolicy.Ensure))
    {
        # If the Policy exists and it shouldn't, simply remove it;
        Remove-RetentionCompliancePolicy -Identity $Name
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
        $Name,

        [Parameter()]
        [System.String]
        $Comment,

        [Parameter()]
        [System.String[]]
        $DynamicScopeLocation,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation = @(),

        [Parameter()]
        [System.String[]]
        $ExchangeLocationException = @(),

        [Parameter()]
        [System.String[]]
        $ModernGroupLocation = @(),

        [Parameter()]
        [System.String[]]
        $ModernGroupLocationException = @(),

        [Parameter()]
        [System.String[]]
        $OneDriveLocation = @(),

        [Parameter()]
        [System.String[]]
        $OneDriveLocationException = @(),

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation = @(),

        [Parameter()]
        [System.Boolean]
        $RestrictiveRetention = $true,

        [Parameter()]
        [System.String[]]
        $SharePointLocation = @(),

        [Parameter()]
        [System.String[]]
        $SharePointLocationException = @(),

        [Parameter()]
        [System.String[]]
        $SkypeLocation = @(),

        [Parameter()]
        [System.String[]]
        $SkypeLocationException = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocation = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChannelLocationException = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChatLocation = @(),

        [Parameter()]
        [System.String[]]
        $TeamsChatLocationException = @(),

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of RetentionCompliancePolicy for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SCRetentionCompliancePolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
