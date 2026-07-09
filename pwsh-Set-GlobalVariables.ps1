# pwsh-1-0-baseVariablesSet

Import-Module .\OptionList.psm1 -Force

$Global:VariableList = [VariableList]::new()

[string]$Global:Info = $true		# Command Details/Debug Help/Examples
[bool]$Global:Details = $false
[switch]$Global:Debug
[switch]$Global:Help
[bool]$Global:Examples = $true
[bool]$Global:Log = $true
[bool]$Global:Registration = $false
[bool]$Global:GlobalSystemVariablesManagement = $false

$Global:VariableList.LoadFromSession()
$Global:VariableList.SaveToJson("GlobalVariables.json")

function BaseVariablesSet
{
	param 
	(
	[switch]$NoDetails
	)
	$Details = -not $NoDetails
	$filename = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
	if ($Details)
	{
		Write-Host "`nБазовые глобальные переменные установлены ($filename):" -Foreground Yellow
		Write-Host "DebugInfo = $DebugInfo"
		Write-Host "CommandInfo = $CommandInfo"
		Write-Host "Examples = $Examples"
		Write-Host "LogDetails = $LogDetails"
		Write-Host "LogDebugInfo = $LogDebugInfo"
		Write-Host "Registration = $Registration"
		Write-Host "GlobalSystemVariablesManagement = $GlobalSystemVariablesManagement"	
	}
}