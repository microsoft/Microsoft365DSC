<# This method creates a new error log file for each session,
   whenever an error is encountered, and appends valuable
   troubleshooting information to the file;
#>
function New-Office365DSCLogEntry
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Error,

        [Parameter()]
        [System.String]
        $Message
    )

    # Get the current folder we are executing the script from;
    $ExecPath = $SCRIPT:MyInvocation.MyCommand.Path
    $LastSlash = $ExecPath.ToString().LastIndexOf("\")
    $ExecPath = $ExecPath.Substring(0, $LastSlash + 1)

    # Obtain the ID of the current PowerShell session. While this may
    # not be unique, it will;
    $SessionID = [System.Diagnostics.Process]::GetCurrentProcess().Id.ToString()

    # Generate the Error log file name based on the SessionID;
    $LogFileName = $SessionID + "-O365DSC-ErrorLog.log"

    # Build up the Error message to append to our log file;
    $LogContent = "[" + [System.DateTime]::Now.ToString("yyyy/MM/dd hh:mm:ss") + "]`r`n"
    $LogContent += "{" + $Error.CategoryInfo.Category.ToString() + "}`r`n"
    $LogContent += $Error.Exception.ToString() + "`r`n"
    $LogContent += "`"" + $Message + "`"`r`n"
    $LogContent += "`r`n`r`n"

    # Write the error content into the log file;
    $LogContent | Out-File $LogFileName -Append
}
