# Technical Workflow Documentation

This directory contains the technical implementation details for Power Platform GitHub Actions workflows. For user-focused documentation, see the main [README.md](../../README.md).

## Quick Reference

| Workflow File | Purpose | User Guide |
|---------------|---------|------------|
| `01-export-solutions.yml` | Export solutions from DEV | See main README |
| `02-deploy-travel-solution.yml` | Deploy travel solution | See main README |  
| `03-deploy-coffeeshop-solution.yml` | Deploy coffee shop solution | See main README |
| `shared-deployment-pipeline.yml` | Reusable deployment pipeline | Technical details below |
| `pr-validator.yml` | PR validation with solution checker | See main README |

## Technical Implementation

## Key Features

✅ **Automatic Solution Versioning**: Uses built-in Power Platform actions for reliable versioning  
✅ **Semantic Versioning**: Supports release tags (v1.2.3) and auto-increment based on build numbers  
✅ **Version Tracking**: Each deployment has a unique version for proper release management  
✅ **Artifact Management**: Versioned artifacts for easy rollback and auditing  
✅ **Solution Checker Integration**: Automated quality validation at every deployment stage  
✅ **Quality Gates**: Three validation checkpoints prevent low-quality solutions from reaching production  
✅ **Custom Branch Naming**: Flexible branch naming with timestamp generation for exports

## Technical Architecture

### Shared Deployment Pipeline (`shared-deployment-pipeline.yml`)
Reusable workflow that provides the core deployment logic with quality gates.

**Input Parameters:**
- `solution_name`: Name of the solution to deploy
- `solution_version`: Version to assign to the solution  
- `environment_dev_url`: Source environment URL
- `environment_build_url`: Build environment URL for managed conversion
- `environment_test_url`: TEST environment URL
- `environment_production_url`: PRODUCTION environment URL
- `client_id`: Service principal client ID
- `tenant_id`: Azure tenant ID

**Jobs:**
1. **convert-to-managed**: Packages unmanaged solution as managed + solution checker
2. **deploy-to-test**: Deploys to TEST environment + solution checker (requires approval)
3. **release-to-production**: Deploys to PRODUCTION + solution checker (requires approval)

**Quality Gates Integration:**
Each job includes solution checker validation with artifact upload to runner temp directory using pattern `${{ runner.temp }}/PowerAppsChecker/**/*`.

### Solution Export (`01-export-solutions.yml`)  
Exports solutions from DEV environment with quality validation.

**Features:**
- Multi-solution export support (comma-separated input)
- Custom branch naming with fallback to timestamp generation
- Solution checker validation during export
- Automatic PR creation with branch-solution action

### Solution-Specific Deployment Workflows
Individual workflows for each solution that call the shared pipeline:

**`02-deploy-travel-solution.yml`:**
- Monitors `solutions/travelsolution/**` path changes
- Calls shared pipeline with travel solution parameters

**`03-deploy-coffeeshop-solution.yml`:**  
- Monitors `solutions/coffeeshop/**` path changes
- Calls shared pipeline with coffee shop solution parameters

### PR Validation (`pr-validator.yml`)
Validates solutions on pull requests with automatic solution detection.

**Process:**
1. Detects changed solutions by analyzing git diff
2. Validates solution folder structure
3. Packages solutions for validation
4. Runs solution checker on each changed solution
5. Reports validation results and blocks merge if critical/high issues found

## Solution Versioning Strategy

### Version Generation Logic:
1. **Release Tag**: If triggered by release with tag `v1.2.3` → version becomes `1.2.3.0`
2. **Manual Version**: If `solution_version` input provided → uses exact version
3. **Auto-increment**: Otherwise → uses `1.0.0.{run_number}` format

### Built-in Power Platform Action:
Uses `microsoft/powerplatform-actions/update-solution-version@v1` which:
- Updates Solution.xml automatically
- Handles version format validation
- Ensures consistent version tracking
- No manual XML manipulation required

## Implementation Details

### Repository Variables Required:
```yaml
DEV_ENVIRONMENT_URL: https://mzhdev.crm4.dynamics.com
BUILD_ENVIRONMENT_URL: https://mzhbuild.crm4.dynamics.com  
TEST_ENVIRONMENT_URL: https://mzhtest.crm4.dynamics.com
PRODUCTION_ENVIRONMENT_URL: https://mzhprod.crm11.dynamics.com
CLIENT_ID: your-service-principal-client-id
TENANT_ID: your-azure-tenant-id
```

### Repository Secrets Required:
```yaml
PowerPlatformSPN: your-service-principal-secret
```

### GitHub Environments Required:
- `TEST`: With required reviewers and branch restrictions
- `PRODUCTION`: With required reviewers and branch restrictions

## Artifact Management

### Solution Checker Artifacts:
- **Path Pattern**: `${{ runner.temp }}/PowerAppsChecker/**/*`
- **Retention**: 30 days
- **Contents**: Analysis results in JSON, XML, and ZIP formats
- **Upload Points**: convert-to-managed, deploy-to-test, release-to-production

### Solution Package Artifacts:
- **Managed Solutions**: Uploaded between pipeline stages
- **Retention**: 30 days  
- **Format**: ZIP files with versioned naming

## Error Handling

### Common Technical Issues:
1. **Artifact Upload Path Errors**: Use `${{ runner.temp }}` instead of relative paths
2. **Solution Checker File Not Found**: Ensure solution checker creates files before upload
3. **Environment Authentication**: Verify service principal permissions
4. **Branch Creation Conflicts**: Handle existing branch scenarios in export workflow

### Debugging Workflow Runs:
1. Check job logs for detailed error messages
2. Download artifacts for solution checker reports
3. Verify environment variables and secrets configuration
4. Test service principal authentication manually

---
For user documentation and setup guides, see the main [README.md](../../README.md).
