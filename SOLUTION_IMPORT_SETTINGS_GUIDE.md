# Power Platform Solution Import Settings Guide

## Overview

This guide explains the optimal Power Platform CLI parameters for importing managed solutions across different deployment scenarios.

## Your Current Settings Analysis

```bash
--async false --force-overwrite false --publish-changes true --skip-dependency-check false 
--convert-to-managed false --max-async-wait-time 60 --activate-plugins true 
--skip-lower-version false --stage-and-upgrade true
```

### ❌ Issues Identified:

1. **`--async false`** - Risky for large solutions and stage-and-upgrade operations
2. **`--force-overwrite false`** - Can cause import failures in target environments
3. **`--stage-and-upgrade true`** - Used for all deployments (fails when solution doesn't exist)

## ✅ Recommended Settings by Scenario

### Scenario 1: First-Time Deployment
**When**: Solution doesn't exist in target environment

```bash
# GitHub Actions parameters
force-overwrite: true
publish-changes: true
activate-plugins: true
skip-dependency-check: false
convert-to-managed: false
async: true
max-async-wait-time: 60
# Note: No stage-and-upgrade (would fail)
```

**CLI Equivalent**:
```bash
pac solution import --path solution.zip \
  --async true \
  --force-overwrite true \
  --publish-changes true \
  --skip-dependency-check false \
  --convert-to-managed false \
  --max-async-wait-time 60 \
  --activate-plugins true \
  --skip-lower-version false
```

### Scenario 2: Update Existing Solution
**When**: Solution exists, preserve extra components

```bash
# GitHub Actions parameters
force-overwrite: true
publish-changes: true
activate-plugins: true
skip-dependency-check: false
convert-to-managed: false
async: true
max-async-wait-time: 60
# Note: Standard import, no stage-and-upgrade
```

**CLI Equivalent**:
```bash
pac solution import --path solution.zip \
  --async true \
  --force-overwrite true \
  --publish-changes true \
  --skip-dependency-check false \
  --convert-to-managed false \
  --max-async-wait-time 60 \
  --activate-plugins true \
  --skip-lower-version false
```

### Scenario 3: Upgrade Existing Solution
**When**: Solution exists, clean upgrade (remove deleted components)

```bash
# GitHub Actions parameters
stage-and-upgrade: true
publish-changes: true
activate-plugins: true
skip-dependency-check: false
convert-to-managed: false
async: true
max-async-wait-time: 60
force-overwrite: true
```

**CLI Equivalent**:
```bash
pac solution import --path solution.zip \
  --async true \
  --force-overwrite true \
  --publish-changes true \
  --skip-dependency-check false \
  --convert-to-managed false \
  --max-async-wait-time 60 \
  --activate-plugins true \
  --skip-lower-version false \
  --stage-and-upgrade true
```

## Parameter Explanation

### Core Import Settings

#### `--async true` ✅ **RECOMMENDED**
- **Purpose**: Import runs asynchronously, prevents timeouts
- **Benefits**: 
  - Better for large solutions
  - Required for stage-and-upgrade operations
  - Allows monitoring of long-running imports
- **When to use**: Always for production deployments

#### `--force-overwrite true` ✅ **RECOMMENDED**
- **Purpose**: Overwrites unmanaged customizations
- **Benefits**: 
  - Prevents import failures due to conflicting customizations
  - Ensures managed solution takes precedence
  - Standard practice for target environments (non-dev)
- **When to use**: Always in TEST/UAT/PROD environments

### Publishing & Activation

#### `--publish-changes true` ✅ **RECOMMENDED**
- **Purpose**: Publishes customizations after import
- **Benefits**: Makes changes immediately available to users
- **When to use**: Always (required for most components to function)

#### `--activate-plugins true` ✅ **RECOMMENDED**
- **Purpose**: Activates plugin steps and workflows in the solution
- **Benefits**: Ensures business logic is enabled after import
- **When to use**: Always (unless specifically testing without plugins)

### Dependency & Version Handling

#### `--skip-dependency-check false` ✅ **RECOMMENDED**
- **Purpose**: Validates dependencies before import
- **Benefits**: Prevents import failures due to missing dependencies
- **When to use**: Always (let Power Platform validate dependencies)

#### `--skip-lower-version false` ✅ **RECOMMENDED**
- **Purpose**: Allows importing same or lower version
- **Benefits**: Enables rollbacks and testing scenarios
- **When to use**: Usually true, unless enforcing version progression

### Solution Type

#### `--convert-to-managed false` ✅ **RECOMMENDED**
- **Purpose**: Don't convert unmanaged to managed during import
- **Benefits**: Import the solution type as-is
- **When to use**: Always when importing managed solutions

### Async Settings

#### `--max-async-wait-time 60` ✅ **RECOMMENDED**
- **Purpose**: Maximum wait time for async operations (minutes)
- **Benefits**: Prevents indefinite waiting
- **Typical values**: 
  - Small solutions: 30 minutes
  - Medium solutions: 60 minutes  
  - Large solutions: 120 minutes

### Upgrade Strategy

#### `--stage-and-upgrade true` ⚠️ **CONDITIONAL**
- **Purpose**: Stages solution for upgrade, then applies it
- **Benefits**: Clean upgrade that removes deleted components
- **When to use**: Only when solution already exists
- **When NOT to use**: First-time deployments (will fail)

## Environment-Specific Recommendations

### Development Environment
```bash
--async false          # Faster feedback for development
--force-overwrite false # Preserve unmanaged customizations
--publish-changes true
--activate-plugins true
--skip-dependency-check false
```

### Test Environment
```bash
--async true           # Handle larger solutions
--force-overwrite true # Overwrite any customizations
--publish-changes true
--activate-plugins true
--skip-dependency-check false
```

### Production Environment
```bash
--async true           # Required for reliability
--force-overwrite true # Ensure managed solution wins
--publish-changes true
--activate-plugins true
--skip-dependency-check false
--max-async-wait-time 120 # Longer timeout for production
```

## Best Practices

### 1. Always Use Async for Production
```yaml
async: true
max-async-wait-time: 60
```
**Why**: Prevents timeout issues and allows monitoring of long-running operations

### 2. Force Overwrite in Target Environments
```yaml
force-overwrite: true
```
**Why**: Ensures managed solutions take precedence over unmanaged customizations

### 3. Validate Dependencies
```yaml
skip-dependency-check: false
```
**Why**: Catches dependency issues before they cause import failures

### 4. Smart Upgrade Strategy
```yaml
# First deployment
stage-and-upgrade: false

# Subsequent deployments (with solution existence check)
stage-and-upgrade: true  # Only if solution exists
```

### 5. Always Publish and Activate
```yaml
publish-changes: true
activate-plugins: true
```
**Why**: Ensures solution is fully functional after import

## Your Enhanced Workflow

The updated composite action now uses optimal settings:

### For First-Time/Update Deployments:
- ✅ `async: true` - Prevents timeouts
- ✅ `force-overwrite: true` - Handles conflicts
- ✅ `publish-changes: true` - Makes changes available
- ✅ `activate-plugins: true` - Enables business logic
- ✅ `skip-dependency-check: false` - Validates dependencies

### For Upgrade Deployments:
- ✅ All above settings PLUS
- ✅ `stage-and-upgrade: true` - Clean upgrade

## Monitoring and Troubleshooting

### Successful Import Indicators:
```
Import operation completed successfully
Solution [name] imported successfully
All components activated
```

### Common Failure Patterns:

#### Timeout Issues:
```
Error: Import operation timed out
```
**Solution**: Increase `max-async-wait-time` or ensure `async: true`

#### Dependency Failures:
```
Error: Missing dependencies
```
**Solution**: Install dependencies first, use dependency validation

#### Overwrite Conflicts:
```
Error: Unmanaged customizations prevent import
```
**Solution**: Use `force-overwrite: true`

#### Stage-and-Upgrade Failures:
```
Error: Cannot create holding solution for missing base
```
**Solution**: Use standard import for first-time deployments

This optimized configuration provides reliable, efficient solution deployments across all environments while handling different deployment scenarios appropriately.
