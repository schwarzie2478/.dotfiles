# Test-Path if exists D:\sources\.dotfiles\backuptask.ps1
if(!(Test-Path "D:\sources\.dotfiles\backuptask.ps1")) {
    Write-Info("File D:\sources\.dotfiles\backuptask.ps1 does not exist")
    Write-Info("If running from different location, please change the path here and in the xml file")
    return
}

# Register-ScheduledTask with xml content fro BackupTask.xml
Register-ScheduledTask -Xml (Get-Content .\BackupTask.xml | Out-String) -TaskName "BackupTask"


