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
	    [string]$Type,

            [Parameter()]
            [switch]$ExactType
	)
	process {
	    try {
			[System.Type]$FullType = "System.Management.Automation.Language.$Type"
			$astTypeFilter = if($ExactType.IsPresent){
                            { $args[0].GetType() -eq $FullType }
                        }
                        else {
                            { $args[0] -is $FullType}
                        }
			$FullPath = (Resolve-Path -Path $ScriptPath).ProviderPath
			$ast = [System.Management.Automation.Language.Parser]::ParseFile( $FullPath, [ref]$null, [ref]$null )
			$ast.FindAll( $astTypeFilter, $true )  |
				ForEach-Object {
					$_
				}
	    }
	    catch {
	        $PSCmdlet.ThrowTerminatingError( $_ )
	    }
	}
}
