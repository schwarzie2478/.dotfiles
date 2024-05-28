push-location C:\Users\Stijn\Documents\PowerShell

Set-ItemProperty 'registry::HKEY_CURRENT_USER\Control Panel\Accessibility\Blind Access' on 1

Import-Module oh-my-posh
Set-PoshPrompt -Theme schwarzie2478
Import-module Terminal-icons

Import-module PSReadline
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# zoxide installed with scoop
# configure zoxide to have z as alias
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# From yazi manual
# Provides the ability to change the current working directory when exiting Yazi.
function yy {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

Write-Host "Loading Visual Studio 2022 Developer Command Prompt"

& "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"

. C:\Users\Stijn\Documents\PowerShell\SoundConfiguration.ps1

function Search-Google{
    $query = 'https://www.google.com/search?q='
    $args | % { $query = $query + "$_+" }
    $url = $query.Substring(0, $query.Length - 1)
    start "$url"
}
Set-Alias google Search-Google

Function OpenNeoVimConfigFile{ nvim $env:userprofile\AppData\local\nvim\init.lua}
set-alias -Name nvim-config -Value OpenNeoVimConfigFile
set-alias -Name vim -Value nvim

Function OpenPowershellConfigFile{ code $Profile}
set-alias -Name ps-config -Value OpenPowershellConfigFile


# make alias for asking github copilot cli for a given suggestion
Function Get-CopilotSuggestion{
    gh copilot suggest -t shell $args
}
# set alias for Get-CopilotSuggestion to suggest
Set-Alias -Name ask -Value Get-CopilotSuggestion

Function Copy-Config{
& "d:\Sources\.dotfiles\backuptask.ps1"
}
set-alias -Name saveconfig -Value Copy-Config

pop-location
