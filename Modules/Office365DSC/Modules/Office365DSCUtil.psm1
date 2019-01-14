function Test-SPOServiceConnection {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SPOCentralAdminUrl,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )    
    Write-Verbose "Verifying the LCM connection state to SharePoint Online"
    Connect-SPOService -Url $SPOCentralAdminUrl -Credential $GlobalAdminAccount
}

function Test-O365ServiceConnection {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )    
    Write-Verbose "Verifying the LCM connection state to Microsoft Online Services"
    Connect-MSOLService -Credential $GlobalAdminAccount
}
function Test-TeamsServiceConnection {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )    
    Write-Verbose "Verifying the LCM connection state to Teams"
    Connect-MicrosoftTeams -Credential $GlobalAdminAccount | Out-Null
}

function Invoke-ExoCommand
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,
    
        [Parameter()]
        [Object[]]
        $Arguments,
    
        [Parameter(Mandatory = $true)]
        [ScriptBlock]
        $ScriptBlock
    )
    $VerbosePreference = 'Continue'
    $invokeArgs = @{
        ScriptBlock = [ScriptBlock]::Create($ScriptBlock.ToString())
    }
    if ($null -ne $Arguments) {
        $invokeArgs.Add("ArgumentList", $Arguments)
    }

    Write-Verbose "Verifying the LCM connection state to Exchange Online"
    $AssemblyPath = Join-Path -Path $PSScriptRoot `
        -ChildPath "..\Dependencies\Microsoft.Exchange.Management.ExoPowershellModule.dll" `
        -Resolve
    $AADAssemblyPath = Join-Path -Path $PSScriptRoot `
        -ChildPath "..\Dependencies\Microsoft.IdentityModel.Clients.ActiveDirectory.dll" `
        -Resolve

    $ScriptPath = Join-Path -Path $PSScriptRoot `
        -ChildPath "..\Dependencies\CreateExoPSSession.ps1" `
        -Resolve

    Import-Module $AssemblyPath
    [Reflection.Assembly]::LoadFile($AADAssemblyPath)
    .$ScriptPath

    # Somehow, every now and then, the first connection attempt will get an invalid Shell Id. Calling the function a second
    # time fixes the issue.
    try
    {
        if (!$Global:ExoPSSessionConnected)
        {
            Connect-ExoPSSession -Credential $GlobalAdminAccount -ErrorAction SilentlyContinue
            $Global:ExoPSSessionConnected = $true
        }
    }
    catch {
        # Check to see if we received a payload error, and if so, wait for the requested period of time before proceeding
        # with the next call.
        $stringToFind = "you have exceeded your budget to create runspace. Please wait for "
        if ($Error) {
            $position = $Error[0].ErrorDetails.Message.IndexOf($stringToFind)

            if ($position -ge 0) {
                $beginning = $position + $stringToFind.Length
                $nextSpace = $Error[0].ErrorDetails.Message.IndexOf(" ", $beginning)

                [int]$timeToWaitInSeconds = $Error[0].ErrorDetails.Message.Substring($beginning, $nextSpace - $beginning)

                Write-Verbose "Detected an exceeded payload against the remote server. Waiting for $($timeToWaitInSeconds) seconds."
                Start-Sleep -Seconds $timeToWaitInSeconds
            }
        }
        Connect-ExoPSSession -Credential $GlobalAdminAccount -ErrorAction SilentlyContinue
        $Global:ExoPSSessionConnected = $true
    }

    try
    {
        $result = Invoke-Command @invokeArgs -Verbose
    }
    catch
    {
        Connect-ExoPSSession -Credential $GlobalAdminAccount -ErrorAction SilentlyContinue
        $Global:ExoPSSessionConnected = $true
        $result = Invoke-Command @invokeArgs -Verbose
    }
    
    return $result
}

