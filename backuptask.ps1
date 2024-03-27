# info about starting
Write-Info( "Start backup task")

# pop location currect script dir
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
push-Location $dir

. ./syncfiles.ps1

BackUpAndCommit
# write to info of last commit
$lastCommit = git log -1
Write-Info( "Last commit: $lastCommit")

pop-Location

