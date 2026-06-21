# serv-global.ps1

# Глобальные переменные для всех скриптов
$Global:ServiceName = "MySql95"
$Global:MySqlBin = "C:\Program Files\MySql\MySql Server 9.5\bin"
$Global:DefaultDrive = "D:"
$Global:DefaultPath = "\.mysql-data"
$Global:DataDir = "$DefaultDrive$DefaultPath"
$Global:MySqlPort = 3306
$Global:MySqlUser = "root"





Write-Host "✅ Глобальные переменные загружены:" -ForegroundColor Green
Write-Host "   ServiceName: $Global:ServiceName" -ForegroundColor Gray
Write-Host "   MySqlBin: $Global:MySqlBin" -ForegroundColor Gray
Write-Host "   DefaultDrive: $Global:DefaultDrive" -ForegroundColor Gray
Write-Host "   DefaultPath: $Global:DefaultPath" -ForegroundColor Gray
Write-Host "   DataDir: $Global:DataDir" -ForegroundColor Gray
Write-Host "   MySqlPort: $Global:MySqlPort" -ForegroundColor Gray

# .\serv-global-func

