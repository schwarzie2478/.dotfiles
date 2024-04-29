push-location .

Set-ItemProperty 'registry::HKEY_CURRENT_USER\Control Panel\Accessibility\Blind Access' on 1

Import-Module oh-my-posh
Set-PoshPrompt -Theme jandedobbeleer
Import-module Terminal-icons
Import-module PSReadline

Write-Host "Loading Visual Studio 2022 Developer Command Prompt"

& "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1"

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

# set audio device to Speakers (Realtek High Definition Audio)
Function Set-Speaker{
    $device = get-audioDEvice -List | ? { $_.Name.Contains("Speakers (Realtek High Definition Audio)") }
    Set-AudioDevice -Id $device.Id
}
Set-Alias -Name speakers -Value Set-Speaker

# do the same for HyperX CloudXSpeakers (HyperX Cloud Flight Wireless)"

Function Set-HyperCloud{
    $device = get-audioDEvice -List | ? { $_.Name.Contains("Speakers (HyperX Cloud Flight Wireless)") }
    Set-AudioDevice -Id $device.Id
}
Set-Alias -Name hyper -Value Set-HyperCloud

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
