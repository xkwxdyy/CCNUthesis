#!/bin/bash
# Release script for CCNUthesis

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}CCNUthesis Release Builder${NC}"
echo "============================"

# Get version from command line or prompt
if [ -z "$1" ]; then
    read -p "Enter version number (e.g., 1.4.7): " VERSION
else
    VERSION=$1
fi

# Base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$BASE_DIR"

# Create release directory
RELEASE_DIR="$BASE_DIR/release/CCNUthesis-v$VERSION"
echo -e "\n${YELLOW}Creating release directory: $RELEASE_DIR${NC}"
mkdir -p "$RELEASE_DIR"

# Copy source files
echo "Copying source files..."
cp source/CCNUthesis.cls "$RELEASE_DIR/"
cp source/gb7714-*.bbx "$RELEASE_DIR/"
cp source/gb7714-*.cbx "$RELEASE_DIR/"

# Copy example files from test-basic
echo "Copying example files..."
cp test/test-basic/main.tex "$RELEASE_DIR/"
cp test/test-basic/ccnu-setup.tex "$RELEASE_DIR/"
cp test/test-basic/CCNUthesis-main.bib "$RELEASE_DIR/"

# Copy subdirectories
cp -r test/test-basic/front "$RELEASE_DIR/"
cp -r test/test-basic/body "$RELEASE_DIR/"
cp -r test/test-basic/back "$RELEASE_DIR/"

# Copy asset directories
echo "Copying assets..."
cp -r assets/images/logos "$RELEASE_DIR/logo"
cp -r assets/images/figures "$RELEASE_DIR/figures"
cp -r assets/documents/copyright "$RELEASE_DIR/copyright"

# Copy documentation and helper files
echo "Copying documentation..."
cp README.md "$RELEASE_DIR/"
cp LICENSE "$RELEASE_DIR/"
cp CHANGELOG.md "$RELEASE_DIR/"
cp scripts/latexmkrc "$RELEASE_DIR/"
[ -f lguide-ch1.pdf ] && cp lguide-ch1.pdf "$RELEASE_DIR/"

# Copy user manual if exists
if [ -f docs/user-guide/CCNUthesis-doc.pdf ]; then
    cp docs/user-guide/CCNUthesis-doc.pdf "$RELEASE_DIR/"
fi

# Update paths in release version
echo "Updating paths for release..."
sed -i.bak 's|../../source/CCNUthesis|CCNUthesis|g' "$RELEASE_DIR/main.tex"
sed -i.bak 's|../assets/images/figures/|figures/|g' "$RELEASE_DIR/CCNUthesis.cls"
sed -i.bak 's|../assets/images/logos/|logo/|g' "$RELEASE_DIR/CCNUthesis.cls"
sed -i.bak 's|../assets/documents/copyright/|copyright/|g' "$RELEASE_DIR/CCNUthesis.cls"
rm "$RELEASE_DIR"/*.bak

# Compile example to generate PDF
echo -e "\n${YELLOW}Compiling example PDF...${NC}"
cd "$RELEASE_DIR"
if latexmk -xelatex main.tex > /dev/null 2>&1; then
    echo -e "${GREEN}✓ PDF compiled successfully${NC}"
else
    echo "Warning: PDF compilation failed"
fi

# Clean auxiliary files
latexmk -c > /dev/null 2>&1

# Create zip archive
cd "$BASE_DIR/release"
ZIP_NAME="CCNUthesis-v$VERSION.zip"
echo -e "\n${YELLOW}Creating archive: $ZIP_NAME${NC}"
zip -r "$ZIP_NAME" "CCNUthesis-v$VERSION" -x "*.DS_Store" "*.aux" "*.log" > /dev/null

echo -e "\n${GREEN}Release created successfully!${NC}"
echo "Location: $RELEASE_DIR"
echo "Archive: release/$ZIP_NAME"