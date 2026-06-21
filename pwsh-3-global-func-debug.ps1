# pwsh-3-global-func.ps1
.\pwsh-1-global
.\pwsh-2-global-colors

function Global:BodyAndSpacelines {
    param (
        [object]$body,
        [int]$before = 0,
        [int]$after = 0,
        [switch]$NoNewline,
        [switch]$Debug
    )
    
    # Добавляем пустые строки перед сообщением
    for ($i = 1; $i -le $before; $i++) {
        if ($Debug) { 
            Write-Host "-$i" -ForegroundColor $OkColor 
        } else { 
            Write-Host "" 
        }
    }
    
    # Выводим сообщение
    $str = "- $body ... "
    if ($Debug) { 
        $str += "$before / $after DebugMode" 
    }
    
    # ДИАГНОСТИКА:
    Write-Host "`n[DEBUG] str = '$str'" -ForegroundColor Cyan
    Write-Host "[DEBUG] MessageColor = $MessageColor" -ForegroundColor Cyan
    Write-Host "[DEBUG] MessageColor Type = $($MessageColor.GetType())" -ForegroundColor Cyan
    
    if ($NoNewline) {
        Write-Host $str -NoNewline -ForegroundColor Yellow
    } else {
        Write-Host $str -ForegroundColor $MessageColor
    }
    
    # Добавляем пустые строки после сообщения
    for ($j = 1; $j -le $after; $j++) {
        if ($Debug) { 
            Write-Host "$j" -ForegroundColor $OkColor 
        } else { 
            Write-Host "" 
        }
    }
}

# Примеры использования
Write-Host "`n1.3.2. Message ([string]`$text)" -ForegroundColor Cyan

BodyAndSpacelines "простое уведомление"
BodyAndSpacelines "простое уведомление без переноса строки" 3 3 -Debug -NoNewline
BodyAndSpacelines "простое уведомление с переносом на две строки" 1 1
BodyAndSpacelines "простое уведомление с переносом на две строки" 5 5 -Debug
BodyAndSpacelines "простое уведомление с переносом на две строки" 5 5