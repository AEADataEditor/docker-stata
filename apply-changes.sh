#!/bin/bash
# Helper script to selectively apply changes from main branch

DIFF_DIR="/tmp/diffs-main-to-stata18"

cat << 'EOF'
=======================================================
Selective Merge Helper for stata18 branch
=======================================================

This script helps you apply changes from main branch
to stata18 branch one file at a time.

Available changes:
EOF

echo ""
echo "MODIFIED FILES:"
for f in "$DIFF_DIR"/*.diff; do
    if [[ -f "$f" ]]; then
        basename "$f" .diff
    fi
done

echo ""
echo "NEW FILES:"
for f in "$DIFF_DIR"/*.NEW; do
    if [[ -f "$f" ]]; then
        basename "$f" .NEW
    fi
done

echo ""
echo "=========================================="
echo "Usage examples:"
echo "=========================================="
echo ""
echo "1. View a specific diff:"
echo "   cat $DIFF_DIR/01-Dockerfile.base.diff"
echo ""
echo "2. Apply a specific diff (dry-run first):"
echo "   git apply --check $DIFF_DIR/01-Dockerfile.base.diff"
echo "   git apply $DIFF_DIR/01-Dockerfile.base.diff"
echo ""
echo "3. Copy a new file:"
echo "   cp $DIFF_DIR/08-Dockerfile.python.NEW ./Dockerfile.python"
echo "   git add Dockerfile.python"
echo ""
echo "4. Apply multiple diffs at once:"
echo "   git apply $DIFF_DIR/02-Dockerfile.type.diff \\"
echo "            $DIFF_DIR/03-README-containers.18.md.diff"
echo ""
echo "5. Apply all safe diffs (README and docs only):"
echo "   git apply $DIFF_DIR/03-README-containers.18.md.diff \\"
echo "            $DIFF_DIR/04-README-containers.19_5.md.diff \\"
echo "            $DIFF_DIR/05-README-containers.template.md.diff"
echo ""
echo "=========================================="
echo "Interactive Mode"
echo "=========================================="
echo ""
read -p "Would you like to review and apply changes interactively? (y/N) " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Starting interactive mode..."
    echo ""
    
    # Modified files
    for difffile in "$DIFF_DIR"/*.diff; do
        if [[ ! -f "$difffile" ]]; then
            continue
        fi
        
        filename=$(basename "$difffile" .diff | cut -d'-' -f2-)
        echo "=========================================="
        echo "File: $filename"
        echo "=========================================="
        echo ""
        echo "Diff preview (first 30 lines):"
        head -30 "$difffile"
        echo ""
        echo "View full diff? (y/N)"
        read view_full
        if [[ "$view_full" =~ ^[Yy]$ ]]; then
            less "$difffile"
        fi
        
        echo ""
        echo "Apply this change? (y/N/q to quit)"
        read apply_answer
        
        case "$apply_answer" in
            y|Y)
                echo "Checking if patch applies cleanly..."
                if git apply --check "$difffile" 2>&1; then
                    git apply "$difffile"
                    echo "✓ Applied successfully!"
                else
                    echo "✗ Patch does not apply cleanly. Skipping."
                fi
                ;;
            q|Q)
                echo "Exiting interactive mode."
                exit 0
                ;;
            *)
                echo "Skipped."
                ;;
        esac
        echo ""
    done
    
    # New files
    for newfile in "$DIFF_DIR"/*.NEW; do
        if [[ ! -f "$newfile" ]]; then
            continue
        fi
        
        filename=$(basename "$newfile" .NEW | cut -d'-' -f2-)
        echo "=========================================="
        echo "New File: $filename"
        echo "=========================================="
        echo ""
        echo "File preview (first 30 lines):"
        head -30 "$newfile"
        echo ""
        echo "View full file? (y/N)"
        read view_full
        if [[ "$view_full" =~ ^[Yy]$ ]]; then
            less "$newfile"
        fi
        
        echo ""
        echo "Copy this file to workspace? (y/N/q to quit)"
        read copy_answer
        
        case "$copy_answer" in
            y|Y)
                cp "$newfile" "./$filename"
                git add "$filename"
                echo "✓ File copied and added to git!"
                ;;
            q|Q)
                echo "Exiting interactive mode."
                exit 0
                ;;
            *)
                echo "Skipped."
                ;;
        esac
        echo ""
    done
    
    echo ""
    echo "=========================================="
    echo "Interactive mode complete!"
    echo "=========================================="
    echo ""
    echo "Review your changes with: git status"
    echo "Review diffs with: git diff"
    echo ""
else
    echo ""
    echo "Exiting. Use the commands above to manually apply changes."
fi
