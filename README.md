# Power Platform ALM with GitHub Actions

Complete automated Application Lifecycle Management (ALM) for Power Platform solutions using GitHub Actions with quality gates, environment approvals, and solution validation.

## 🎯 What This Repository Does

✅ **Export Solutions**: Automated export from DEV environment with custom branch naming  
✅ **Quality Gates**: Solution checker validation at every deployment stage  
✅ **Deployment Pipeline**: Automated TEST → PRODUCTION deployment with approval gates  
✅ **PR Validation**: Automatic solution validation on pull requests  
✅ **Version Management**: Semantic versioning with release tag support  
✅ **Artifact Management**: Solution artifacts with 30-day retention

## 🚀 Quick Start

### 1. Repository Setup
```bash
# Clone this repository
git clone https://github.com/mziaulhaqz89/solutions.git
cd solutions

# Repository is ready to use - all workflows are pre-configured!
```

### 2. Configure Secrets & Variables

**Required Repository Secrets** (Settings → Secrets and variables → Actions):
```
PowerPlatformSPN = your-service-principal-secret
```

**Environment URLs** (Currently hardcoded in workflow files):
```
DEV: https://mzhdev.crm4.dynamics.com
BUILD: https://mzhbuild.crm4.dynamics.com  
TEST: https://mzhtest.crm4.dynamics.com
PRODUCTION: https://mzhprod.crm11.dynamics.com
CLIENT_ID: c07145b8-e4f8-48ad-8a7c-9fe5d3827e52
TENANT_ID: d7d483b3-60d3-4211-a15e-9c2a090d2136
```

### 3. Current Setup Status

**✅ Currently Working:**
- Export workflows with solution checker validation
- Automatic deployment on PR merge to main
- Quality gates during deployment stages
- Solution artifacts with retention

**⚠️ Optional Enhancements Available:**
- GitHub environments with approval gates
- Branch protection with required status checks  
- PR validation workflows
- Repository variables instead of hardcoded values

### 4. Start Using

**Export Solutions:**
1. Actions → "Export Power Platform Solution" → Run workflow
2. Choose solution name, custom branch name (optional)
3. Creates PR with solution changes

**Deploy Solutions:**
1. Merge PR to `main` branch
2. **Automatic deployment**: Triggered immediately when PR merges
3. Quality gates validate at each stage (no approval gates currently configured)

## 📋 Available Workflows

### 1. 🔄 Export Power Platform Solution
**File**: `01-export-solutions.yml`  
**Purpose**: Export solutions from DEV and create PR

**Features**:
- Multi-solution export (comma-separated)
- Custom branch naming or auto-generated timestamps
- Solution checker validation
- Automatic PR creation

**Usage**:
```yaml
Solution names: travelsolution,coffeeshop
Custom branch name: feature/my-updates  # Optional
Target branch: main
Include managed: false
```

### 2. 🚢 Deploy Travel Solution  
**File**: `02-deploy-travel-solution.yml`  
**Purpose**: Deploy travel solution through all environments

**Triggers**:
- **Push to `main`** when `solutions/travelsolution/**` changes (automatic)
- Manual workflow dispatch
- Release creation

### 3. ☕ Deploy Coffee Shop Solution
**File**: `03-deploy-coffeeshop-solution.yml`  
**Purpose**: Deploy coffee shop solution through all environments  

**Triggers**:
- **Push to `main`** when `solutions/coffeeshop/**` changes (automatic)
- Manual workflow dispatch

### 4. 🏗️ Shared Deployment Pipeline
**File**: `shared-deployment-pipeline.yml`  
**Purpose**: Reusable deployment workflow with quality gates

**Stages**:
1. **Convert-to-Managed**: Package + validate solution
2. **Deploy-to-Test**: Deploy to TEST + validate
3. **Release-to-Production**: Deploy to PROD + validate

## 🔍 Quality Gates System

### Three Validation Checkpoints:

#### 1. Convert-to-Managed Stage
- **When**: During solution packaging
- **Purpose**: Validate solution structure and components
- **Action**: Creates managed solution with validation

#### 2. Deploy-to-Test Stage  
- **When**: Before TEST environment deployment
- **Purpose**: Ensure solution quality before TEST
- **Action**: Final check before TEST deployment

#### 3. Release-to-Production Stage
- **When**: Before PRODUCTION deployment  
- **Purpose**: Final validation before production release
- **Action**: Last quality gate before PROD

