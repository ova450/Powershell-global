# Краткий сводный синтаксис PowerShell

## 1. Параметры функций

```powershell
# Булев параметр
function Test-Bool {
    param([bool]$Flag)
    if ($Flag) { "Включено" }
}
Test-Bool -Flag $true

# Переключатель (switch)
function Test-Switch {
    param([switch]$Force)
    if ($Force) { "Принудительно" }
}
Test-Switch -Force
```



## 2. Условный оператор `if`

```powershell
# Приведение к bool
if (5) { }          # Число ≠ 0 → $true
if ("text") { }     # Непустая строка → $true
if ("false") { }    # ⚠️ Строка "false" → $true
if ($null) { }      # $null → $false
if (@()) { }        # Пустой массив → $false
```



## 3. Вызов команд и оператор `&`

```powershell
# Вызов внешней программы из строки
$exe = "mysqld.exe"
& $exe --install

# Получение кода возврата
$LASTEXITCODE
```



## 4. Передача выражений в функцию

```powershell
function Check {
    param([bool]$Condition)
    if ($Condition) { "OK" } else { "NO" }
}

# Выражение вычисляется до вызова
Check ( (Get-Service "spooler") -ne $null )
```



## 5. Передача по ссылке и ленивое вычисление

```powershell
# [ref] — передача переменной по ссылке
function Set-Ref {
    param([ref]$Var)
    $Var.Value = 100
}
$number = 5
Set-Ref ([ref]$number)
# $number теперь 100

# [scriptblock] — отложенное выполнение
function Invoke-Later {
    param([scriptblock]$Code)
    Start-Sleep -Seconds 1
    & $Code
}
Invoke-Later ({ Get-Date })
```



## 6. Создание объектов

```powershell
# PSCustomObject
$obj = [PSCustomObject]@{
    Name = "Server"
    Role = "DC"
}

# Класс
class ServiceStatus {
    [string]$Name
    [bool]$Running
    ServiceStatus([string]$n) { $this.Name = $n }
}
```



## 7. Наследование классов (PS 5.0+)

```powershell
class Base {
    [string]$Name
    Base([string]$n) { $this.Name = $n }
    [string]GetInfo() { return $this.Name }
}

class Child : Base {
    [int]$ID
    Child([string]$n, [int]$id) : base($n) { $this.ID = $id }
    [string]GetInfo() { return "$($this.Name):$($this.ID)" }
}
```



## 8. Форматирование вывода

```powershell
# Цвета консоли
Write-Host "Ошибка" -ForegroundColor Red
$Global:HeaderColor = [ConsoleColor]::Cyan

# Стили текста ($PSStyle требует PS 7+)
$PSStyle.Bold + "Жирный" + $PSStyle.Reset
$PSStyle.Italic + "Курсив" + $PSStyle.Reset
$PSStyle.Underline + "Подчеркнутый" + $PSStyle.Reset

# PowerShellRich разметка
"[bold]Важно[/bold] и [underline]акцент[/underline]"
```



## 9. Модули (библиотеки)

```powershell
# Создание модуля MyModule.psm1
function Invoke-Custom { "Работает" }
Export-ModuleMember -Function Invoke-Custom

# Манифест MyModule.psd1 (фрагмент)
@{
    RootModule = 'MyModule.psm1'
    ModuleVersion = '1.0.0'
}

# Установка из репозитория
Register-PSRepository -Name "MyRepo" -SourceLocation "https://..."
Install-Module -Name MyModule
```



## 10. Типичные проверки

```powershell
# Проверка службы
$service = Get-Service "MySQL" -ErrorAction SilentlyContinue
if ($service -ne $null) { "Служба существует" }

# Проверка успешности команды
& some.exe
if ($LASTEXITCODE -eq 0) { "Успех" }
```

