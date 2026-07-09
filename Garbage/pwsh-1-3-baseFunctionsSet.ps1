# pwsh-1-2-basefunctions

<#
.SYNOPSIS
    Чтение клавиши с консоли с перехватом отображения

.DESCRIPTION
    Функция вызывает статический метод ReadKey из класса System.Console в .NET Framework.
    Позволяет перехватывать нажатия клавиш без отображения в консоли.
    Используется для создания интерактивных меню, ввода паролей, ожидания нажатий.

.PARAMETER  NotShowKey
    Определяет, будет ли нажатая клавиша отображаться в консоли.
	По умолчанию клавиша ОТОБРАЖАЕТСЯ.
	НЕ отображается: ReadKey -NotShowKey 

.PARAMETER  ReturnKeyInfo
    Определяет возвращаемый тип , будет ли нажатая клавиша отображаться в консоли.
	По умолчанию возвращается KeyInfo.KeyChar.
	При вызове с параметром (ReadKey -ReturnKeyInfo) возвращается KeyInfo. 

.PARAMETER DebugInfo
    Определяет, будет ли отображаться отладочная игформация в консоли.
	По умолчанию отладочная информация НЕ отображается. 
	При вызове с параметром -DebugInfo ОТОБРАЖАЕТСЯ: 
			- нажатая клавиша
			- символ
			- модификаторы
		}

.EXAMPLE
    PS C:\> ReadKey
    Ожидает нажатие любой клавиши.
	После нажатия отображает символ.
    Возвращает объект KeyInfo.KeyChar по умолчанию.

.EXAMPLE
    PS C:\> ReadKey -NotShowKey -ReturnKeyInfo
    Ожидает нажатие любой клавиши БЕЗ отображения символа.
    Возвращает объект KeyInfo.

.EXAMPLE
    PS C:\> ReadKey -DebugInfo
    Ожидает нажатие любой клавиши.
	После нажатия отображает символ.
    Возвращает объект KeyInfo.KeyChar по умолчанию.
	Также отображает отладочную информацию: 
			- нажатую клавишу: Write-Host "Key pressed: $($key.Key)" -Foreground $DebugInfoColor
		    - символ: Write-Host "Char: $($key.KeyChar)" Foreground $DebugInfoColor
			- модификаторы: Write-Host "Modifiers: $($key.Modifiers)" -Foreground $DebugInfoColor

.INPUTS
        [switch]$NotShowKey,		# Перехват нажатия клавиши БЕЗ отображения в консоли.
        [switch]$ReturnKeyInfo,		# По умолчанию функция возвращает KeyInfo.KeyChar, при использовании параметра - KeyInfo.
		[switch]$DebugInfo,			# Отображение отладочной информации.

.OUTPUTS
    System.Char - по умолчанию (KeyInfo.KeyChar)
    System.ConsoleKeyInfo - при использовании параметра ReturnKeyInfo

.NOTES
    Имя: ReadKey
    Версия: 1.0
    Автор: ovaataaridotru
    Дата: 15.06.2026
    
    Зависимости:
    - PowerShell 7.0 или выше
    - .NET 6.0 или выше
    
    Ограничения:
    - НЕ РАБОТАЕТ в PowerShell ISE
    - РАБОТАЕТ в обычной консоли, Windows Terminal, VS Code
    
    Известные проблемы:
    - В некоторых терминалах может не работать с комбинацией Ctrl+C
    
    Рекомендации:
    - Используйте для интерактивных скриптов
    - При вводе паролей всегда используйте NotShowKey

.LINK
    Документация Microsoft:
    https://docs.microsoft.com/en-us/dotnet/api/system.console.readkey
    
    PowerShell справка:
    https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/07-hash-tables

.COMPONENT
    pwsh

.ROLE
    Разработчик скриптов автоматизации
    
.FUNCTIONALITY
    Обработка ввода с клавиатуры
    Интерактивное взаимодействие с пользователем
#>

function Global:ReadKey {
    param(
        [switch]$NotShowKey,		# Перехват нажатия клавиши БЕЗ отображения в консоли.
        [switch]$ReturnKeyInfo,	# По умолчанию функция возвращает KeyInfo.KeyChar, при использовании параметра - KeyInfo.
		[switch]$DebugInfo			# Отображение отладочной информации.
    )
        $KeyInfo = [System.Console]::ReadKey($NotShowKey)
		
		if ($DebugInfo) {
			Write-Host "`nНажата клавиша: $($KeyInfo.Key)" -Foreground $DebugInfoColor
			Write-Host "Символ: $($KeyInfo.KeyChar)" -Foreground $DebugInfoColor
			Write-Host "Модификаторы: $($KeyInfo.Modifiers)" -Foreground $DebugInfoColor
		}
		if ($ReturnKeyInfo) {return $KeyInfo}
		else {return $keyInfo.KeyChar}
}

function Global:ReadKeyLimited {
    param(
		[switch]$NoLimitedSet			# Выключает чувствительность регистра.
		[switch]$NoCaseSensitive	# Выключает чувствительность регистра.
        [switch]$NotShowKey,			# Перехват нажатия клавиши БЕЗ отображения в консоли.
        [switch]$ReturnKeyInfo,		# По умолчанию функция возвращает KeyInfo.KeyChar, при использовании параметра - KeyInfo.
		[switch]$DebugInfo				# Отображение отладочной информации.
    )
		do{
        $Ret = ReadKey ($NotShowKey, $ReturnKeyInfo, $DebugInfo))
			
		}
		
		return $Ret
}







function Global:ReadKeyDigit{
    param(
        [int]$min = 0,
        [int]$max = 9
    )
	[string]$ValidDigits = ""
	for ($i = $min; $i -le $max; $i++)
	{
		$ValidDigits += $i
	}	
    return ReadKey "Press any key from $min to $($max): " $ValidDigits
}

function Global:ReadKeyBool{
    param(
		[string]$message = "Press key y/n: ",
		[switch]$ShowBoolResult
	)
	[string]$ValidDigits = "yYnN01"
	$keyinfo = ReadKey $message $ValidDigits
#	if ( $ShowBoolResult){
		$boolResult = $keyinfo.KeyChar -eq 'y' -or $result.KeyChar -eq 'Y' -or $result.KeyChar -eq '1' ? $true : $false
#	}
return  [bool]$boolResult
}
<# 
function Global:ReadKeyBool{
    param(
		[string]$ResultMessage = "You key pressed: ",
		[switch]$ShowBoolResult
	)
	[string]$ValidDigits = "yYnN01"
	$keyinfo = ReadKey "Press key y/n: " $ValidDigits
	if ( $ShowBoolResult){
		$boolResult = $keyinfo.KeyChar -eq 'y' -or $result.KeyChar -eq 'Y' -or $result.KeyChar -eq '1' ? $true : $false
	}
    return  $boolResult
}
 #>


function Global:OptionBool
{
	param
	(
		[string]$message,
		[string]$optionYes,
		[string]$optionNo
	)
	Write-Host $message
	$boolResult  =ReadKeyBool -showboolresult
	if ($boolResult) 	{ Write-Host $optionYes }
	else { Write-Host $optionNo }
	return $boolResult
}

