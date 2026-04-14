BeforeAll {
    Import-Module "$PSScriptRoot/../../../Modules/Microsoft365DSC/Modules/M365DSCErrorHandler.psm1" -Force
}

Describe 'Test-M365DSCTransientError' {
    Context 'When the error is a timeout' {
        It 'Should return $true for "<Message>"' -ForEach @(
            @{ Message = 'The operation has timed out.' }
            @{ Message = 'The request timed out while connecting to the remote service.' }
            @{ Message = 'Connection timeout reached after 30 seconds.' }
            @{ Message = 'The task was canceled due to timeout.' }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCTransientError -ErrorRecord $_
                $result | Should -BeTrue
            }
        }
    }

    Context 'When the error is a server error (5XX)' {
        It 'Should return $true for "<Message>"' -ForEach @(
            @{ Message = 'Response status code does not indicate success: 500 (Internal Server Error).' }
            @{ Message = 'Response status code does not indicate success: 502 (Bad Gateway).' }
            @{ Message = 'Response status code does not indicate success: 503 (Service Unavailable).' }
            @{ Message = 'Response status code does not indicate success: 504 (Gateway Timeout).' }
            @{ Message = 'The remote server returned an error: (503) Service Unavailable.' }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCTransientError -ErrorRecord $_
                $result | Should -BeTrue
            }
        }
    }

    Context 'When the error is a throttling error' {
        It 'Should return $true for "<Message>"' -ForEach @(
            @{ Message = 'Response status code does not indicate success: 429 (Too Many Requests).' }
            @{ Message = 'Request was throttled. Retry after 30 seconds.' }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCTransientError -ErrorRecord $_
                $result | Should -BeTrue
            }
        }
    }

    Context 'When the error is a connection failure' {
        It 'Should return $true for "<Message>"' -ForEach @(
            @{ Message = 'Unable to connect to the remote server.' }
            @{ Message = 'The underlying connection was closed: A connection that was expected to be kept alive was closed by the server.' }
            @{ Message = 'An existing connection was forcibly closed by the remote host.' }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCTransientError -ErrorRecord $_
                $result | Should -BeTrue
            }
        }
    }

    Context 'When the error is NOT transient' {
        It 'Should return $false for "<Message>"' -ForEach @(
            @{ Message = 'Request_ResourceNotFound: Resource does not exist.' }
            @{ Message = 'Insufficient privileges to complete the operation.' }
            @{ Message = 'Access denied.' }
            @{ Message = 'The specified object was not found.' }
            @{ Message = 'Parameter validation failed.' }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCTransientError -ErrorRecord $_
                $result | Should -BeFalse
            }
        }
    }
}

Describe 'Test-M365DSCNotFoundError' {
    Context 'When the error is a Graph "not found"' {
        It 'Should return $true for "<Message>"' -ForEach @(
            @{ Message = "[ResourceNotFound] : {`n  ""_version"": 3,`n  ""Message"": ""An error has occurred"" }" }
            @{ Message = 'Resource ''MyPolicy'' does not exist or one of its queried reference-property objects are not present.' }
            @{ Message = "Response status code does not indicate success: 404 (Not Found)." }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCNotFoundError -ErrorRecord $_
                $result | Should -BeTrue
            }
        }
    }

    Context 'When the error is an Exchange "not found"' {
        It 'Should return $true for "<Message>"' -ForEach @(
            @{ Message = "The operation couldn't be completed because object 'TestDomain.com' couldn't be found on 'YOURSERVER.outlook.com'." }
            @{ Message = "The specified object was not found in the store." }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCNotFoundError -ErrorRecord $_
                $result | Should -BeTrue
            }
        }
    }

    Context 'When the error is a SharePoint/PnP "not found"' {
        It 'Should return $true for "<Message>"' -ForEach @(
            @{ Message = 'Site Script Not Found' }
            @{ Message = 'File Not Found.' }
            @{ Message = 'Group cannot be found.' }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCNotFoundError -ErrorRecord $_
                $result | Should -BeTrue
            }
        }
    }

    Context 'When the error is NOT a "not found" error' {
        It 'Should return $false for "<Message>"' -ForEach @(
            @{ Message = 'Insufficient privileges to complete the operation.' }
            @{ Message = 'Access denied.' }
            @{ Message = 'Response status code does not indicate success: 500 (Internal Server Error).' }
            @{ Message = 'The operation has timed out.' }
            @{ Message = 'The remote server returned an error: (503) Service Unavailable.' }
        ) {
            try
            {
                throw $Message
            }
            catch
            {
                $result = Test-M365DSCNotFoundError -ErrorRecord $_
                $result | Should -BeFalse
            }
        }
    }
}

