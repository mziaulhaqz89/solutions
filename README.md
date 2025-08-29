# Power Platform Solution Management

This repository contains GitHub Actions workflows for comprehensive Power Platform solution management, including export, deployment, and release management with environment-based approval gates.

## Setup

### 1. Required Secrets

You need to configure the following secrets in your GitHub repository:

1. Go to your repository settings
2. Navigate to "Secrets and variables" > "Actions"
3. Add the following repository secrets:

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `PowerPlatformSPN` | Azure AD App Registration Client Secret | Generate a client secret in your App Registration |

**Note**: The workflows use predefined environment URLs and client configurations. Update the workflow files with your specific environment URLs and client IDs.

### 2. Azure AD App Registration Setup

1. **Create App Registration:**
   - Go to Azure Portal > Azure Active Directory > App registrations
   - Click "New registration"
   - Name: "GitHub Actions Power Platform"
   - Supported account types: "Accounts in this organizational directory only"
   - Redirect URI: Leave blank
   - Click "Register"

2. **Configure API Permissions:**
   - In your app registration, go to "API permissions"
   - Click "Add a permission"
   - Select "Dynamics CRM"
   - Select "Delegated permissions"
   - Check "user_impersonation"
   - Click "Add permissions"
   - Click "Grant admin consent"

3. **Create Client Secret:**
   - Go to "Certificates & secrets"
   - Click "New client secret"
   - Add description and set expiration
   - Copy the secret value (this is your `POWER_PLATFORM_CLIENT_SECRET`)

4. **Get Application ID:**
   - Go to "Overview"
   - Copy the "Application (client) ID" (this is your `POWER_PLATFORM_APP_ID`)

5. **Get Tenant ID:**
   - In Azure AD overview, copy the "Tenant ID" (this is your `POWER_PLATFORM_TENANT_ID`)

### 3. Power Platform User Setup

The service principal needs to be added as a user in your Power Platform environment:

1. Go to Power Platform Admin Center
2. Select your environment
3. Go to "Settings" > "Users + permissions" > "Application users"
4. Click "New app user"
5. Select your app registration
6. Assign appropriate security roles (System Administrator for full access)

## Workflows

This repository contains several GitHub Actions workflows:

### 1. Export Power Platform Solution (`export-power-platform-solution.yml`)
- **Purpose**: Export and unpack solutions from DEV environment
- **Trigger**: Manual workflow dispatch
- **Features**:
  - Exports solution from DEV environment
  - Unpacks solution for source control
  - Creates feature branch with changes
  - Automatically commits solution files

### 2. Release Solution to Production (`release-solution-to-prod-with-inputs.yml`)
- **Purpose**: Deploy solutions through TEST and PRODUCTION environments with approval gates
- **Trigger**: Called by release-action-call.yml
- **Features**:
  - Converts unmanaged solution to managed
  - **Environment-based approval gates**
  - Deploys to TEST environment (requires approval)
  - Deploys to PRODUCTION environment (requires approval)
  - Artifact management between stages

### 3. Release Action Call (`release-action-call.yml`)
- **Purpose**: Triggers the release workflow
- **Trigger**: Manual workflow dispatch or GitHub release creation
- **Features**:
  - Calls the reusable release workflow
  - Configured with specific environment URLs

### 4. Test Action (`test.yml`)
- **Purpose**: Basic testing workflow
- **Trigger**: Manual workflow dispatch

## Environment-Based Deployment

### 🔒 Approval Gates

The release workflow now includes approval gates for controlled deployments:

1. **Build Phase**: Convert solution to managed (automatic)
2. **⏸️ TEST Approval Gate**: Requires manual approval before TEST deployment
3. **TEST Deployment**: Deploys to TEST environment after approval
4. **⏸️ PRODUCTION Approval Gate**: Requires manual approval before PRODUCTION deployment  
5. **PRODUCTION Deployment**: Final deployment after approval

### Environment Configuration

To set up approval gates, you need to configure GitHub environments:

1. Go to Repository → Settings → Environments
2. Create environments: `TEST` and `PRODUCTION`
3. Configure protection rules and required reviewers
4. See `.github/ENVIRONMENT_SETUP.md` for detailed setup instructions

### Current Environment URLs
- **DEV**: `https://mzhdev.crm4.dynamics.com`
- **BUILD**: `https://mzhbuild.crm4.dynamics.com`
- **TEST**: `https://mzhtest.crm4.dynamics.com`
- **PRODUCTION**: `https://mzhprod.crm11.dynamics.com`

## Usage

