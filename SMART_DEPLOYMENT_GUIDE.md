# Smart Release Deployment Workflow

## 🎯 Overview
The enhanced `release-action-call.yml` automatically detects which solution was changed and deploys the correct solution to your environments.

## 🔄 How It Works

### Trigger Events:
1. **Push to Main** (when PR is merged): Auto-detects changed solution
2. **Manual Dispatch**: Choose specific solution to deploy
3. **Release Created**: Deploys travelsolution by default

### Decision Flow:
```
┌─────────────────┐
│   Trigger Event │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│ Detect Solution │
└─────────────────┘
         │
         ▼
    ┌─────────┐    No Changes     ┌──────────────┐
    │Changes? ├─────────────────► │ Skip Deploy  │
    └─────────┘                   └──────────────┘
         │ Yes
         ▼
┌─────────────────┐
│ Deploy Solution │ ──► BUILD → TEST → PROD
└─────────────────┘
```

## 📋 Detection Logic

### 1. Manual Override (Workflow Dispatch)
- **User selects solution** from dropdown
- **Deploys selected solution** immediately

### 2. Push to Main (PR Merge)
- **Analyzes changed files** in `solutions/` directory
- **Single solution changed** → Deploy that solution
- **Multiple solutions changed** → Deploy `travelsolution` as default
- **No solution changes** → Skip deployment

### 3. Release Created
- **Deploys `travelsolution`** by default
- Can be enhanced to read solution from release tag

## 🚀 Usage Examples

### Scenario 1: Export and Deploy Travel Solution
```bash
# 1. Export travelsolution using GitHub Actions
# 2. Changes appear in solutions/travelsolution/
# 3. Create PR and merge to main
# 4. Workflow automatically detects travelsolution changes
# 5. Deploys travelsolution to BUILD → TEST → PROD
```

### Scenario 2: Export and Deploy Coffee Shop Solution
```bash
# 1. Export coffeeshop using GitHub Actions  
# 2. Changes appear in solutions/coffeeshop/
# 3. Create PR and merge to main
# 4. Workflow automatically detects coffeeshop changes
# 5. Deploys coffeeshop to BUILD → TEST → PROD
```

### Scenario 3: Manual Deployment
```bash
# 1. Go to Actions → "Smart Release Deployment"
# 2. Click "Run workflow"
# 3. Select solution from dropdown
# 4. Click "Run workflow"
# 5. Deploys selected solution immediately
```

## 📁 File Detection

The workflow monitors changes in:
- `solutions/travelsolution/**`
- `solutions/coffeeshop/**`

### Change Detection Examples:
```bash
# These changes would trigger travelsolution deployment:
solutions/travelsolution/Entities/mzh_travel/Entity.xml
solutions/travelsolution/Other/Solution.xml

# These changes would trigger coffeeshop deployment:
solutions/coffeeshop/Entities/mzh_product/Entity.xml
solutions/coffeeshop/Other/Customizations.xml
```

## ⚙️ Configuration

### Environment URLs:
- **BUILD**: `https://mzhbuild.crm4.dynamics.com`
- **TEST**: `https://mzhtest.crm4.dynamics.com`
- **PRODUCTION**: `https://mzhprod.crm11.dynamics.com`

### Authentication:
- Uses service principal authentication
- Requires `PowerPlatformSPN` secret

## 🔍 Workflow Benefits

✅ **Smart Detection**: Automatically knows which solution to deploy  
✅ **Multi-Solution Support**: Handles both travelsolution and coffeeshop  
✅ **Trigger Flexibility**: Manual, PR merge, or release triggers  
✅ **Safe Defaults**: Falls back to travelsolution if multiple changes  
✅ **Clear Logging**: Detailed output showing detection logic  
✅ **Deployment Summary**: Visual summary of what's being deployed  

## 📝 Workflow Output Example

When triggered, you'll see output like:
```
🔍 Detecting changed solutions from recent commits...
📁 Changed files:
solutions/coffeeshop/Entities/mzh_product/Entity.xml
solutions/coffeeshop/Other/Solution.xml

🎯 Changed solutions: coffeeshop
📊 Number of changed solutions: 1
✅ Single solution detected: coffeeshop

## 🚀 Deployment Summary
**Solution to Deploy**: coffeeshop
**Trigger**: push
**Status**: ✅ Proceeding with deployment
💡 **Deployment Pipeline**: BUILD → TEST → PRODUCTION
```

## 🔧 Customization

To add more solutions, update:
1. **Workflow dropdown options**
2. **Path monitoring** in the `paths:` section
3. **Detection logic** to recognize new solution folders

This workflow makes your deployment process intelligent and automated! 🎉
