# .\pwsh-1-1-environment

# =============================================
# 0. CHECK ADMIN RIGHTS
# =============================================
function Test-Administrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [System.Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

$isAdmin = Test-Administrator
if (-not $isAdmin) {
    Write-Host "`nWARNING: Running without administrator rights" -ForegroundColor Yellow
}

# =============================================
# 1. CHECK POWERSHELL VERSION
# =============================================
Write-Host "`n1. ENVIRONMENT CHECKING" -ForegroundColor Cyan

$requiredVersion = 7
if ($PSVersionTable.PSVersion.Major -lt $requiredVersion) {
    Write-Host "  Current version: $($PSVersionTable.PSVersion)" -ForegroundColor Red
    Write-Host "  Required: PowerShell $requiredVersion+"
    
    $pwshPath = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($pwshPath) {
        Write-Host "  PowerShell 7 found: $($pwshPath.Source)" -NoNewline 
        $version7 = & pwsh -Command '$PSVersionTable.PSVersion.ToString()' 
        Write-Host "  Version 7: $version7" -Foreground Green
        
        Write-Host "`n  Restart script in PowerShell 7? (y/N)" -ForegroundColor Yellow -NoNewline
        $restart = Read-Host " "
        if ($restart -eq 'y' -or $restart -eq 'Y') {
            Write-Host "`n  Restarting..." -ForegroundColor Green
            & pwsh -File $MyInvocation.MyCommand.Path
            exit
        } else {
            Write-Host "`n  Continuing in old version (some features may not work)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  PowerShell 7 not installed!" -ForegroundColor Red
        Write-Host "  Install: https://github.com/PowerShell/PowerShell/releases" -ForegroundColor Gray
        Write-Host "  or: winget install Microsoft.PowerShell" -ForegroundColor Gray
        exit 1
    }
} else {
    Write-Host "  PowerShell $($PSVersionTable.PSVersion) (modern version)" -ForegroundColor Gray
}

# =============================================
# 2. CHECK SYSTEM MODULES
# =============================================
Write-Host "`n1.1. System modules" -ForegroundColor Cyan

function Test-SystemModule {
    param([string]$ModuleName)
    
    $module = Get-Module -Name $ModuleName -ListAvailable -ErrorAction SilentlyContinue
    if ($module) {
        Write-Host "  OK $ModuleName (version $($module.Version))" -ForegroundColor Gray
        return $true
    } else {
        Write-Host "  MISSING $ModuleName (not installed)" -ForegroundColor Red
        return $false
    }
}

$modules = @('PowerShellGet', 'PSReadLine', 'Microsoft.PowerShell.Utility')
$missingModules = @()

foreach ($module in $modules) {
    $installed = Test-SystemModule -ModuleName $module
    if (-not $installed) {
        $missingModules += $module
    }
}

if ($missingModules.Count -gt 0 -and $isAdmin) {
    $install = Read-Host "`nInstall missing modules? (y/N)"
    if ($install -eq 'y' -or $install -eq 'Y') {
        $nugetProvider = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
        if (-not $nugetProvider) {
            Write-Host "  Installing NuGet provider..." -ForegroundColor Yellow
            Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction SilentlyContinue
        }
        
        foreach ($module in $missingModules) {
            Write-Host "  Installing $module..." -ForegroundColor Cyan
            Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber -ErrorAction SilentlyContinue
            if ($?) {
                Write-Host "    OK $module installed" -ForegroundColor Green
            } else {
                Write-Host "    FAILED to install $module" -ForegroundColor Red
            }
        }
    }
}

# =============================================
# 3. MAIN LOGIC
# =============================================
Write-Host "`nChecking environment completed successfully!" -ForegroundColor Yellow