
# Полный синтаксис PowerShell (кратко)

## 1. Переменные и типы
```powershell
# Объявление и присвоение
$var = "значение"
[int]$num = 42
[string]$str = "текст"
[bool]$flag = $true
[array]$arr = @(1,2,3)
[hashtable]$hash = @{name="value"; key="val"}

# Пустые значения
$null
@()           # пустой массив
@{}           # пустая хеш-таблица
"" или ''     # пустая строка
```
## 2. Операторы
```powershell
# Арифметические
+ - * / %     # сложение, вычитание и т.д.
+= -= *= /=   # составные
++ --         # инкремент/декремент

# Сравнения
-eq -ne -gt -lt -ge -le   # равно, не равно, больше, меньше, больше/равно, меньше/равно
-like -notlike             # с подстановочными знаками * ?
-match -notmatch           # регулярные выражения
-contains -notcontains     # для коллекций
-in -notin                 # элемент в коллекции
-is -isnot                 # проверка типа

# Логические
-and -or -xor -not !       # И, ИЛИ, исключающее ИЛИ, НЕ

# Строковые
+                          # конкатенация
*                          # повторение "a"*3 → "aaa"
-f                         # форматирование "{0} {1}" -f $a,$b

# Специальные
&                          # вызов (call operator)
.                          # точка (выполнение в текущей области)
..                         # диапазон 1..10
::                         # статический метод/свойство
```
## 3. Ветвления
```powershell
# if-elseif-else
if ($condition) {
    # код
} elseif ($other) {
    # код
} else {
    # код
}

# switch (значение)
switch ($value) {
    1 { "один" }
    2 { "два" }
    "text" { "текст" }
    default { "другое" }
}

# switch (регулярные выражения)
switch -Regex ($string) {
    "^start" { "начинается" }
    "end$" { "заканчивается" }
}

# switch с файлом
switch -Wildcard -File ./file.txt {
    "*error*" { "найдена ошибка" }
}
```
## 4. Циклы
```powershell
# for
for ($i = 0; $i -lt 10; $i++) {
    Write-Host $i
}

# foreach (ключевое слово)
foreach ($item in $collection) {
    Write-Host $item
}

# foreach (оператор, короче)
$collection | ForEach-Object { $_ }

# while
while ($condition) {
    # код
}

# do-while (выполнится минимум раз)
do {
    # код
} while ($condition)

# do-until
do {
    # код
} until ($condition)

# break, continue
foreach ($i in 1..10) {
    if ($i -eq 5) { break }      # выход из цикла
    if ($i -eq 3) { continue }   # переход к следующей итерации
}
```
## 5. Функции
```powershell
# Базовая функция
function MyFunction {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        
        [int]$Count = 1,
        
        [switch]$Force
    )
    process {
        # тело функции
        return $result
    }
}

# Расширенная функция (cmdlet-подобная)
function Test-Advanced {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$InputObject,
        
        [Parameter(ParameterSetName="Set1")]
        [int]$ID,
        
        [Parameter(ParameterSetName="Set2")]
        [string]$Name
    )
    begin { $counter = 0 }
    process { $counter++ }
    end { Write-Host "Обработано: $counter" }
}

# Валидация параметров
param(
    [ValidateNotNullOrEmpty()][string]$Name,
    [ValidateRange(1,100)][int]$Port,
    [ValidateSet("Red","Green","Blue")][string]$Color,
    [ValidatePattern("^\d+$")][string]$Numbers
)
```
## 6. Конвейер (Pipeline)
```powershell
# Передача объектов
Get-Process | Where-Object { $_.CPU -gt 100 } | Stop-Process

# Фильтрация
$collection | Where-Object { $_.Property -eq "value" }

# Преобразование
$data | Select-Object -Property Name, ID
$data | Select-Object -First 10 -Last 5 -Skip 2

# Сортировка
$data | Sort-Object -Property Name -Descending

# Группировка
$data | Group-Object -Property Category

# Пользовательские блоки в конвейере
1..5 | ForEach-Object { $_ * 2 }
1..5 | ForEach-Object -Begin { $sum=0 } -Process { $sum+=$_ } -End { $sum }
```
## 7. Работа с объектами
```powershell
# Создание
[PSCustomObject]@{ Prop1="Val1"; Prop2=123 }
New-Object -TypeName PSObject -Property @{ Name="Test" }

# Классы (PS 5.0+)
class MyClass {
    [string]$Property
    [int]$Number
    
    MyClass([string]$prop) {
        $this.Property = $prop
        $this.Number = 0
    }
    
    [void]Method() {
        Write-Host "Метод вызван"
    }
    
    [int]GetDouble() {
        return $this.Number * 2
    }
}

# Наследование
class ChildClass : MyClass {
    [string]$Extra
    ChildClass([string]$prop, [string]$extra) : base($prop) {
        $this.Extra = $extra
    }
}

# Свойства (getter/setter)
class WithProperty {
    hidden [int]$_value
    [int]Value {
        get { return $this._value }
        set { if ($value -gt 0) { $this._value = $value } }
    }
}
```
## 8. Массивы и хеш-таблицы
```powershell
# Массивы
$arr = @(1,2,3,4,5)
$arr = 1..10              # диапазон
$arr[0]                   # первый элемент
$arr[-1]                  # последний
$arr[1..3]                # диапазон индексов
$arr += 6                 # добавление (создает новый массив)
$arr -contains 3          # проверка наличия
$arr -in 3                # элемент в массиве

# Хеш-таблицы
$hash = @{
    Key1 = "Value1"
    Key2 = 123
    "Key with spaces" = "Value"
}
$hash.Key1                # доступ через точку
$hash["Key with spaces"]  # доступ через индекс
$hash.Add("Key3","Val3")  # добавление
$hash.Remove("Key1")      # удаление
$hash.ContainsKey("Key2") # проверка
```
## 9. Обработка ошибок
```powershell
# try-catch-finally
try {
    Get-Item "C:\notexist.txt" -ErrorAction Stop
}
catch [System.IO.FileNotFoundException] {
    Write-Host "Файл не найден"
}
catch {
    Write-Host "Ошибка: $($_.Exception.Message)"
}
finally {
    Write-Host "Выполняется всегда"
}

# Управление ошибками
$ErrorActionPreference = "Stop"  # SilentlyContinue, Continue, Inquire
$?                                # успешна ли последняя команда ($true/$false)
$Error                            # массив ошибок сессии

# throw
throw "Произошла ошибка"
throw (New-Object System.Exception("Сообщение"))

# trap
trap {
    Write-Host "Перехвачена ошибка: $_"
    continue  # или break
}
```
## 10. Работа с файлами
```powershell
# Чтение
Get-Content -Path "file.txt"
Get-Content -Path "file.txt" -Raw              # весь файл как одна строка
Get-Content -Path "file.txt" -TotalCount 10    # первые 10 строк

# Запись
"текст" | Out-File -FilePath "file.txt"
"строка1", "строка2" | Set-Content -Path "file.txt"
"добавить" | Add-Content -Path "file.txt"

# Импорт/экспорт CSV
Import-Csv -Path "data.csv" -Delimiter ";"
$data | Export-Csv -Path "output.csv" -NoTypeInformation

# Импорт/экспорт JSON
Get-Content "data.json" | ConvertFrom-Json
$data | ConvertTo-Json -Depth 10 | Out-File "output.json"

# XML
[xml]$xml = Get-Content "data.xml"
$xml.Save("output.xml")
```
## 11. Работа с процессами и службами
```powershell
# Процессы
Get-Process
Get-Process -Name "notepad"
Start-Process -FilePath "notepad.exe" -ArgumentList "file.txt"
Stop-Process -Name "notepad" -Force
Wait-Process -Name "notepad" -Timeout 30

# Службы
Get-Service
Get-Service -Name "spooler"
Start-Service -Name "spooler"
Stop-Service -Name "spooler"
Restart-Service -Name "spooler"
Set-Service -Name "spooler" -StartupType Automatic
```
## 12. Форматирование вывода
```powershell
# Цвета и стили (PS 7+)
Write-Host "Красный текст" -ForegroundColor Red
Write-Host "Зеленый фон" -BackgroundColor Green
$PSStyle.Bold + "Жирный" + $PSStyle.Reset
$PSStyle.Italic + "Курсив" + $PSStyle.Reset
$PSStyle.Underline + "Подчеркнутый" + $PSStyle.Reset
$PSStyle.Foreground.FromRgb(255,128,0) + "Оранжевый" + $PSStyle.Reset

# Таблицы
Get-Process | Format-Table -Property Name, CPU, PM
Get-Process | Format-Table -AutoSize -Wrap

# Списки
Get-Process | Format-List -Property Name, Id, Path

# Пользовательское форматирование
"{0:N2} - {1}" -f $number, $text
$date.ToString("yyyy-MM-dd HH:mm:ss")
```
## 13. Регулярные выражения
```powershell
# Операторы -match и -replace
"Hello123" -match "\d+"      # $true, $Matches[0] = "123"
"Hello123" -replace "\d+", "World"  # "HelloWorld"

# Методы .NET
[regex]::Match("text", "pattern")
[regex]::Matches("text1 text2", "\w+")
[regex]::Replace("text", "pattern", "replacement")

# Группы
if ("Order: #12345" -match "Order: #(\d+)") {
    $orderNumber = $Matches[1]  # "12345"
}
```
## 14. Удаленные команды
```powershell
# PSSession
$session = New-PSSession -ComputerName "Server01"
Invoke-Command -Session $session -ScriptBlock { Get-Service }
Remove-PSSession $session

# Одна команда
Invoke-Command -ComputerName "Server01", "Server02" -ScriptBlock {
    Get-Process -Name "powershell"
}

# С параметрами
Invoke-Command -ComputerName "Server01" -ScriptBlock {
    param($Name)
    Get-Service -Name $Name
} -ArgumentList "spooler"

# Enter-PSSession (интерактивно)
Enter-PSSession -ComputerName "Server01"
exit
```
## 15. Модули и области видимости
```powershell
# Импорт/экспорт модулей
Import-Module -Name ModuleName
Import-Module -Name "C:\path\to\module.psm1"
Remove-Module -Name ModuleName
Get-Module -ListAvailable

# Области видимости переменных
$global:GlobalVar = "Доступна везде"
$script:ScriptVar = "Доступна в скрипте"
$local:LocalVar = "Доступна только в текущей области"

# Точки останова и отладка
Set-PSBreakpoint -Script .\script.ps1 -Variable varName
Wait-Debugger
```
## 16. Специальные операторы
```powershell
# :: - статические члены
[System.Math]::PI
[System.DateTime]::Now
[System.Environment]::GetEnvironmentVariable("PATH")

# .. - диапазон
1..10
"a".."z"
10..1  # обратный порядок

# $( ) - подстановка в строке
"Сегодня: $(Get-Date -Format 'dd.MM.yyyy')"

# @( ) - гарантированный массив
@(Get-Process -Name "notepad*")

# , - оператор запятой (создание массива)
$arr = , 1  # массив с одним элементом

# . - вызов метода
$string.ToUpper()
$array.Add($item)

# ? - альтернатива Where-Object
$collection | ? { $_ -gt 5 }
```
## 17. Справочная система
```powershell
Get-Help Get-Process
Get-Help Get-Process -Examples
Get-Help Get-Process -Detailed
Get-Help Get-Process -Full
Get-Help about_*              # концептуальные темы
Get-Command *service*         # поиск команд
Get-Member -InputObject $obj  # методы/свойства объекта
```