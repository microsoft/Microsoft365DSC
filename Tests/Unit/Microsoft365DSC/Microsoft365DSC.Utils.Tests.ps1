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
}
