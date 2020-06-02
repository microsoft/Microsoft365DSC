name: Generate Wiki Content
on: [pull_request]

jobs:
  # This workflow contains a single job called dfsdfsdd
  build:
    # The type of runner that the job will run ondfdddhh
    runs-on: windows-latest

    # Steps represent a sequence of tasks that will ert ovkf t
    steps:
    - uses: actions/checkout@v2
    - name: Install Modules 
      shell: powershell
      run: |
       git clone https://github.com/PowerShell/DscResource.Tests
       
       Import-Module -Name "./DscResource.Tests/AppVeyor.psm1"
       Invoke-AppveyorInstallTask
       $env:APPVEYOR_BUILD_FOLDER = Get-Location | select -ExpandProperty Path
       $env:APPVEYOR_BUILD_VERSION = "1.0.0"
       Invoke-AppveyorAfterTestTask `
            -Type 'Wiki' `
            -MainModulePath 'Modules\Microsoft365DSC' `
            -ResourceModuleName 'Microsoft365DSC'
    - uses: actions/upload-artifact@v2
    - name: Upload Wiki Content
      with:
        name: WikiContent
        path: D:\a\GitHubActionsTest\GitHubActionsTest\Microsoft365DSC_1.0.0_wikicontent.zip
