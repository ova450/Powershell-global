
function Global:ReadKey {
    param(
        [string]$message = "Press any key [A..z] or [0..9] > ",
        [string]$ValidChars = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    )
    Write-Host $message -ForegroundColor $AttentionColor -NoNewline
    $validHash = @{}
    $ValidChars.ToCharArray() | ForEach-Object { $validHash[$_] = $true }
    do {
        $keyInfo = [System.Console]::ReadKey($true)
        $char = $keyInfo.KeyChar
        if ($char -eq 0 -or -not $validHash.ContainsKey($char)) { continue }
        if ($keyInfo.Modifiers -ne 0) { continue }
        break       
    }
	while ($true)
    Write-Host $char -ForegroundColor $OKColor
    return $keyInfo
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
    param( [string]$ResultMessage = "You key pressed: " )
	[string]$ValidDigits = "yYnN"
	$keyinfo = ReadKey "Press key y/n: " $ValidDigits
	$boolResult = $keyinfo.KeyChar -eq 'y' -or $result.KeyChar -eq 'Y' ? $true : $false
	# $info = $ResultMessage + $result.KeyChar -eq 'y' -or $result.KeyChar -eq 'Y'
    return  $boolResult
}


 <#     if ($check) { Write-Host $isok -ForegroundColor Green }
	else { Write-Host $isnok -ForegroundColor Red }
 #>


