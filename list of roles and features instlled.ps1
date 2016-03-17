Import-Module ServerManager
Get-WindowsFeature | 
    Where-Object {$_.Installed -match “True”} | 
    ForEach-Object {
        $_.Name | Write-Host
    }