### Quality Gate Benefits:
✅ **Early Detection**: Issues caught before reaching environments  
✅ **Continuous Validation**: Solutions checked at every stage  
✅ **Artifact Storage**: Validation results saved (30-day retention)  
✅ **Automated Process**: No manual steps required

## 🎛️ Optional Enhancements

The following features can be enabled for additional control:

### 🛡️ PR Validation System
**Setup**: Create `pr-validator.yml` workflow

**What It Would Do:**
- Auto-detects changed solutions by analyzing git diff
- Validates solution folder structure and required files
- Packages solutions to ensure they can be built
- Runs solution checker on each changed solution
- Reports validation results as PR status check
- Blocks merge if critical/high severity issues found

**Setup Steps:**
1. Create `.github/workflows/pr-validator.yml` workflow file
2. Configure to trigger on pull requests affecting `solutions/**`
3. Add solution structure validation logic
4. Integrate with solution checker for quality analysis
5. Set up as required status check in branch protection

**Branch Protection Integration:**
- Repository Settings → Branches → Add rule for `main`
- Check "Require status checks to pass before merging"  
- Search and select the PR validator check
- Result: PRs cannot be merged until validation passes

### 🔒 Environment Approval Gates
**Setup**: Create GitHub Environments (Settings → Environments)

**Step-by-Step Setup:**

1. **Navigate to Repository Settings**
   - Go to your repository on GitHub → Settings tab
   - In left sidebar, click "Environments"

2. **Create TEST Environment**
   - Click "New environment" → Name: `TEST`
   - **Protection Rules**:
     - ✅ Required reviewers: Add team members for TEST approvals
     - ✅ Wait timer: 0 minutes (immediate after approval)
     - ✅ Deployment branches: Restrict to `main` branch only

3. **Create PRODUCTION Environment**  
   - Click "New environment" → Name: `PRODUCTION`
   - **Protection Rules**:
     - ✅ Required reviewers: Add senior team members/release managers
     - ✅ Wait timer: 5-10 minutes (optional safety buffer)
     - ✅ Deployment branches: Restrict to `main` branch only

**How Approval Gates Work:**
- **Convert-to-managed**: Runs automatically (no approval needed)
- **Deploy-to-test**: Waits for TEST environment reviewers to approve
- **Release-to-production**: Waits for PRODUCTION environment reviewers to approve
- Reviewers get notifications and can approve/reject with comments

**Benefits**:
- Manual approval required before TEST deployment
- Manual approval required before PRODUCTION deployment
- Designated reviewers for each environment
- Complete audit trail of all approvals
- Email notifications to reviewers
- Deployment history tracking

### 🛡️ Branch Protection
**Setup**: Repository Settings → Branches → Add rule for `main`

**Recommended Protection Rules:**
- ✅ **Require pull request reviews**: Prevent direct pushes to main
- ✅ **Require status checks**: Ensure PR validation passes (if implemented)  
- ✅ **Require branches to be up to date**: Force rebase before merge
- ✅ **Include administrators**: Apply rules to all users
- ✅ **Restrict pushes**: Only allow pushes through pull requests

**Best Practices:**
- **Reviewer Assignment**: Require at least 1-2 reviewers for PRs
- **Code Owners**: Use CODEOWNERS file for automatic reviewer assignment
- **Required Status Checks**: Add PR validator when implemented
- **Linear History**: Enforce clean git history

**Benefits**:
- Prevent accidental direct pushes to main branch
- Ensure all changes go through code review process  
- Maintain clean git history and audit trail
- Integrate with quality gates and validation systems

## 🏗️ Current Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   DEV           │    │   BUILD          │    │   TEST          │
│   Environment   │───▶│   Environment    │───▶│   Environment   │
│                 │    │   (Managed)      │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
                                               ┌─────────────────┐
                                               │   PRODUCTION    │
                                               │   Environment   │
                                               │                 │
                                               └─────────────────┘

Quality Gates:    🔍────────────🔍────────────🔍────────────🔍
                Export     Convert      Deploy      Release

Automatic Trigger: PR Merge → Main → Auto Deploy to All Environments
```

## 📁 Detailed Workflow Reference

### 🔄 Complete Development Process

```
1. Developer makes changes in Power Platform DEV environment
   ↓
2. Run "01-export-solutions.yml" → Select solution → Export + Validate
   ↓  
3. Review validation results and merge PR
   ↓
4. Auto-trigger "02-deploy-travel-solution.yml" OR "03-deploy-coffeeshop-solution.yml"
   ↓
