<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        IntuneDeviceConfigurationEndpointProtectionPolicyWindows10 'Example'
        {
            ApplicationGuardAllowFileSaveOnHost                                          = $True;
            ApplicationGuardAllowPersistence                                             = $True;
            ApplicationGuardAllowPrintToLocalPrinters                                    = $True;
            ApplicationGuardAllowPrintToNetworkPrinters                                  = $True;
            ApplicationGuardAllowPrintToPDF                                              = $True;
            ApplicationGuardAllowPrintToXPS                                              = $True;
            ApplicationGuardAllowVirtualGPU                                              = $True;
            ApplicationGuardBlockClipboardSharing                                        = "blockContainerToHost";
            ApplicationGuardBlockFileTransfer                                            = "blockImageFile";
            ApplicationGuardBlockNonEnterpriseContent                                    = $True;
            ApplicationGuardCertificateThumbprints                                       = @();
            ApplicationGuardEnabled                                                      = $True;
            ApplicationGuardEnabledOptions                                               = "enabledForEdge";
            ApplicationGuardForceAuditing                                                = $True;
            AppLockerApplicationControl                                                  = "enforceComponentsStoreAppsAndSmartlocker";
            Assignments                                                                  = @(
                MSFT_DeviceManagementConfigurationPolicyAssignments{
                    deviceAndAppManagementAssignmentFilterType = 'none'
                    dataType = '#microsoft.graph.allLicensedUsersAssignmentTarget'
                }
            );
            BitLockerAllowStandardUserEncryption                                         = $True;
            BitLockerDisableWarningForOtherDiskEncryption                                = $True;
            BitLockerEnableStorageCardEncryptionOnMobile                                 = $True;
            BitLockerEncryptDevice                                                       = $True;
            BitLockerFixedDrivePolicy                                                    = MSFT_MicrosoftGraphbitLockerFixedDrivePolicy{
                RecoveryOptions = MSFT_MicrosoftGraphBitLockerRecoveryOptions{
                    RecoveryInformationToStore = 'passwordAndKey'
                    HideRecoveryOptions = $True
                    BlockDataRecoveryAgent = $True
                    RecoveryKeyUsage = 'allowed'
                    EnableBitLockerAfterRecoveryInformationToStore = $True
                    EnableRecoveryInformationSaveToStore = $True
                    RecoveryPasswordUsage = 'allowed'
                }
                            RequireEncryptionForWriteAccess = $True
                EncryptionMethod = 'xtsAes128'
            };
            BitLockerRecoveryPasswordRotation                                            = "notConfigured";
            BitLockerRemovableDrivePolicy                                                = MSFT_MicrosoftGraphbitLockerRemovableDrivePolicy{
                RequireEncryptionForWriteAccess = $True
                BlockCrossOrganizationWriteAccess = $True
                EncryptionMethod = 'aesCbc128'
            };
            BitLockerSystemDrivePolicy                                                   = MSFT_MicrosoftGraphbitLockerSystemDrivePolicy{
                PrebootRecoveryEnableMessageAndUrl = $True
                StartupAuthenticationTpmPinUsage = 'allowed'
                EncryptionMethod = 'xtsAes128'
                StartupAuthenticationTpmPinAndKeyUsage = 'allowed'
                StartupAuthenticationRequired = $True
                RecoveryOptions = MSFT_MicrosoftGraphBitLockerRecoveryOptions{
                    RecoveryInformationToStore = 'passwordAndKey'
                    HideRecoveryOptions = $False
                    BlockDataRecoveryAgent = $True
                    RecoveryKeyUsage = 'allowed'
                    EnableBitLockerAfterRecoveryInformationToStore = $True
                    EnableRecoveryInformationSaveToStore = $False
                    RecoveryPasswordUsage = 'allowed'
                }
                            StartupAuthenticationTpmUsage = 'allowed'
                StartupAuthenticationTpmKeyUsage = 'allowed'
                StartupAuthenticationBlockWithoutTpmChip = $False
            };
            Credential                                                                   = $Credscredential;
            DefenderAdditionalGuardedFolders                                             = @();
            DefenderAdobeReaderLaunchChildProcess                                        = "notConfigured";
            DefenderAdvancedRansomewareProtectionType                                    = "notConfigured";
            DefenderAttackSurfaceReductionExcludedPaths                                  = @();
            DefenderBlockPersistenceThroughWmiType                                       = "userDefined";
            DefenderEmailContentExecution                                                = "userDefined";
            DefenderEmailContentExecutionType                                            = "userDefined";
            DefenderExploitProtectionXml                                                 = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxNaXRpZ2F0aW9uUG9saWN5Pg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9IkFjcm9SZDMyLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJBY3JvUmQzMkluZm8uZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9ImNsdmlldy5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0iY25mbm90MzIuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9ImV4Y2VsLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJleGNlbGNudi5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0iRXh0RXhwb3J0LmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJncmFwaC5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0iaWU0dWluaXQuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9ImllaW5zdGFsLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJpZWxvd3V0aWwuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9ImllVW5hdHQuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9ImlleHBsb3JlLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJseW5jLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJtc2FjY2Vzcy5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0ibXNjb3JzdncuZXhlIj4NCiAgICA8RXh0ZW5zaW9uUG9pbnRzIERpc2FibGVFeHRlbnNpb25Qb2ludHM9InRydWUiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9Im1zZmVlZHNzeW5jLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJtc2h0YS5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0ibXNvYWRmc2IuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9Im1zb2FzYi5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0ibXNvaHRtZWQuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9Im1zb3NyZWMuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9Im1zb3htbGVkLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJtc3B1Yi5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0ibXNxcnkzMi5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0iTXNTZW5zZS5leGUiPg0KICAgIDxFeHRlbnNpb25Qb2ludHMgRGlzYWJsZUV4dGVuc2lvblBvaW50cz0idHJ1ZSIgLz4NCiAgICA8SW1hZ2VMb2FkIFByZWZlclN5c3RlbTMyPSJ0cnVlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJuZ2VuLmV4ZSI+DQogICAgPEV4dGVuc2lvblBvaW50cyBEaXNhYmxlRXh0ZW5zaW9uUG9pbnRzPSJ0cnVlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJuZ2VudGFzay5leGUiPg0KICAgIDxFeHRlbnNpb25Qb2ludHMgRGlzYWJsZUV4dGVuc2lvblBvaW50cz0idHJ1ZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0ib25lbm90ZS5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0ib25lbm90ZW0uZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9Im9yZ2NoYXJ0LmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJvdXRsb29rLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJwb3dlcnBudC5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0iUHJlc2VudGF0aW9uSG9zdC5leGUiPg0KICAgIDxERVAgRW5hYmxlPSJ0cnVlIiBFbXVsYXRlQXRsVGh1bmtzPSJmYWxzZSIgLz4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIEJvdHRvbVVwPSJ0cnVlIiBIaWdoRW50cm9weT0idHJ1ZSIgLz4NCiAgICA8U0VIT1AgRW5hYmxlPSJ0cnVlIiBUZWxlbWV0cnlPbmx5PSJmYWxzZSIgLz4NCiAgICA8SGVhcCBUZXJtaW5hdGVPbkVycm9yPSJ0cnVlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJQcmludERpYWxvZy5leGUiPg0KICAgIDxFeHRlbnNpb25Qb2ludHMgRGlzYWJsZUV4dGVuc2lvblBvaW50cz0idHJ1ZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0iUmRyQ0VGLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJSZHJTZXJ2aWNlc1VwZGF0ZXIuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9InJ1bnRpbWVicm9rZXIuZXhlIj4NCiAgICA8RXh0ZW5zaW9uUG9pbnRzIERpc2FibGVFeHRlbnNpb25Qb2ludHM9InRydWUiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9InNjYW5vc3QuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9InNjYW5wc3QuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9InNkeGhlbHBlci5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQogIDxBcHBDb25maWcgRXhlY3V0YWJsZT0ic2VsZmNlcnQuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9InNldGxhbmcuZXhlIj4NCiAgICA8QVNMUiBGb3JjZVJlbG9jYXRlSW1hZ2VzPSJ0cnVlIiBSZXF1aXJlSW5mbz0iZmFsc2UiIC8+DQogIDwvQXBwQ29uZmlnPg0KICA8QXBwQ29uZmlnIEV4ZWN1dGFibGU9IlN5c3RlbVNldHRpbmdzLmV4ZSI+DQogICAgPEV4dGVuc2lvblBvaW50cyBEaXNhYmxlRXh0ZW5zaW9uUG9pbnRzPSJ0cnVlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJ3aW53b3JkLmV4ZSI+DQogICAgPEFTTFIgRm9yY2VSZWxvY2F0ZUltYWdlcz0idHJ1ZSIgUmVxdWlyZUluZm89ImZhbHNlIiAvPg0KICA8L0FwcENvbmZpZz4NCiAgPEFwcENvbmZpZyBFeGVjdXRhYmxlPSJ3b3JkY29udi5leGUiPg0KICAgIDxBU0xSIEZvcmNlUmVsb2NhdGVJbWFnZXM9InRydWUiIFJlcXVpcmVJbmZvPSJmYWxzZSIgLz4NCiAgPC9BcHBDb25maWc+DQo8L01pdGlnYXRpb25Qb2xpY3k+";
            DefenderExploitProtectionXmlFileName                                         = "Settings.xml";
            DefenderFileExtensionsToExclude                                              = @();
            DefenderFilesAndFoldersToExclude                                             = @();
            DefenderGuardedFoldersAllowedAppPaths                                        = @();
            DefenderGuardMyFoldersType                                                   = "auditMode";
            DefenderNetworkProtectionType                                                = "enable";
            DefenderOfficeAppsExecutableContentCreationOrLaunch                          = "userDefined";
            DefenderOfficeAppsExecutableContentCreationOrLaunchType                      = "userDefined";
            DefenderOfficeAppsLaunchChildProcess                                         = "userDefined";
            DefenderOfficeAppsLaunchChildProcessType                                     = "userDefined";
            DefenderOfficeAppsOtherProcessInjection                                      = "userDefined";
            DefenderOfficeAppsOtherProcessInjectionType                                  = "userDefined";
            DefenderOfficeCommunicationAppsLaunchChildProcess                            = "notConfigured";
            DefenderOfficeMacroCodeAllowWin32Imports                                     = "userDefined";
            DefenderOfficeMacroCodeAllowWin32ImportsType                                 = "userDefined";
            DefenderPreventCredentialStealingType                                        = "enable";
            DefenderProcessCreation                                                      = "userDefined";
            DefenderProcessCreationType                                                  = "userDefined";
            DefenderProcessesToExclude                                                   = @();
            DefenderScriptDownloadedPayloadExecution                                     = "userDefined";
            DefenderScriptDownloadedPayloadExecutionType                                 = "userDefined";
            DefenderScriptObfuscatedMacroCode                                            = "userDefined";
            DefenderScriptObfuscatedMacroCodeType                                        = "userDefined";
            DefenderSecurityCenterBlockExploitProtectionOverride                         = $False;
            DefenderSecurityCenterDisableAccountUI                                       = $False;
            DefenderSecurityCenterDisableClearTpmUI                                      = $True;
            DefenderSecurityCenterDisableFamilyUI                                        = $False;
            DefenderSecurityCenterDisableHardwareUI                                      = $True;
            DefenderSecurityCenterDisableHealthUI                                        = $False;
            DefenderSecurityCenterDisableNetworkUI                                       = $False;
            DefenderSecurityCenterDisableNotificationAreaUI                              = $False;
            DefenderSecurityCenterDisableRansomwareUI                                    = $False;
            DefenderSecurityCenterDisableVirusUI                                         = $False;
            DefenderSecurityCenterDisableVulnerableTpmFirmwareUpdateUI                   = $True;
            DefenderSecurityCenterHelpEmail                                              = "me@domain.com";
            DefenderSecurityCenterHelpPhone                                              = "yes";
            DefenderSecurityCenterITContactDisplay                                       = "displayInAppAndInNotifications";
            DefenderSecurityCenterNotificationsFromApp                                   = "blockNoncriticalNotifications";
            DefenderSecurityCenterOrganizationDisplayName                                = "processes.exe";
            DefenderUntrustedExecutable                                                  = "userDefined";
            DefenderUntrustedExecutableType                                              = "userDefined";
            DefenderUntrustedUSBProcess                                                  = "userDefined";
            DefenderUntrustedUSBProcessType                                              = "userDefined";
            DeviceGuardEnableSecureBootWithDMA                                           = $True;
            DeviceGuardEnableVirtualizationBasedSecurity                                 = $True;
            DeviceGuardLaunchSystemGuard                                                 = "notConfigured";
            DeviceGuardLocalSystemAuthorityCredentialGuardSettings                       = "enableWithoutUEFILock";
            DeviceGuardSecureBootWithDMA                                                 = "notConfigured";
            DisplayName                                                                  = "endpoint protection legacy - dsc v2.0";
            DmaGuardDeviceEnumerationPolicy                                              = "deviceDefault";
            Ensure                                                                       = "Present";
            FirewallCertificateRevocationListCheckMethod                                 = "deviceDefault";
            FirewallIPSecExemptionsAllowDHCP                                             = $False;
            FirewallIPSecExemptionsAllowICMP                                             = $False;
            FirewallIPSecExemptionsAllowNeighborDiscovery                                = $False;
            FirewallIPSecExemptionsAllowRouterDiscovery                                  = $False;
            FirewallIPSecExemptionsNone                                                  = $False;
            FirewallPacketQueueingMethod                                                 = "deviceDefault";
            FirewallPreSharedKeyEncodingMethod                                           = "deviceDefault";
            FirewallProfileDomain                                                        = MSFT_MicrosoftGraphwindowsFirewallNetworkProfile{
                PolicyRulesFromGroupPolicyNotMerged = $False
                InboundNotificationsBlocked = $True
                OutboundConnectionsRequired = $True
                GlobalPortRulesFromGroupPolicyNotMerged = $True
                ConnectionSecurityRulesFromGroupPolicyNotMerged = $True
                UnicastResponsesToMulticastBroadcastsRequired = $True
                PolicyRulesFromGroupPolicyMerged = $False
                UnicastResponsesToMulticastBroadcastsBlocked = $False
                IncomingTrafficRequired = $False
                IncomingTrafficBlocked = $True
                ConnectionSecurityRulesFromGroupPolicyMerged = $False
                StealthModeRequired = $False
                InboundNotificationsRequired = $False
                AuthorizedApplicationRulesFromGroupPolicyMerged = $False
                InboundConnectionsBlocked = $True
                OutboundConnectionsBlocked = $False
                StealthModeBlocked = $True
                GlobalPortRulesFromGroupPolicyMerged = $False
                SecuredPacketExemptionBlocked = $False
                SecuredPacketExemptionAllowed = $False
                InboundConnectionsRequired = $False
                FirewallEnabled = 'allowed'
                AuthorizedApplicationRulesFromGroupPolicyNotMerged = $True
            };
            FirewallRules                                                                = @(
                MSFT_MicrosoftGraphwindowsFirewallRule{
                    Action = 'allowed'
                    InterfaceTypes = 'notConfigured'
                    DisplayName = 'ICMP'
                    TrafficDirection = 'in'
                    ProfileTypes = 'domain'
                    EdgeTraversal = 'notConfigured'
                }
            );
            LanManagerAuthenticationLevel                                                = "lmNtlmAndNtlmV2";
            LanManagerWorkstationDisableInsecureGuestLogons                              = $False;
            LocalSecurityOptionsAdministratorElevationPromptBehavior                     = "notConfigured";
            LocalSecurityOptionsAllowAnonymousEnumerationOfSAMAccountsAndShares          = $False;
            LocalSecurityOptionsAllowPKU2UAuthenticationRequests                         = $False;
            LocalSecurityOptionsAllowRemoteCallsToSecurityAccountsManagerHelperBool      = $False;
            LocalSecurityOptionsAllowSystemToBeShutDownWithoutHavingToLogOn              = $True;
            LocalSecurityOptionsAllowUIAccessApplicationElevation                        = $False;
            LocalSecurityOptionsAllowUIAccessApplicationsForSecureLocations              = $False;
            LocalSecurityOptionsAllowUndockWithoutHavingToLogon                          = $True;
            LocalSecurityOptionsBlockMicrosoftAccounts                                   = $True;
            LocalSecurityOptionsBlockRemoteLogonWithBlankPassword                        = $True;
            LocalSecurityOptionsBlockRemoteOpticalDriveAccess                            = $True;
            LocalSecurityOptionsBlockUsersInstallingPrinterDrivers                       = $True;
            LocalSecurityOptionsClearVirtualMemoryPageFile                               = $True;
            LocalSecurityOptionsClientDigitallySignCommunicationsAlways                  = $False;
            LocalSecurityOptionsClientSendUnencryptedPasswordToThirdPartySMBServers      = $False;
            LocalSecurityOptionsDetectApplicationInstallationsAndPromptForElevation      = $False;
            LocalSecurityOptionsDisableAdministratorAccount                              = $True;
            LocalSecurityOptionsDisableClientDigitallySignCommunicationsIfServerAgrees   = $False;
            LocalSecurityOptionsDisableGuestAccount                                      = $True;
            LocalSecurityOptionsDisableServerDigitallySignCommunicationsAlways           = $False;
            LocalSecurityOptionsDisableServerDigitallySignCommunicationsIfClientAgrees   = $False;
            LocalSecurityOptionsDoNotAllowAnonymousEnumerationOfSAMAccounts              = $True;
            LocalSecurityOptionsDoNotRequireCtrlAltDel                                   = $True;
            LocalSecurityOptionsDoNotStoreLANManagerHashValueOnNextPasswordChange        = $False;
            LocalSecurityOptionsFormatAndEjectOfRemovableMediaAllowedUser                = "administrators";
            LocalSecurityOptionsHideLastSignedInUser                                     = $False;
            LocalSecurityOptionsHideUsernameAtSignIn                                     = $False;
            LocalSecurityOptionsInformationDisplayedOnLockScreen                         = "notConfigured";
            LocalSecurityOptionsInformationShownOnLockScreen                             = "notConfigured";
            LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedClients             = "none";
            LocalSecurityOptionsMinimumSessionSecurityForNtlmSspBasedServers             = "none";
            LocalSecurityOptionsOnlyElevateSignedExecutables                             = $False;
            LocalSecurityOptionsRestrictAnonymousAccessToNamedPipesAndShares             = $True;
            LocalSecurityOptionsSmartCardRemovalBehavior                                 = "lockWorkstation";
            LocalSecurityOptionsStandardUserElevationPromptBehavior                      = "notConfigured";
            LocalSecurityOptionsSwitchToSecureDesktopWhenPromptingForElevation           = $False;
            LocalSecurityOptionsUseAdminApprovalMode                                     = $False;
            LocalSecurityOptionsUseAdminApprovalModeForAdministrators                    = $False;
            LocalSecurityOptionsVirtualizeFileAndRegistryWriteFailuresToPerUserLocations = $False;
            SmartScreenBlockOverrideForFiles                                             = $True;
            SmartScreenEnableInShell                                                     = $True;
            SupportsScopeTags                                                            = $True;
            UserRightsAccessCredentialManagerAsTrustedCaller                             = MSFT_MicrosoftGraphdeviceManagementUserRightsSetting{
                State = 'allowed'
                LocalUsersOrGroups = @(
                    MSFT_MicrosoftGraphDeviceManagementUserRightsLocalUserOrGroup{
                        Name = 'NT AUTHORITY\Local service'
                        SecurityIdentifier = '*S-1-5-19'
                    }
                )
            };
            WindowsDefenderTamperProtection                                              = "enable";
            XboxServicesAccessoryManagementServiceStartupMode                            = "manual";
            XboxServicesEnableXboxGameSaveTask                                           = $True;
            XboxServicesLiveAuthManagerServiceStartupMode                                = "manual";
            XboxServicesLiveGameSaveServiceStartupMode                                   = "manual";
            XboxServicesLiveNetworkingServiceStartupMode                                 = "manual";
        }
    }
}
