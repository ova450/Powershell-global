# pwsh-global.ps1
[bool]$Global:LogDebug = $true
[bool]$Global:LogExamples = $true
[bool]$Global:LogHeader = $true
[bool]$Global:LogDetails = $true
[bool]$Global:Registration = $false
[bool]$Global:GlobalSystemVariablesManagement = $false

function Start()
{
	
}

function GlobalSystemVariables
{
	param(
		[switch]:$Debug,
		[switch]:$Examples,
		[switch]:$Headers,
		[switch]:$Details
		[switch]:$Registration
		[switch]:$GlobalSystemVariablesManagement
		)
[bool]$Global:LogDebug = $true
[bool]$Global:LogExamples = $true
[bool]$Global:LogHeader = $true
[bool]$Global:LogDetails = $true
}

function Global:BodyAndSpacelines {
    param (
        [object]$body,
        [int]$before = 0,
        [int]$after = 0,
        [switch]$NoNewline,
        [switch]$Debug
    )

Write-Host "`n1. УСТАНОВКА ГЛОБАЛЬНЫХ СИСТЕМНЫХ МОДУЛЕЙ, ФУНКЦИЙ, ПЕРЕМЕННЫХ И РЕЖИМОВ" -foreground cyan
# Режимы вывода
Write-Host "`n1.1. Режимы вывода" -foreground cyan
Write-Host "`nHeaders = $Headers"
Write-Host "Details = $Details"
# Режимы логирования
Write-Host "`n1.1. Режимы логирования" -foreground cyan
Write-Host "`nDebug = $Debug"
Write-Host "Examples = $Examples"
# Системные модули
Write-Host "`n1.3. Системные модули" -foreground cyan
[bool]$Global:InstallModuleInstalled = $false
[bool]$Global:PowershellRichInstalled = $false
[bool]$Global:PowershellRichModeOn = $false
Write-Host "`nInstallModuleInstalled = $InstallModuleInstalled"
Write-Host "PowershellRichInstalled = $InstallModuleInstalled"
Write-Host "PowershellRichModeOn = $InstallModuleInstalled"
# Colors
Write-Host "`n1.4. Глобальные системные цвета"-foreground cyan
$Global:HeaderColor = [ConsoleColor]::Cyan
$Global:MessageColor = [ConsoleColor]::Gray
$Global:MessageSimpleColor = [ConsoleColor]::DarkGray
$Global:RequestColor = [ConsoleColor]::Yellow
$Global:OkColor = [ConsoleColor]::Green
$Global:NotOkColor = [ConsoleColor]::Red
$Global:ErrorMessage = [ConsoleColor]::Red
Write-Host "`nHeader" -ForegroundColor $HeaderColor
Write-Host "простое уведомление" -ForegroundColor $MessageColor
Write-Host "Сообщение об ошибке" -ForegroundColor $ErrorMessage
Write-Host "Важное сообщение, уведомление о проверке, запрос реакции" -ForegroundColor $RequestColor
Write-Host "Положительный результат проверки" -ForegroundColor $OkColor
Write-Host "Отрицательный результат проверки" -ForegroundColor $NotOkColor
