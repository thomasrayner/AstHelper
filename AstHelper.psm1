$paths = @(
    'ArgumentCompleters',
    'Public'
)

foreach ($path in $paths) {
    Get-ChildItem -Path "$PSScriptRoot\$path\*.ps1" | ForEach-Object {
        . $_.FullName
    }
}
