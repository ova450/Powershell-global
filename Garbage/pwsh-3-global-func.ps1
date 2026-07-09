# pwsh-3-global-func.ps1
.\pwsh-1-global
#.\pwsh-2-global-colors

Write-Host "`n1.3. Установка локальных системных функций	"-foreground $headercolor

# 1. Check
function Global:Check {
    param(
        [bool]$check,
        [string]$message,
        [string]$isok,
        [string]$isnok
    )
	Write-Host $message  -foreground $requestcolor -NoNewline
    if ($check) { Write-Host $isok -ForegroundColor Green }
	else { Write-Host $isnok -ForegroundColor Red }
}

# Проверка служб
Write-Host "`n1.3.1. Check ([bool]"$"check, [string]"$"message, [string]"$"isok, [string]"$"isnok)" -foreground $messagesimplecolor
$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
Check ($service -ne $null) "       Проверка службы $ServiceName... " "Служба $ServiceName уже установлена" "Служба $ServiceName не установлена"
$service = Get-Service -Name "NoName" -ErrorAction SilentlyContinue
Check ($service -ne $null) "       Проверка службы NoName... " "Служба NoName уже установлена" "Служба NoName не установлена"

<# # Перенос строк
function Global:BodyAndSpacelines {
    param (
        [object]$body,
        [int]$before = 0,
        [int]$after = 0,
		[switch]$NoNewline
    )
    
    # Добавляем пустые строки перед сообщением
    for ($i = 1; $i -le $before; $i++) {
        Write-Host ($Debug ? "-$i" : "") -ForegroundColor $OkColor
    }
    
    # Выводим сообщение
	$str = "- $body ... " + ($Debug ? "$before / $after DebugMode":"")
	if ($NoNewline) {Write-Host $str -NoNewline -ForegroundColor $RequestColor}
	else  {Write-Host $str -ForegroundColor $RequestColor}
	   
    # Добавляем пустые строки после сообщения
    for ($j = 1; $j -le $after; $j++) {
        Write-Host ($Debug ? "$j" : "") -ForegroundColor $OkColor
    }
} #>

# Перенос строк
function Global:Spacelines {
    param (
        [int]$numlines = 0,
        [switch]$Before,
		[switch]$NoNewline
    )
# Добавляем пустые строки перед ...
if ($Before) {  for ($i = 1; $i -le $before; $i++) {  Write-Host ($Debug ? "-$i" : "") -ForegroundColor $OkColor }
# Добавляем пустые строки после ...
else { for ($j = 1; $j -le $after; $j++) { Write-Host ($Debug ? "$j" : "") -ForegroundColor $OkColor }
    
function Global:Spacelines {
    param (
        [int]$numlines = 0,
        [switch]$Before,
		[switch]$NoNewline
    )
    
    # Добавляем пустые строки перед сообщением
function Global: Spacr	
    for ($i = 1; $i -le $before; $i++) {
        Write-Host ($Debug ? "-$i" : "") -ForegroundColor $OkColor
    }
    
    # Выводим сообщение
	$str = "- $body ... " + ($Debug ? "$before / $after DebugMode":"")
	if ($NoNewline) {Write-Host $str -NoNewline -ForegroundColor $RequestColor}
	else  {Write-Host $str -ForegroundColor $RequestColor}
	   
    # Добавляем пустые строки после сообщения
    for ($j = 1; $j -le $after; $j++) {
        Write-Host ($Debug ? "$j" : "") -ForegroundColor $OkColor
    }
}



# Примеры использования
Write-Host "`n1.3.2. Message ([string]`$text)" -ForegroundColor Cyan

BodyAndSpacelines "простое уведомление"
BodyAndSpacelines "простое уведомление без переноса строки" 3 3 -Debug -NoNewline
BodyAndSpacelines "простое уведомление с переносом на две строки" 1 1
BodyAndSpacelines "простое уведомление с переносом на две строки" 5 5 -Debug
BodyAndSpacelines "простое уведомление с переносом на две строки" 5 5
