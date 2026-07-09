# pwsh-Get-GlobalVariables.ps1

# Загружаем базовые скрипты
. .\pwsh-1-0-baseVariablesSet.ps1
. .\pwsh-1-1-baseColorsSet.ps1

Write-Host "`n=== Пользовательские глобальные переменные ===`n" -ForegroundColor Cyan

$allGlobals = Get-Variable -Scope Global

$filtered = $allGlobals | Where-Object {
    $name = $_.Name

    # Исключаем цвета
    if ($_.Value -is [ConsoleColor] -or $name -match 'Color$') { return $false }

    # Исключаем автоматические и системные переменные
    if ($name -in @('^', '$', 'args', 'input', 'StackTrace', 'MyInvocation', 'PWD', 'PROFILE')) { return $false }
    
    if ($name -match '^(PS|Console|Error|Host|LAST|True|False|NULL|_|ConfirmPreference|DebugPreference|ErrorActionPreference|VerbosePreference|WarningPreference|InformationPreference|ProgressPreference|WhatIfPreference|FormatEnumerationLimit|MaximumHistoryCount|NestedPromptLevel|OutputEncoding|PSSession|PSNative|PSBoundParameters|PSDefaultParameterValues)') {
        return $false
    }

    # Исключаем read-only и constant
    if ($_.Options -match 'ReadOnly|Constant') { return $false }

    return $true
} | Sort-Object Name

# Формирование таблицы
$result = foreach ($var in $filtered) {
    $name  = $var.Name
    $value = $var.Value

    if ($null -eq $value) {
        $psType = '[object]'
        $display = '$null'
    }
    elseif ($value -is [switch] -or $value -is [System.Management.Automation.SwitchParameter]) {
        $psType = '[switch]'
        $display = if ($value.IsPresent) { 'True' } else { 'False' }
    }
    else {
        $typeName = $value.GetType().Name
        $psType = switch ($typeName) {
            'Boolean'   { '[bool]' }
            'String'    { '[string]' }
            'Int32'     { '[int]' }
            'Int64'     { '[long]' }
            'Double'    { '[double]' }
            default     { "[$($typeName.ToLower())]" }
        }
        $display = if ($value -is [string] -and $value.Length -gt 60) { 
                        $value.Substring(0,57) + '...' 
                   } else { 
                        $value.ToString() 
                   }
    }

    [PSCustomObject]@{
        Type  = $psType.PadRight(12)
        Name  = "`$$name".PadRight(35)
        Value = $display
    }
}

$result | Format-Table -AutoSize

Write-Host "`nВсего пользовательских переменных: $($result.Count)" -ForegroundColor Yellow