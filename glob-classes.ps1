# glob-classes.ps1

# Header Class

class HeaderNum 
{
	[int]$Num1 = 1
	[int]$Num2 = $null
	[int]$Num3 = $null
	
	HeaderNum ( [int]$num1, [int]$num2, [int]$num3 )
	{
		$this.Num1 = $num1
		$this.Num2 = $num2
		$this.Num3 = $num3
	}
	[string]ToString()
	{
		[string]$str = "$($this.Num1). "
		if ( $Num2 -is $null )
		{
			$str += "$($this.Num2). "		
			if ( $Num3 -is $null )	{ $str += "$($this.Num3). " }
		}
		return $str	
	}

class Header {
    [string]$Num
	[string]$Text
	
	Header ([int]$num, [string]$text){
		$this.Num = $num
		$this.Text = $text
	}
	[string]ToString(){ return "$($this.Num). $($this.Text)"	}
	[string]ToString([Header]$Header){ return "$($Header.Num). $($Header.Text)"	}
	[string]WriteTo(){ Write-Host $this.ToString() -ForegroundColor $HeaderColor }
	[string]WriteTo([Header]$Header)){ Write-Host $this.ToString($Header) -ForegroundColor $HeaderColor }
}

class Header2 : Header{
    [int]$Num
    [Header]$Header
	[string]$Text

	Header2([int]$num, [Header]$header){
		$this.Header = $header
		$this.Num = $num
	}
	
	Header2([int]$num1, [int]$num2, [string]$text){
		$this.Header = new Header($num2, $text)
		$this.Num = $num1
	}
	
	///////////////////////////////////////////////////
	[string]ToString(){ return "$($this.1\Num). $base.ToString($this.Text)"	}
	[string]WriteTo(){ Write-Host $this.ToString() -ForegroundColor $HeaderColor }
	
}
{
    [Header]$Header1
    [string]$Num2
    [string]$S
    [int]$PID
    
    ServiceInfo([string]$name, [string]$status, [int]$pid) {
        $this.Name = $name
        $this.Status = $status
        $this.PID = $pid
    }
    
    [string]ToString() {
        return "$($this.Name) - $($this.Status)"
    }
}

# Создаем объект класса
$serviceObj = [ServiceInfo]::new("MySQL", "Running", 1234)