Describe 'Invoke-M365DSCCommand' {
    Context 'When the scriptblock succeeds' {
        It 'Should return the result of the scriptblock' {
            $result = Invoke-M365DSCCommand -ScriptBlock { 'Hello World' }
            $result | Should -Be 'Hello World'
        }

        It 'Should return complex objects' {
            $result = Invoke-M365DSCCommand -ScriptBlock {
                @{ Name = 'Test'; Value = 42 }
            }
            $result.Name | Should -Be 'Test'
            $result.Value | Should -Be 42
        }
    }

    Context 'When the scriptblock returns $null' {
        It 'Should return $null without error' {
            $result = Invoke-M365DSCCommand -ScriptBlock { $null }
            $result | Should -BeNullOrEmpty
        }
    }

    Context 'When a not-found error occurs with SuppressNotFoundError' {
        It 'Should return $null instead of throwing' {
            $result = Invoke-M365DSCCommand -ScriptBlock {
                throw "Request_ResourceNotFound: Resource does not exist."
            } -SuppressNotFoundError
            $result | Should -BeNullOrEmpty
        }
    }

    Context 'When a not-found error occurs without SuppressNotFoundError' {
        It 'Should throw the error' {
            {
                Invoke-M365DSCCommand -ScriptBlock {
                    throw "Request_ResourceNotFound: Resource does not exist."
                }
            } | Should -Throw '*Request_ResourceNotFound*'
        }
    }

    Context 'When a not-found error occurs with RetryOnNotFoundError' {
        It 'Should not throw the error if limit is not reached' {
            {
                $Script:limit = 1
                $Script:count = 0
                $baseDelay = 0
                Invoke-M365DSCCommand -ScriptBlock {
                    $Script:count++
                    if ($Script:count -le $Script:limit)
                    {
                        throw "Request_ResourceNotFound: Resource does not exist. Attempt $Script:count of $Script:limit."
                    }
                    return "Success on attempt $Script:count"
                } -RetryOnNotFoundError -BaseDelayInSeconds $baseDelay
            } | Should -Not -Throw
        }

        It 'Should throw the error if the limit is reached' {
            {
                $baseDelay = 0
                Invoke-M365DSCCommand -ScriptBlock {
                    throw "Request_ResourceNotFound: Resource does not exist."
                } -RetryOnNotFoundError -BaseDelayInSeconds $baseDelay -MaxRetries 2
            } | Should -Throw '*Request_ResourceNotFound*'
        }
    }

    Context 'When a transient error occurs and then succeeds' {
        It 'Should retry and return the result' {
            $script:callCount = 0
            $result = Invoke-M365DSCCommand -ScriptBlock {
                $script:callCount++
                if ($script:callCount -eq 1)
                {
                    throw 'The operation has timed out.'
                }
                'Success after retry'
            } -BaseDelayInSeconds 0
            $result | Should -Be 'Success after retry'
            $script:callCount | Should -Be 2
        }
    }

    Context 'When a transient error persists beyond max retries' {
        It 'Should throw after exhausting retries' {
            {
                Invoke-M365DSCCommand -ScriptBlock {
                    throw 'Response status code does not indicate success: 503 (Service Unavailable).'
                } -MaxRetries 2 -BaseDelayInSeconds 0
            } | Should -Throw '*503*Service Unavailable*'
        }
    }

    Context 'When a permanent error occurs' {
        It 'Should throw immediately without retrying' {
            $script:callCount = 0
            {
                Invoke-M365DSCCommand -ScriptBlock {
                    $script:callCount++
                    throw 'Insufficient privileges to complete the operation.'
                } -BaseDelayInSeconds 0
            } | Should -Throw '*Insufficient privileges*'
            $script:callCount | Should -Be 1
        }
    }

    Context 'When multiple transient errors occur before success' {
        It 'Should retry multiple times and succeed' {
            $script:callCount = 0
            $result = Invoke-M365DSCCommand -ScriptBlock {
                $script:callCount++
                if ($script:callCount -le 2)
                {
                    throw 'The operation has timed out.'
                }
                'Finally succeeded'
            } -MaxRetries 3 -BaseDelayInSeconds 0
            $result | Should -Be 'Finally succeeded'
            $script:callCount | Should -Be 3
        }
    }
}
