#!/bin/bash
# Deploy to Vercel Script
# This script helps deploy the project to Vercel

echo "=========================================="
echo "Vercel Deployment Preparation"
echo "=========================================="
echo ""

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI not found. Installing..."
    npm install -g vercel
fi

echo "✓ Vercel CLI ready"
echo ""

# Install dependencies
echo "Installing npm dependencies..."
npm install --legacy-peer-deps

echo ""
echo "✓ Dependencies installed"
echo ""

# Build project
echo "Building project for production..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build successful!"
    echo ""
    echo "=========================================="
    echo "Ready to deploy to Vercel!"
    echo "=========================================="
    echo ""
    echo "Run: vercel"
    echo ""
else
    echo ""
    echo "❌ Build failed! Fix errors above."
    exit 1
fi
