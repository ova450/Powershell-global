# pwsh-rich.ps1
.\pwsh-global

$moduleName = "PowerShellRich"
.\pwsh-install-module
if {$InstallModuleInstalled)
{
Write-Host "Проверяем установку PowerShellRich" -Foreground Yellow
$PowershellRichInstalled = Get-InstalledModule -Name  "PowerShellRich" -ErrorAction SilentlyContinue
if ($installedModule) { Write-Host "Модуль '$moduleName' уже установлен. Версия: $($installedModule.Version" -ForegroundColor Green} 
	
}
else { Write-Error "Модуль Install-Module не установлен." }


$Global:HasInstallModule = Get-Command Install-Module -ErrorAction SilentlyContinue
    if ( $HasInstallModule ) {Write-Host "команда Install-Module найдена." -Foreground Green }
    else { Write-Error "команда не найдена (установите модуль PowerShellGet или обновите PowerShell до версии 5.1+)" } 


<# 
else 
	{ 
		Write-Host "Модуль '$moduleName' не найден. Начинаем установку..." -ForegroundColor Yellow
		Write-Host "Проверка на наличие команды Install-Module (обычно есть в PowerShell 5.1+)"
    if (-not (Get-Command Install-Module -ErrorAction SilentlyContinue)) {
        Write-Error "❌ Команда Install-Module не найдена. Установите модуль PowerShellGet или обновите PowerShell до версии 5.1 и выше."
        return
    }

    # Установка модуля (может потребоваться подтверждение политики)
    try {
        # Для автоматической установки без лишних вопросов используйте -Force
        # Для установки только для текущего пользователя добавьте -Scope CurrentUser
        Install-Module -Name $moduleName -Force -AllowClobber -ErrorAction Stop
        Write-Host "✅ Модуль '$moduleName' успешно установлен." -ForegroundColor Green
    }
    catch {
        Write-Error "❌ Ошибка при установке модуля: $_"
        Write-Host "💡 Убедитесь, что политика выполнения (ExecutionPolicy) не блокирует установку." -ForegroundColor Yellow
        Write-Host "   Попробуйте выполнить от имени администратора: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
    }
}
 #><# 
Как это работает
Проверка наличия (Get-InstalledModule):
С помощью Get-InstalledModule проверяется, есть ли модуль в списке установленных . Флаг -ErrorAction SilentlyContinue подавляет ошибку, если модуль не найден, чтобы скрипт мог продолжить работу.

Анализ результата:
Если объект $installedModule существует, скрипт выводит сообщение об успехе с версией модуля .
Если $installedModule пуст, скрипт переходит к установке.

Установка (Install-Module):
Команда Install-Module -Name PowerShellRich загружает модуль из галереи PowerShell Gallery .
Параметр -Force используется для автоматического подтверждения установки без запроса "Вы доверяете этому репозиторию?".
Параметр -AllowClobber разрешает перезапись конфликтующих команд, если они есть .

Обработка ошибок:
Если установка не удалась (например, из-за политик безопасности), скрипт выводит подсказку о проверке ExecutionPolicy.

Важные замечания
Требования к версии PowerShell:
Модуль PowerShellRich требует PowerShell 7.0 или новее . Если у вас более старая версия (например, Windows PowerShell 5.1), установка, скорее всего, не сработает.

Политика выполнения (ExecutionPolicy):
При первом использовании Install-Module система может запросить разрешение на установку модулей из ненадежного репозитория (PowerShell Gallery). Если скрипт выдает ошибку, выполните в консоли (один раз) команду:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Это разрешит запуск локальных скриптов и установку подписанных модулей из интернета .

Установка без прав администратора:
Если у вас нет прав на запись в системную папку Program Files, используйте установку для текущего пользователя. Для этого в команду Install-Module внутри скрипта нужно добавить флаг -Scope CurrentUser. Тогда модуль установится в папку пользователя ~\Documents\PowerShell\Modules .
 #>

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