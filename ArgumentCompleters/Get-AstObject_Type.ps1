<#
    .SYNOPSIS
    Provides Argument Completion for the 'Get-AstObject' Function, 'Type' parameter.
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
