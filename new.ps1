<#
.SYNOPSIS
    Функция ReadKeyLimitedSet - чтение клавиши с консоли с ограничением допустимого множества.

.DESCRIPTION
    Функция вызывает функцию ReadKey, которая возвращает KeyInfo или KeyChar.
    Проверяет попадание символа в допустимое множество.
    Если OK, тогда передает полученный из ReadKey результат дальше.
    Иначе снова встает в ожидание по ReadKey.
    
    Поддерживает диапазоны: "a-z", "0-9", "A-Z", "a-z0-9"

.PARAMETER LimitedSet
    Определяет множество допустимых символов (строкой или массивом).
    Поддерживает диапазоны: "a-z", "0-9", "A-Z", "a-zA-Z0-9"

.PARAMETER NoCaseSensitive
    Выключает чувствительность регистра (по умолчанию регистр важен)

.PARAMETER NotShowKey
    Перехват нажатия клавиши БЕЗ отображения в консоли

.PARAMETER ReturnKeyInfo
    По умолчанию функция возвращает KeyInfo.KeyChar, при использовании параметра - KeyInfo

.PARAMETER DebugInfo
    Отображение отладочной информации

.EXAMPLE
    PS C:\> ReadKeyLimited -LimitedSet "yn"
    Ожидает ввод Y или N (регистр важен). Возвращает символ.

.EXAMPLE
    PS C:\> ReadKeyLimited -LimitedSet "a-z"
    Ожидает ввод любой строчной буквы от a до z.

.EXAMPLE
    PS C:\> ReadKeyLimited -LimitedSet "0-9"
    Ожидает ввод любой цифры от 0 до 9.

.EXAMPLE
    PS C:\> ReadKeyLimited -LimitedSet "a-zA-Z0-9"
    Ожидает ввод любой буквы или цифры.

.EXAMPLE
    PS C:\> ReadKeyLimited -LimitedSet "a-cx-z"
    Ожидает ввод a, b, c, x, y, z.

.INPUTS
    [string] LimitedSet - строка с допустимыми символами
    [string[]] LimitedSet - массив допустимых символов
    [switch] NoCaseSensitive - отключает чувствительность регистра
    [switch] NotShowKey - скрывает ввод
    [switch] ReturnKeyInfo - возвращает KeyInfo вместо KeyChar
    [switch] DebugInfo - выводит отладочную информацию

.OUTPUTS
    System.Char - по умолчанию (KeyInfo.KeyChar)
    System.ConsoleKeyInfo - при использовании параметра ReturnKeyInfo

.NOTES
    Имя: ReadKeyLimited
    Версия: 1.0
    Автор: ovaataaridotru
    Дата: 15.06.2026
#>

function Global:ReadKeyLimitedSet {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Alias("Set")]
        $LimitedSet,
        
        [Parameter(Mandatory = $false)]
        [switch]$NoCaseSensitive,
        
        [Parameter(Mandatory = $false)]
        [switch]$NotShowKey,
        
        [Parameter(Mandatory = $false)]
        [switch]$ReturnKeyInfo,
        
        [Parameter(Mandatory = $false)]
        [switch]$DebugInfo
    )
    
    # Вспомогательная функция парсинга диапазонов
    function Parse-LimitedSet {
        param([string]$Set)
        
        $result = @()
        $i = 0
        
        while ($i -lt $Set.Length) {
            $char = $Set[$i]
            
            # Проверяем, не является ли это началом диапазона
            if (($i + 2) -lt $Set.Length -and $Set[$i + 1] -eq '-') {
                # Это диапазон: a-z, 0-9, A-Z
                $start = $Set[$i]
                $end = $Set[$i + 2]
                
                if ($start -lt $end) {
                    # Прямой диапазон
                    for ($code = [int][char]$start; $code -le [int][char]$end; $code++) {
                        $result += [char]$code
                    }
                } else {
                    # Обратный диапазон (z-a)
                    for ($code = [int][char]$start; $code -ge [int][char]$end; $code--) {
                        $result += [char]$code
                    }
                }
                
                $i += 3 # Пропускаем три символа: начало, '-', конец
            } else {
                # Одиночный символ
                $result += $char
                $i++
            }
        }
        
        return $result
    }
    
    # Обработка LimitedSet
    $validSet = @()
    if ($LimitedSet -is [string]) {
        $validSet = Parse-LimitedSet -Set $LimitedSet
    } elseif ($LimitedSet -is [array]) {
        $validSet = $LimitedSet
    } else {
        $validSet = Parse-LimitedSet -Set $LimitedSet.ToString()
    }
    
    # Если отключена чувствительность регистра - добавляем оба регистра
    if ($NoCaseSensitive) {
        $originalSet = $validSet
        $validSet = @()
        foreach ($char in $originalSet) {
            $validSet += $char.ToString().ToLower()
            $validSet += $char.ToString().ToUpper()
        }
        $validSet = $validSet | Select-Object -Unique
    }
    
    # Отладочная информация
    if ($DebugInfo) {
        Write-Host "`n=== ОТЛАДОЧНАЯ ИНФОРМАЦИЯ ===" -ForegroundColor Cyan
        Write-Host "LimitedSet: $LimitedSet" -ForegroundColor Yellow
        Write-Host "Допустимые символы: $($validSet -join ', ')" -ForegroundColor Yellow
        Write-Host "Всего символов: $($validSet.Count)" -ForegroundColor Yellow
        Write-Host "CaseSensitive: $(-not $NoCaseSensitive)" -ForegroundColor Yellow
        Write-Host "NotShowKey: $NotShowKey" -ForegroundColor Yellow
        Write-Host "ReturnKeyInfo: $ReturnKeyInfo" -ForegroundColor Yellow
        Write-Host "================================`n" -ForegroundColor Cyan
    }
    
    # Основной цикл
    do {
        try {
            if (-not (Get-Command -Name ReadKey -ErrorAction SilentlyContinue)) {
                $keyInfo = [System.Console]::ReadKey($NotShowKey)
            } else {
                $keyInfo = ReadKey -Intercept $NotShowKey
            }
        } catch {
            Write-Error "Ошибка чтения клавиши: $_"
            return $null
        }
        
        $keyChar = $keyInfo.KeyChar
        
        if ($validSet -contains $keyChar) {
            if ($DebugInfo) {
                Write-Host "Допустимый символ: '$keyChar'" -ForegroundColor Green
            }
            
            if ($ReturnKeyInfo) {
                return $keyInfo
            } else {
                return $keyChar
            }
        } else {
            if ($DebugInfo) {
                Write-Host "Недопустимый символ: '$keyChar'. Ожидается: $($validSet -join ', ')" -ForegroundColor Red
            }
            continue
        }
    } while ($true)
}

# Вспомогательная функция ReadKey
function Global:ReadKey {
    param(
        [Parameter(Mandatory = $false)]
        [bool]$Intercept = $true
    )
    
    try {
        return [System.Console]::ReadKey($Intercept)
    } catch {
        Write-Error "Ошибка в ReadKey: $_"
        return $null
    }
}

# Экспорт функций
<# Export-ModuleMember -Function ReadKeyLimited, ReadKey #>