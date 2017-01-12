function Get-AstObject {
	<#
		.SYNOPSIS
			Returns all the AST objects in a script that are of a specified type.
		.DESCRIPTION
			Takes the content of a script, parses it, and returns all the objects in a script that are of that type.
		.EXAMPLE
			Get-AstObject -ScriptPath .\MyScript.ps1 -Type CommandAst
		.NOTES
			Author: Thomas Rayner (@MrThomasRayner), workingsysadmin.com
		.LINK
			http://workingsysadmin.com
	#>
	
	[CmdletBinding()]
	[OutputType([PSCustomObject[]])]
	param (
	    [Parameter(Mandatory)]
	    [ValidateNotNullOrEmpty()]
	    [string]$ScriptPath,
	
		[Parameter(Mandatory)]
	    [ValidateNotNullOrEmpty()]
	    [string]$Type
	)
	process {
	    try {
			[System.Type]$FullType = "System.Management.Automation.Language.$Type"
			$ast = [System.Management.Automation.Language.Parser]::ParseFile( $ScriptPath, [ref]$null, [ref]$null )
			$ast.FindAll( { $args[0] -is $FullType }, $true )  |
				ForEach-Object {
					$_
				}
	    }
	    catch {
	        $PSCmdlet.ThrowTerminatingError( $_ )
	    }
	}
}
