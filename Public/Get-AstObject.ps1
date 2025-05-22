function Get-AstObject {
	<#
		.SYNOPSIS
			Returns all the AST objects in a script that are of a specified type.
		.DESCRIPTION
			Takes the content of a script, parses it, and returns all the objects in a script that match the specified AST type.
			
			This function allows you to extract specific elements from a PowerShell script based on their 
			AST object type. This is useful for:
			
			- Finding all instances of a particular language element (commands, variables, etc.)
			- Performing targeted code analysis
			- Extracting specific parts of a script for inspection or modification
			
			By default, the function returns objects of the specified type and any derived types. 
			Use the -ExactType switch to match only the exact type specified.
		.PARAMETER ScriptPath
			The path to the PowerShell script file to analyze. This parameter accepts relative or absolute paths.
		.PARAMETER Type
			The AST type to search for. This should be the name of an AST type without the namespace prefix.
			Common types include:
			- CommandAst (commands)
			- VariableExpressionAst (variables)
			- ScriptBlockAst (script blocks)
			- FunctionDefinitionAst (function definitions)
			- ParameterAst (parameters)
			
			Use Get-AstType with the same script to discover available types.
			
			Tab completion is available for this parameter after specifying -ScriptPath.
		.PARAMETER ExactType
			When specified, the function will only return objects that exactly match the specified type,
			excluding objects of derived types. By default, derived types are included in the results.
		.EXAMPLE
			Get-AstObject -ScriptPath .\MyScript.ps1 -Type CommandAst
			
			Returns all command AST objects in MyScript.ps1.
		.EXAMPLE
			Get-AstObject -ScriptPath .\MyScript.ps1 -Type VariableExpressionAst | Select-Object -ExpandProperty VariablePath
			
			Returns the paths of all variables used in MyScript.ps1.
		.EXAMPLE
			Get-AstObject -ScriptPath .\MyScript.ps1 -Type CommandAst -ExactType
			
			Returns only the AST objects that are exactly of type CommandAst, excluding any derived types.
		.EXAMPLE
			Get-AstObject -ScriptPath .\MyScript.ps1 -Type FunctionDefinitionAst | Select-Object -ExpandProperty Name
			
			Returns the names of all functions defined in MyScript.ps1.
		.NOTES
			Author: Thomas Rayner (@MrThomasRayner), workingsysadmin.com
			
			This function includes tab completion for the -Type parameter if a valid -ScriptPath is provided first.
		.LINK
			https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.language
		.LINK
			https://workingsysadmin.com
	#>
	
	[CmdletBinding()]
	[OutputType([System.Management.Automation.Language.Ast[]])]
	param (
	    [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
	    [ValidateNotNullOrEmpty()]
	    [string]$ScriptPath,
	
	    [Parameter(Mandatory, Position = 1)]
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
