#!/bin/bash

# Build All Packages Script
# Builds all Swift packages in the correct dependency order

set -e

echo "🔨 Building NEAR Protocol Swift SDK..."
echo ""

# Build NearJsonRpcTypes first (no dependencies)
echo "📦 Building NearJsonRpcTypes..."
cd Packages/NearJsonRpcTypes
swift build
echo "✅ NearJsonRpcTypes built successfully"
echo ""

# Build NearJsonRpcClient (depends on NearJsonRpcTypes)
echo "📦 Building NearJsonRpcClient..."
cd ../NearJsonRpcClient
swift build
echo "✅ NearJsonRpcClient built successfully"
echo ""

# Build CodeGenerator
echo "📦 Building CodeGenerator..."
cd ../../Tools/CodeGenerator
swift build
echo "✅ CodeGenerator built successfully"
echo ""

# Build BasicExample (depends on NearJsonRpcClient)
echo "📦 Building BasicExample..."
cd ../../Examples/BasicExample
swift build
echo "✅ BasicExample built successfully"
echo ""

echo "🎉 All packages built successfully!"

