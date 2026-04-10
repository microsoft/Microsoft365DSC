@{
    Dependencies = @(
        @{
            ModuleName      = 'Az.Accounts'
            RequiredVersion = '5.0.1'
        },
        @{
            ModuleName      = 'Az.ResourceGraph'
            RequiredVersion = '1.2.1'
        },
        @{
            ModuleName      = 'Az.Resources'
            RequiredVersion = '8.0.0'
        },
        @{
            ModuleName      = 'Az.Security'
            RequiredVersion = '1.6.2'
        },
        @{
            ModuleName      = 'Az.SecurityInsights'
            RequiredVersion = '3.2.0'
        },
        @{
            ModuleName      = 'DSCParser'
            RequiredVersion = '3.0.0.2'
        },
        @{
            ModuleName      = 'ExchangeOnlineManagement'
            RequiredVersion = '3.9.2'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Applications'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Applications'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Authentication'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.DeviceManagement'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Devices.CorporateManagement'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.DeviceManagement.Administration'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.DeviceManagement.Enrollment'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.NetworkAccess'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Identity.DirectoryManagement'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Identity.DirectoryManagement'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Identity.Governance'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Identity.SignIns'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Identity.SignIns'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Reports'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Search'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Teams'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.DeviceManagement.Administration'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.DirectoryObjects'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Groups'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Beta.Groups'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Planner'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Sites'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Users'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Users.Actions'
            RequiredVersion = '2.36.1'
        },
        @{
            ModuleName      = 'MicrosoftTeams'
            RequiredVersion = '7.6.0'
        },
        @{
            ModuleName      = "MSCloudLoginAssistant"
            RequiredVersion = "1.1.62"
        },
        @{
            ModuleName      = 'PnP.PowerShell'
            RequiredVersion = '1.12.0'
            InstallLocation = 'WindowsPowerShell'
            # TODO: Review again once ModuleFast can work with additional properties
            # https://github.com/microsoft/Microsoft365DSC/pull/6726
            # https://github.com/ykuijs/M365DSC_CICD/issues/53
            #DependsOn       = @('Microsoft.Graph.Authentication')
        },
        @{
            ModuleName      = 'ReverseDSC'
            RequiredVersion = '2.0.0.34'
        },
        @{
            ModuleName      = 'PSParallelPipeline'
            RequiredVersion = '1.2.5'
        }
    )
}
