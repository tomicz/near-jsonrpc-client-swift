#!/bin/bash

# Validation Script
# Runs all checks before committing: lint, build, and test

set -e

echo "🔍 Running full validation for NEAR Protocol Swift SDK..."
echo ""

# Run linting
echo "📋 Step 1/3: Linting..."
./Scripts/lint.sh
echo ""

# Build all packages
echo "📋 Step 2/3: Building..."
./Scripts/build-all.sh
echo ""

# Run tests
echo "📋 Step 3/3: Testing..."
./Scripts/test-all.sh
echo ""

echo "🎉 All validation checks passed!"
echo ""
echo "✅ Linting passed"
echo "✅ All packages built successfully"
echo "✅ All tests passed"
echo ""
echo "You're ready to commit! 🚀"

