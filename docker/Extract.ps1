param(
    [parameter(Mandatory = $true)]
    [System.String[]]
    $Components,

    [parameter(Mandatory = $true)]
    [System.String]
    $FileName
)
function Export-C4Configuration
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [parameter(Mandatory = $true)]
        [System.String[]]
        $Components,

        [parameter(Mandatory = $true)]
        [System.String]
        $FileName
    )
    $random = $fileName -replace ".ps1", ".txt"
    "Getting in" | Out-File $random
    $password = ConvertTo-SecureString 'Pass@word!11' -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ('adminnonmfa@o365DSC.onmicrosoft.com', $password)

    "FileName = $FileName" | Out-File $random -Append
    "Components = $Components" | Out-File $random -Append
    $filePath = Join-Path -Path "C:\M365DSC\" -ChildPath $FileName
    "FilePath = $FilePath" | Out-File $random -Append

    Export-M365DSCConfiguration -Credential $credential `
        -Components $Components `
        -Path 'C:\M365DSC' `
        -FileName $FileName

    "File Extracted" | Out-File $random -Append
    $url = 'https://c4files.blob.core.windows.net/exports?sp=rw&st=2021-10-12T19:19:05Z&se=2024-06-14T03:19:05Z&spr=https&sv=2020-08-04&sr=c&sig=k%2B8PPOcZiIsKxWtAf6AhsBlWggFhqZL2Swc%2BwRy280o%3D'
    $HashArguments = @{
        uri = $url.replace("?","/$($(get-item $filePath).name)?")
        method = "Put"
        InFile = $filePath
        headers = @{"x-ms-blob-type" = "BlockBlob"}
    }
    Invoke-RestMethod @HashArguments

    "Done" | Out-File $random -Append
}

Export-C4Configuration -Components $Components -FileName $FileName
