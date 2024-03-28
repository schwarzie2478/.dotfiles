. $PSScriptRoot\configFiles.ps1
. $PSScriptRoot\helperFunctions.ps1
. $PSScriptRoot\gitFunctions.ps1

function Copy-FilesToRepoRoot($copyData) {
    foreach ($fileName in $copyData.Keys) {
        $sourcePath = Join-Path -Path $env:USERPROFILE -ChildPath $copyData[$fileName]["fileLocation"]
        $destinationParent = $copyData[$fileName]["syncDir"]
        $destinationPath = Join-Path -Path $destinationParent -ChildPath $fileName
        Copy-Item $sourcePath -Destination $destinationPath -Force
    }
}



function Backup {
    param()
    Copy-FilesToRepoRoot $configItems
    BackUpInstalledModulesToJson
    ListChocoPackages
    ListScoopPackages
}

# function to pull from remote and return false if there are conflicts


function BackUpAndCommit {
    param(
    )
    git pull
    # if there are conflicts, return
    if (Test-Git-Conflicts) {
        return
    }

    Backup
    $modified = git status -s
    # if string is not empty take first element
    if ($modified) {
        if($modified -is [string]) {
            $firstModified = $modified
        } elseif ($modified -is [array]) {  
            $firstModified = $modified[0]
        }
    }else {
        Info "No files modified"
        return
    }

    git add .
    git commit -m $"Backup config like $firstModified" -m "Backup config on machine $env:COMPUTERNAME\n\n Modified files:  \n$modified"
    if (Test-Git-Conflicts) {
        return
    }
    git push
}

# install vs code plugins from extensions.json in commandline if not installed  and after confirming with the user
function InstallVsCodeExtensions {
    param(
    )
    $extensions = Get-Content .\vscode\extensions\extensions.json | ConvertFrom-Json
    $extensions | ForEach-Object {
        $extensionName = $_.identifier.id
        $extensionPublisher = $_.metadata.publisherDisplayName
        if(CheckIfExtensionInstalled -extensionName $extensionName ) {
            Write-Host "Extension $extensionName by $extensionPublisher is already installed"
            continue
        }

        $installExtension = Read-Host "Install extension $extensionName by $extensionPublisher? (y/n)"
        if ($installExtension -eq "y") {
            # code --install-extension $extensionName
        }
    }
}
# check if extension is installed in vs code from commandline
function CheckIfExtensionInstalled {
    param(
        [string]$extensionName
    )
    $extension = code --list-extensions | Where-Object {$_ -eq "$extensionName"}
    if ($extension -eq "$extensionName") {
        Write-Host "Extension $extensionName  is installed"
        return $true
    } else {
        Write-Host "Extension $extensionName  is not installed"
        return $false
    }
}

# retrieve list of installed moduls in powershell
function GetInstalledModules {
    param(
    )
    Get-Module -ListAvailable | Select-Object Name, Version, Path
}
# retrieve list of installed modules in powershell and save to a json file
function BackUpInstalledModulesToJson {
    param(
    )
    GetInstalledModules | ConvertTo-Json | Out-File $PSScriptRoot\powershell\installedModules.json
}
# for all modules in installedModules.json, install them after confirming with the user
function InstallModulesFromJson {
    param(
    )
    $modules = Get-Content .\powershell\installedModules.json | ConvertFrom-Json
    $modules | ForEach-Object {
        $moduleName = $_.Name
        $moduleVersion = $_.Version
        $modulePath = $_.Path
        $installModule = Read-Host "Install module $moduleName version $moduleVersion from $modulePath? (y/n)"
        if ($installModule -eq "y") {
            Install-Module -Name $moduleName -RequiredVersion $moduleVersion -Scope CurrentUser
        }
    }
}

# function to list scoop packages
function ListScoopPackages {
    param(
    )
   scoop list > tools\scoop-packages.txt
}

# function to list choco packages
function ListChocoPackages {
    param(
    )
    choco list > tools\choco-packages.txt
}
