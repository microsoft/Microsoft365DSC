if ($PSVersionTable.PSEdition -eq 'Core')
{
    return
}

Write-Warning -Message 'Starting October 2026, PowerShell 7 will be required to be installed when using Microsoft365DSC.'
Write-Warning -Message 'It is recommended to start planning for this new requirement and ensure that PowerShell 7 is installed and configured properly on your systems.'
Write-Warning -Message 'Please note: Windows PowerShell 5.1 will continue to work, but some features will require PowerShell 7 to function properly.'
