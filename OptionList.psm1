# OptionList.psm1 - Универсальный класс для управления глобальными опциями (цвета + переменные)
# Для проекта Global в ShellByPowershell

class OptionList {
    [string]$Name
    [hashtable]$Items = @{}  # Key: Name, Value: PSCustomObject {Type, Value, Description?}

    OptionList([string]$name) {
        $this.Name = $name
    }

    # Универсальный метод загрузки из текущего сеанса
    [void] LoadFromSession() {
        $globals = Get-Variable -Scope Global -ErrorAction SilentlyContinue
        
        foreach ($var in $globals) {
            $name = $var.Name
            $value = $var.Value
            
            # Фильтрация (можно расширить)
            if ($name -match '^(PS|Error|Host|LAST|True|False|NULL|_)' -or $var.Options -match 'ReadOnly|Constant') {
                continue
            }
            
            $type = $value.GetType().Name
            $this.Items[$name] = [PSCustomObject]@{
                Type  = $type
                Value = $value
            }
        }
        Write-Host "[$($this.Name)] Загружено $($this.Items.Count) элементов из сеанса" -ForegroundColor Cyan
    }

    # Универсальный метод загрузки из JSON с логикой сравнения
    [void] LoadFromJson([string]$JsonPath) {
        if (-not (Test-Path $JsonPath)) {
            Write-Host "[$($this.Name)] JSON не найден: $JsonPath. Будет создан при сохранении." -ForegroundColor Yellow
            return
        }

        $jsonData = Get-Content $JsonPath -Raw | ConvertFrom-Json
        $sessionData = @{}
        $this.LoadFromSession()  # Сначала загружаем текущее
        $this.Items.GetEnumerator() | ForEach-Object { $sessionData[$_.Key] = $_.Value }

        $changes = @()
        foreach ($key in $jsonData.PSObject.Properties.Name) {
            $jsonVal = $jsonData.$key
            if ($sessionData.ContainsKey($key)) {
                $sessVal = $sessionData[$key].Value
                if ($sessVal -ne $jsonVal.Value) {
                    $changes += "$key (текущее: $($sessVal) vs JSON: $($jsonVal.Value))"
                }
            } else {
                # Из JSON в сессию
                $this.Items[$key] = $jsonVal
                Set-Variable -Name $key -Value $jsonVal.Value -Scope Global -Force
            }
        }

        if ($changes.Count -gt 0) {
            Write-Host "[$($this.Name)] Обнаружены расхождения:" -ForegroundColor Yellow
            $changes | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
            $answer = Read-Host "Применить значения из JSON? (y/N)"
            if ($answer -eq 'y') {
                foreach ($key in $jsonData.PSObject.Properties.Name) {
                    $val = $jsonData.$key.Value
                    Set-Variable -Name $key -Value $val -Scope Global -Force
                }
            }
        } else {
            Write-Host "[$($this.Name)] Нет расхождений с JSON." -ForegroundColor Green
        }
    }

    # Универсальный метод сохранения в JSON
    [void] SaveToJson([string]$JsonPath) {
        $this.LoadFromSession()  # Обновляем перед сохранением
        $export = @{}
        foreach ($kv in $this.Items.GetEnumerator()) {
            $export[$kv.Key] = $kv.Value
        }
        $export | ConvertTo-Json -Depth 10 | Out-File -FilePath $JsonPath -Encoding UTF8
        Write-Host "[$($this.Name)] Сохранено в $JsonPath" -ForegroundColor Green
    }

    [void] Show() {
        $this.Items.GetEnumerator() | Sort-Object Key | ForEach-Object {
            Write-Host "$($_.Key) = $($_.Value.Value)" -ForegroundColor (if ($this.Name -like "*Color*") { $_.Value.Value } else { 'Gray' })
        }
    }
}

# Дочерние классы
class ColorList : OptionList {
    ColorList() : base("Global/Options/ColorList") {}
}

class VariableList : OptionList {
    VariableList() : base("Global/Options/VariableList") {}
}

# Экспорт
Export-ModuleMember -Class OptionList, ColorList, VariableList