# GitHub Actions Workflows

This directory contains all GitHub Actions workflows for Power Platform solution management.

## 📋 Workflow Files (in execution order)

### 1. Export Workflows
- **`01-export-solutions.yml`** - Export solutions from DEV environment
  - Manual trigger with dropdown to select solution (travelsolution or coffeeshop)
  - Creates PR with exported solution files

### 2. Deployment Workflows  
- **`02-deploy-travel-solution.yml`** - Deploy Travel Solution
  - Auto-triggers when `solutions/travelsolution/**` changes
  - Manual trigger available
  - Deploys to BUILD → TEST → PRODUCTION

- **`03-deploy-coffeeshop-solution.yml`** - Deploy Coffee Shop Solution  
  - Auto-triggers when `solutions/coffeeshop/**` changes
  - Manual trigger available
  - Deploys to BUILD → TEST → PRODUCTION

### 3. Shared Components
- **`shared-deployment-pipeline.yml`** - Reusable deployment logic
  - Called by deployment workflows
  - Handles BUILD → TEST → PRODUCTION pipeline
  - Contains environment URLs and deployment steps

## 🔄 Complete Workflow Process

```
1. Developer makes changes in DEV environment
   ↓
2. Run "01-export-solutions.yml" → Select solution → Export
   ↓  
3. Review and merge PR
   ↓
4. Auto-trigger "02-deploy-travel-solution.yml" OR "03-deploy-coffeeshop-solution.yml"
   ↓
5. Solution deploys through BUILD → TEST → PRODUCTION
```

## 🎯 File Naming Convention

- **`01-`** prefix for export/source workflows
- **`02-`** prefix for primary deployment workflows  
- **`03-`** prefix for secondary deployment workflows
- **`shared-`** prefix for reusable workflows
- Descriptive names that clearly indicate purpose

## 📁 Quick Reference

| Workflow | Purpose | Trigger |
|----------|---------|---------|
| `01-export-solutions.yml` | Export from DEV | Manual (dropdown) |
| `02-deploy-travel-solution.yml` | Deploy travel solution | Auto on path change + Manual |
| `03-deploy-coffeeshop-solution.yml` | Deploy coffeeshop solution | Auto on path change + Manual |
| `shared-deployment-pipeline.yml` | Reusable deployment logic | Called by other workflows |

This structure makes it immediately clear what each workflow does and in what order they typically execute! 🎉
