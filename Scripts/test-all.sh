#!/bin/bash

# Test All Packages Script
# Runs tests for all Swift packages

set -e

echo "🧪 Running tests for NEAR Protocol Swift SDK..."
echo ""

# Test NearJsonRpcTypes
echo "📦 Testing NearJsonRpcTypes..."
cd Packages/NearJsonRpcTypes
if swift test; then
    echo "✅ NearJsonRpcTypes tests passed"
else
    echo "❌ NearJsonRpcTypes tests failed"
    exit 1
fi
echo ""

# Test NearJsonRpcClient
echo "📦 Testing NearJsonRpcClient..."
cd ../NearJsonRpcClient
if swift test; then
    echo "✅ NearJsonRpcClient tests passed"
else
    echo "❌ NearJsonRpcClient tests failed"
    exit 1
fi
echo ""

echo "🎉 All tests passed successfully!"

