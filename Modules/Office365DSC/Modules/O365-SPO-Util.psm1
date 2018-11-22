$Global:AlreadyConnected = $false
function Test-SPOServiceConnection
{
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
    
    if(!$Global:AlreadyConnected)
    {
        Write-Verbose "Verifying the LCM connection state to SharePoint Online"
        try {
            Get-SPOSite $SPOCentralAdminUrl
            Write-Verbose "The LCM was already connected to SharePoint Online"
            $Global:AlreadyConnected = $true
        }
        catch {
            Write-Verbose "Determined that the LCM process is not already connected to SharePoint Online"
            Connect-SPOService -Url $SPOCentralAdminUrl -Credential $GlobalAdminAccount
        }
    }
}