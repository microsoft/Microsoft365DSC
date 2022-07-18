
# IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager

## Description

This resource configures an Intune Endpoint Protection Attack Surface Reduction Rules policy for a Windows 10 Device for Configuration Manager.
This policy setting enables setting the state (Block/Audit/Off/Warn) for each attack surface reduction (ASR) rule. Each ASR rule listed can be set to one of the following states (Block/Audit/Off/Warn). The ASR rule ID and state should be added under the Options for this setting. Each entry must be listed as a name value pair. The name defines a valid ASR rule ID, while the value contains the status ID indicating the status of the rule.

For more information about ASR rule ID and status ID, see Enable Attack Surface Reduction: https://docs.microsoft.com/en-us/windows/threat-protection/windows-defender-exploit-guard/enable-attack-surface-reduction.
