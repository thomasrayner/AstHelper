# AstHelper

AstHelper is a PowerShell module that aims to make working with Abstract Syntax Trees (ASTs) a more convenient process. If you're writing a tool that parses PowerShell scripts, analyzes code structure, or performs static analysis, this module provides useful utilities to simplify those tasks.

## What is an Abstract Syntax Tree (AST)?

In PowerShell, an Abstract Syntax Tree is a hierarchical representation of PowerShell code that shows the structure and elements of scripts. The AST provides a way to programmatically analyze and work with PowerShell code without executing it. It breaks down scripts into their component parts (commands, parameters, expressions, etc.), allowing for inspection and manipulation of code structure.

## Why Use AstHelper?

Working directly with PowerShell's AST can be complex and requires in-depth knowledge of the AST structure. AstHelper provides simplified functions to:

* Discover what AST types exist in a PowerShell script
* Retrieve specific types of AST objects from a script
* Tokenize PowerShell scripts for more granular analysis
* Benefit from automatic tab completion when working with AST types

## Installation

### Manual Installation

1. Clone this repository:
   ```powershell
   git clone https://github.com/thomasrayner/AstHelper.git
   ```

2. Import the module:
   ```powershell
   Import-Module ./AstHelper/AstHelper.psd1
   ```

### For Development

Copy the module to your PowerShell modules directory:
```powershell
Copy-Item -Path ./AstHelper -Destination "$($env:PSModulePath.Split(';')[0])/AstHelper" -Recurse
```

## Features

AstHelper provides the following key functions:

* **Get-AstType**: Discovers all AST object types used in a script
* **Get-AstObject**: Retrieves specific AST objects from a script by their type
* **Invoke-Tokenize**: Breaks down a script into its token components

## Usage Examples

### Finding All AST Types in a Script

```powershell
# Get all the AST types found in a script
Get-AstType -ScriptPath ./MyScript.ps1

# Output might include types like:
# CommandAst
# CommandParameterAst
# ScriptBlockAst
# ...etc
```

### Finding Specific AST Objects

```powershell
# Find all commands in a script
Get-AstObject -ScriptPath ./MyScript.ps1 -Type CommandAst

# Find all variables in a script
Get-AstObject -ScriptPath ./MyScript.ps1 -Type VariableExpressionAst

# Find exact type matches only (not derived types)
Get-AstObject -ScriptPath ./MyScript.ps1 -Type CommandAst -ExactType
```

### Tokenizing a Script

```powershell
# Break down a script into its token components
Invoke-Tokenize -ScriptPath ./MyScript.ps1

# This returns token objects with properties like:
# - Content
# - Type
# - Start
# - Length
# - StartLine
# - StartColumn
# - EndLine
# - EndColumn
```

### Using Tab Completion

AstHelper includes parameter completion for the `-Type` parameter in `Get-AstObject`:

```powershell
# Start typing and use tab completion to discover available AST types in your script
Get-AstObject -ScriptPath ./MyScript.ps1 -Type <TAB>
```

## Common AST Scenarios

### Finding All Function Definitions in a Script

```powershell
Get-AstObject -ScriptPath ./MyScript.ps1 -Type FunctionDefinitionAst
```

### Identifying Potentially Unsafe Commands

```powershell
Get-AstObject -ScriptPath ./MyScript.ps1 -Type CommandAst | 
    Where-Object { $_.CommandElements[0].Value -in @('Invoke-Expression', 'iex', 'Invoke-WebRequest') }
```

### Static Code Analysis

```powershell
# Find all variables that might be unused
$variables = Get-AstObject -ScriptPath ./MyScript.ps1 -Type VariableExpressionAst
$assignments = $variables | Where-Object { $_.Parent -is [System.Management.Automation.Language.AssignmentStatementAst] }
$usages = $variables | Where-Object { $_.Parent -isnot [System.Management.Automation.Language.AssignmentStatementAst] }

$assignments | Where-Object { 
    $varName = $_.VariablePath.UserPath
    -not ($usages | Where-Object { $_.VariablePath.UserPath -eq $varName })
}
```

## Additional Resources

For more information about PowerShell AST:

* [PowerShell AST Documentation](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-ast)
* [Deep Dive into PowerShell AST](https://devblogs.microsoft.com/scripting/learn-how-it-works-use-the-powershell-ast/)
* [AST Explorer for PowerShell](https://github.com/SeeminglyScience/EditorServicesCommandSuite)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