function Test-Office365DSCParameterState {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 1)]
        [HashTable]
        $CurrentValues,

        [Parameter(Mandatory = $true, Position = 2)]
        [Object]
        $DesiredValues,

        [Parameter(, Position = 3)]
        [Array]
        $ValuesToCheck
    )

    $returnValue = $true

    if (($DesiredValues.GetType().Name -ne "HashTable") `
            -and ($DesiredValues.GetType().Name -ne "CimInstance") `
            -and ($DesiredValues.GetType().Name -ne "PSBoundParametersDictionary")) {
        throw ("Property 'DesiredValues' in Test-SPDscParameterState must be either a " + `
                "Hashtable or CimInstance. Type detected was $($DesiredValues.GetType().Name)")
    }

    if (($DesiredValues.GetType().Name -eq "CimInstance") -and ($null -eq $ValuesToCheck)) {
        throw ("If 'DesiredValues' is a CimInstance then property 'ValuesToCheck' must contain " + `
                "a value")
    }

    if (($null -eq $ValuesToCheck) -or ($ValuesToCheck.Count -lt 1)) {
        $KeyList = $DesiredValues.Keys
    }
    else {
        $KeyList = $ValuesToCheck
    }

    $KeyList | ForEach-Object -Process {
        if (($_ -ne "Verbose") -and ($_ -ne "InstallAccount")) {
            if (($CurrentValues.ContainsKey($_) -eq $false) `
                    -or ($CurrentValues.$_ -ne $DesiredValues.$_) `
                    -or (($DesiredValues.ContainsKey($_) -eq $true) -and ($null -ne $DesiredValues.$_ -and $DesiredValues.$_.GetType().IsArray))) {
                if ($DesiredValues.GetType().Name -eq "HashTable" -or `
                        $DesiredValues.GetType().Name -eq "PSBoundParametersDictionary") {
                    $CheckDesiredValue = $DesiredValues.ContainsKey($_)
                }
                else {
                    $CheckDesiredValue = Test-SPDSCObjectHasProperty -Object $DesiredValues -PropertyName $_
                }

                if ($CheckDesiredValue) {
                    $desiredType = $DesiredValues.$_.GetType()
                    $fieldName = $_
                    if ($desiredType.IsArray -eq $true) {
                        if (($CurrentValues.ContainsKey($fieldName) -eq $false) `
                                -or ($null -eq $CurrentValues.$fieldName)) {
                            Write-Verbose -Message ("Expected to find an array value for " + `
                                    "property $fieldName in the current " + `
                                    "values, but it was either not present or " + `
                                    "was null. This has caused the test method " + `
                                    "to return false.")
                            $returnValue = $false
                        }
                        else {
                            $arrayCompare = Compare-Object -ReferenceObject $CurrentValues.$fieldName `
                                -DifferenceObject $DesiredValues.$fieldName
                            if ($null -ne $arrayCompare) {
                                Write-Verbose -Message ("Found an array for property $fieldName " + `
                                        "in the current values, but this array " + `
                                        "does not match the desired state. " + `
                                        "Details of the changes are below.")
                                $arrayCompare | ForEach-Object -Process {
                                    Write-Verbose -Message "$($_.InputObject) - $($_.SideIndicator)"
                                }
                                $returnValue = $false
                            }
                        }
                    }
                    else {
                        switch ($desiredType.Name) {
                            "String" {
                                if ([string]::IsNullOrEmpty($CurrentValues.$fieldName) `
                                        -and [string]::IsNullOrEmpty($DesiredValues.$fieldName))
                                {}
                                else {
                                    Write-Verbose -Message ("String value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $returnValue = $false
                                }
                            }
                            "Int32" {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {}
                                else {
                                    Write-Verbose -Message ("Int32 value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $returnValue = $false
                                }
                            }
                            "Int16" {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {}
                                else {
                                    Write-Verbose -Message ("Int16 value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $returnValue = $false
                                }
                            }
                            "Boolean" {
                                if ($CurrentValues.$fieldName -ne $DesiredValues.$fieldName) {
                                    Write-Verbose -Message ("Boolean value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $returnValue = $false
                                }
                            }
                            "Single" {
                                if (($DesiredValues.$fieldName -eq 0) `
                                        -and ($null -eq $CurrentValues.$fieldName))
                                {}
                                else {
                                    Write-Verbose -Message ("Single value for property " + `
                                            "$fieldName does not match. " + `
                                            "Current state is " + `
                                            "'$($CurrentValues.$fieldName)' " + `
                                            "and desired state is " + `
                                            "'$($DesiredValues.$fieldName)'")
                                    $returnValue = $false
                                }
                            }
                            default {
                                Write-Verbose -Message ("Unable to compare property $fieldName " + `
                                        "as the type ($($desiredType.Name)) is " + `
                                        "not handled by the " + `
                                        "Test-SPDscParameterState cmdlet")
                                $returnValue = $false
                            }
                        }
                    }
                }
            }
        }
    }
    return $returnValue
}

