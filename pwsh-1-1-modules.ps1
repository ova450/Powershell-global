# pwsh-1-1-modules.ps1

# =============================================
# 0. ПРОВЕРКА ПРАВ АДМИНИСТРАТОРА
# =============================================
function Test-Administrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [System.Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

$isAdmin = Test-Administrator
if (-not $isAdmin) {
    Write-Host "⚠️ Запущено без прав администратора" -ForegroundColor Yellow
}

# =============================================
# 1. ПРОВЕРКА ВЕРСИИ POWERSHELL
# =============================================
Write-Host "`n1. ПРОВЕРКА СРЕДЫ ВЫПОЛНЕНИЯ" -ForegroundColor Cyan

$requiredVersion = 7
if ($PSVersionTable.PSVersion.Major -lt $requiredVersion) {
    Write-Host "  Текущая версия: $($PSVersionTable.PSVersion)" -ForegroundColor Red
    Write-Host "  Требуется: PowerShell $requiredVersion+" -ForegroundColor Yellow
    
    $pwshPath = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($pwshPath) {
        Write-Host "  PowerShell 7 найден: $($pwshPath.Source)" -ForegroundColor Green
        $version7 = & pwsh -Command '$PSVersionTable.PSVersion.ToString()'
        Write-Host "  Версия 7: $version7" -ForegroundColor Cyan
        
        $restart = Read-Host "`n  Перезапустить скрипт в PowerShell 7? (y/N)"
        if ($restart -eq 'y' -or $restart -eq 'Y') {
            Write-Host "`n  Перезапуск..." -ForegroundColor Green
            & pwsh -File $MyInvocation.MyCommand.Path
            exit
        } else {
            Write-Host "`n  Продолжаем в старой версии (некоторые функции могут не работать)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  PowerShell 7 не установлен!" -ForegroundColor Red
        Write-Host "  Установите: https://github.com/PowerShell/PowerShell/releases" -ForegroundColor Cyan
        Write-Host "  или: winget install Microsoft.PowerShell" -ForegroundColor Cyan
        exit 1
    }
} else {
    Write-Host "  ✓ PowerShell $($PSVersionTable.PSVersion) (современная версия)" -ForegroundColor Green
}

# =============================================
# 2. ПРОВЕРКА СИСТЕМНЫХ МОДУЛЕЙ
# =============================================
Write-Host "`n1.1. Системные модули" -ForegroundColor Cyan

function Test-SystemModule {
    param([string]$ModuleName)
    
    $module = Get-Module -Name $ModuleName -ListAvailable -ErrorAction SilentlyContinue
    if ($module) {
        Write-Host "  ✓ $ModuleName (версия $($module.Version))" -ForegroundColor Green
        return $true
    } else {
        Write-Host "  ✗ $ModuleName (не установлен)" -ForegroundColor Red
        return $false
    }
}

# Проверяем базовые модули
$modules = @('PowerShellGet', 'PSReadLine', 'Microsoft.PowerShell.Utility')
$missingModules = @()

foreach ($module in $modules) {
    $installed = Test-SystemModule -ModuleName $module
    if (-not $installed) {
        $missingModules += $module
    }
}

# Установка отсутствующих модулей
if ($missingModules.Count -gt 0 -and $isAdmin) {
    $install = Read-Host "`nУстановить отсутствующие модули? (y/N)"
    if ($install -eq 'y' -or $install -eq 'Y') {
        # Проверяем NuGet провайдер
        $nugetProvider = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
        if (-not $nugetProvider) {
            Write-Host "  Установка NuGet провайдера..." -ForegroundColor Yellow
            Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction SilentlyContinue
        }
        
        foreach ($module in $missingModules) {
            Write-Host "  Установка $module..." -ForegroundColor Cyan
            Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber -ErrorAction SilentlyContinue
            if ($?) {
                Write-Host "    ✓ $module установлен" -ForegroundColor Green
            } else {
                Write-Host "    ✗ Ошибка установки $module" -ForegroundColor Red
            }
        }
    }
}

# =============================================
# 3. ОСТАЛЬНАЯ ЛОГИКА
# =============================================
Write-Host "`n✅ Скрипт выполнен успешно!" -ForegroundColor Green
# Ваш код здесь