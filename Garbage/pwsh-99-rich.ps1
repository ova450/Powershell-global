<#
.SYNOPSIS
    99. Богатое форматирование вывода с помощью PowerShellRich
.DESCRIPTION
    Демонстрация возможностей Rich-форматирования
.NOTES
    Требуется: PowerShell 7.0+, модуль PowerShellRich
    Установка: Install-Module -Name PowerShellRich -Force
#>

# Проверка наличия модуля
if (-not (Get-Module -ListAvailable -Name PowerShellRich)) {
    Write-Host "Установка модуля PowerShellRich..." -ForegroundColor Yellow
    Install-Module -Name PowerShellRich -Force -Scope CurrentUser
}
Import-Module PowerShellRich -Force -ErrorAction SilentlyContinue

# Заголовок раздела 99
Write-Host "`n99. RICH-ФОРМАТИРОВАНИЕ" -ForegroundColor Cyan

# 99.1. Форматирование шрифтов Write-Rich
Write-Host "`n99.1. Форматирование шрифтов в строках Write-Rich" -ForegroundColor Cyan
Write-Host "Форматирование строк реализуется командлетом Write-Rich."
Write-Host "Форматирование шрифтов - тегами [tag]форматированный текст[/tag]:"
Write-Host "Базовые теги:"

Write-Host "`n[bold]форматированный шрифт[/bold]: " -NoNewline
Write-Rich "Это [bold]жирный[/bold] текст"

Write-Host "`n[italic]форматированный текст[/italic]: " -NoNewline
Write-Rich "Это [italic]наклонный[/italic] текст"

Write-Host "`n[underline]форматированный текст[/underline]: " -NoNewline
Write-Rich "Это [underline]подчеркнутый[/underline] текст"

Write-Host "`n[strike]форматированный текст[/strike]: " -NoNewline
Write-Rich "Это [strike]зачеркнутый[/strike] текст"

Write-Host "`n[reverse]форматированный текст[/reverse]: " -NoNewline
Write-Rich "Это [reverse]инвертированный[/reverse] текст"

Write-Host "`nКомбинирование тегов: " -NoNewline
Write-Rich "[bold italic underline]Все стили сразу[/]"

Write-Host "`nКороткое закрытие [/] закрывает последний тег: " -NoNewline
Write-Rich "[bold red]Важно![/] Обычный текст"

Write-Host "`nВложенные теги (закрываются в обратном порядке): " -NoNewline
Write-Rich "[bold]Жирный [italic]жирный+курсив[/italic] только жирный[/bold]"

Write-Host "`nПример с несколькими тегами в одной строке:" 
Write-Rich "Это [bold]жирный[/bold], [italic]курсив[/italic], [underline]подчеркнутый[/underline] и [strike]зачеркнутый[/strike] текст"

Write-Host "`nПример с комбинированием разных стилей:" 
Write-Rich "[bold red]Красный жирный[/bold red], [italic green]Зеленый курсив[/italic green], [underline blue]Синий подчеркнутый[/underline blue]"

Write-Host "`nПример с RGB цветами:" 
Write-Rich "[rgb(255,100,50)]Оранжевый текст[/] и [#ff00ff]пурпурный[/]"

Write-Host "`nПример с фоном:" 
Write-Rich "[bold white on_red]Белый на красном[/] и [italic black on_yellow]Черный на желтом[/]"

Write-Host "`nСложный пример со всеми стилями:" 
Write-Rich "[bold italic underline strike reverse rgb(255,200,50) on_blue]СУПЕР СТИЛЬ[/]"

Write-Host "`nДемонстрация работы тегов:"
Write-Host "  [bold] - жирный шрифт"
Write-Host "  [italic] - курсивный шрифт"
Write-Host "  [underline] - подчеркнутый шрифт"
Write-Host "  [strike] - зачеркнутый шрифт"
Write-Host "  [reverse] - инвертированные цвета"
Write-Host "  [red], [green], [blue] и др. - цвет текста"
Write-Host "  [on_red], [on_green] и др. - цвет фона"
Write-Host "  [rgb(255,100,50)] - цвет в формате RGB"
Write-Host "  [#ff00ff] - цвет в HEX формате"
Write-Host "  [/] - закрывает последний открытый тег"
Write-Host "  [стиль1 стиль2] - комбинирование стилей через пробел"
Write-Host ""

