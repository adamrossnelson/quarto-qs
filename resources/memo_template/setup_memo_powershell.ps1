# setup_memo_powershell.ps1 — Download and configure a Quarto research memo
# from the quarto-qs memo_template. Run this script in the directory where you
# want your new memo project to live.

$ErrorActionPreference = "Stop"

$BaseUrl = "https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template"

# Prompt for user inputs
$ProjectName = Read-Host "Project name (used as folder name)"
$AuthorName = Read-Host "Author name"
$MemoDate = Read-Host "Date (e.g., Feb 1, 2030)"
$ResearchQuestion = Read-Host "Research or analytical question"

# Validate inputs
if (-not $ProjectName -or -not $AuthorName -or -not $MemoDate -or -not $ResearchQuestion) {
    Write-Error "All fields are required."
    exit 1
}

# Create project folder
New-Item -ItemType Directory -Path $ProjectName -Force | Out-Null
Set-Location $ProjectName

Write-Host "Downloading template files..."
Invoke-WebRequest -Uri "$BaseUrl/memo_template.qmd" -OutFile "memo_template.qmd"
Invoke-WebRequest -Uri "$BaseUrl/memo_template_refs.bib" -OutFile "memo_template_refs.bib"
Invoke-WebRequest -Uri "$BaseUrl/memo_template.docx" -OutFile "memo_template.docx"

# Replace placeholders in the .qmd file
$content = Get-Content -Path "memo_template.qmd" -Raw
$content = $content -replace [regex]::Escape("title: Research Memo Template"), "title: $ProjectName"
$content = $content -replace [regex]::Escape('author: "Your Name"'), "author: `"$AuthorName`""
$content = $content -replace [regex]::Escape("date: Feb 1, 2030"), "date: $MemoDate"
$content = $content -replace [regex]::Escape("Did vehicles become more efficient over time?"), $ResearchQuestion
Set-Content -Path "memo_template.qmd" -Value $content -NoNewline

Write-Host ""
Write-Host "Memo project created in: $(Get-Location)"
Write-Host "  Title:    $ProjectName"
Write-Host "  Author:   $AuthorName"
Write-Host "  Date:     $MemoDate"
Write-Host "  Question: $ResearchQuestion"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. cd $ProjectName"
Write-Host "  2. Edit memo_template.qmd - replace the example analysis with your own"
Write-Host "  3. Edit memo_template_refs.bib - add your references"
Write-Host "  4. quarto render memo_template.qmd"
Write-Host "  5. quarto preview memo_template.qmd"