### 1. Export Solution from DEV
1. Go to your repository on GitHub
2. Click "Actions" tab
3. Select "export-and-branch-solution" workflow
4. Click "Run workflow"
5. Enter the solution name (default: `travelsolution`)
6. The workflow will:
   - Export solution from DEV environment
   - Unpack the solution
   - Create a feature branch with changes
   - Commit the unpacked solution files

### 2. Release to TEST and PRODUCTION
1. Create a GitHub release, or
2. Manually trigger "Release action" workflow
3. The workflow will:
   - Convert solution to managed
   - **Wait for TEST approval** ⏸️
   - Deploy to TEST environment after approval ✅
   - **Wait for PRODUCTION approval** ⏸️  
   - Deploy to PRODUCTION environment after approval ✅

### 3. Approval Process
When the workflow reaches an approval gate:
1. Designated reviewers receive notifications
2. Reviewers can view the deployment details
3. Reviewers approve or reject the deployment
4. Workflow continues only after approval

## Workflow Features

- **Export Solutions**: Downloads solutions from Power Platform DEV environment
- **Unpack Solutions**: Extracts solution components for source control
- **Source Control**: Commits unpacked solution files to the repository with automatic branching
- **Managed Solution Conversion**: Converts unmanaged solutions to managed for deployment
- **Environment-Based Deployment**: Supports DEV → TEST → PRODUCTION promotion
- **Approval Gates**: Manual approval required before TEST and PRODUCTION deployments
- **Artifact Management**: Uploads solution ZIP files as GitHub artifacts between stages
- **Release Management**: Integration with GitHub releases for deployment triggers
- **Multi-Environment Support**: Separate environments for development, testing, and production

## Directory Structure

After running the workflows, your repository will have:

```
.github/
├── workflows/           # GitHub Actions workflow files
│   ├── export-power-platform-solution.yml
│   ├── release-solution-to-prod-with-inputs.yml
│   ├── release-action-call.yml
│   └── test.yml
└── ENVIRONMENT_SETUP.md # Environment configuration guide

solutions/
└── travelsolution/      # Unpacked solution source files
    ├── Entities/
    │   ├── mzh_destination/
    │   └── mzh_travel/
    └── Other/
        ├── Customizations.xml
        ├── Relationships.xml
        └── Solution.xml

out/                     # Temporary build artifacts (not committed)
├── exported/           # Exported solution ZIP files
├── solutions/          # Staged unpacked solutions
├── ship/              # Managed solution artifacts
└── release/           # Final release artifacts
```

## Troubleshooting

### Common Issues

1. **Authentication Failed**
   - Verify `PowerPlatformSPN` secret is correctly configured
   - Ensure the app registration has proper permissions
   - Check that the service principal is added to Power Platform

2. **Solution Not Found**
   - Verify the solution name is correct (case-sensitive)
   - Ensure the solution exists in the specified environment
   - Check solution is in the DEV environment for exports

3. **Permission Denied**
   - Ensure the service principal has appropriate security roles
   - Check that API permissions are granted in Azure AD

4. **Approval Gate Issues**
   - Verify GitHub environments (`TEST`, `PRODUCTION`) are configured
   - Ensure required reviewers are assigned to environments
   - Check that reviewers have proper repository permissions

5. **Deployment Stuck on Approval**
   - Check if approval notifications were sent to reviewers
   - Verify reviewers are available and aware of pending approvals
   - Review environment protection rules configuration

### Debug Steps

1. Check the workflow run logs in GitHub Actions
2. Verify environment URL format (should include protocol and trailing slash)
3. Test authentication using Power Platform CLI locally
4. Ensure solution is not currently being edited by someone else
5. For approval issues, check repository Settings → Environments
6. Review approval history in workflow run details

## Configuration

### Environment URLs
Update the following URLs in your workflow files to match your Power Platform environments:

**In `export-power-platform-solution.yml`:**
- `ENVIRONMENT_URL`: Your DEV environment URL
- `CLIENT_ID`: Your Azure AD app registration client ID  
- `TENANT_ID`: Your Azure AD tenant ID

**In `release-action-call.yml`:**
- `BUILD_ENVIRONMENT_URL`: Environment used for solution conversion
- `TEST_ENVIRONMENT_URL`: TEST environment URL
- `PRODUCTION_ENVIRONMENT_URL`: PRODUCTION environment URL
- `CLIENT_ID` and `TENANT_ID`: Same as above

### Solution Configuration
- Default solution name: `travelsolution`
- Update `solution_name` parameter in workflows if using a different solution

## Security Best Practices

- Use least privilege principle for service principal roles
- Regularly rotate client secrets
- Monitor workflow runs for suspicious activity
- Use environment-specific secrets for different Power Platform environments
