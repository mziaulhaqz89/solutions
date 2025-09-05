# PAC CLI Entity Validation Fix

## Problem Summary
The GitHub Actions workflow was failing due to invalid PAC CLI commands for entity validation. The workflow was attempting to use non-existent commands:
- `pac entity list` 
- `pac data list-tables`

## Root Cause Analysis

Based on official Microsoft documentation research:

### PAC CLI Command Groups (Official)
From https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/:

- `pac data` - Import and export data from Dataverse
- `pac env` - Work with your Dataverse organization
- `pac modelbuilder` - Code Generator for Dataverse APIs and Tables

### PAC Data Commands (Official)
From https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/data:

Available commands:
- `pac data export` - Export data from Dataverse
- `pac data import` - Import data to Dataverse

**NO `list-tables` command exists in `pac data`**

### PAC Env Commands (Official)  
From https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/env:

Available commands include:
- `pac env fetch` - **Execute FetchXML queries against Dataverse**

## Solution Implementation

### Approach: FetchXML Query via `pac env fetch`

Replace invalid entity listing commands with documented `pac env fetch` using FetchXML to query the `entity` table in Dataverse.

#### FetchXML Query Structure
```xml
<?xml version="1.0" encoding="utf-8"?>
<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false" count="1">
  <entity name="entity">
    <attribute name="logicalname" />
    <attribute name="displayname" />
    <filter type="and">
      <condition attribute="logicalname" operator="eq" value="{ENTITY_NAME}" />
    </filter>
  </entity>
</fetch>
```

#### Implementation Steps
1. **Generate FetchXML**: Dynamically create FetchXML with target entity name
2. **Execute Query**: Use `pac env fetch --query-file` to execute against Dataverse
3. **Parse Results**: Check if entity exists in query response
4. **Graceful Fallback**: If validation fails, proceed with export (which will validate entity existence)

### Code Changes

#### Before (Invalid Commands)
```powershell
# ❌ INVALID - These commands don't exist
pac entity list
pac data list-tables
```

#### After (Documentation-Based Fix)
```powershell
# ✅ VALID - Using documented pac env fetch with FetchXML
pac env fetch --query-file "entity_check.xml" --environment $ENVIRONMENT_URL
```

## Documentation References

### Official Microsoft Learn Documentation
1. **PAC CLI Command Groups**: https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/
2. **PAC Data Commands**: https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/data
3. **PAC Env Commands**: https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/env
4. **PAC Modelbuilder**: https://learn.microsoft.com/en-us/power-platform/developer/cli/reference/modelbuilder

### Key Findings
- **No direct entity listing commands** exist in PAC CLI
- **FetchXML queries** are the proper way to query Dataverse entities
- **pac env fetch** is the documented method for executing FetchXML
- **Error handling** should allow export to proceed if validation fails

## Testing Validation

### Success Criteria
1. ✅ Workflow executes without "invalid command" errors
2. ✅ Entity validation uses only documented PAC CLI commands  
3. ✅ Graceful fallback when entity validation fails
4. ✅ Export process still validates entity existence at runtime

### Error Prevention
- **No assumptions** about undocumented commands
- **Official documentation** as single source of truth
- **Defensive programming** with fallback mechanisms
- **Clear error messages** for troubleshooting

## Implementation Benefits

1. **Compliance**: Uses only documented Microsoft PAC CLI commands
2. **Reliability**: Based on official Microsoft Learn documentation
3. **Maintainability**: Future-proof against PAC CLI changes
4. **Robustness**: Graceful handling of validation failures

## Lessons Learned

1. **Always verify** command existence in official documentation
2. **Don't assume** command naming patterns (pac data ≠ pac data list-*)
3. **Use FetchXML** for Dataverse queries when direct commands don't exist
4. **Implement fallbacks** for non-critical validation steps

---

**Documentation Date**: January 2025  
**PAC CLI Version**: 1.43.6  
**Status**: ✅ Fixed using official Microsoft documentation
