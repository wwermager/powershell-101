param (
    # Defining a parameter in this way will automatically prompt the user for the value if it is not provided
    [Parameter(Position=1,mandatory=$true)]
    [string]$Path
)

$files = Get-ChildItem -Path $Path -Filter "*.json"

# TODO If no files are found in the specified path, print a message and exit

Write-Host "Found files: $($files.Name)"

$log_entries = $files | ForEach-Object { 
    Write-Debug "Processing $($_.FullName)"
    Get-Content $_.FullName | ConvertFrom-Json
}

$error_entries = $log_entries | Where-Object { $_.log_level -eq "ERROR" }

$grouped = $error_entries | Group-Object -Property log_message

$summary = $grouped | ForEach-Object {
    [PSCustomObject]@{
        count = $_.Count
        log_level = $_.Group.log_level | Get-Unique
        log_message = $_.Group.log_message | Sort-Object | Get-Unique
    }
}

# TODO Export the summary to a CSV file: allow the user to optionally specify the output path
$summary
