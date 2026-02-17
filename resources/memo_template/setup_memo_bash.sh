#!/bin/bash
# setup_memo_bash.sh — Download and configure a Quarto research memo from the
# quarto-qs memo_template. Run this script in the directory where you want
# your new memo project to live.

set -e

BASE_URL="https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template"

# Check for dependencies
missing=""

if ! command -v quarto &> /dev/null; then
    missing="${missing}\n  [!] IMPORTANT: Quarto is not installed."
    missing="${missing}\n      Install from https://quarto.org/docs/get-started/"
    missing="${missing}\n"
fi

if ! command -v jupyter &> /dev/null; then
    missing="${missing}\n  [!] IMPORTANT: Jupyter is not installed (needed for Python code blocks)."
    missing="${missing}\n      Install with: pip install jupyter"
    missing="${missing}\n"
fi

if ! command -v Rscript &> /dev/null; then
    missing="${missing}\n  [!] IMPORTANT: R is not installed (needed for R code blocks)."
    missing="${missing}\n      Install from https://r-project.org or: brew install r"
    missing="${missing}\n"
fi

if [ -n "$missing" ]; then
    echo ""
    echo "=========================================="
    echo "  Dependency Check"
    echo "=========================================="
    echo -e "$missing"
    echo "The script will continue, but rendering"
    echo "may fail without these dependencies."
    echo "=========================================="
    echo ""
fi

# Prompt for user inputs
read -rp "Folder name: " folder_name
read -rp "Project title: " project_title
read -rp "Author name: " author_name
read -rp "Date (e.g., Feb 1, 2030): " memo_date
read -rp "Research or analytical question: " research_question

# Validate inputs
if [ -z "$folder_name" ] || [ -z "$project_title" ] || [ -z "$author_name" ] || [ -z "$memo_date" ] || [ -z "$research_question" ]; then
    echo "Error: All fields are required."
    exit 1
fi

# Create project folder
mkdir -p "$folder_name"
cd "$folder_name"

echo "Downloading template files..."
curl -sO "$BASE_URL/memo_template.qmd"
curl -sO "$BASE_URL/memo_template_refs.bib"
curl -sO "$BASE_URL/memo_template.docx"
curl -sO "https://raw.githubusercontent.com/adamrossnelson/quarto-qs/refs/heads/main/slides.qmd"

# Ask about renaming file prefix
read -rp "Rename files to Quarto default prefix 'index'? [Y/n]: " rename_choice
rename_choice=${rename_choice:-Y}

if [[ "$rename_choice" =~ ^[Nn][Oo]?$ ]]; then
    read -rp "Enter a custom file prefix [memo_template]: " custom_prefix
    file_prefix=${custom_prefix:-memo_template}
else
    file_prefix="index"
fi

# Rename files if prefix is not memo_template
if [ "$file_prefix" != "memo_template" ]; then
    mv memo_template.qmd "${file_prefix}.qmd"
    mv memo_template_refs.bib "${file_prefix}_refs.bib"
    mv memo_template.docx "${file_prefix}.docx"
    # Update the bibliography reference inside the .qmd
    sed -i.bak "s|memo_template_refs.bib|${file_prefix}_refs.bib|" "${file_prefix}.qmd"
    # Update the other-links hrefs inside the .qmd
    sed -i.bak "s|memo_template.pdf|${file_prefix}.pdf|" "${file_prefix}.qmd"
    sed -i.bak "s|memo_template.docx|${file_prefix}.docx|" "${file_prefix}.qmd"
fi

# Replace placeholders in the .qmd file
# Use | as sed delimiter to avoid conflicts with user input containing /
sed -i.bak "s|title: Research Memo Template|title: $project_title|" "${file_prefix}.qmd"
sed -i.bak "s|author: \"Your Name\"|author: \"$author_name\"|" "${file_prefix}.qmd"
sed -i.bak "s|date: Feb 1, 2030|date: $memo_date|" "${file_prefix}.qmd"
sed -i.bak "s|Did vehicles become more efficient over time?|$research_question|" "${file_prefix}.qmd"

# Update slides.qmd bibliography to match the project's .bib file name
sed -i.bak "s|bibliography: references.bib|bibliography: ${file_prefix}_refs.bib|" slides.qmd
rm -f slides.qmd.bak

# Create a minimal _quarto.yml so `quarto render` and `quarto preview`
# work without specifying a file name.
cat > _quarto.yml <<EOF
project:
  type: default
  render:
    - ${file_prefix}.qmd
EOF

# Clean up sed backup files
rm -f "${file_prefix}.qmd.bak"

echo ""
echo "Memo project created in: $(pwd)"
echo "  Folder:   $folder_name"
echo "  Prefix:   $file_prefix"
echo "  Title:    $project_title"
echo "  Author:   $author_name"
echo "  Date:     $memo_date"
echo "  Question: $research_question"
echo ""
echo "Next steps:"
echo "  1. cd $folder_name"
echo "  2. Edit ${file_prefix}.qmd — replace the example analysis with your own"
echo "  3. Edit ${file_prefix}_refs.bib — add your references"
echo "  4. quarto render              (or: quarto render ${file_prefix}.qmd)"
echo "  5. quarto preview             (or: quarto preview ${file_prefix}.qmd)"
