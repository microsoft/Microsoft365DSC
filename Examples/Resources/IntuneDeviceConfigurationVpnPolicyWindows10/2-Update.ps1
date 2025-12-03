<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationVpnPolicyWindows10 'Example'
        {
            Assignments                                = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            AuthenticationMethod                       = "usernameAndPassword";
            ConnectionName                             = "Cisco VPN";
            ConnectionType                             = "ciscoAnyConnect";
            CustomXml                                  = "";
            DisplayName                                = "VPN";
            DnsRules                                   = @(
                MSFT_MicrosoftGraphvpnDnsRule{
                    Servers = @('10.0.1.10')
                    Name = 'NRPT rule'
                    Persistent = $True
                    AutoTrigger = $True
                }
            );
            DnsSuffixes                                = @("mydomain.com");
            EnableAlwaysOn                             = $True;
            EnableConditionalAccess                    = $True;
            EnableDnsRegistration                      = $True;
            EnableSingleSignOnWithAlternateCertificate = $True; # Updated Property
            EnableSplitTunneling                       = $False;
            Ensure                                     = "Present";
            ProfileTarget                              = "user";
            ProxyServer                                = MSFT_MicrosoftGraphwindows10VpnProxyServer{
                Port = 8081
                BypassProxyServerForLocalAddress = $True
                AutomaticConfigurationScriptUrl = ''
                Address = '10.0.10.100'
            };
            RememberUserCredentials                    = $True;
            ServerCollection                           = @(
                MSFT_MicrosoftGraphvpnServer{
                    IsDefaultServer = $True
                    Description = 'gateway1'
                    Address = '10.0.1.10'
                }
            );
            TrafficRules                               = @(
                MSFT_MicrosoftGraphvpnTrafficRule{
                    Name = 'VPN rule'
                    AppType = 'none'
                    LocalAddressRanges = @(
                        MSFT_MicrosoftGraphIPv4Range{
                            UpperAddress = '10.0.2.240'
                            LowerAddress = '10.0.2.0'
                        }
                    )
                    RoutingPolicyType = 'forceTunnel'
                    VpnTrafficDirection = 'outbound'
                }
            );
            TrustedNetworkDomains                      = @();
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
