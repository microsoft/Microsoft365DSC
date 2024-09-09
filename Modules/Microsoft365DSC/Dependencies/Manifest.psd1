@{
    Dependencies = @(
        @{
            ModuleName      = 'DSCParser'
            RequiredVersion = '2.0.0.8'
        },
        @{
            ModuleName      = 'ExchangeOnlineManagement'
            RequiredVersion = '3.4.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Applications'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Authentication'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.DeviceManagement'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Devices.CorporateManagement'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.DeviceManagement.Administration'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.DeviceManagement.Enrollment'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Identity.DirectoryManagement'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Identity.Governance'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Identity.SignIns'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Reports'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Teams'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.DeviceManagement.Administration'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.DirectoryObjects'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Groups'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Planner'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Sites'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Users'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Users.Actions'
            RequiredVersion = '2.20.0'
        },
        @{
            ModuleName      = 'Microsoft.PowerApps.Administration.PowerShell'
            RequiredVersion = '2.0.191'
        },
        @{
            ModuleName      = 'MicrosoftTeams'
            RequiredVersion = '6.5.0'
        },
        @{
            ModuleName      = "MSCloudLoginAssistant"
            RequiredVersion = "1.1.20"
        },
        @{
            ModuleName      = 'PnP.PowerShell'
            RequiredVersion = '1.12.0'
        },
        @{
            ModuleName      = 'PSDesiredStateConfiguration'
            RequiredVersion = '1.1'
            PowerShellCore  = $false
        },
        @{
            ModuleName      = 'PSDesiredStateConfiguration'
            RequiredVersion = '2.0.7'
            PowerShellCore  = $true
            ExplicitLoading = $true
            Prefix          = 'Pwsh'
        },
        @{
            ModuleName      = 'ReverseDSC'
            RequiredVersion = '2.0.0.20'
        }
    )
}