function Get-UsersLicences {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Store all users licences information in Global Variable for futur usage."
    #Store information to be able to check later if the users is correctly licences for features.
    if ($Global:UsersLicences -eq $NULL) {
        $Global:UsersLicences = Get-MsolUser -All  | Select-Object UserPrincipalName, isLicensed, Licenses
    }
    Return $Global:UsersLicences
}

<# This is the main Office365DSC.Reverse function that extracts the DSC configuration from an existing
   Office 365 Tenant. #>
function Export-O365Configuration
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    $VerbosePreference = 'Continue'
    $AzureAutomation = $false
    $DSCContent = "Configuration O365TenantConfig `r`n{`r`n"
    $DSCContent += "    Import-DSCResource -ModuleName Office365DSC`r`n`r`n"
    $DSCContent += "    <# Credentials #>`r`n"
    $DSCContent += "    Node localhost`r`n"
    $DSCContent += "    {`r`n"
    # Add the GlobalAdminAccount to the Credentials List
    Save-Credentials -UserName $GlobalAdminAccount.UserName

    #region "EXOMailTips"
    $OrgConfig = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                    -ScriptBlock {
        Get-OrganizationConfig
    }

    $organizationName = $OrgConfig.Name
    Add-ConfigurationDataEntry -Node "localhost" `
                               -Key "OrganizationName" `
                               -Value $organizationName `
                               -Description "Name of the Organization"

    $EXOMailTipsModulePath = Join-Path -Path $PSScriptRoot `
                                       -ChildPath "..\DSCResources\MSFT_EXOMailTips\MSFT_EXOMailTips.psm1" `
                                       -Resolve

    Import-Module $EXOMailTipsModulePath
    $DSCContent += Export-TargetResource -Organization $organizationName -GlobalAdminAccount $GlobalAdminAccount
    #endregion

    #region "EXOSharedMailbox"
    $EXOSharedMailboxModulePath = Join-Path -Path $PSScriptRoot `
                                            -ChildPath "..\DSCResources\MSFT_EXOSharedMailbox\MSFT_EXOSharedMailbox.psm1" `
                                            -Resolve

    Import-Module $EXOSharedMailboxModulePath
    $mailboxes = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                   -ScriptBlock {
        Get-Mailbox
    }
    $mailboxes = $mailboxes | Where-Object {$_.RecipientTypeDetails -eq "SharedMailbox"}

    foreach ($mailbox in $mailboxes)
    {
        $mailboxName = $mailbox.Name
        if ($mailboxName)
        {
            $DSCContent += Export-TargetResource -DisplayName $mailboxName -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    #region "O365Group"
    $O365GroupModulePath = Join-Path -Path $PSScriptRoot `
                                     -ChildPath "..\DSCResources\MSFT_O365Group\MSFT_O365Group.psm1" `
                                     -Resolve

    Import-Module $O365GroupModulePath

    # Security Groups
    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    $securityGroups = Get-MSOLGroup | Where-Object {$_.GroupType -eq "Security"}

    foreach ($securityGroup in $securityGroups)
    {
        $securityGroupDisplayName = $securityGroup.DisplayName
        if ($securityGroupDisplayName)
        {
            $DSCContent += Export-TargetResource -DisplayName $securityGroupDisplayName `
                                                 -GroupType "Security" `
                                                 -GlobalAdminAccount $GlobalAdminAccount
        }
    }

    $securityGroups = Get-MSOLGroup | Where-Object {$_.GroupType -eq "Security"}

    # Other Groups
    $groups = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                -ScriptBlock {
        Get-Group
    }
    $groups = $groups | Where-Object { `
        $_.RecipientType -eq "MailUniversalDistributionGroup" `
        -or $_.RecipientType -eq "MailUniversalSecurityGroup" `
    }
    foreach ($group in $groups)
    {
        $groupName = $group.DisplayName
        if ($groupName)
        {
            $groupType = "DistributionList"
            if ($group.RecipientTypeDetails -eq "GroupMailbox")
            {
                $groupType = "Office365"
            }
            elseif ($group.RecipientTypeDetails -eq "MailUniversalSecurityGroup")
            {
                $groupType = "MailEnabledSecurity"
            }
            $DSCContent += Export-TargetResource -DisplayName $groupName `
                                                 -GroupType $groupType `
                                                 -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    #region "O365User"
    $O365UserModulePath = Join-Path -Path $PSScriptRoot `
                                    -ChildPath "..\DSCResources\MSFT_O365USer\MSFT_O365USer.psm1" `
                                    -Resolve

    Import-Module $O365UserModulePath
    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount

    $users = Get-MSOLUser

    foreach ($user in $users)
    {
        $userUPN = $user.UserPrincipalName
        if ($userUPN)
        {
            $DSCContent += Export-TargetResource -UserPrincipalName $userUPN -GlobalAdminAccount $GlobalAdminAccount
        }
    }
    #endregion

    #region "ODSettings"
    $ODSettingsModulePath = Join-Path -Path $PSScriptRoot `
                                      -ChildPath "..\DSCResources\MSFT_ODSettings\MSFT_ODSettings.psm1" `
                                      -Resolve

    Import-Module $ODSettingsModulePath

    # Obtain central administration url from a User Principal Name
    $centralAdminUrl = $null
    if ($users.Count -gt 0)
    {
        $tenantParts = $users[0].UserPrincipalName.Split('@')
        if ($tenantParts.Length -gt 0)
        {
            $tenantName = $tenantParts[1].Split(".")[0]
            $centralAdminUrl = "https://" + $tenantName + "-admin.sharepoint.com"
        }
    }

    if ($centralAdminUrl)
    {
        $DSCContent += Export-TargetResource -CentralAdminUrl $centralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    #region "SPOSite"
    $SPOSiteModulePath = Join-Path -Path $PSScriptRoot `
                                    -ChildPath "..\DSCResources\MSFT_SPOSite\MSFT_SPOSite.psm1" `
                                    -Resolve

    Import-Module $SPOSiteModulePath

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    $sites = Get-SPOSite

    foreach ($site in $sites)
    {
        $DSCContent += Export-TargetResource -Url $site.Url `
                                             -CentralAdminUrl $centralAdminUrl `
                                             -GlobalAdminAccount $GlobalAdminAccount
    }
    #endregion

    # Close the Node and Configuration declarations
    $DSCContent += "    }`r`n"
    $DSCContent += "}`r`n"

    #region Add the Prompt for Required Credentials at the top of the Configuration
    $credsContent = ""
    foreach ($credential in $Global:CredsRepo)
    {
        if (!$credential.ToLower().StartsWith("builtin"))
        {
            if (!$AzureAutomation)
            {
                $credsContent += "    " + (Resolve-Credentials $credential) + " = Get-Credential -UserName `"" + $credential + "`" -Message `"Please provide credentials`"`r`n"
            }
            else
            {
                $resolvedName = (Resolve-Credentials $credential)
                $credsContent += "    " + $resolvedName + " = Get-AutomationPSCredential -Name " + ($resolvedName.Replace("$", "")) + "`r`n"
            }
        }
    }
    $credsContent += "`r`n"
    $startPosition = $DSCContent.IndexOf("<# Credentials #>") + 19
    $DSCContent = $DSCContent.Insert($startPosition, $credsContent)
    $DSCContent += "O365TenantConfig -ConfigurationData .\ConfigurationData.psd1"
    #endregion

    #region Prompt the user for a location to save the extract and generate the files
    $OutputDSCPath = Read-Host "Destination Path"
    while (!(Test-Path -Path $OutputDSCPath -PathType Container -ErrorAction SilentlyContinue))
    {
        try
        {
            Write-Output "Directory `"$OutputDSCPath`" doesn't exist; creating..."
            New-Item -Path $OutputDSCPath -ItemType Directory | Out-Null
            if ($?) {break}
        }
        catch
        {
            Write-Warning "$($_.Exception.Message)"
            Write-Warning "Could not create folder $OutputDSCPath!"
        }
        $OutputDSCPath = Read-Host "Please Enter Output Folder for DSC Configuration (Will be Created as Necessary)"
    }
    <## Ensures the path we specify ends with a Slash, in order to make sure the resulting file path is properly structured. #>
    if (!$OutputDSCPath.EndsWith("\") -and !$OutputDSCPath.EndsWith("/"))
    {
        $OutputDSCPath += "\"
    }

    $outputDSCFile = $OutputDSCPath + "Office365TenantConfig.ps1"
    $DSCContent | Out-File $outputDSCFile

    if (!$AzureAutomation)
    {
        $outputConfigurationData = $OutputDSCPath + "ConfigurationData.psd1"
        New-ConfigurationDataDocument -Path $outputConfigurationData
    }
    #endregion
    Invoke-Item -Path $OutputDSCPath
}
