# test Write-Info with pester

BeforeAll {
    . $PSScriptRoot\..\HelperFunctions.ps1
}

# Describe "Write-Info" 

Describe "Write-Info" {
    It "should write to the console" {
        Write-Info "This is a test"
    }
}
# test Write-Error with pester
Describe "Write-Error" {
    It "should write to the console" {
        Write-Error "This is a test"
    }
}

# test info to eventlog
Describe "Write-Info with logEvent set to true" {
    It "should write to the event log" {
        Write-Info "This is a test" -logEvent $true
        $result = Get-winEvent -ProviderName Application -MaxEvents 1
        $result.Message | Should -Be "This is a test"
    }
}


