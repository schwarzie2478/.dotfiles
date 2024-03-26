function BackupConfigFiles {
    param(
    )
    # copy .gitignore to the root of the repository
    Copy-Item $env:USERPROFILE\.gitignore -Destination .\.gitignore -Force
    # copy .gitconfig to the root of the repository
    Copy-Item $env:USERPROFILE\.gitconfig -Destination .\.gitconfig -Force
    # copy .gitattributes to the root of the repository
    Copy-Item $env:USERPROFILE\.gitattributes -Destination .\.gitattributes -Force
    # copy .editorconfig to the root of the repository
    Copy-Item $env:USERPROFILE\.editorconfig -Destination .\.editorconfig -Force
    # copy .gitmessage to the root of the repository
    Copy-Item $env:USERPROFILE\.gitmessage -Destination .\.gitmessage -Force
    # copy .npmrc to the root of the repository
    Copy-Item $env:USERPROFILE\.npmrc -Destination .\.npmrc -Force
    # copy .vscode/extensions/extensions.json to the root of the repository
    Copy-Item $env:USERPROFILE\.vscode\extensions\extensions.json -Destination .\vscode\extensions\ -Recurse -Force
    # copy vscode settings from appdata to the root of the repository
    Copy-Item $env:USERPROFILE\AppData\Roaming\Code\User\settings.json -Destination .\vscode\settings.json -Force
    # copy vscode snippets from appdata to the root of the repository
    Copy-Item $env:USERPROFILE\AppData\Roaming\Code\User\snippets -Destination .\vscode\snippets -Recurse -Force
    # copy vscode keybindings from appdata to the root of the repository
    Copy-Item $env:USERPROFILE\AppData\Roaming\Code\User\keybindings.json -Destination .\vscode\keybindings.json -Force
    # copy powershell config file from Documents/Powershell to the root of the repository
    Copy-Item $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -Destination .\Microsoft.PowerShell_profile.ps1 -Force
    # copy VS code powershell config file from Documents/Powershell to the root of the repository 
    Copy-Item $env:USERPROFILE\Documents\PowerShell\Microsoft.VSCode_profile.ps1 -Destination .\Microsoft.VSCode_profile.ps1 -Force

}
# reverse previous function
function RestoreConfigFiles {
    param(
    )
    # copy .gitignore to the root of the user profile
    Copy-Item .\.gitignore -Destination $env:USERPROFILE\.gitignore -Force
    # copy .gitconfig to the root of the user profile
    Copy-Item .\.gitconfig -Destination $env:USERPROFILE\.gitconfig -Force
    # copy .gitattributes to the root of the user profile
    Copy-Item .\.gitattributes -Destination $env:USERPROFILE\.gitattributes -Force
    # copy .editorconfig to the root of the user profile
    Copy-Item .\.editorconfig -Destination $env:USERPROFILE\.editorconfig -Force
    # copy .gitmessage to the root of the user profile
    Copy-Item .\.gitmessage -Destination $env:USERPROFILE\.gitmessage -Force
    # copy .npmrc to the root of the user profile
    Copy-Item .\.npmrc -Destination $env:USERPROFILE\.npmrc -Force
    # copy .vscode/extensions/extensions.json to the root of the user profile
    Copy-Item .\vscode\extensions\extensions.json -Destination $env:USERPROFILE\.vscode\extensions\ -Recurse -Force
    # copy vscode settings from the root of the repository to appdata
    Copy-Item .\vscode\settings.json -Destination $env:USERPROFILE\AppData\Roaming\Code\User\settings.json -Force
    # copy vscode snippets from the root of the repository to appdata
    Copy-Item .\vscode\snippets -Destination $env:USERPROFILE\AppData\Roaming\Code\User\snippets -Recurse -Force
    # copy vscode keybindings from the root of the repository to appdata
    Copy-Item .\vscode\keybindings.json -Destination $env:USERPROFILE\AppData\Roaming\Code\User\keybindings.json -Force
    # copy powershell config file from the root of the repository to Documents/Powershell
    Copy-Item .\Microsoft.PowerShell_profile.ps1 -Destination $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -Force
    # copy VS code powershell config file from the root of the repository to Documents/Powershell
    Copy-Item .\Microsoft.VSCode_profile.ps1 -Destination $env:USERPROFILE\Documents\PowerShell\Microsoft.VSCode_profile.ps1 -Force
}

function BackUpAndCommit {
    param(
    )
    BackupConfigFiles
    git add .
    git commit -m "syncfiles.ps1: backup config files on machine $env:COMPUTERNAME"
}
function RestoreConfigFilesAfterPull {
    param(
    )
    git pull
    RestoreConfigFiles
}

# install vs code plugins from extensions.json in commandline
function InstallVsCodeExtensions {
    param(
    )
    $extensions = Get-Content vscode\extensions\extensions.json | ConvertFrom-Json
    $extensions | ForEach-Object {
        code --install-extension $_.name
    }
}






