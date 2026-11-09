#!/usr/bin/env bash
set -e

# Configure git to avoid dubious ownership issues in root container
git config --global --add safe.directory '*'

# Clone or pull Flutter
if [ -d "flutter" ]; then
  cd flutter && git pull && cd ..
else
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 flutter
fi

# Add flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"

# Disable analytics to prevent prompts
flutter config --no-analytics

# Build Flutter web for release
flutter build web --release
