param (
    # Defining a parameter in this way will automatically prompt the user for the value if it is not provided
    [Parameter(Position=1,mandatory=$true)]
    [string]$Path,
    [Parameter(Position=2)]
    [string]$OutPath
)

$files = Get-ChildItem -Path $Path -Filter "*.json"

if ($files.Count -eq 0) {
    Write-Host "No files found in $Path"
    exit
}

Write-Host "Found files: $($files.Name)"

$log_entries = $files | ForEach-Object { 
    Write-Debug "Processing $($_.FullName)"
    Get-Content $_.FullName | ConvertFrom-Json
}

$error_entries = $log_entries | Where-Object { $_.log_level -eq "ERROR" }

$grouped = $error_entries | Group-Object -Property log_level, log_message

$summary = $grouped | ForEach-Object {
    [PSCustomObject]@{
        count = $_.Count
        log_level = $_.Group.log_level | Get-Unique
        log_message = $_.Group.log_message | Sort-Object | Get-Unique
    }
  }

# Optionally write the summary to a file
if ($OutPath) {
    $summary | ConvertTo-Csv -NoTypeInformation | Set-Content -Path $OutPath
} else {
    $summary | ConvertTo-Csv -NoTypeInformation | Set-Content -Path "./error-summary.csv"
}
