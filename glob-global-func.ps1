# serv-global.ps1

# Титул
function Global:Titul {
    param (
        [int]$num,
        [string]$text
    )
    Write-Host "`n=== "$num". "$text" ===" -ForegroundColor Cyan
}

# Титул2
function Global:SubTitul {
    param (
        [int]$num1,
        [int]$num2,
        [string]$text
    )
    Write-Host "`n"$num1"."$num2". "$text -ForegroundColor Cyan
}

 # Функция для проверки запуска сервера
function Global:TestMySqlRunning {
    $portCheck = netstat -ano | findstr ":$Global:MySqlPort.*LISTENING"    # Проверяем, стартовал ли сервер
<#     Write-Host "Проверяем активацию сервера... " -ForegroundColor Yellow -NoNewline
    if ($portCheck) { Write-Host "Сервер активен" -ForegroundColor Green } 
	else { Write-Host "Сервер неактивен" -ForegroundColor Red }    
 #>    return [bool]$portCheck
}
<#
# Функция для проверки установки сервера
function Global:TestMySqlInstall {
	$service = Get-Service -Name $Global:ServiceName -ErrorAction SilentlyContinue    # Проверяем, установлен ли сервер
    Write-Host "Проверяем установлен ли сервер... " -ForegroundColor Yellow -NoNewline
    if ($service) 
	{ 
		Write-Host "Сервер уже установлен" -ForegroundColor Green 
		if (TestMySqlRunning) { .\mysql-3-mysql-console  } else { .\mysql-2-restart } # проверяем, стартовал ли сервер
	} 
	else 
	{ 
		Write-Host "Сервер не установлен, запуск прекращен" -ForegroundColor Red
		exit 1
	}    
} #>





# Результат
function Global:Result {
    param (  [string]$text  )
    Write-Host ": "$text -ForegroundColor Gray
}

# Проверка
function Global:Check{
	param(
	[bool]$check,
	[string]$isok,
	[string]$isnok
	)
	if ($check) { Write-Host $isok -ForegroundColor Green  } 
	else { Write-Host $isnok -ForegroundColor Red }
        }
		
# Функция прогресса
function Global:Progress {
    param (
        [int]$num,
        [string]$message,
        [ConsoleColor]$color = "Yellow"  # цвет по умолчанию - желтый
    )
    Write-Host "$message" -ForegroundColor $color  -NoNewline
    for ($i = 1; $i -le $num; $i++) {
        Start-Sleep -Seconds 1
        Write-Host "." -NoNewline
    }
	Write-Host ""
}

# Функция ожидания
function Global:Delay-Until 
{
    param
	(
		[int]$duration,
        [string]$message,
        [scriptblock]$condition,  
		[string]$isok,
		[string]$isnok,
        [ConsoleColor]$color = "Yellow"
    )
    Message $message
	for ($i = 1; $i -le $duration; $i++) 
	{
		Start-Sleep -Seconds 1
		Write-Host "." -NoNewline
		if (& $condition) {break}
	}
Check [bool]$condition $isok $isnok
}

<# function Global:Repeat-Until {
    param(
        [Parameter(Mandatory = $true)]
        [object]$Condition,              # ScriptBlock, bool или значение
        [scriptblock]$Action,
        [int]$maxIterations = 100,
        [int]$delayMs = 100
    )
    
    $iteration = 0
    
    while ($iteration -lt $maxIterations) {
        # Выполняем действие
        if ($Action) { & $Action  }
        
        # Проверяем условие (основная магия)
        $shouldStop = switch ($Condition) {
            { $_ -is [scriptblock] } { & $Condition; break }
            { $_ -is [bool] } { $_; break }
            default { [bool]$_ }
        }
        
        if ($shouldStop) {
            Write-Verbose "Цикл прерван на итерации $iteration" -Verbose
            return $true
        }
        
        $iteration++
        if ($iteration -lt $maxIterations) {
            Start-Sleep -Milliseconds $delayMs
        }
    }
    
    Write-Warning "Достигнуто максимальное количество итераций ($maxIterations)"
    return $false
}
 #>