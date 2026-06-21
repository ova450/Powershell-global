# pwsh-1-1-modules.ps1

Write-Host "`n1. ПРОВЕРКА/УСТАНОВКА ГЛОБАЛЬНЫХ СИСТЕМНЫХ МОДУЛЕЙ, ФУНКЦИЙ, ПЕРЕМЕННЫХ И РЕЖИМОВ" -foreground cyan
Write-Host "`n1.1. Системные модули" -foreground cyan

if ($PSVersionTable.PSEdition -eq "Core") {  Write-Host "Вы в консоли PowerShell 7+" -ForegroundColor Green }
else 
	{    
		Write-Host "'nВы в консоли Windows PowerShell 5.1" -ForegroundColor Red 
		$pwshPath = Get-Command pwsh -ErrorAction SilentlyContinue
 		if ($pwshPath) 
		{
 			Write-Host "'nPowerShell 7 установлен по пути: $($pwshPath.Source)" -ForegroundColor Green
			Write-Host "      >рекомендуется перейти на версию 7 для доступа" -ForegroundColor Yellow
			Write-Host "      >к полной функцииональности скриптов в дальнейшем." -ForegroundColor Yellow
			# Получаем версию
			$version = & pwsh -Command '$PSVersionTable.PSVersion.ToString()'
			Write-Host "Версия: $version" -ForegroundColor Cyan
 		} 
		else 
		{
			Write-Host "PowerShell 7 не установлен" -ForegroundColor Red
			Write-Host "      >рекомендуется установить версию Powershell 7+ для доступа" -ForegroundColor Yellow
			Write-Host "      >к полной функцииональности скриптов в дальнейшем." -ForegroundColor Yellow
		}
	}