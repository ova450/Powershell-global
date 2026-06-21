# .\pwsh-1-4-checkcolors

function Show-GlobalVariables {
    <#
    .SYNOPSIS
    Показывает все глобальные переменные с номерами
    #>
    
    Write-Host "`n" + $("="*60) -ForegroundColor Cyan
    Write-Host "GLOBAL VARIABLES CONTROL" -ForegroundColor Cyan
    Write-Host "="*60 -ForegroundColor Cyan
    
    # Получаем все глобальные переменные
    $globalVars = Get-Variable -Scope Global | Where-Object { $_.Value -is [ConsoleColor] }

<#     # Получаем все глобальные переменные
    $globalVars = Get-Variable -Scope Global | Where-Object { 
        $_.Value -is [ConsoleColor] -and 
        $_.Name -notin @("HeaderColor", "MessageColor", "MessageSimpleColor", "AttentionColor", "OkColor", "NotOkColor", "ErrorMessage")
    }

 #>    
    if ($globalVars.Count -eq 0) {
        Write-Host "`nNo custom global color variables found." -ForegroundColor Yellow
        Write-Host "System variables are protected from deletion." -ForegroundColor DarkGray
        return $null
    }
    
    Write-Host "`nCUSTOM GLOBAL COLOR VARIABLES:" -ForegroundColor Yellow
    Write-Host "-"*60 -ForegroundColor DarkGray
    
    $index = 1
    $varList = @()
    
    foreach ($var in $globalVars) {
        $varInfo = [PSCustomObject]@{
            Index = $index
            Name = $var.Name
            Value = $var.Value
            Color = $var.Value
        }
        $varList += $varInfo
        
        # Показываем переменную с её цветом
        Write-Host ("{0,3}. {1}" -f $index, $var.Name) -NoNewline -ForegroundColor White
        Write-Host " = " -NoNewline -ForegroundColor DarkGray
        Write-Host $var.Value -ForegroundColor $var.Value
        
        $index++
    }
    
    Write-Host "-"*60 -ForegroundColor DarkGray
    Write-Host "Total: $($globalVars.Count) custom variables`n" -ForegroundColor Gray
    
    return $varList
}

function Remove-GlobalVariableByIndex {
    <#
    .SYNOPSIS
    Удаляет глобальную переменную по номеру
    #>
    param(
        [int]$Index,
        [array]$VariableList
    )
    
    if ($Index -lt 1 -or $Index -gt $VariableList.Count) {
        Write-Host "Invalid index! Please choose number between 1 and $($VariableList.Count)" -ForegroundColor Red
        return $false
    }
    
    $varToRemove = $VariableList[$Index - 1]
    $varName = $varToRemove.Name
    $varValue = $varToRemove.Value
    
    Write-Host "`nVariable to delete:" -ForegroundColor Yellow
    Write-Host "  Name: " -NoNewline -ForegroundColor White
    Write-Host $varName -ForegroundColor $varValue
    Write-Host "  Value: " -NoNewline -ForegroundColor White
    Write-Host $varValue -ForegroundColor $varValue
    
    $confirm = Read-Host "`nAre you sure you want to delete this variable? (y/N)"
    
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        Remove-Variable -Name $varName -Scope Global -Force -ErrorAction SilentlyContinue
        Write-Host "`nVariable '$varName' has been deleted!" -ForegroundColor Green
        return $true
    } else {
        Write-Host "Deletion cancelled." -ForegroundColor Yellow
        return $false
    }
}