# 99.2. Цвета текста
Write-Host "`n99.2. Цвета текста" -ForegroundColor Cyan
Write-Host "Командлет Write-Rich поддерживает 8 стандартных цветов:"
Write-Host ""

$colors = @("black", "red", "green", "yellow", "blue", "magenta", "cyan", "white")
$colorNames = @("Черный", "Красный", "Зеленый", "Желтый", "Синий", "Пурпурный", "Голубой", "Белый")

for ($i = 0; $i -lt $colors.Count; $i++) {
    $color = $colors[$i]
    $name = $colorNames[$i]
    Write-Host "[$color] " -NoNewline -ForegroundColor $color
    Write-Host "$name" -NoNewline
    Write-Rich " ([${color}]Пример текста[/${color}])"
}

Write-Host "`n99.3. Цвета фона" -ForegroundColor Cyan
Write-Host "Цвета фона задаются с префиксом 'on_':"
Write-Host ""

$bgColors = @("on_black", "on_red", "on_green", "on_yellow", "on_blue", "on_magenta", "on_cyan", "on_white")
$bgNames = @("Черный фон", "Красный фон", "Зеленый фон", "Желтый фон", "Синий фон", "Пурпурный фон", "Голубой фон", "Белый фон")

for ($i = 0; $i -lt $bgColors.Count; $i++) {
    $bg = $bgColors[$i]
    $name = $bgNames[$i]
    $textColor = if ($bg -eq "on_black" -or $bg -eq "on_blue") { "white" } else { "black" }
    Write-Host "[$bg] " -NoNewline
    Write-Rich "[${bg} ${textColor}]${name}[/]"
}

Write-Host "`n99.4. Комбинирование стилей и цветов" -ForegroundColor Cyan
Write-Host "Можно комбинировать теги шрифтов с цветами:"
Write-Host ""

Write-Host "[bold red] " -NoNewline
Write-Rich "[bold red]Жирный красный текст[/bold red]"

Write-Host "[italic green on_blue] " -NoNewline
Write-Rich "[italic green on_blue]Курсив зеленый на синем[/]"

Write-Host "[underline yellow on_red] " -NoNewline
Write-Rich "[underline yellow on_red]Подчеркнутый желтый на красном[/]"

Write-Host "[bold italic underline white on_magenta] " -NoNewline
Write-Rich "[bold italic underline white on_magenta]СУПЕР СТИЛЬ[/]"

Write-Host "`n99.5. True Color (RGB и HEX)" -ForegroundColor Cyan
Write-Host "Поддержка 24-битных цветов в формате RGB и HEX:"
Write-Host ""

Write-Host "RGB (255,100,50): " -NoNewline
Write-Rich "[rgb(255,100,50)]Оранжевый текст[/]"

Write-Host "HEX #ff00ff: " -NoNewline
Write-Rich "[#ff00ff]Пурпурный текст[/]"

Write-Host "RGB + фон: " -NoNewline
Write-Rich "[rgb(0,200,255) on #333333]Голубой на темном фоне[/]"

Write-Host "HEX + жирный: " -NoNewline
Write-Rich "[bold #00ff00]Ярко-зеленый жирный[/]"

Write-Host "`n99.6. Создание таблиц" -ForegroundColor Cyan
Write-Host "Для создания таблиц используется набор командлетов:"
Write-Host "  New-RichTable - создание таблицы"
Write-Host "  New-RichTableColumn - добавление колонок"
Write-Host "  Add-RichTableRow - добавление строк"
Write-Host "  Format-RichTable - вывод таблицы"
Write-Host ""

