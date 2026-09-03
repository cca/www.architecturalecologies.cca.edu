#!/bin/bash

# Script to fix all live domain links in the wget archive
echo "Fixing links in all HTML files..."

total_files=0
fixed_files=0

# Find all HTML files (excluding backups) and fix them
find . -name "*.html" -type f ! -name "*.bak" | while read file; do
    ((total_files++))
    
    # Check if file has live URLs
    if grep -q "https://www\.architecturalecologies\.cca\.edu" "$file"; then
        # Create backup
        cp "$file" "$file.bak"
        
        # Replace the domain with relative paths
        # This captures the path after the domain and adds .html
        # For root domain, use index.html
        sed -i.tmp \
            -e 's|href="https://www\.architecturalecologies\.cca\.edu/\([^"]*\)"|href="\1.html"|g' \
            -e 's|src="https://www\.architecturalecologies\.cca\.edu/\([^"]*\)"|src="\1.html"|g' \
            -e 's|href="https://www\.architecturalecologies\.cca\.edu"|href="index.html"|g' \
            -e 's|src="https://www\.architecturalecologies\.cca\.edu"|src="index.html"|g' \
            "$file"
        
        # Remove the .tmp files created by sed
        rm -f "$file.tmp"
        
        ((fixed_files++))
        echo "Fixed: $file"
    fi
done

echo ""
echo "Done!"
echo "Processed files, fixed those with live URLs"
echo "Backup files created with .bak extension"
echo ""
echo "To verify: grep -r 'https://www.architecturalecologies.cca.edu' . --include='*.html' | grep -v 'og:url\|twitter:url\|itemprop' | wc -l"
echo "To remove backups: find . -name '*.bak' -delete"
