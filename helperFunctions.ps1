#if Write-Info is  defined,don't load the helper functions again
# if  (Get-Command Write-Info -ErrorAction SilentlyContinue){
#     return
# }

$logPath = '$PSScriptRoot\log'

if (!(Test-Path -Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

function Write-Info{
    param (
        [Parameter(Mandatory = $true)]
        $logMessage,
        [Parameter(Mandatory = $false)]
        $logEvent = $false
    )

    write-host $logMessage
    # get date and time in a format that can be used in a file name
    $date = Get-Date -Format "yyyy-MM-dd"
    $logMessage | Out-File -Append -FilePath "$PSScriptRoot\log\${date}-log.txt"
    if ($logEvent) {
        # use new-winevent to write to the event log
        # TODO: figure out how to use this
        # New-WinEvent -ProviderName Microsoft-Windows-PowerShell -Payload @( "BackupTask",$logMessage) -Id 0 
    }
}
function Write-Error($logMessage)
{
    $date = Get-Date -Format "yyyy-MM-dd"
    $logMessage | Out-File -Append -FilePath "$PSScriptRoot\log\${date}-error.txt"
    # TODO: figure out how to use this
    # New-WinEvent -ProviderName Microsoft-Windows-PowerShell -Payload@( "BackupTask",$logMessage) -Id 1000 
}

# use Get-WinEvent to retrieve the last 100 events from the Microsoft-Windows-PowerShell log and return a list of the distinct ids
function Get-EventIds {
    $events = Get-WinEvent -LogName Microsoft-Windows-PowerShell -MaxEvents 100
    $eventIds = $events | Select-Object -ExpandProperty Id -Unique
    return $eventIds
}