$table1 = New-RichTable -Border "heavy" -ShowHeader $true
New-RichTableColumn -Table $table1 -Header "Служба" -Width 20
New-RichTableColumn -Table $table1 -Header "Статус" -Width 15
New-RichTableColumn -Table $Table1 -Header "Состояние" -Width 10
Add-RichTableRow -Table $table1 -Values @("MySQL", "[green]Запущена[/green]", "[green]✓[/green]")
Add-RichTableRow -Table $table1 -Values @("Apache", "[red]Остановлена[/red]", "[red]✗[/red]")
Add-RichTableRow -Table $table1 -Values @("PostgreSQL", "[yellow]Неизвестно[/yellow]", "[yellow]?[/yellow]")
Format-RichTable -Table $table1

Write-Host "`n99.7. Типы границ таблицы" -ForegroundColor Cyan
Write-Host "Доступные стили границ: none, ascii, square, heavy, rounded, double, simple"
Write-Host ""

$borderStyles = @("none", "ascii", "square", "heavy", "rounded", "double", "simple")
foreach ($style in $borderStyles) {
    Write-Host "Стиль '$style':" -ForegroundColor Yellow
    $table = New-RichTable -Border $style -ShowHeader $true
    New-RichTableColumn -Table $table -Header "ID" -Width 8
    New-RichTableColumn -Table $table -Header "Значение" -Width 20
    Add-RichTableRow -Table $table -Values @("1", "[green]Пример[/green]")
    Add-RichTableRow -Table $table -Values @("2", "[red]Таблицы[/red]")
    Format-RichTable -Table $table
    Write-Host ""
}

# 99.2. Цвета текста
Write-Host "`n99.2. Цвета текста" -ForegroundColor Cyan
Write-Host 
$colors = @("black", "red", "green", "yellow", "blue", "magenta", "cyan", "white")
foreach ($color in $colors) {
    Write-Rich "[${color}]■ ${color}[/${color}]"
}
Write-Host ""

# 99.3. Цвета фона
Write-Host "99.3. Цвета фона" -ForegroundColor Cyan
Write-Host ""
$bgColors = @("on_black", "on_red", "on_green", "on_yellow", "on_blue", "on_magenta", "on_cyan", "on_white")
foreach ($bg in $bgColors) {
    $colorName = $bg -replace "on_", ""
    Write-Rich "[${bg} white] ${colorName} [/]"
}
Write-Host ""

# 99.4. Комбинирование стилей
Write-Host "99.4. Комбинирование цветов и стилей" -ForegroundColor Cyan
Write-Host ""
Write-Rich "[bold red]Красный жирный[/bold red]"
Write-Rich "[italic green on_blue]Зеленый курсив на синем фоне[/]"
Write-Rich "[bold italic underline yellow on_red]СЛОЖНЫЙ СТИЛЬ[/]"
Write-Rich "[bold]Жирный [italic]жирный+курсив[/italic] только жирный[/bold]"
Write-Host ""

# 99.5. True Color (RGB и HEX)
Write-Host "99.5. True Color (RGB и HEX)" -ForegroundColor Cyan
Write-Host ""
Write-Rich "[rgb(255,100,50)]Оранжевый текст (RGB)[/]"
Write-Rich "[#ff00ff]Пурпурный текст (HEX)[/#ff00ff]"
Write-Rich "[rgb(0,200,255) on #333333]Голубой на темном фоне[/]"
Write-Host ""

# 99.6. Создание таблиц
Write-Host "99.6. Создание таблиц" -ForegroundColor Cyan
Write-Host ""

$table1 = New-RichTable -Border "heavy" -ShowHeader $true
New-RichTableColumn -Table $table1 -Header "Служба" -Width 20
New-RichTableColumn -Table $table1 -Header "Статус" -Width 15
New-RichTableColumn -Table $table1 -Header "Состояние" -Width 10
Add-RichTableRow -Table $table1 -Values @("MySQL", "[green]Запущена[/green]", "[green]✓[/green]")
Add-RichTableRow -Table $table1 -Values @("Apache", "[red]Остановлена[/red]", "[red]✗[/red]")
Add-RichTableRow -Table $table1 -Values @("PostgreSQL", "[yellow]Неизвестно[/yellow]", "[yellow]?[/yellow]")
Format-RichTable -Table $table1
Write-Host ""