function Remove-MultipleGlobalVariables {
    <#
    .SYNOPSIS
    Удаляет несколько глобальных переменных по номерам
    #>
    param(
        [array]$VariableList
    )
    
    if ($VariableList.Count -eq 0) {
        Write-Host "No variables to delete." -ForegroundColor Yellow
        return
    }
    
    Write-Host "`nEnter variable numbers to delete (separated by spaces, commas, or ranges):" -ForegroundColor Yellow
    Write-Host "Examples: 1 3 5  or  1,3,5  or  1-5" -ForegroundColor DarkGray
    
    $input = Read-Host "Numbers"
    
    # Парсим ввод
    $numbersToDelete = @()
    
    # Разделяем по пробелам и запятым
    $parts = $input -split "[,\s]+" | Where-Object { $_ -ne "" }
    
    foreach ($part in $parts) {
        if ($part -match "^(\d+)-(\d+)$") {
            # Диапазон
            $start = [int]$Matches[1]
            $end = [int]$Matches[2]
            if ($start -le $end) {
                $numbersToDelete += $start..$end
            } else {
                $numbersToDelete += $end..$start
            }
        } elseif ($part -match "^\d+$") {
            # Одиночное число
            $numbersToDelete += [int]$part
        }
    }
    
    # Удаляем дубликаты и сортируем
    $numbersToDelete = $numbersToDelete | Sort-Object -Unique
    
    # Валидация
    $validNumbers = $numbersToDelete | Where-Object { $_ -ge 1 -and $_ -le $VariableList.Count }
    $invalidNumbers = $numbersToDelete | Where-Object { $_ -lt 1 -or $_ -gt $VariableList.Count }
    
    if ($invalidNumbers.Count -gt 0) {
        Write-Host "Invalid numbers ignored: $invalidNumbers" -ForegroundColor Red
    }
    
    if ($validNumbers.Count -eq 0) {
        Write-Host "No valid numbers entered." -ForegroundColor Yellow
        return
    }
    
    # Показываем что будет удалено
    Write-Host "`nVariables to delete:" -ForegroundColor Yellow
    foreach ($num in $validNumbers) {
        $var = $VariableList[$num - 1]
        Write-Host ("  {0,3}. {1} = " -f $num, $var.Name) -NoNewline -ForegroundColor White
        Write-Host $var.Value -ForegroundColor $var.Value
    }
    
    $confirm = Read-Host "`nDelete these $($validNumbers.Count) variables? (y/N)"
    
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        $deleted = 0
        foreach ($num in $validNumbers | Sort-Object -Descending) {
            $var = $VariableList[$num - 1]
            Remove-Variable -Name $var.Name -Scope Global -Force -ErrorAction SilentlyContinue
            $deleted++
            Write-Host "Deleted: $($var.Name)" -ForegroundColor Green
        }
        Write-Host "`nTotal deleted: $deleted variables" -ForegroundColor Green
    } else {
        Write-Host "Deletion cancelled." -ForegroundColor Yellow
    }
}

# ============ ОСНОВНАЯ ПРОГРАММА ============

Clear-Host
Write-Host "="*60 -ForegroundColor Cyan
Write-Host "GLOBAL COLOR VARIABLES MANAGER" -ForegroundColor Cyan
Write-Host "="*60 -ForegroundColor Cyan

do {
    # Показываем текущие переменные
    $varList = Show-GlobalVariables
    
    if ($varList -and $varList.Count -gt 0) {
        Write-Host "`nOPTIONS:" -ForegroundColor Yellow
        Write-Host "  1. Delete single variable by number" -ForegroundColor White
        Write-Host "  2. Delete multiple variables by numbers" -ForegroundColor White
        Write-Host "  3. Delete ALL custom variables" -ForegroundColor White
        Write-Host "  4. Refresh list" -ForegroundColor White
        Write-Host "  5. Exit" -ForegroundColor White
		
		# Очистка буфера перед Read-Host
while ($Host.UI.RawUI.KeyAvailable) {
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

        
        $choice = ReadKey "`nSelect option (1-5)"
        
        switch ($choice) {
            "1" {
                $num = Read-Host "Enter variable number to delete"
                if ($num -match "^\d+$") {
                    Remove-GlobalVariableByIndex -Index ([int]$num) -VariableList $varList
                } else {
                    Write-Host "Invalid number!" -ForegroundColor Red
                }
            }
            "2" {
                Remove-MultipleGlobalVariables -VariableList $varList
            }
            "3" {
                Write-Host "`nWARNING: This will delete ALL custom color variables!" -ForegroundColor Red
                Write-Host "System variables (HeaderColor, MessageColor, etc.) are protected." -ForegroundColor DarkGray
                
                $confirm = Read-Host "`nAre you sure? Type 'DELETE ALL' to confirm"
                
                if ($confirm -eq "DELETE ALL") {
                    $count = 0
                    foreach ($var in $varList) {
                        Remove-Variable -Name $var.Name -Scope Global -Force -ErrorAction SilentlyContinue
                        $count++
                        Write-Host "Deleted: $($var.Name)" -ForegroundColor Green
                    }
                    Write-Host "`nDeleted $count variables!" -ForegroundColor Green
                } else {
                    Write-Host "Deletion cancelled." -ForegroundColor Yellow
                }
            }
            "4" {
                # Refresh - просто продолжаем цикл
            }
            "5" {
                Write-Host "`nExiting..." -ForegroundColor Cyan
                break
            }
            default {
                Write-Host "Invalid option!" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "`nNo custom variables found. Exiting..." -ForegroundColor Yellow
        break
    }
    
    if ($choice -ne "5") {
        Write-Host "`nPress any key to continue..." -ForegroundColor DarkGray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
    
} while ($true)

Write-Host "`nProgram finished." -ForegroundColor Cyan