<#
    .SYNOPSIS
    Provides Argument Completion for the 'Get-AstObject' Function, 'Type' parameter.
    
    .DESCRIPTION
    This script implements tab completion for the -Type parameter of the Get-AstObject function.
    It dynamically retrieves all AST types found in the script specified by the -ScriptPath parameter
    and provides them as completion options when pressing Tab after typing '-Type'.
    
    .NOTES
    This enhances user experience by making it easier to discover and select valid AST types
    without having to remember all possible type names or run Get-AstType separately.
    
    .EXAMPLE
    # After importing the module, type:
    Get-AstObject -ScriptPath .\MyScript.ps1 -Type <TAB>
    
    # Tab completion will show available AST types in MyScript.ps1
#>
Register-ArgumentCompleter -CommandName Get-AstObject -ParameterName Type -ScriptBlock {
    param($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameter)

    if ([System.IO.File]::Exists($FakeBoundParameter.ScriptPath)) {
        $types = Get-AstType -ScriptPath $FakeBoundParameter.ScriptPath
        $names = $types.Where({$_.Name -like "$WordToComplete*"}).Name | Sort-Object

        foreach ($name in $names) {
            [System.Management.Automation.CompletionResult]::new($name, $name, 'ParameterValue', $name)
        }
    }
}
