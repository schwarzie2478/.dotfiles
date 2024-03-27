

# pop location currect script dir
push-Location $PSScriptRoot
. ./syncfiles.ps1

# info about starting
Write-Info( "Start backup task")

BackUpAndCommit
# write to info of last commit
$lastCommit = git log -1
Write-Info( "Last commit: $lastCommit")

pop-Location

