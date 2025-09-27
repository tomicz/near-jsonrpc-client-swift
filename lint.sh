#!/bin/bash

# Swift Linting Script for NEAR Protocol Swift SDK
# This script lints the generated types and provides feedback

set -e

echo "🔍 Running SwiftLint on NEAR Protocol Swift SDK..."
echo ""

# Check if SwiftLint is installed
if ! command -v swiftlint &> /dev/null; then
    echo "❌ SwiftLint is not installed. Please install it first:"
    echo "   brew install swiftlint"
    exit 1
fi

echo "📦 Linting generated types..."
swiftlint lint packages/NearJsonRpcTypes/ --quiet

if [ $? -eq 0 ]; then
    echo "✅ Generated types passed SwiftLint checks!"
else
    echo "❌ Generated types have linting issues."
    echo "   Run 'swiftlint lint packages/NearJsonRpcTypes/' to see details."
    exit 1
fi

echo ""
echo "🎉 Linting complete!"
echo ""
echo "💡 To run linting manually:"
echo "   swiftlint lint packages/NearJsonRpcTypes/"
