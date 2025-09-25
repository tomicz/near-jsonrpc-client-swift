# Automatic OpenAPI Updates

This repository automatically stays in sync with the NEAR Protocol's OpenAPI specification, following the same approach as the [near-jsonrpc-client-ts](https://github.com/near/near-jsonrpc-client-ts) project.

## How It Works

The workflow (`codegenerator.yml`) automatically:

1. **Downloads** the latest OpenAPI spec from NEAR's repository
2. **Generates** Swift types using our code generator
3. **Tests** compilation to ensure everything works
4. **Creates a Pull Request** if changes are detected

## Triggers

- **Manual**: Run the workflow from GitHub Actions UI
- **Scheduled**: Daily at 6 AM UTC (same as TypeScript project)
- **Push to main**: Regenerates types on every push

## Source

OpenAPI specification is downloaded from:

```
https://raw.githubusercontent.com/near/nearcore/master/chain/jsonrpc/openapi/openapi.json
```

## Benefits

- ✅ **Always up-to-date** with NEAR's latest API changes
- ✅ **Single workflow file** - simple and maintainable
- ✅ **Automatic PR creation** for review
- ✅ **Compilation testing** before committing
- ✅ **Follows TypeScript project's proven approach**

## Manual Updates

You can manually trigger an update by:

1. Go to **Actions** tab in GitHub
2. Select **"Update Generated Swift Types from OpenAPI"**
3. Click **"Run workflow"**
