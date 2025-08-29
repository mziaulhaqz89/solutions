# Power Platform Solution Export Script
# This script can be used for local testing or manual exports

param(
    [Parameter(Mandatory=$true)]
    [string]$SolutionName,
    
    [Parameter(Mandatory=$true)]
    [string]$EnvironmentUrl,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("managed", "unmanaged")]
    [string]$ExportType = "unmanaged",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = ".\solutions\exports"
)

# Check if Power Platform CLI is installed
try {
    $pacVersion = pac --version
    Write-Host "Power Platform CLI version: $pacVersion" -ForegroundColor Green
} catch {
    Write-Error "Power Platform CLI is not installed. Please install it first."
    Write-Host "Install via: winget install Microsoft.PowerPlatformCLI" -ForegroundColor Yellow
    exit 1
}

# Create output directory if it doesn't exist
if (!(Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force
    Write-Host "Created output directory: $OutputPath" -ForegroundColor Green
}

# Generate filename with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$filename = "${SolutionName}_${ExportType}_${timestamp}.zip"
$fullPath = Join-Path $OutputPath $filename

Write-Host "Starting export of solution: $SolutionName" -ForegroundColor Cyan
Write-Host "Environment: $EnvironmentUrl" -ForegroundColor Cyan
Write-Host "Export Type: $ExportType" -ForegroundColor Cyan
Write-Host "Output File: $fullPath" -ForegroundColor Cyan

try {
    # Authenticate (this will prompt for credentials)
    Write-Host "Authenticating to Power Platform..." -ForegroundColor Yellow
    pac auth create --url $EnvironmentUrl
    
    # Export solution
    Write-Host "Exporting solution..." -ForegroundColor Yellow
    if ($ExportType -eq "managed") {
        pac solution export --name $SolutionName --path $fullPath --managed
    } else {
        pac solution export --name $SolutionName --path $fullPath
    }
    
    Write-Host "Solution exported successfully to: $fullPath" -ForegroundColor Green
    
    # Optional: Unpack solution for source control
    $choice = Read-Host "Do you want to unpack the solution for source control? (y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        $unpackPath = ".\solutions\src\$SolutionName"
        
        if (Test-Path $unpackPath) {
            Write-Host "Removing existing unpacked solution..." -ForegroundColor Yellow
            Remove-Item $unpackPath -Recurse -Force
        }
        
        Write-Host "Unpacking solution..." -ForegroundColor Yellow
        pac solution unpack --zipfile $fullPath --folder $unpackPath --packagetype $ExportType
        
        Write-Host "Solution unpacked to: $unpackPath" -ForegroundColor Green
    }
    
} catch {
    Write-Error "Error during export: $($_.Exception.Message)"
    exit 1
}

Write-Host "Export completed successfully!" -ForegroundColor Green
