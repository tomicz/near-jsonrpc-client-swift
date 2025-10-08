#!/bin/bash

# Code Generation Script
# Runs the code generator and validates the output

set -e

echo "🔧 Running NEAR Protocol Swift Code Generator..."
echo ""

# Run the code generator
echo "📥 Downloading OpenAPI spec and generating Swift code..."
cd Tools/CodeGenerator
swift run
cd ../..
echo "✅ Code generation complete"
echo ""

# Lint the generated code
echo "🔍 Linting generated code..."
./Scripts/lint.sh
echo ""

# Build to verify compilation
echo "🔨 Verifying generated code compiles..."
cd Packages/NearJsonRpcTypes
swift build
echo "✅ Generated types compile successfully"
echo ""

cd ../NearJsonRpcClient
swift build
echo "✅ Client with generated methods compiles successfully"
echo ""

cd ../..
echo "🎉 Code generation, linting, and compilation successful!"
echo ""
echo "📋 Generated files:"
echo "   - Packages/NearJsonRpcTypes/Types.swift"
echo "   - Packages/NearJsonRpcTypes/Methods.swift"
echo "   - Packages/NearJsonRpcClient/Sources/GeneratedMethods.swift"
echo "   - Packages/NearJsonRpcClient/Sources/ConvenienceMethods.swift"

