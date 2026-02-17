#!/bin/bash
# setup_memo_bash.sh — Download and configure a Quarto research memo from the
# quarto-qs memo_template. Run this script in the directory where you want
# your new memo project to live.

set -e

BASE_URL="https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template"

# Prompt for user inputs
read -rp "Project name (used as folder name): " project_name
read -rp "Author name: " author_name
read -rp "Date (e.g., Feb 1, 2030): " memo_date
read -rp "Research or analytical question: " research_question

# Validate inputs
if [ -z "$project_name" ] || [ -z "$author_name" ] || [ -z "$memo_date" ] || [ -z "$research_question" ]; then
    echo "Error: All fields are required."
    exit 1
fi

# Create project folder
mkdir -p "$project_name"
cd "$project_name"

echo "Downloading template files..."
curl -sO "$BASE_URL/memo_template.qmd"
curl -sO "$BASE_URL/memo_template_refs.bib"
curl -sO "$BASE_URL/memo_template.docx"

# Replace placeholders in the .qmd file
# Use | as sed delimiter to avoid conflicts with user input containing /
sed -i.bak "s|title: Research Memo Template|title: $project_name|" memo_template.qmd
sed -i.bak "s|author: \"Your Name\"|author: \"$author_name\"|" memo_template.qmd
sed -i.bak "s|date: Feb 1, 2030|date: $memo_date|" memo_template.qmd
sed -i.bak "s|Did vehicles become more efficient over time?|$research_question|" memo_template.qmd

# Clean up sed backup files
rm -f memo_template.qmd.bak

echo ""
echo "Memo project created in: $(pwd)"
echo "  Title:    $project_name"
echo "  Author:   $author_name"
echo "  Date:     $memo_date"
echo "  Question: $research_question"
echo ""
echo "Next steps:"
echo "  1. cd $project_name"
echo "  2. Edit memo_template.qmd — replace the example analysis with your own"
echo "  3. Edit memo_template_refs.bib — add your references"
echo "  4. quarto render memo_template.qmd"
echo "  5. quarto preview memo_template.qmd"
