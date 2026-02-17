# Memo Template

The `resources/memo_template/` folder is a self-contained starter kit for writing compact, one-page research memos in [Quarto](https://quarto.org). Grab the folder, replace the example content with your own analysis, and render to HTML, PDF, or Word from a single source file.

## What's Inside

| File | Purpose |
|------|---------|
| `memo_template.qmd` | The Quarto source file. Contains YAML front matter, example Python code blocks, and placeholder sections for your memo. |
| `memo_template_refs.bib` | A BibTeX bibliography file. Add your own references here and cite them in the `.qmd` with `@key` or `[@key]` syntax. |
| `setup_memo_bash.sh` | Setup script for macOS / Linux. Prompts for project name, author, date, and research question, then downloads and populates the template files. |
| `setup_memo_powershell.ps1` | Setup script for Windows. Same interactive prompts and behavior as the bash version, using PowerShell. |

The spacing and formatting have been updated to result in a more compact and dense layout that maximizes the amount of information that can be included on a single page.

## Design Decisions

The template is opinionated toward brevity and density. Some of the key decisions in support of this opinionated approach include:

- **Small margins** (0.75 in on all sides) to maximize usable page area.
- **No table of contents** — the memo is meant to fit on one page.
- **Compact PDF title block** — the title is left-justified, with the author on the left and date on the right, separated from the body by a horizontal rule. This more compacted layout replaces LaTeX's default centered title block which consumes significant vertical space.
- **Tight heading spacing** — vertical space above and below section headings is reduced via the `titlesec` LaTeX package.
- **Smaller code blocks in PDF** — code font size is set to `\small` so code listings don't dominate the page.
- **Code folding and code tools in HTML** — code blocks are collapsed by default with a toggle to expand, and a "Code" menu lets readers show/hide all code or view the source.
- **PDF and Word download links** — the HTML view includes sidebar links to download the rendered PDF and Word versions.
- **Bibliography support** — citations are managed through a `.bib` file with APA-style formatting.

## Template Sections

The memo follows a three-section structure:

1. **Analytical Or Research Question** — State the question your memo addresses.
2. **Answer, Response, & Summary of Results** — Present your findings, including code, figures, and narrative.
3. **Remaining Questions + Uncertainties** — Document open questions, limitations, and next steps.

A **References** section at the end is generated automatically from your citations.

## Getting the Files (Scripted)

### Quick Setup Script

For the fastest start, run the setup script directly. It prompts for your project name, author, date, and research question, then downloads the files and populates them with your inputs.

**macOS / Linux (bash):**

```bash
bash <(curl -s https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template/setup_memo_bash.sh)
```

**Windows (PowerShell):**

```powershell
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template/setup_memo_powershell.ps1").Content
```

Each script will create a new folder with your project name, download `memo_template.qmd`, `memo_template_refs.bib`, and `memo_template.docx`, and replace the placeholder title, author, date, and research question with your responses.

## Getting the Files (Individually)

### macOS / Linux

Download the two source files into a new folder with `curl`:

```bash
mkdir memo_template && cd memo_template

curl -O https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template/memo_template.qmd
curl -O https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template/memo_template_refs.bib
curl -O https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template/memo_template.docx
```

### Windows (PowerShell)

```powershell
mkdir memo_template; cd memo_template

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template/memo_template.qmd" -OutFile "memo_template.qmd"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template/memo_template_refs.bib" -OutFile "memo_template_refs.bib"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/adamrossnelson/quarto-qs/main/resources/memo_template/memo_template.docx" -OutFile "memo_template.docx"
```

## Using the Template

1. **Edit `memo_template.qmd`** — Replace the title, author, date, and all section content with your own. Swap the example Python code for your analysis.

2. **Edit `memo_template_refs.bib`** — Remove the example entry and add your own BibTeX references. Cite them in the `.qmd` with `[@key]` for parenthetical or `@key` for narrative citations.

3. **Render all formats**:

   ```bash
   quarto render memo_template.qmd
   ```

   This produces `memo_template.html`, `memo_template.pdf`, and `memo_template.docx` in one command. The HTML version includes download links to the PDF and Word files.

   Following `quarto render`, you can also use `quarto preview memo_template.qmd` to preview the HTML version with live reload (as shown below).

4. **Preview with live reload** (HTML only):

   ```bash
   quarto preview memo_template.qmd
   ```

   This `quarto preview` opens the HTML in your browser and automatically refreshes when you save changes to the `.qmd` file. Note that the PDF and Word download links will only work after you run a full `quarto render`.

## Customization Options

- **Change margins** — Adjust the `geometry` values under `pdf:` and the `margin-*` values under `html:` in the YAML front matter.
- **Change code block font size** — In the `include-in-header` LaTeX block, replace `\small` with `\footnotesize` (smaller) or `\normalsize` (default).
- **Remove code entirely** — If your memo has no code, delete the Python code blocks and remove the `code-fold`, `code-tools`, and `execute` options from the YAML.
- **Change the citation style** — Add `csl: https://www.zotero.org/styles/apa` (or another CSL style URL) to the YAML front matter.
- **Rename the file** — If you rename `memo_template.qmd`, update the `href` values under `other-links` to match the new output filenames.
