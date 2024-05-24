BeforeAll {
    . $PSScriptRoot\..\syncFiles.ps1
}
Describe "Testing Backup PowerShell Modules" {
    Context "When the script is run" {
        It "should create a file in the powershell folder" {
            BackUpInstalledModulesToJson
            $fileExists = Test-Path -Path $PSScriptRoot\..\powershell\installedModules.json
            $fileExists | Should -Be $true
        }
    }
}
Describe "Testing Backup configuration files" {
    Context "When the script is run" {
        # TODO: make test file different from existing files
        It "should create a file in the config folder" {
            Copy-FilesToRepoRoot
            $fileExists = Test-Path -Path $PSScriptRoot\..\.gitmessage
            $fileExists | Should -Be $true
            
            $fileExists = Test-Path -Path $PSScriptRoot\..\windowsTerminal\settings.json
            $fileExists | Should -Be $true
            
        }
    }
}
Describe "Testing Commit and Push" {
    Context "When the script is run" {
        It "should commit and push the changes" {
            BackUpAndCommit
        }
    }
}
AfterAll {
    # Remove-Item -Path $PSScriptRoot\..\powershell\installedModules.json
}
