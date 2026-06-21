# pwsh-99-rich.ps1

Write-Host "`n99.2. Базовый синтаксис" -Foreground Cyan
Write-Rich "`n[стиль]текст[/стиль]"
Write-Host "`n99.3. Примеры стилей" -Foreground Cyan

# Цвета и базовые стили
Write-Rich "[bold]Жирный текст[/bold]"
Write-Rich "[italic]Курсив[/italic]"
Write-Rich "[underline]Подчеркнутый[/underline]"
Write-Rich "[strike]Зачеркнутый[/strike]"
Write-Rich "[reverse]Инвертированные цвета[/reverse]"

# Цвета текста
Write-Rich "[red]Красный текст[/red]"
Write-Rich "[green]Зеленый текст[/green]"
Write-Rich "[blue]Синий текст[/blue]"
Write-Rich "[yellow]Желтый текст[/yellow]"
Write-Rich "[cyan]Голубой текст[/cyan]"
Write-Rich "[magenta]Пурпурный текст[/magenta]"
# Цвет фона (с префиксом "on")
Write-Rich "[red on white]Красный на белом[/]"
Write-Rich "[bold green on black]Жирный зеленый на черном[/]"
Write-Host "`n99.4. Комбинирование стилей" -Foreground Cyan
# Несколько стилей в одном теге
Write-Rich "[bold italic underline red]СЛОЖНЫЙ СТИЛЬ[/]"
# Вложенные стили (закрываются в обратном порядке)
Write-Rich "[bold]Жирный [italic]жирный+курсив[/italic] только жирный[/bold]"
# Короткое закрытие ([/] закрывает последний открытый стиль)
Write-Rich "[bold red]Важно![/] Обычный текст"
Write-Host "`n99.5. True Color (RGB и HEX)" -Foreground Cyan
# RGB формат
Write-Rich "[rgb(255,100,50)]Оранжевый текст[/]"
# HEX формат
Write-Rich "[#ff00ff]Розовый/Пурпурный[/]"
Write-Host "`n99.6. Создание таблиц" -Foreground Cyan
# Создание таблицы
$table = New-RichTable -Border "heavy" -ShowHeader $true
# Добавление колонок
New-RichTableColumn -Table $table -Header "Имя" -Width 20
New-RichTableColumn -Table $table -Header "Статус" -Width 15
New-RichTableColumn -Table $table -Header "Цвет" -Width 15
# Добавление строк
Add-RichTableRow -Table $table -Values @("Служба MySQL", "[green]Запущена[/green]", "[green]✓[/green]")
Add-RichTableRow -Table $table -Values @("Служба Apache", "[red]Остановлена[/red]", "[red]✗[/red]")
Add-RichTableRow -Table $table -Values @("Служба PostgreSQL", "[yellow]Неизвестно[/yellow]", "[yellow]?[/yellow]")
# Вывод таблицы
Format-RichTable -Table $table
Write-Host "`n99.7. Типы границ таблицы" -Foreground Cyan
# Различные стили границ
# "none", "ascii", "square", "heavy", "rounded", "double", "simple"
$table = New-RichTable -Border "rounded" -ShowHeader $true
Write-Host "`n99.8. Прогресс-бар" -Foreground Cyan
<# # Запуск прогресса
$progress = Start-RichProgress -TaskName "Установка службы"
for ($i = 1; $i -le 100; $i++) {
    Update-RichProgress -Progress $progress -Completed $i -Description "Шаг $i из 100"
    Start-Sleep -Milliseconds 50
}
# Завершение прогресса
Update-RichProgress -Progress $progress -Completed 100 -Description "Готово!" #>
Write-Host "`n99.9. Деревья и панели" -Foreground Cyan
# Создание дерева
$tree = New-RichTree -Label "Службы Windows"
# Добавление узлов
Add-RichTree -Tree $tree -Label "[green]MySQL[/green] - Запущена"
Add-RichTree -Tree $tree -Label "[red]Apache[/red] - Остановлена"
Add-RichTree -Tree $tree -Label "[yellow]PostgreSQL[/yellow] - Перезапускается"
# Вывод дерева
Format-RichTree -Tree $tree
<# # Панель с рамкой
New-RichPanel -Content "Содержимое панели" -Title "Заголовок" -Border "double" #>
Write-Host "`n99.10. Создание собственных тем" -Foreground Cyan
# Определение темы (предполагается, что синтаксис аналогичен Python Rich)
# В текущей версии PowerShellRich темы могут не поддерживаться напрямую
# Используйте прямую разметку или создавайте переменные со стилями
$styleSuccess = "[bold green]"
$styleError = "[bold red]"
$styleWarning = "[bold yellow]"
Write-Rich "$($styleSuccess)Успех!$($PSStyle.Reset) Операция выполнена"
Write-Rich "$($styleError)Ошибка!$($PSStyle.Reset) Проверьте параметры"
Write-Host "`n99.11. Доступные команды модуля" -Foreground Cyan
<# Категория	Команды
Таблицы	New-RichTable, New-RichTableColumn, Add-RichTableRow, Format-RichTable
Прогресс	Start-RichProgress, Update-RichProgress, Add-RichProgressTask
Деревья	New-RichTree, Add-RichTree, Format-RichTree
Текст	Write-Rich, Format-RichText, Convert-RichMarkup
Layout	New-RichLayout, Format-RichLayout, Split-RichLayout, Update-RichLayout
Прочее	New-RichColumns, New-RichPanel, Start-RichStatus, New-RichSpinner #>
Write-Host "`n99.12. Важные замечания" -Foreground Cyan
<# Требуется PowerShell 7.0+ — модуль не работает в Windows PowerShell 5.1 
Поддержка терминала — для корректной работы нужен терминал с поддержкой ANSI (Windows Terminal, VS Code, современная консоль)
Markup синтаксис — используйте [стиль]текст[/стиль] или [/] для закрытия последнего стиля
Эмуляция Python Rich — это порт, поэтому не все функции оригинальной библиотеки могут быть доступны
 #>