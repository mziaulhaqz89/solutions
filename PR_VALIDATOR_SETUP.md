# PR Validator Setup Guide

This guide explains how to set up the PR Validator as a required status check to prevent merging PRs with validation failures.

## 🎯 What the PR Validator Does

The `pr-validator.yml` workflow:
- ✅ **Auto-triggers** on any PR affecting `solutions/**`
- ✅ **Detects changed solutions** automatically  
- ✅ **Validates solution structure** (checks for required files)
- ✅ **Runs solution checker** on each changed solution
- ✅ **Blocks merge** if critical or high severity issues found
- ✅ **Provides clear summary** of validation results

## 🔧 Setting Up Required Status Check

To make this validator mandatory for PR merges:

### 1. Go to Repository Settings
1. Navigate to your repository: `https://github.com/mziaulhaqz89/solutions`
2. Click **Settings** tab
3. Click **Branches** in the left sidebar

### 2. Add Branch Protection Rule
1. Click **Add rule** or edit existing rule for `main` branch
2. Check **Require status checks to pass before merging**
3. Check **Require branches to be up to date before merging**
4. In the search box, type: `validate-pr` (this is the job name)
5. Select `validate-pr` from the dropdown
6. Click **Save changes**

### 3. Test the Setup
1. Create a test PR with solution changes
2. Verify the "PR Validator" check appears
3. Confirm you cannot merge until the check passes

## 📋 Validation Process

### What Gets Validated:
```
1. Solution folder structure
   ├── Check if solution folder exists
   ├── Verify Solution.xml is present
   └── Validate folder structure

2. Solution packaging
   ├── Pack solution as ZIP file
   ├── Verify packing succeeds
   └── Generate solution file for checking

3. Solution checker analysis
   ├── Run Power Platform Solution Checker
   ├── Count issues by severity level
   └── Fail if Critical or High issues found
```

### Validation Results:
- **✅ Pass**: No critical or high issues (merge allowed)
- **❌ Fail**: Critical or high issues found (merge blocked)
- **⚠️ Warning**: Medium/low issues (merge allowed with warnings)

## 🚫 Merge Prevention

The validator will **block merge** if:
- ❌ Solution folder is missing or malformed
- ❌ Required files (Solution.xml) are missing  
- ❌ Solution cannot be packaged
- ❌ Solution checker finds **Critical** severity issues
- ❌ Solution checker finds **High** severity issues

## ✅ Merge Allowed

The validator will **allow merge** if:
- ✅ All solution files are properly structured
- ✅ Solution packages successfully
- ✅ No critical or high severity issues found
- ✅ Only medium, low, or informational issues (if any)

## 📊 Example Validation Output

```
🔍 PR Validation Results

Changed Solutions: travelsolution

- ✅ travelsolution - Validation passed (Medium: 2 issues)

✅ Status: All validations passed - PR ready to merge
```

Or for failures:
```
🔍 PR Validation Results

Changed Solutions: coffeeshop

- ❌ coffeeshop - Critical: 1, High: 2 issues

❌ Status: Validation failed - Fix issues before merging
```

## 🎯 Benefits

✅ **Quality Gate**: Prevents bad solutions from reaching main branch  
✅ **Early Detection**: Issues caught before deployment  
✅ **Automated**: No manual intervention required  
✅ **Clear Feedback**: Developers know exactly what to fix  
✅ **Flexible**: Only blocks for critical/high issues  
✅ **Audit Trail**: Full validation results saved as artifacts  

## 🔧 Customization

To modify validation rules, edit `pr-validator.yml`:

```yaml
# To change what blocks merge, modify this section:
if ($criticalCount -gt 0 -or $highCount -gt 0) {
  # Currently blocks for Critical OR High issues
  # Change to: if ($criticalCount -gt 0) to only block Critical
}
```

This ensures only high-quality solutions make it to production! 🎉