# 99.7. Типы границ таблицы
Write-Host "99.7. Типы границ таблицы" -ForegroundColor Cyan
Write-Host ""
$borderStyles = @("none", "ascii", "square", "heavy", "rounded", "double", "simple")
foreach ($style in $borderStyles) {
    Write-Host "Стиль: $style" -ForegroundColor Yellow
    $table = New-RichTable -Border $style -ShowHeader $true
    New-RichTableColumn -Table $table -Header "ID" -Width 10
    New-RichTableColumn -Table $table -Header "Значение" -Width 20
    Add-RichTableRow -Table $table -Values @("1", "Пример")
    Add-RichTableRow -Table $table -Values @("2", "Таблицы")
    Format-RichTable -Table $table
    Write-Host ""
}

# 99.8. Прогресс-бар
Write-Host "99.8. Прогресс-бар" -ForegroundColor Cyan
Write-Host ""

$progress = Start-RichProgress -TaskName "Выполнение операций"
for ($i = 1; $i -le 5; $i++) {
    Update-RichProgress -Progress $progress -Completed ($i * 20) -Description "Шаг $i из 5"
    Start-Sleep -Milliseconds 300
}
Update-RichProgress -Progress $progress -Completed 100 -Description "Готово!"
Write-Host ""

# 99.9. Деревья
Write-Host "99.9. Деревья и иерархические структуры" -ForegroundColor Cyan
Write-Host ""

$tree = New-RichTree -Label "[bold]Структура сервисов[/bold]"
Add-RichTree -Tree $tree -Label "[green]● Запущенные[/green]"
Add-RichTree -Tree $tree -Label "  ├── [green]MySQL[/green] (порт 3306)"
Add-RichTree -Tree $tree -Label "  └── [green]Nginx[/green] (порт 80)"
Add-RichTree -Tree $tree -Label "[red]● Остановленные[/red]"
Add-RichTree -Tree $tree -Label "  ├── [red]Apache[/red] (порт 8080)"
Add-RichTree -Tree $tree -Label "  └── [red]Redis[/red] (порт 6379)"
Add-RichTree -Tree $tree -Label "[yellow]● В процессе[/yellow]"
Add-RichTree -Tree $tree -Label "  └── [yellow]PostgreSQL[/yellow] (обновление)"
Format-RichTree -Tree $tree
Write-Host ""

# 99.10. Панели
Write-Host "99.10. Панели и контейнеры" -ForegroundColor Cyan
Write-Host ""

New-RichPanel -Content "[bold]Информационная панель[/bold]`nСтатус: [green]Активен[/green]`nВерсия: 2.1.0" -Title " [bold cyan]СИСТЕМА[/bold cyan] " -Border "double"
Write-Host ""
New-RichPanel -Content "`n[red]КРИТИЧЕСКАЯ ОШИБКА[/red]`n`n[bold]Действие:[/bold] Перезапуск службы`n[bold]Время:[/bold] $(Get-Date -Format 'HH:mm:ss')`n" -Title " [bold red]⚠ ОШИБКА ⚠[/bold red] " -Border "heavy"
Write-Host ""

# 99.11. Команды модуля
Write-Host "99.11. Команды модуля PowerShellRich" -ForegroundColor Cyan
Write-Host ""

# Таблица с командами
$cmdTable = New-RichTable -Border "rounded" -ShowHeader $true
New-RichTableColumn -Table $cmdTable -Header "Категория" -Width 15
New-RichTableColumn -Table $cmdTable -Header "Команды" -Width 55

Add-RichTableRow -Table $cmdTable -Values @(
    "Таблицы", 
    "New-RichTable, New-RichTableColumn, Add-RichTableRow, Format-RichTable"
)
Add-RichTableRow -Table $cmdTable -Values @(
    "Прогресс", 
    "Start-RichProgress, Update-RichProgress, Add-RichProgressTask"
)
Add-RichTableRow -Table $cmdTable -Values @(
    "Деревья", 
    "New-RichTree, Add-RichTree, Format-RichTree"
)
Add-RichTableRow -Table $cmdTable -Values @(
    "Текст", 
    "Write-Rich, Format-RichText, Convert-RichMarkup"
)
Add-RichTableRow -Table $cmdTable -Values @(
    "Layout", 
    "New-RichLayout, Format-RichLayout, Split-RichLayout, Update-RichLayout"
)
Add-RichTableRow -Table $cmdTable -Values @(
    "Панели", 
    "New-RichColumns, New-RichPanel, Start-RichStatus, New-RichSpinner"
)

