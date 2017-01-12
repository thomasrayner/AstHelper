Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 |
ForEach-Object {
    . $_.FullName
} 
