#!/bin/bash

# Auto-increment version script for Wholesalers B2B
# This script automatically updates the version number in pubspec.yaml

PUBSPEC_FILE="pubspec.yaml"

# Check if pubspec.yaml exists
if [ ! -f "$PUBSPEC_FILE" ]; then
    echo "Error: pubspec.yaml not found!"
    exit 1
fi

# Extract current version
CURRENT_VERSION=$(grep "^version:" $PUBSPEC_FILE | sed 's/version: //' | sed 's/+.*//')
CURRENT_BUILD=$(grep "^version:" $PUBSPEC_FILE | sed 's/.*+//')

echo "Current version: $CURRENT_VERSION+$CURRENT_BUILD"

# Parse version components
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Increment build number
NEW_BUILD=$((CURRENT_BUILD + 1))

# For major releases, increment major version and reset others
if [ "$1" == "major" ]; then
    NEW_MAJOR=$((MAJOR + 1))
    NEW_MINOR=0
    NEW_PATCH=0
    NEW_BUILD=1
    NEW_VERSION="$NEW_MAJOR.$NEW_MINOR.$NEW_PATCH+$NEW_BUILD"
# For minor releases, increment minor version and reset patch
elif [ "$1" == "minor" ]; then
    NEW_MINOR=$((MINOR + 1))
    NEW_PATCH=0
    NEW_BUILD=1
    NEW_VERSION="$MAJOR.$NEW_MINOR.$NEW_PATCH+$NEW_BUILD"
# For patch releases, increment patch version
elif [ "$1" == "patch" ]; then
    NEW_PATCH=$((PATCH + 1))
    NEW_BUILD=1
    NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH+$NEW_BUILD"
# Default: just increment build number
else
    NEW_VERSION="$CURRENT_VERSION+$NEW_BUILD"
fi

echo "New version: $NEW_VERSION"

# Update pubspec.yaml
sed -i.bak "s/^version:.*/version: $NEW_VERSION/" $PUBSPEC_FILE

# Remove backup file
rm "$PUBSPEC_FILE.bak"

echo "✅ Version updated successfully!"
echo "📱 Ready to build with version $NEW_VERSION"
