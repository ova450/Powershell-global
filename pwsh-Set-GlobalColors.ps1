# pwsh-1-1-baseColorsSet

<# Write-Host "`n2. SETTING UP COLORS" -ForegroundColor Cyan
Write-Host "`n2.1. All defined global colors:" -ForegroundColor Cyan

 #>
 
  # .\pwsh-1-0-baseVariablesSet
 
$Global:HeaderColor = [ConsoleColor]::Cyan
$Global:MessageColor = [ConsoleColor]::Gray
$Global:MessageSimpleColor = [ConsoleColor]::DarkGray
$Global:AttentionColor = [ConsoleColor]::Yellow
$Global:OkColor = [ConsoleColor]::Green
$Global:NotOkColor = [ConsoleColor]::Red
$Global:ErrorMessageColor = [ConsoleColor]::Red
$Global:DebugInfoColor = [ConsoleColor]::DarkBlue

 $filename = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
Write-Host "Базовые глобальные цвета установлены скриптом $filename ..." -Foreground Yellow
Write-Host 

<# Write-Host "`nHeader" -ForegroundColor $HeaderColor
Write-Host "Message" -ForegroundColor $MessageColor
Write-Host "Error" -ForegroundColor $ErrorMessage
Write-Host "Important message, checking, reaction request" -ForegroundColor $AttentionColor
Write-Host "Positive checking result" -ForegroundColor $OkColor
Write-Host "Negative checking result" -ForegroundColor $NotOkColor
 #>
<# Get-Variable -Scope Global | Where-Object { $_.Value -is [ConsoleColor] } | ForEach-Object {
    Write-Host "$($_.Name) = $($_.Value)" -ForegroundColor $_.Value
}

optionbool "Do you want to add more named global colors? (y/N)"

Write-Host "`n2.2. Additionally" -ForegroundColor Cyan

# Get valid console colors
$validColors = [System.Enum]::GetValues([ConsoleColor])

do {
    $colorname = Read-Host "`nEnter the name of the global color variable (e.g., MyCustomColor)"
    
    if ($colorname -ne "") {
        # Check if variable name is valid (starts with letter and contains only letters, numbers, underscore)
        if ($colorname -match "^[a-zA-Z_][a-zA-Z0-9_]*$") {
            # Display available colors
            Write-Host "`nAvailable colors:" -ForegroundColor Yellow
            $validColors | ForEach-Object { Write-Host "- $_" -ForegroundColor $_ }
            
            $colorName = Read-Host "`nEnter the color name from the list above"
            
            # Validate the color
            if ($colorName -ne "" -and [ConsoleColor]::GetNames([ConsoleColor]) -contains $colorName) {
                # Convert string to ConsoleColor enum
                $colorValue = [ConsoleColor]::$colorName
                
                # Create global variable
                Set-Variable -Name $colorname -Value $colorValue -Scope Global -Force
                
                Write-Host "A global color '$colorname' has been created!" -ForegroundColor Yellow
                Write-Host "Test: " -NoNewline
                Write-Host "This is $colorname color" -ForegroundColor $colorValue
            } else {
                Write-Host "Invalid color name. Please choose from the list above." -ForegroundColor Red
            }
        } else {
            Write-Host "Invalid variable name. Use letters, numbers, and underscores only." -ForegroundColor Red
        }
    } else {
        Write-Host "Variable name cannot be empty." -ForegroundColor Red
    }
    
    $continue = Read-Host "`nDo you want to add more named global colors? (y/N)"
} while ($continue -eq "y" -or $continue -eq "Y")

Write-Host "`nAll defined global colors:" -ForegroundColor Cyan
Get-Variable -Scope Global | Where-Object { $_.Value -is [ConsoleColor] } | ForEach-Object {
    Write-Host "$($_.Name) = $($_.Value)" -ForegroundColor $_.Value
} #>