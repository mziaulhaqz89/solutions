# GitHub Environment Setup Guide

This guide will help you set up GitHub environments with approval gates for your Power Platform solution deployments.

## Overview

Your workflows now include environment-based deployments with approval gates:
- **TEST Environment**: Requires approval before deploying to test
- **PRODUCTION Environment**: Requires approval before deploying to production

## Setting Up GitHub Environments

### 1. Navigate to Repository Settings
1. Go to your repository on GitHub
2. Click on **Settings** tab
3. In the left sidebar, click on **Environments**

### 2. Create TEST Environment
1. Click **New environment**
2. Name: `TEST`
3. Configure the following settings:

#### Protection Rules for TEST:
- ✅ **Required reviewers**: Add yourself or team members who should approve TEST deployments
- ✅ **Wait timer**: Optional - set to 0 minutes for immediate deployment after approval
- ✅ **Deployment branches**: Restrict to `main` branch only

#### Environment Variables for TEST (Optional):
- You can add environment-specific variables if needed

### 3. Create PRODUCTION Environment
1. Click **New environment**
2. Name: `PRODUCTION`
3. Configure the following settings:

#### Protection Rules for PRODUCTION:
- ✅ **Required reviewers**: Add senior team members or release managers
- ✅ **Wait timer**: Optional - consider 5-10 minutes to allow for last-minute checks
- ✅ **Deployment branches**: Restrict to `main` branch only
- ✅ **Required status checks**: Optional - can require specific checks to pass first

#### Environment Variables for PRODUCTION (Optional):
- You can add environment-specific variables if needed

## Environment Secrets

If you need environment-specific secrets:

### For TEST Environment:
1. In the TEST environment settings
2. Go to **Environment secrets**
3. Add any TEST-specific secrets (e.g., different service principal for TEST)

### For PRODUCTION Environment:
1. In the PRODUCTION environment settings
2. Go to **Environment secrets**
3. Add any PRODUCTION-specific secrets

## How Approval Gates Work

### Workflow Execution Flow:
1. **Convert-to-managed job**: Runs automatically (no approval needed)
2. **Deploy-to-test job**: 
   - Waits for approval from TEST environment reviewers
   - Reviewers get notification to approve/reject
   - Deployment proceeds only after approval
3. **Release-to-production job**:
   - Waits for TEST deployment to complete successfully
   - Then waits for approval from PRODUCTION environment reviewers
   - Deployment proceeds only after approval

### Approval Process:
1. When a workflow reaches an environment gate, it pauses
2. Designated reviewers receive notifications
3. Reviewers can:
   - **Approve**: Deployment continues
   - **Reject**: Deployment stops
   - **Add comments**: Provide feedback on the deployment

### Notifications:
- Email notifications are sent to reviewers
- GitHub UI shows pending approvals
- Mobile app notifications (if configured)

## Best Practices

### Reviewer Assignment:
- **TEST**: Assign developers and QA team members
- **PRODUCTION**: Assign senior developers, DevOps engineers, or release managers

### Branch Protection:
- Only allow deployments from protected branches (main/master)
- Require pull request reviews before merging to main

### Documentation:
- Require deployment comments explaining what's being deployed
- Maintain a deployment log/changelog

### Monitoring:
- Set up monitoring for both TEST and PRODUCTION environments
- Configure alerts for deployment failures

## Example Approval Workflow

1. Developer creates a release
2. Workflow starts automatically
3. Solution is converted to managed
4. **PAUSE**: Waiting for TEST approval
5. QA lead approves TEST deployment
6. Solution deploys to TEST environment
7. **PAUSE**: Waiting for PRODUCTION approval
8. Release manager approves PRODUCTION deployment
9. Solution deploys to PRODUCTION environment
10. Workflow completes

## Troubleshooting

### Common Issues:
- **Environment not found**: Make sure environment names match exactly (case-sensitive)
- **No reviewers assigned**: At least one reviewer must be assigned to each environment
- **Branch restrictions**: Ensure your deployment branch is allowed in environment settings

### Viewing Deployment History:
- Go to **Actions** tab in your repository
- Click on any workflow run
- You'll see the approval history and who approved each stage

## Additional Security (Optional)

Consider adding these additional security measures:

### Required Status Checks:
- Require unit tests to pass
- Require security scans to pass
- Require solution checker to pass (when implemented)

### Time-based Restrictions:
- Only allow PRODUCTION deployments during business hours
- Block deployments during maintenance windows

### Audit Trail:
- All approvals are logged and tracked
- Deployment history is maintained
- Can integrate with external audit systems if needed
