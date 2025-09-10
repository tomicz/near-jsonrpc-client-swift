# GitHu Actions Setup

Simple CI workflow for automated testing.

## What's set up

- **One workflow**: `.github/workflows/ci.yml`
- **Triggers**: Push to `main`, Pull Requests to `main`
- **Tests**: All packages and examples
- **Platform**: macOS 14 with Swift 5.9

## How to use

1. Commit and push the workflow:

   ```bash
   git add .github/
   git commit -m "Add CI workflow"
   git push
   ```

2. Check the Actions tab in GitHub for results

## Status badge

Add this to your README.md:

```markdown
[![CI](https://github.com/YOUR_USERNAME/near-jsonrpc-client-swift/workflows/CI/badge.svg)](https://github.com/YOUR_USERNAME/near-jsonrpc-client-swift/actions)
```

That's it! 🚀
