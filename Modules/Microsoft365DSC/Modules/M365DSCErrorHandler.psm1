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
