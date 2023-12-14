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
        SCComplianceTag 'ConfigureComplianceTag'
        {
            Name              = "DemoTag"
            Comment           = "This is a Demo Tag"
            RetentionAction   = "Keep"
            RetentionDuration = "1025"
            RetentionType     = "ModificationAgeInDays"
            FilePlanProperty  = MSFT_SCFilePlanProperty
            {
                FilePlanPropertyDepartment  = "DemoDept"
                FilePlanPropertyCitation    = "DemoCit"
                FilePlanPropertyReferenceId = "DemoRef"
                FilePlanPropertyAuthority   = "DemoAuth"
                FilePlanPropertyCategory    = "DemoCat"
                FilePlanPropertySubcategory = "DemoSub"
            }
            Ensure            = "Present"
            Credential        = $Credscredential
        }
    }
}
