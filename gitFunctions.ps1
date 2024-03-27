##if Test-Git-Conflicts is  defined,don't load the helper functions again
if  (Get-Command Test-Git-Conflicts -ErrorAction SilentlyContinue){
    return
}
. $PSScriptRoot\helperFunctions.ps1


function Test-Git-Conflicts {
    [CmdletBinding()]
    param ()
    process {
            $conflicts = git diff --name-only --diff-filter=U
            if ($conflicts) {
                Write-Error "Conflicts found in files: $conflicts"
                return $true
            }
            Write-Info "No conflicts found"
            return $false
    }   
 }