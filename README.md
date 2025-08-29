# Power Platform Solution Export

This repository contains a GitHub Actions workflow to automatically export Power Platform solutions.

## Setup

### 1. Required Secrets

You need to configure the following secrets in your GitHub repository:

1. Go to your repository settings
2. Navigate to "Secrets and variables" > "Actions"
3. Add the following repository secrets:

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `POWER_PLATFORM_APP_ID` | Azure AD App Registration Application ID | Create an App Registration in Azure AD |
| `POWER_PLATFORM_CLIENT_SECRET` | Azure AD App Registration Client Secret | Generate a client secret in your App Registration |
| `POWER_PLATFORM_TENANT_ID` | Azure AD Tenant ID | Found in Azure AD properties |
| `POWER_PLATFORM_ENV_URL` | Default Power Platform Environment URL | Example: `https://yourorg.crm.dynamics.com/` |

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

## Usage

### Manual Trigger (Workflow Dispatch)

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Select "Export Power Platform Solution" workflow
4. Click "Run workflow"
5. Fill in the required parameters:
   - **Solution Name**: The unique name of your Power Platform solution
   - **Environment URL**: Your Power Platform environment URL (optional if using default)
   - **Export Type**: Choose between "managed" or "unmanaged"

### Automatic Triggers

The workflow also runs automatically:
- On push to `main` or `dev` branches
- On pull requests to `main` branch

## Workflow Features

- **Export Solutions**: Downloads solutions from Power Platform
- **Unpack Solutions**: Extracts solution components for source control
- **Source Control**: Commits unpacked solution files to the repository
- **Artifacts**: Uploads solution ZIP files as GitHub artifacts
- **Releases**: Creates GitHub releases for main branch exports
- **Flexible**: Supports both managed and unmanaged solution exports

## Directory Structure

After running the workflow, your repository will have:

```
solutions/
├── exports/          # ZIP files of exported solutions
└── src/             # Unpacked solution source files
    └── [SolutionName]/
        ├── Entities/
        ├── OptionSets/
        ├── Workflows/
        └── ...
```

## Troubleshooting

### Common Issues

1. **Authentication Failed**
   - Verify all secrets are correctly configured
   - Ensure the app registration has proper permissions
   - Check that the service principal is added to Power Platform

2. **Solution Not Found**
   - Verify the solution name is correct (case-sensitive)
   - Ensure the solution exists in the specified environment

3. **Permission Denied**
   - Ensure the service principal has appropriate security roles
   - Check that API permissions are granted in Azure AD

### Debug Steps

1. Check the workflow run logs in GitHub Actions
2. Verify environment URL format (should include protocol and trailing slash)
3. Test authentication using Power Platform CLI locally
4. Ensure solution is not currently being edited by someone else

## Environment Variables

You can customize the workflow by modifying these environment variables in the workflow file:

- `SOLUTION_NAME`: Default solution name
- `ENVIRONMENT_URL`: Default environment URL
- `EXPORT_TYPE`: Default export type (managed/unmanaged)

## Security Best Practices

- Use least privilege principle for service principal roles
- Regularly rotate client secrets
- Monitor workflow runs for suspicious activity
- Use environment-specific secrets for different Power Platform environments
