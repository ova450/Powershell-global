# pwsh-install-module.ps1

Write-Host "Проверяем установку Install-Module..." -Foreground Yellow -NoNewline

$InstallModuleInstalled = Get-Command Install-Module -ErrorAction SilentlyContinue
    if ( $InstallModuleInstalled ) {Write-Host "команда Install-Module найдена." -Foreground Green }
    else { Write-Error "команда не найдена (установите модуль PowerShellGet или обновите PowerShell до версии 5.1+)" } 
