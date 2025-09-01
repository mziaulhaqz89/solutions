# Power Platform GitHub Actions Workflows with Automatic Solution Versioning

This repository contains GitHub Actions workflows for Power Platform ALM (Application Lifecycle Management) with **automatic solution versioning** following Microsoft best practices.

## Key Features

✅ **Automatic Solution Versioning**: Uses built-in Power Platform actions for reliable versioning  
✅ **Semantic Versioning**: Supports release tags (v1.2.3) and auto-increment based on build numbers  
✅ **Version Tracking**: Each deployment has a unique version for proper release management  
✅ **Artifact Management**: Versioned artifacts for easy rollback and auditing  

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

## Workflows Overview

### 1. `export-power-platform-solution.yml`
**Purpose**: Export solution from DEV environment and create a pull request with changes.

**Supported Solutions**:
- `travelsolution`: Travel management solution
- `coffeeshopsolution`: Coffee shop management solution

**Triggers**:
- Manual trigger (`workflow_dispatch`) with solution selection dropdown
- Select which solution to export via the GitHub Actions UI

**Usage**:
1. Go to Actions tab → "Export Power Platform Solution"
2. Click "Run workflow" 
3. Select solution from dropdown (travelsolution or coffeeshopsolution)
4. Click "Run workflow" to start export

**Required Repository Variables**:
- `DEV_ENVIRONMENT_URL`: Development environment URL
- `CLIENT_ID`: Service Principal Client ID  
- `TENANT_ID`: Azure Tenant ID

**Required Secrets**:
- `PowerPlatformSPN`: Service Principal secret

### 2. `release-action-call.yml`
**Purpose**: Trigger the release workflow when a new release is created.

**Triggers**:
- Manual trigger (`workflow_dispatch`)
- Release creation (`release.created`)

**Version Handling**: Automatically passes release tag to versioning system

### 3. `release-solution-to-prod-with-inputs.yml`
**Purpose**: Reusable workflow that converts solution to managed and deploys through TEST → PRODUCTION.

**Features**:
- **Automatic Solution Versioning** using Power Platform built-in actions
- Converts unmanaged solution to managed using BUILD environment
- Deploys to TEST environment with approval gate
- Deploys to PRODUCTION environment with approval gate
- **Versioned artifacts** for tracking: `managedSolutions-v{version}`
- **Versioned solution files**: `travelsolution_v1.2.3.0_managed.zip`
- Input validation and error handling
- Version summary in workflow output

### 4. `ci-validate-solution.yml`
**Purpose**: Continuous Integration to validate solutions on pull requests.

**Features**:
- Runs solution checker
- Validates solution packaging
- Uploads validation artifacts

## Setup Instructions

### 1. Repository Variables Setup
Go to Settings → Secrets and variables → Actions → Variables tab and add:

```
BUILD_ENVIRONMENT_URL=https://your-build-env.crm.dynamics.com
TEST_ENVIRONMENT_URL=https://your-test-env.crm.dynamics.com  
PRODUCTION_ENVIRONMENT_URL=https://your-prod-env.crm.dynamics.com
DEV_ENVIRONMENT_URL=https://your-dev-env.crm.dynamics.com
CLIENT_ID=your-service-principal-client-id
TENANT_ID=your-azure-tenant-id
```

### 2. Repository Secrets Setup
Go to Settings → Secrets and variables → Actions → Secrets tab and add:

```
PowerPlatformSPN=your-service-principal-secret
```

### 3. Environment Protection Rules
1. Go to Settings → Environments
2. Create environments: `TEST` and `PRODUCTION`
3. Add protection rules:
   - Required reviewers for PRODUCTION
   - Wait timer if needed
   - Restrict to specific branches (main)

### 4. Service Principal Setup
Your Service Principal needs permissions on all environments:
- System Administrator role (or appropriate security role)
- API permissions in Azure AD

## Version Management Examples

### Using Release Tags:
1. Create release with tag `v1.2.3`
2. Solution version becomes `1.2.3.0`
3. Artifacts: `managedSolutions-v1.2.3.0`
4. Files: `travelsolution_v1.2.3.0_managed.zip`

### Manual Versioning:
1. Run workflow manually
2. Provide `solution_version: "2.1.0.5"`
3. Solution version becomes `2.1.0.5`
4. Artifacts: `managedSolutions-v2.1.0.5`

### Auto-increment:
1. No release tag or manual version
2. Solution version becomes `1.0.0.{run_number}`
3. E.g., `1.0.0.42` for run #42

## Solution Versioning Benefits

### ✅ **Proper Version Control**:
- Each deployment has unique version
- No more "same version" overwrites
- Clear version history in environments

### ✅ **Rollback Capability**:
- Versioned artifacts for easy rollback
- Clear identification of deployed versions
- Audit trail for compliance

### ✅ **Release Management**:
- Semantic versioning support
- Integration with GitHub releases
- Automated version bumping

### ✅ **Power Platform Best Practices**:
- Uses official Microsoft actions
- Follows ALM guidance
- Reliable version handling

## Security Best Practices Implemented

✅ **Repository Variables**: Environment URLs and IDs stored as variables (not hardcoded)  
✅ **Service Principal Authentication**: More secure than username/password  
✅ **Environment Protection**: Approval gates for production deployments  
✅ **Versioned Artifacts**: Proper handling of solution artifacts with versions  
✅ **Input Validation**: Validates required inputs before processing  
✅ **Timeout Settings**: Prevents workflows from running indefinitely  
✅ **Minimal Permissions**: Workflows only request needed permissions  

## Workflow Execution Flow

### Development Flow:
1. Developer makes changes in DEV environment
2. Run `export-power-platform-solution.yml` to export and create PR
3. CI validation runs automatically on PR
4. Review and merge PR

### Release Flow:
1. Create GitHub release with semantic version tag (e.g., `v1.2.3`)
2. `release-action-call.yml` triggers automatically
3. **Solution version automatically set to `1.2.3.0`**
4. Solution files updated with new version
5. Convert to managed in BUILD environment  
6. Deploy to TEST environment (with approval)
7. Deploy to PRODUCTION environment (with approval)
8. **Versioned artifacts available for audit and rollback**

## Troubleshooting

### Common Issues:
1. **Variable not found errors**: Ensure all repository variables are set
2. **Authentication failures**: Check Service Principal permissions
3. **Environment not found**: Verify environment URLs are correct
4. **Solution import failures**: Check solution dependencies
5. **Version format errors**: Ensure semantic versioning format (X.Y.Z)

### Debug Mode:
All workflows have `RUNNER_DEBUG: 1` enabled for detailed logging.

## Next Steps

1. Set up repository variables and secrets
2. Configure environment protection rules  
3. Test the export workflow manually
4. **Create a test release with semantic version tag** (e.g., `v1.0.1`)
5. Validate that solution versioning works correctly
6. Review deployed solution versions in your environments
7. Adjust protection rules based on your organization's needs

## Solution Versioning in Action

When you create a release tagged `v1.2.3`, you'll see:
- ✅ Solution.xml updated to version `1.2.3.0`
- ✅ Artifact named `managedSolutions-v1.2.3.0`
- ✅ Solution file named `travelsolution_v1.2.3.0_managed.zip`
- ✅ Version summary in workflow output
- ✅ Unique version deployed to each environment

This solves the "same solution version" problem and provides proper version control for your Power Platform solutions!
