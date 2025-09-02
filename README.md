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

**Required Repository Variables** (Settings → Secrets and variables → Actions → Variables):
```
DEV_ENVIRONMENT_URL = https://mzhdev.crm4.dynamics.com
BUILD_ENVIRONMENT_URL = https://mzhbuild.crm4.dynamics.com  
TEST_ENVIRONMENT_URL = https://mzhtest.crm4.dynamics.com
PRODUCTION_ENVIRONMENT_URL = https://mzhprod.crm11.dynamics.com
CLIENT_ID = your-service-principal-client-id
TENANT_ID = your-azure-tenant-id
```

### 3. Set Up Approval Gates

**Create GitHub Environments** (Settings → Environments):
1. Create `TEST` environment → Add required reviewers
2. Create `PRODUCTION` environment → Add required reviewers  
3. Restrict to `main` branch only

### 4. Start Using

**Export Solutions:**
1. Actions → "Export Power Platform Solution" → Run workflow
2. Choose solution name, custom branch name (optional)
3. Creates PR with solution changes

**Deploy Solutions:**
1. Merge PR to `main` branch
2. Automatic deployment: BUILD → TEST (approval) → PROD (approval)
3. Quality gates validate at each stage

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
- Push to `main` when `solutions/travelsolution/**` changes
- Manual workflow dispatch
- Release creation

### 3. ☕ Deploy Coffee Shop Solution
**File**: `03-deploy-coffeeshop-solution.yml`  
**Purpose**: Deploy coffee shop solution through all environments  

**Triggers**:
- Push to `main` when `solutions/coffeeshop/**` changes
- Manual workflow dispatch

### 4. 🔍 PR Validator
**File**: `pr-validator.yml`  
**Purpose**: Validate solutions on pull requests

**Features**:
- Auto-detects changed solutions
- Validates solution structure
- Runs solution checker
- Blocks merge if critical/high issues found

### 5. 🏗️ Shared Deployment Pipeline
**File**: `shared-deployment-pipeline.yml`  
**Purpose**: Reusable deployment workflow with quality gates

**Stages**:
1. **Convert-to-Managed**: Package + validate solution
2. **Deploy-to-Test**: Deploy to TEST + validate (requires approval)  
3. **Release-to-Production**: Deploy to PROD + validate (requires approval)

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

## 🛡️ PR Validation System

### Automatic PR Checks:
1. **Structure Validation**: Verifies solution folder structure
2. **Packaging Test**: Ensures solution can be packaged
3. **Solution Checker**: Runs comprehensive quality analysis
4. **Merge Protection**: Blocks merge if critical/high issues found

### Setting Up Required Status Checks:
1. Repository Settings → Branches → Add rule for `main`
2. Check "Require status checks to pass before merging"
3. Search and select: `validate-pr`
4. Save changes

**Result**: PRs cannot be merged until validation passes! 🛡️

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   DEV           │    │   BUILD          │    │   TEST          │
│   Environment   │───▶│   Environment    │───▶│   Environment   │
│                 │    │   (Managed)      │    │   (Approval)    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
                                               ┌─────────────────┐
                                               │   PRODUCTION    │
                                               │   Environment   │
                                               │   (Approval)    │
                                               └─────────────────┘

Quality Gates:    🔍────────────🔍────────────🔍────────────🔍
                Export     Convert      Deploy      Release
```

## 📁 Repository Structure

```
📦 solutions/
├── 📂 .github/workflows/          # All GitHub Actions workflows
│   ├── 01-export-solutions.yml    # Export with quality gates
│   ├── 02-deploy-travel-solution.yml
│   ├── 03-deploy-coffeeshop-solution.yml  
│   ├── shared-deployment-pipeline.yml     # Reusable pipeline
│   └── pr-validator.yml           # PR validation
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
3. Copy Application ID → Add to repository variables as CLIENT_ID
4. Copy Tenant ID → Add to repository variables as TENANT_ID
```

### 4. Power Platform Access:
```bash
1. Power Platform Admin Center → Environment → Settings
2. Users + permissions → Application users → New app user
3. Select app registration → Assign System Administrator role
```

## 📊 Workflow Comparison

| Feature | Manual Process | This Repository |
|---------|---------------|-----------------|
| **Export** | Manual download | ✅ Automated with PR |
| **Validation** | Manual testing | ✅ Automated quality gates |
| **Deployment** | Manual steps | ✅ Automated pipeline |
| **Approvals** | Email/manual | ✅ GitHub approval gates |
| **Audit Trail** | Limited | ✅ Complete GitHub history |
| **Rollback** | Complex | ✅ Git-based rollback |

## 🎯 Best Practices

### Development Workflow:
1. **Export** solutions using GitHub Actions (creates PR)
2. **Review** PR with automatic validation results  
3. **Merge** PR to trigger automated deployment
4. **Approve** TEST deployment when ready
5. **Approve** PRODUCTION deployment for release

### Quality Management:
- ✅ Never bypass quality gates  
- ✅ Fix critical/high issues before merging
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
