# Troubleshooting / Known Issues

## Error "Device code terminal timed-out after 120 seconds. Please try again."

### ISSUE

When you are using Credentials and Delegated Authentication (for more info, see: <a href="../../get-started/authentication-and-permissions/#microsoft-graph-permissions" target="_blank">Delegated Permissions</a>), it is possible that you receive the following error:

```
Device code terminal timed-out after 120 seconds. Please try again.
+ CategoryInfo : NotSpecified: (:) [], CimException
+ FullyQualifiedErrorId : Microsoft.Graph.PowerShell.Authentication.Cmdlets.ConnectMgGraph
+ PSComputerName : localhost
```

### CAUSE

This is caused by the fact that the delegated Graph application has not been given consent to use the assigned permissions and therefore prompts for consent. However, since the deployment process runs in a non-interactive process, you will never see this prompt. After 120 seconds it will time out and throw the above error.

### RESOLUTION

This issue can be resolved by granting and consenting the correct permissions. You can do this via the Azure Admin Portal or by running using the <a href="../../cmdlets/Update-M365DSCAllowedGraphScopes/" target="_blank">Update-M365DSCAllowedGraphScopes</a> cmdlet. More information about that process can be found <a href="../authentication-and-permissions/#providing-consent-for-graph-permissions" target="_blank">here</a>.


## Error "The WMI service or the WMI provider returned an unknown error: HRESULT 0x80041033" when running Exchange workload

### ISSUE

When you are running a configuration apply or test with many Exchange workload resources, it is possible that the WMI provider throws an error and high memory usage is detected.

```
The WS-Management service cannot process the request. The WMI service or the WMI provider returned an unknown error: HRESULT 0x80041033
+ CategoryInfo : ResourceUnavailable: (root/Microsoft/...gurationManager:String) [], CimException
+ FullyQualifiedErrorId : HRESULT 0x80041033
+ PSComputerName : localhost
```

### CAUSE

This is caused by the `ExchangeOnlineManagement` PowerShell module consuming more memory than what is available to the wmiprvse.exe process (WMI Provider Host). The default is 4GB of memory on a Windows 11 computer. If those 4GB of memory are not enough, the WMI Provider Host will crash and might restart or not.

### RESOLUTION

This issue can be resolved by allowing the WMI Provider Host to allocate more than the default 4GB of memory.

```powershell
$quotaConfiguration = Get-CimInstance -Namespace Root -ClassName "__ProviderHostQuotaConfiguration"
$quotaConfiguration.MemoryAllHosts = 4 * 4GB # Adjust the memory for all processes combined
$quotaConfiguration.MemoryPerHost  = 3 * 4GB # Adjust the memory for a single wmiprvse.exe process
Set-CimInstance -InputObject $quotaConfiguration
```

If you want all memory of the computer to be available to the WMI Provider Host, you can do that as well, but a customized amount is most likely better suited:

```powershell
$computerSystem = Get-CimInstance -ClassName "Win32_ComputerSystem"
$quotaConfiguration.MemoryAllHosts = $computerSystem.TotalPhysicalMemory
$quotaConfiguration.MemoryPerHost  = $computerSystem.TotalPhysicalMemory
```

Optionally, for improved performance, you can increase the handles and threads per host (wmiprvse.exe process) as well:

```powershell
$quotaConfiguration.HandlesPerHost = 8192
$quotaConfiguration.ThreadsPerHost = 512
```
