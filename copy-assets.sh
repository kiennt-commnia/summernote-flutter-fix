#!/bin/bash
# copy-assets.sh
# Run this script once to copy required asset files from your Flutter pub cache
# into this repo before pushing to GitHub.

set -e

PACKAGE="html_editor_enhanced"

# Find the package in pub cache (picks the latest version)
PUB_CACHE_DIR=""
for dir in ~/.pub-cache/hosted/pub.dev/${PACKAGE}-*/lib/assets; do
  PUB_CACHE_DIR="$dir"
done

if [ -z "$PUB_CACHE_DIR" ] || [ ! -d "$PUB_CACHE_DIR" ]; then
  echo "❌ Could not find $PACKAGE in pub cache."
  echo "   Make sure you have run 'flutter pub get' in a project that uses $PACKAGE."
  exit 1
fi

echo "✅ Found assets at: $PUB_CACHE_DIR"

# Copy JS/CSS assets
cp "$PUB_CACHE_DIR/jquery.min.js" .
cp "$PUB_CACHE_DIR/summernote-lite.min.js" .
cp "$PUB_CACHE_DIR/summernote-lite.min.css" .

# Copy dark CSS if it exists
if [ -f "$PUB_CACHE_DIR/summernote-lite-dark.min.css" ]; then
  cp "$PUB_CACHE_DIR/summernote-lite-dark.min.css" .
fi

# Copy plugins folder
if [ -d "$PUB_CACHE_DIR/plugins" ]; then
  cp -r "$PUB_CACHE_DIR/plugins" .
fi

echo ""
echo "✅ All assets copied successfully!"
echo ""
echo "Next steps:"
echo "  1. git add ."
echo "  2. git commit -m 'Add summernote assets'"
echo "  3. git push origin main"
echo ""
echo "Then enable GitHub Pages:"
echo "  Settings → Pages → Source: GitHub Actions"
echo ""
echo "Your hosted URL will be:"
echo "  https://kiennt-commnia.github.io/summernote-flutter-fix/summernote.html"
