<#
.Description
This function stores the already exported configuration to file, so this
information isn't lost when the export encounters an issue

.Functionality
Internal
#>
function Save-M365DSCPartialExport
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Content,

        [Parameter(Mandatory = $true)]
        [System.String]
        $FileName
    )

    $tempPath = Join-Path $env:TEMP -ChildPath $FileName
    $Content | Out-File $tempPath -Append:$true -Force
}

Export-ModuleMember -Function @(
    'Save-M365DSCPartialExport'
)
