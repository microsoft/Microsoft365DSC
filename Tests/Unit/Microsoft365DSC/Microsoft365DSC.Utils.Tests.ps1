Describe -Name 'Removing of empty / null splat properties' {
    It 'From hashtable' {
        function Test-FunctionHashtable {
            [cmdletBinding()]
            param(
                [ValidateNotNull()]$Test,
                [string] $Test1,
                [int] $Test5,
                [int] $Test6
            )
            Write-Verbose "Value for Test is $Test, Value for Test1 is $Test1, test5 $Test5, test6 $Test6"
        }

        $Splat = @{
            Test  = $NotExistingParameter
            Test1 = 'Existing Entry'
            Test2 = $null
            Test3 = ''
            Test5 = 0
            Test6 = 6
        }

        Remove-EmptyValue -Splat $Splat
        { Test-FunctionHashtable @Splat } | Should -Not -Throw
    }
    It 'From OrderedDictionary' {
        function Test-FunctionOrderedDictionary {
            [cmdletBinding()]
            param(
                [ValidateNotNull()]$Test,
                [string] $Test1,
                [int] $Test5,
                [int] $Test6
            )
            Write-Verbose "Value for Test is $Test, Value for Test1 is $Test1, test5 $Test5, test6 $Test6"
        }
        $SplatDictionary = [ordered] @{
            Test  = $NotExistingParameter
            Test1 = 'Existing Entry'
            Test2 = $null
            Test3 = ''
            Test5 = 0
            Test6 = 6
        }
        Remove-EmptyValue -Splat $SplatDictionary
        { Test-FunctionOrderedDictionary @SplatDictionary } | Should -Not -Throw
    }
    It 'From OrderedDictionary but with ExcludedProperty' {
        $SplatDictionary = [ordered] @{
            Test  = $NotExistingParameter
            Test1 = 'Existing Entry'
            Test2 = $null
            Test3 = ''
            Test5 = 0
            Test6 = 6
        }
        Remove-EmptyValue -Splat $SplatDictionary -ExcludeParameter 'Test3'
        $SplatDictionary['Test3'] | Should -Be ''
    }
    It 'From OrderedDictionary Recursive' {
        $SplatDictionary = [ordered] @{
            Test  = $NotExistingParameter
            Test1 = 'Existing Entry'
            Test2 = $null
            Test3 = ''
            Test5 = 0
            Test6 = 6
            Test7 = @{}
        }
        Remove-EmptyValue -Splat $SplatDictionary
        $SplatDictionary.Keys | Should -Contain 'Test7'

        Remove-EmptyValue -Splat $SplatDictionary -Recursive
        $SplatDictionary.Keys | Should -not -Contain 'Test7'
    }
    It 'From OrderedDictionary Recursive with ILIST check' {
        $SplatDictionary = [ordered] @{
            Test  = $NotExistingParameter
            Test1 = 'Existing Entry'
            Test2 = $null
            Test3 = ''
            Test5 = 0
            Test6 = [System.Collections.Generic.List[PSCustomObject]]::new()
            Test7 = @{}
        }
        $DummyObject = [PSCustomObject] @{
            Test  = 1
            Test1 = 2
        }
        $SplatDictionary.Test6.Add($DummyObject)

        Remove-EmptyValue -Splat $SplatDictionary
        $SplatDictionary.Keys | Should -Contain 'Test6'
        $SplatDictionary.Keys | Should -Contain 'Test7'

        Remove-EmptyValue -Splat $SplatDictionary -Recursive
        $SplatDictionary.Keys | Should -not -Contain 'Test7'
    }
    It 'From OrderedDictionary Recursive with ILIST check for Empty Arrays' {
        $SplatDictionary = [ordered] @{
            Test  = $NotExistingParameter
            Test1 = 'Existing Entry'
            Test2 = $null
            Test3 = ''
            Test5 = 0
            Test6 = [System.Collections.Generic.List[PSCustomObject]]::new()
            Test7 = @{}
            Test8 = @()
            Test9 = [System.Collections.Generic.List[PSCustomObject]]::new()
            Test10 = @('Test')
        }
        $DummyObject = [PSCustomObject] @{
            Test  = 1
            Test1 = 2
        }
        $SplatDictionary.Test6.Add($DummyObject)

        Remove-EmptyValue -Splat $SplatDictionary
        $SplatDictionary.Keys | Should -Contain 'Test6'
        $SplatDictionary.Keys | Should -Contain 'Test7'
        $SplatDictionary.Keys | Should -not -Contain 'Test8'
        $SplatDictionary.Keys | Should -not -Contain 'Test9'
        $SplatDictionary.Keys | Should -Contain 'Test10'

        Remove-EmptyValue -Splat $SplatDictionary -Recursive
        $SplatDictionary.Keys | Should -not -Contain 'Test7'
    }
    It 'Testing edge cases' {
        $Splat = [ordered]@{
            PageContent = 'Text'
            Settings    = 'Oops', 'oops'
            Margins     = @{
                MarginLeft    = 250
                MarginTop     = 250
                MarginBottom  = 200
                MarginRight   = 100
                MarginRight1  = 0
                MarginRight2  = $null
                TestBool1     = $True
                TestBool2     = $false
                TestBoolArray = $false, $true
            }
            PageSize    = 'A4'
            Rotate1     = $False, $True, $false
            Rotate2     = $False
            Rotate3     = $true
            Rotate4     = $true, $false
            Rotate5     = ''
            Rotate6     = $null, ''
        }

        Remove-EmptyValue -Hashtable $Splat
        $Splat.Keys | Should -Contain 'Rotate6'
        $Splat.Keys | Should -Not -Contain 'Rotate5'
        $Splat.Keys | Should -Contain 'Rotate4'
        $Splat.Keys | Should -Contain 'Rotate3'
        $Splat.Keys | Should -Contain 'Rotate2'
        $Splat.Keys | Should -Contain 'Rotate1'
        $Splat.Margins.Keys | Should -Contain MarginLeft
        $Splat.Margins.Keys | Should -Contain MarginTop
        $Splat.Margins.Keys | Should -Contain MarginBottom
        $Splat.Margins.Keys | Should -Contain MarginRight
        $Splat.Margins.Keys | Should -Contain MarginRight1
        $Splat.Margins.Keys | Should -Contain MarginRight2
        $Splat.Margins.Keys | Should -Contain TestBool1
        $Splat.Margins.Keys | Should -Contain TestBool2
        $Splat.Margins.Keys | Should -Contain TestBoolArray

        Remove-EmptyValue -Hashtable $Splat -Recursive
        $Splat.Margins.Keys | Should -Not -Contain MarginRight2
    }
}
