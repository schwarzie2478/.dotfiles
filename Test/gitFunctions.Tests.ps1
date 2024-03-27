# write pester tests for the functions in gitFunctions.ps1

BeforeAll {
    . $PSScriptRoot\..\helperFunctions.ps1
    . $PSScriptRoot\..\gitFunctions.ps1
    Push-Location $PSScriptRoot\..\..
    $testRoot = Get-Item .

    # make a test directory at next to the root of the repo
    $testDir = Join-Path -Path $testRoot -ChildPath "\GitTest"
    if (!(Test-Path -Path $testDir)) {
        New-Item -ItemType Directory -Path $testDir | Out-Null
        
    }else
    {
        Write-Info("Removing existing test directory")
        Remove-Item -Path $testDir -Recurse -Force
        New-Item -ItemType Directory -Path $testDir | Out-Null
    }

    # initialize a git repo in the test directory
    set-location $testDir
    git init 
    # create a file in the test directory
    $testFile = Join-Path -Path $testDir -ChildPath "testFile.txt"
    New-Item -Path $testFile -ItemType File -Value "This is a test file" | Out-Null
    # add the file to the git repo
    git add $testFile
    git commit -m "Initial commit"

}
# test the function Test-Git-Conflicts
Describe "Test-Git-Conflicts" {
    Context "When there are no conflicts" {
        It "Should return false" {
            $result = Test-Git-Conflicts
            $result | Should -Be $false
        }
    }
    Context "When there are conflicts" {
        It "Should return true" {
            # create a conflict
            $testFile = Join-Path -Path $testDir -ChildPath "testFile2.txt"

            git checkout -B testBranch
            Set-Content -Path $testFile -Value "This is a newly modified test file"
            git add $testFile
            git commit -m "Modified file from branch"
            git checkout master
            Set-Content -Path $testFile -Value "This is a modified test file"
            git add $testFile
            git commit -m "Modified file from master"
            git merge testBranch
            $result = Test-Git-Conflicts
            $result | Should -Be $true
        }
    }
}

AfterAll {
    # remove the test directory
    Remove-Item -Path $testDir -Recurse -Force
    pop-location
}

