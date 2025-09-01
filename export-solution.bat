@echo off
REM Quick export script for Power Platform solutions
REM This provides a menu-driven interface for exporting solutions

echo ============================================
echo  Power Platform Solution Export Menu
echo ============================================
echo.
echo Select a solution to export:
echo 1. Travel Solution
echo 2. Coffee Shop Solution
echo 3. Exit
echo.

set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo.
    echo Exporting Travel Solution...
    set solution=travelsolution
    goto :export
)

if "%choice%"=="2" (
    echo.
    echo Exporting Coffee Shop Solution...
    set solution=coffeeshopsolution
    goto :export
)

if "%choice%"=="3" (
    echo Goodbye!
    goto :end
)

echo Invalid choice. Please run the script again.
goto :end

:export
set /p env="Enter environment URL (e.g., https://mzhdev.crm4.dynamics.com): "
if "%env%"=="" (
    echo Environment URL is required!
    goto :end
)

echo.
echo Export Type:
echo 1. Unmanaged (for development)
echo 2. Managed (for deployment)
set /p exportType="Select export type (1-2): "

if "%exportType%"=="1" (
    set type=unmanaged
) else if "%exportType%"=="2" (
    set type=managed
) else (
    set type=unmanaged
    echo Defaulting to unmanaged export...
)

echo.
echo Starting export...
powershell -ExecutionPolicy Bypass -File ".\scripts\Export-Solution.ps1" -SolutionName "%solution%" -EnvironmentUrl "%env%" -ExportType "%type%"

:end
pause
