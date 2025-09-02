# Solution Export Guide

This repository supports exporting multiple Power Platform solutions using automated GitHub Actions workflows.

## Available Solutions

- **travelsolution**: Travel management solution located in `solutions/travelsolution/`
- **coffeeshopsolution**: Coffee shop management solution located in `solutions/coffeeshopsolution/`

## Export Methods

### 1. GitHub Actions (Recommended for Team Collaboration)

**Automatic Export via GitHub Actions UI:**

1. Navigate to your repository: https://github.com/mziaulhaqz89/solutions
2. Go to the **Actions** tab
3. Select **"Export Power Platform Solution"** workflow
4. Click **"Run workflow"**
5. Configure your export settings:
   - **Solution names**: Enter solution names (comma-separated for multiple)
   - **Custom branch name**: Optional - specify your preferred branch name
   - **Target branch**: Choose target branch (usually `main`)
   - **Include managed solutions**: Choose whether to include managed solutions
6. Click **"Run workflow"** to start

#### Branch Naming Options:

**Custom Branch Name:**
```yaml
# When you provide a custom name:
Custom branch name: "feature/coffee-shop-updates"
# Result: Creates branch named "feature/coffee-shop-updates"
```

**Auto-Generated Name (Default):**
```yaml
# When custom name is left empty:
Custom branch name: (leave empty)  
# Result: Creates branch like "solution-export-20241220-143052"
#         (includes timestamp for uniqueness)
```

**What happens:**
- Exports the selected solution from your DEV environment
- Unpacks the solution files
- Updates the corresponding folder in `solutions/{solution_name}/`
- Creates a new branch with the changes
- Prepares for a Pull Request

### 2. Local Development Export

**Using the Batch Script (Windows):**
```cmd
# Run from repository root
export-solution.bat
```
Follow the menu prompts to select solution and export type.

**Using PowerShell Directly:**
```powershell
# For Travel Solution
.\scripts\Export-Solution.ps1 -SolutionName "travelsolution" -EnvironmentUrl "https://mzhdev.crm4.dynamics.com"

# For Coffee Shop Solution  
.\scripts\Export-Solution.ps1 -SolutionName "coffeeshopsolution" -EnvironmentUrl "https://mzhdev.crm4.dynamics.com"
```

## Repository Structure

```
solutions/
├── travelsolution/           # Travel solution files
│   ├── Entities/            # Entity definitions
│   ├── Other/               # Other solution components
│   └── ...
├── coffeeshopsolution/       # Coffee shop solution files
│   ├── Entities/            # Entity definitions  
│   ├── Other/               # Other solution components
│   └── ...
scripts/
├── Export-Solution.ps1      # PowerShell export script
.github/workflows/
├── export-power-platform-solution.yml  # Main export workflow
└── ...
```

## Environment Configuration

The GitHub Actions workflow is configured for:
- **DEV Environment**: `https://mzhdev.crm4.dynamics.com`
- **Authentication**: Service Principal (configured in repository secrets)

## Prerequisites

### For GitHub Actions:
- Repository secret `PowerPlatformSPN` must be configured
- Service principal must have access to the Power Platform environment

### For Local Development:
- Power Platform CLI must be installed:
  ```cmd
  winget install Microsoft.PowerPlatformCLI
  ```
- Valid credentials for the Power Platform environment

## Workflow Benefits

✅ **Multi-Solution Support**: Easy switching between solutions  
✅ **Automated Branching**: Creates branches automatically for PRs  
✅ **Version Control**: Proper tracking of solution changes  
✅ **Team Collaboration**: Standardized export process  
✅ **Local Development**: Scripts for individual developer use  

## Adding New Solutions

To add support for a new solution:

1. **Update GitHub Actions workflow**:
   - Edit `.github/workflows/export-power-platform-solution.yml`
   - Add new solution name to the `options` list

2. **Update PowerShell script**:
   - Edit `scripts/Export-Solution.ps1`
   - Add new solution name to the `ValidateSet` attribute

3. **Update batch script**:
   - Edit `export-solution.bat`
   - Add new menu option and solution name

4. **Create solution folder**:
   - Ensure `solutions/{new_solution_name}/` directory exists

## Best Practices

- **Use GitHub Actions** for team exports and official releases
- **Use local scripts** for development and testing
- **Always review** changes before merging pull requests
- **Keep solution names consistent** across environments
- **Document** any custom solution components or dependencies

## Troubleshooting

**Common Issues:**
- **Authentication errors**: Check service principal permissions
- **Solution not found**: Verify solution name exists in environment
- **Export fails**: Check Power Platform CLI installation and version

**Getting Help:**
- Check workflow logs in GitHub Actions
- Review PowerShell script output for detailed error messages
- Verify environment URLs and authentication settings
