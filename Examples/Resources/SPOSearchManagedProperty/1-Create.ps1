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
        SPOSearchManagedProperty 'ConfigureSearchMP'
        {
            Searchable                  = $True
            FullTextIndex               = ""
            MappedCrawledProperties     = @()
            LanguageNeutralTokenization = $True
            CompanyNameExtraction       = $False
            AllowMultipleValues         = $True
            Aliases                     = $True
            Queryable                   = $True
            Name                        = "TestManagedProperty"
            Safe                        = $True
            Description                 = "Description of item"
            FinerQueryTokenization      = $True
            Retrievable                 = $True
            Type                        = "Text"
            CompleteMatching            = $True
            FullTextContext             = 4
            Sortable                    = "Yes"
            Refinable                   = "Yes"
            TokenNormalization          = $True
            Ensure                      = "Present"
            Credential                  = $Credscredential
        }
    }
}
