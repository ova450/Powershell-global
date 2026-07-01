# pwsh-1-0-baseVariablesSet

[bool]$Global:DebugInfo = $true
[bool]$Global:CommandInfo = $true
[bool]$Global:Examples = $true
[bool]$Global:LogDetails = $true
[bool]$Global:LogDebugInfo = $true
[bool]$Global:Registration = $false
[bool]$Global:GlobalSystemVariablesManagement = $false

 $filename = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
Write-Host "`n$filename : базовые глобальные переменные установлены..." -Foreground Gray