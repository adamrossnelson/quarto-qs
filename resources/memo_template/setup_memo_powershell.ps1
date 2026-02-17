# setup_memo_powershell.ps1 — Download and configure a Quarto research memo
# from the quarto-qs memo_template. Run this script in the directory where you
# want your new memo project to live.

$ErrorActionPreference = "Stop"

$BaseUrl = "https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template"

# Prompt for user inputs
$FolderName = Read-Host "Folder name"
$ProjectTitle = Read-Host "Project title"
$AuthorName = Read-Host "Author name"
$MemoDate = Read-Host "Date (e.g., Feb 1, 2030)"
$ResearchQuestion = Read-Host "Research or analytical question"

# Validate inputs
if (-not $FolderName -or -not $ProjectTitle -or -not $AuthorName -or -not $MemoDate -or -not $ResearchQuestion) {
    Write-Error "All fields are required."
    exit 1
}

# Create project folder
New-Item -ItemType Directory -Path $FolderName -Force | Out-Null
Set-Location $FolderName

Write-Host "Downloading template files..."
Invoke-WebRequest -Uri "$BaseUrl/memo_template.qmd" -OutFile "memo_template.qmd"
Invoke-WebRequest -Uri "$BaseUrl/memo_template_refs.bib" -OutFile "memo_template_refs.bib"
Invoke-WebRequest -Uri "$BaseUrl/memo_template.docx" -OutFile "memo_template.docx"

# Ask about renaming file prefix
$RenameChoice = Read-Host "Rename files to Quarto default prefix 'index'? [Y/n]"
if (-not $RenameChoice) { $RenameChoice = "Y" }

if ($RenameChoice -match "^[Nn][Oo]?$") {
    $CustomPrefix = Read-Host "Enter a custom file prefix [memo_template]"
    if (-not $CustomPrefix) { $CustomPrefix = "memo_template" }
    $FilePrefix = $CustomPrefix
} else {
    $FilePrefix = "index"
}

# Rename files if prefix is not memo_template
if ($FilePrefix -ne "memo_template") {
    Rename-Item -Path "memo_template.qmd" -NewName "$FilePrefix.qmd"
    Rename-Item -Path "memo_template_refs.bib" -NewName "${FilePrefix}_refs.bib"
    Rename-Item -Path "memo_template.docx" -NewName "$FilePrefix.docx"
}

# Replace placeholders in the .qmd file
$content = Get-Content -Path "$FilePrefix.qmd" -Raw
$content = $content -replace [regex]::Escape("title: Research Memo Template"), "title: $ProjectTitle"
$content = $content -replace [regex]::Escape('author: "Your Name"'), "author: `"$AuthorName`""
$content = $content -replace [regex]::Escape("date: Feb 1, 2030"), "date: $MemoDate"
$content = $content -replace [regex]::Escape("Did vehicles become more efficient over time?"), $ResearchQuestion
if ($FilePrefix -ne "memo_template") {
    $content = $content -replace [regex]::Escape("memo_template_refs.bib"), "${FilePrefix}_refs.bib"
    $content = $content -replace [regex]::Escape("memo_template.pdf"), "$FilePrefix.pdf"
    $content = $content -replace [regex]::Escape("memo_template.docx"), "$FilePrefix.docx"
}
Set-Content -Path "$FilePrefix.qmd" -Value $content -NoNewline

Write-Host ""
Write-Host "Memo project created in: $(Get-Location)"
Write-Host "  Folder:   $FolderName"
Write-Host "  Prefix:   $FilePrefix"
Write-Host "  Title:    $ProjectTitle"
Write-Host "  Author:   $AuthorName"
Write-Host "  Date:     $MemoDate"
Write-Host "  Question: $ResearchQuestion"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. cd $FolderName"
Write-Host "  2. Edit $FilePrefix.qmd - replace the example analysis with your own"
Write-Host "  3. Edit ${FilePrefix}_refs.bib - add your references"
Write-Host "  4. quarto render $FilePrefix.qmd"
Write-Host "  5. quarto preview $FilePrefix.qmd"
