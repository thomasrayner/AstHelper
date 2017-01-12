function Invoke-Tokenize {
	<#
		.SYNOPSIS
			Tokenizes a script.
		.DESCRIPTION
			Gets the content of a script located at a given path and tokenizes it.
		.EXAMPLE
			Invoke-Tokenize -ScriptPath .\MyScript.ps1
		.NOTES
			Author: Thomas Rayner (@MrThomasRayner), workingsysadmin.com
		.LINK
			http://workingsysadmin.com
	#>
	
	[CmdletBinding()]
	param (
	    # The path to the script to be tokenized
		[Parameter(Mandatory)]
	    [ValidateNotNullOrEmpty()]
	    [string]$ScriptPath
	)
	
	$code = Get-Content $ScriptPath
	[System.Management.Automation.PSParser]::Tokenize($code,[ref]$null) |
	    ForEach-Object {
				$_
			} 
}