5. Solution deploys through BUILD → TEST → PRODUCTION with quality gates
```

### 📋 Workflow File Details

| Workflow | Purpose | Trigger | Features |
|----------|---------|---------|----------|
| `01-export-solutions.yml` | Export from DEV + Solution Checker | Manual (dropdown) | Multi-solution export, custom branch naming, quality gates |
| `02-deploy-travel-solution.yml` | Deploy travel solution | Auto on `solutions/travelsolution/**` changes + Manual | Quality gates, automatic deployment |
| `03-deploy-coffeeshop-solution.yml` | Deploy coffee shop solution | Auto on `solutions/coffeeshop/**` changes + Manual | Quality gates, automatic deployment |
| `shared-deployment-pipeline.yml` | Reusable deployment logic | Called by other workflows | 3 quality gates, environment deployment |

### 🎯 File Naming Convention

- **`01-`** prefix: Export/source workflows
- **`02-`**, **`03-`** prefix: Solution-specific deployment workflows  
- **`shared-`** prefix: Reusable workflows
- Descriptive names that clearly indicate purpose

## 📁 Repository Structure

```
📦 solutions/
├── 📂 .github/workflows/          # All GitHub Actions workflows
│   ├── 01-export-solutions.yml    # Export with quality gates
│   ├── 02-deploy-travel-solution.yml # Travel solution deployment
│   ├── 03-deploy-coffeeshop-solution.yml # Coffee shop deployment  
│   ├── shared-deployment-pipeline.yml # Reusable pipeline with quality gates
│   └── README.md                   # Technical implementation details
├── 📂 solutions/                  # Solution source code
│   ├── 📂 travelsolution/         # Travel solution components
│   └── 📂 coffeeshop/            # Coffee shop solution components
├── 📄 README.md                  # This comprehensive guide
└── 📄 .gitignore                # Git ignore rules
```

## 🎛️ Advanced Configuration

### Custom Branch Naming
```yaml
# Auto-generated (default):
Custom branch name: (empty)
# Result: "solution-export-20250902-143052"

# Custom naming:
Custom branch name: "feature/travel-updates"  
# Result: "feature/travel-updates"
```

### Solution Selection
```yaml
# Single solution:
Solution names: travelsolution

# Multiple solutions:
Solution names: travelsolution,coffeeshopsolution
```

### Version Management
```yaml
# Release tag approach:
Create release with tag: v1.2.3
# Result: Solution version 1.2.3.0

# Auto-increment:
No release tag
# Result: Solution version 1.0.0.{run_number}
```

## 🚨 Troubleshooting Guide

### Common Issues & Solutions:

#### 🔐 Authentication Failed
```bash
# Check:
- PowerPlatformSPN secret configured correctly
- Service principal has Power Platform access  
- Environment URLs are correct format
```

#### 🏗️ Solution Export Failed
```bash
# Check:
- Solution exists in DEV environment
- Solution name spelling is exact (case-sensitive)
- No concurrent edits in Power Platform
```

#### ⏸️ Approval Gate Stuck
```bash
# Check:
- TEST/PRODUCTION environments created in GitHub
- Required reviewers assigned to environments
- Reviewers have repository access
```

#### ❌ Quality Gate Failed
```bash
# Check:
- Solution Checker artifacts for detailed error report
- Download validation results from workflow artifacts
- Fix critical/high severity issues before retry
```

#### 🔄 PR Validation Failed
```bash
# Check:
- Solution folder structure is correct
- Solution.xml file exists
- No critical/high issues in solution checker report
```

### Additional Troubleshooting

#### 🔍 Environment Issues
**Environment not found:**
- Ensure environment names match exactly (case-sensitive: `TEST`, `PRODUCTION`)
- Check that environments are created in repository settings

**No reviewers assigned:**
- At least one reviewer must be assigned to each environment
- Reviewers must have repository access permissions

**Branch restrictions:**
- Ensure deployment branch (`main`) is allowed in environment settings
- Check that branch protection rules don't conflict

#### 📊 Viewing Deployment History
- Go to **Actions** tab in your repository
- Click on any workflow run to see execution details
- Check approval history and reviewer comments
- Download artifacts for detailed logs and reports

#### ⚡ Performance Issues
**Workflow runs slowly:**
- Check Power Platform environment performance
- Verify network connectivity between GitHub and Power Platform
- Review solution size and complexity

**Solution checker takes long time:**
- Large solutions require more validation time
- Complex customizations increase analysis duration
- Consider breaking large solutions into smaller components

## 🎯 Best Practices

### 📋 Development Workflow Best Practices

**Reviewer Assignment:**
- **For Basic PRs**: Assign developers and QA team members
- **For Production Releases**: Assign senior developers, DevOps engineers, or release managers
- **Code Owners**: Use CODEOWNERS file for automatic reviewer assignment

**Documentation Standards:**
- Require clear commit messages explaining changes
- Document deployment notes in PR descriptions
- Maintain a deployment log/changelog for major releases
- Include solution checker results review in PR process

**Quality Management:**
- Review solution checker artifacts before merging PRs
- Fix critical and high severity issues before deployment
- Test solutions in DEV environment before export
- Validate customizations don't break existing functionality

### 🔒 Security Best Practices

**Environment Security:**
- Use least privilege principle for service principal roles
- Regularly rotate client secrets (recommended: every 6 months)
- Monitor workflow runs for suspicious activity
- Use environment-specific secrets for different Power Platform environments

**Access Control:**
- Restrict repository access to authorized team members
- Use branch protection to prevent unauthorized changes
- Implement approval gates for production deployments
- Regular access review and cleanup of inactive users

**Monitoring and Alerts:**
- Set up monitoring for both TEST and PRODUCTION environments
- Configure alerts for deployment failures
- Monitor solution checker results for quality trends
- Track deployment frequency and success rates

### ⏰ Operational Best Practices

**Deployment Timing:**
- Schedule PRODUCTION deployments during low-usage periods
- Avoid deployments during business-critical periods
- Consider time zones for global teams
- Plan rollback procedures before major deployments

**Environment Management:**
- Keep DEV, TEST, and PRODUCTION environments in sync for metadata
- Regularly backup production data before deployments
- Test rollback procedures in non-production environments
- Document environment-specific configurations

## 🔧 Service Principal Setup

### 1. Azure AD App Registration:
```bash
1. Azure Portal → Azure AD → App registrations → New registration
2. Name: "GitHub Actions Power Platform"
3. Account types: "Single tenant"
4. Redirect URI: (leave blank)
5. Register
```

### 2. Configure Permissions:
```bash
1. API permissions → Add permission → Dynamics CRM
2. Delegated permissions → user_impersonation
3. Grant admin consent
```

### 3. Create Secret:
```bash
1. Certificates & secrets → New client secret
2. Copy secret value → Add to GitHub repository secrets as PowerPlatformSPN
```

**Note**: CLIENT_ID and TENANT_ID are currently hardcoded in workflow files.

### 4. Power Platform Access:
```bash
1. Power Platform Admin Center → Environment → Settings
2. Users + permissions → Application users → New app user
3. Select app registration → Assign System Administrator role
```

## 📊 Current vs Manual Process

| Feature | Manual Process | This Repository |
|---------|---------------|-----------------|
| **Export** | Manual download | ✅ Automated with PR creation |
| **Validation** | Manual testing | ✅ Automated solution checker |
| **Deployment** | Manual steps | ✅ Automatic on PR merge |
| **Quality Gates** | Manual review | ✅ Automated at every stage |
| **Audit Trail** | Limited | ✅ Complete GitHub history |
| **Rollback** | Complex manual process | ✅ Git-based rollback |

## 🎯 Current Workflow

### Development Process:
1. **Export** solutions using GitHub Actions (creates PR automatically)
2. **Review** PR changes and solution checker results
3. **Merge** PR to `main` branch
4. **Automatic deployment** triggers immediately through all environments
5. **Monitor** deployment progress in GitHub Actions

### Quality Management:
- ✅ Solution checker validates at export and deployment stages
- ✅ All validation results stored as artifacts
- ✅ Review solution checker artifacts
- ✅ Use meaningful commit messages

### Release Management:
- ✅ Create releases for major deployments
- ✅ Use semantic versioning (v1.2.3)
- ✅ Document release notes
- ✅ Coordinate approvals with stakeholders

## 🆘 Support & Documentation

### Getting Help:
1. **Check workflow logs** in GitHub Actions for detailed error messages
2. **Download artifacts** from failed runs for solution checker reports
3. **Review this README** for configuration guidance
4. **Check environment setup** if approval gates aren't working

### Additional Resources:
- Microsoft Power Platform CLI documentation
- GitHub Actions documentation  
- Power Platform ALM best practices
- Azure AD app registration guide

---

🎉 **You're all set!** This repository provides enterprise-grade ALM for Power Platform with automated quality gates, deployment pipelines, and approval workflows.
