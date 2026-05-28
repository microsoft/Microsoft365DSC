@{
    Dependencies = @(
        @{
            ModuleName      = 'Az.Accounts'
            RequiredVersion = '5.3.2'
        },
        @{
            ModuleName      = 'Az.ResourceGraph'
            RequiredVersion = '1.2.1'
        },
        @{
            ModuleName      = 'Az.Resources'
            RequiredVersion = '9.0.1'
        },
        @{
            ModuleName      = 'Az.Subscription'
            RequiredVersion = '0.12.0'
        },
        @{
            ModuleName      = 'Az.Security'
            RequiredVersion = '1.8.0'
        },
        @{
            ModuleName      = 'Az.SecurityInsights'
            RequiredVersion = '3.2.1'
        },
        @{
            ModuleName      = 'DSCParser'
            RequiredVersion = '3.0.0.5'
        },
        @{
            ModuleName      = 'ExchangeOnlineManagement'
            RequiredVersion = '3.9.2'
        },
        @{
            ModuleName      = 'Microsoft.Graph.Authentication'
            RequiredVersion = '2.35.1'
        },
        @{
            ModuleName      = 'MicrosoftTeams'
            RequiredVersion = '7.6.0'
        },
        @{
            ModuleName      = "MSCloudLoginAssistant"
            RequiredVersion = "1.1.64"
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
