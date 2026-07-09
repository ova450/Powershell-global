# pwsh-1-1-baseColorsSet

Import-Module .\OptionList.psm1 -Force

$Global:ColorList = [ColorList]::new()

$Global:HeaderColor = [ConsoleColor]::Cyan
$Global:MessageColor = [ConsoleColor]::Gray
$Global:MessageSimpleColor = [ConsoleColor]::DarkGray
$Global:AttentionColor = [ConsoleColor]::Yellow
$Global:OkColor = [ConsoleColor]::Green
$Global:NotOkColor = [ConsoleColor]::Red
$Global:ErrorMessageColor = [ConsoleColor]::Red
$Global:DebugInfoColor = [ConsoleColor]::DarkBlue

$Global:ColorList.LoadFromSession()
$Global:ColorList.SaveToJson("GlobalColors.json")

$filename = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
Write-Host "Базовые глобальные цвета установлены скриптом $filename ..." -Foreground Yellow
Write-Host 