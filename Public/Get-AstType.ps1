function Get-AstType {
	<#
		.SYNOPSIS
			Returns all of the types of AST objects in a script.
		.DESCRIPTION
			Parses the contents of a provided script and gets a list of all the AST object types.
			
			This function analyzes a PowerShell script file and identifies all the different 
			types of Abstract Syntax Tree (AST) objects that exist within it. This is useful for:
			
			- Understanding the structure of a PowerShell script
			- Discovering what AST object types are available for further analysis
			- Preparing to use Get-AstObject by identifying valid Type parameter values
			
			The function returns System.Type objects that represent each unique AST type found in the script.
		.PARAMETER ScriptPath
			The path to the PowerShell script file to analyze. This parameter accepts relative or absolute paths.
		.EXAMPLE
			Get-AstType -ScriptPath .\MyScript.ps1
			
			Returns all AST types found in MyScript.ps1.
		.EXAMPLE
			Get-AstType -ScriptPath .\MyScript.ps1 | Where-Object { $_.Name -like '*Expression*' }
			
			Returns only AST types that contain 'Expression' in their name.
		.EXAMPLE
			$types = Get-AstType -ScriptPath .\MyScript.ps1
			$types | Select-Object -ExpandProperty Name
			
			Gets all AST types and displays only their type names.
		.NOTES
			Author: Thomas Rayner (@MrThomasRayner), workingsysadmin.com
			
			The AST objects returned are .NET types from the System.Management.Automation.Language namespace.
		.LINK
			https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.language
		.LINK
			https://workingsysadmin.com
	#>
	
	[CmdletBinding()]
	[OutputType([System.Type[]])]
	param (
	    [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
	    [ValidateNotNullOrEmpty()]
	    [string]$ScriptPath
	)
	process {
	    try {
			$FullPath = (Resolve-Path -Path $ScriptPath).ProviderPath
			$ast = [System.Management.Automation.Language.Parser]::ParseFile( $FullPath, [ref]$null, [ref]$null )
			$ast.FindAll( { $args[0] -ne $null }, $true )  |
				ForEach-Object {
					$_.GetType()
				} | Select-Object -Unique
	    }
	    catch {
	        $PSCmdlet.ThrowTerminatingError( $_ )
	    }
	}
}
