#!/bin/bash

# Clean All Build Artifacts Script
# Removes all .build directories and derived data

set -e

echo "🧹 Cleaning NEAR Protocol Swift SDK build artifacts..."
echo ""

# Clean NearJsonRpcTypes
if [ -d "Packages/NearJsonRpcTypes/.build" ]; then
    echo "📦 Cleaning NearJsonRpcTypes..."
    rm -rf Packages/NearJsonRpcTypes/.build
    echo "✅ NearJsonRpcTypes cleaned"
fi

# Clean NearJsonRpcClient
if [ -d "Packages/NearJsonRpcClient/.build" ]; then
    echo "📦 Cleaning NearJsonRpcClient..."
    rm -rf Packages/NearJsonRpcClient/.build
    echo "✅ NearJsonRpcClient cleaned"
fi

# Clean CodeGenerator
if [ -d "Tools/CodeGenerator/.build" ]; then
    echo "📦 Cleaning CodeGenerator..."
    rm -rf Tools/CodeGenerator/.build
    echo "✅ CodeGenerator cleaned"
fi

# Clean BasicExample
if [ -d "Examples/BasicExample/.build" ]; then
    echo "📦 Cleaning BasicExample..."
    rm -rf Examples/BasicExample/.build
    echo "✅ BasicExample cleaned"
fi

# Clean any Package.resolved files
echo ""
echo "🗑️  Removing Package.resolved files..."
find . -name "Package.resolved" -type f -delete

echo ""
echo "🎉 All build artifacts cleaned!"

