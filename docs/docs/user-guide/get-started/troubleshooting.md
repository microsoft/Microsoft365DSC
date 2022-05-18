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
