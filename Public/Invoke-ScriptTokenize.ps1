function Invoke-Tokenize {
	<#
		.SYNOPSIS
			Tokenizes a PowerShell script.
		.DESCRIPTION
			Gets the content of a PowerShell script located at a given path and breaks it down into its token components.
			
			Tokenizing is the process of breaking down a script into its individual elements or tokens.
			This is useful for:
			
			- Analyzing script structure at a more granular level than AST
			- Finding specific language elements like keywords, operators, or literals
			- Understanding how PowerShell parses your code before execution
			
			Each token returned includes properties like Content, Type, Start position, Length, and Line/Column positions.
		.PARAMETER ScriptPath
			The path to the PowerShell script file to tokenize. This parameter accepts relative or absolute paths.
		.EXAMPLE
			Invoke-Tokenize -ScriptPath .\MyScript.ps1
			
			Returns all tokens in the MyScript.ps1 file.
		.EXAMPLE
			Invoke-Tokenize -ScriptPath .\MyScript.ps1 | Where-Object { $_.Type -eq 'Command' }
			
			Returns only command tokens from MyScript.ps1.
		.EXAMPLE
			Invoke-Tokenize -ScriptPath .\MyScript.ps1 | Group-Object -Property Type | Select-Object Name, Count
			
			Groups all tokens by their type and shows the count of each type.
		.NOTES
			Author: Thomas Rayner (@MrThomasRayner), workingsysadmin.com
			
			Token types include:
			- Comment
			- Command
			- CommandParameter
			- CommandArgument
			- Number
			- String
			- Variable
			- Operator
			- Keyword
			- And many more...
		.LINK
			https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.psparser
		.LINK
			https://workingsysadmin.com
	#>
	
	[CmdletBinding()]
	[OutputType([System.Management.Automation.PSToken[]])]
	param (
	    # The path to the script to be tokenized
		[Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
	    [ValidateNotNullOrEmpty()]
	    [string]$ScriptPath
	)
	
	$code = Get-Content $ScriptPath
	[System.Management.Automation.PSParser]::Tokenize($code,[ref]$null) |
	    ForEach-Object {
				$_
			} 
}