Format-RichTable -Table $cmdTable
Write-Host ""

# 99.12. Создание собственных стилей
Write-Host "99.12. Создание собственных тем и стилей" -ForegroundColor Cyan
Write-Host ""

$success = "[bold green]"
$error = "[bold red]"
$warning = "[bold yellow]"
$info = "[bold cyan]"
$reset = "[/]"

Write-Rich "$($success)✓ Успех:$($reset) Операция выполнена успешно"
Write-Rich "$($error)✗ Ошибка:$($reset) Проверьте параметры подключения"
Write-Rich "$($warning)⚠ Предупреждение:$($reset) Диск заполнен на 85%"
Write-Rich "$($info)ℹ Информация:$($reset) Обновление доступно"
Write-Host ""

# 99.13. Spinner
Write-Host "99.13. Spinner (индикатор выполнения)" -ForegroundColor Cyan
Write-Host ""

Start-RichStatus -Message "Загрузка данных..." -Spinner "dots"
Start-Sleep -Seconds 2
Start-RichStatus -Message "Обработка файлов..." -Spinner "arc"
Start-Sleep -Seconds 2
Start-RichStatus -Message "Подготовка отчета..." -Spinner "simpleDots"
Start-Sleep -Seconds 2
Stop-RichStatus
Write-Host ""

# 99.14. Конвертация разметки
Write-Host "99.14. Конвертация разметки" -ForegroundColor Cyan
Write-Host ""

$markup = "[bold]Жирный[/bold] и [italic]курсив[/italic] текст"
$converted = Convert-RichMarkup -Markup $markup
Write-Host "Оригинал: $markup" -ForegroundColor Gray
Write-Host "Конвертировано: " -NoNewline
Write-Rich $converted
Write-Host ""

# 99.15. Комбинирование с Get-Process
Write-Host "99.15. Комбинирование с другими командлетами" -ForegroundColor Cyan
Write-Host ""

$topProcesses = Get-Process | Sort-Object -Property WorkingSet -Descending | Select-Object -First 5
$procTable = New-RichTable -Border "rounded" -ShowHeader $true
New-RichTableColumn -Table $procTable -Header "Имя" -Width 20
New-RichTableColumn -Table $procTable -Header "Память (МБ)" -Width 15
New-RichTableColumn -Table $procTable -Header "CPU" -Width 10

foreach ($proc in $topProcesses) {
    $mem = [math]::Round($proc.WorkingSet / 1MB, 2)
    $memColor = if ($mem -gt 500) { "red" } elseif ($mem -gt 200) { "yellow" } else { "green" }
    Add-RichTableRow -Table $procTable -Values @(
        $proc.ProcessName,
        "[${memColor}]${mem}[/]",
        "$([math]::Round($proc.CPU, 1))%"
    )
}
Format-RichTable -Table $procTable
Write-Host ""

# 99.16. Итоговое резюме
Write-Host "99.16. Итоговое резюме раздела" -ForegroundColor Cyan
Write-Host ""

New-RichPanel -Content @"
[bold]Изученные возможности:[/bold]
• [green]✓[/green] Базовый синтаксис Write-Rich
• [green]✓[/green] Цвета текста и фона
• [green]✓[/green] Комбинирование стилей
• [green]✓[/green] True Color (RGB/HEX)
• [green]✓[/green] Таблицы с разными границами
• [green]✓[/green] Прогресс-бары
• [green]✓[/green] Деревья и иерархии
• [green]✓[/green] Панели и контейнеры
• [green]✓[/green] Spinner и индикаторы
• [green]✓[/green] Пользовательские стили
"@ -Title " [bold green]РЕЗЮМЕ РАЗДЕЛА 99[/bold green] " -Border "double"

Write-Host ""
Write-Host "РАЗДЕЛ 99 ЗАВЕРШЕН" -ForegroundColor Green
Write-Host ""