# Quarto Quick-Start Template

This repository contains ready-to-use examples of [Quarto](https://quarto.org), the open-source scientific and technical publishing system. It works as a quick reference for people who are new to Quarto or who use it infrequently and need a refresher on its key features.

The first main examples here (`manuscript.qbd` and `slides.qmd`) approach a single, lighthearted research question *On which days do restaurant patrons tip their servers the best?* using the `tips` dataset from the seaborn Python library. 

The examples given here are written for Python users, but the techniques are easily adaptable for R users. See the [memo template documentation](resources/memo_template.md#for-use-with-r) for tips on getting started with R.

The content is contrived, but the Quarto techniques are real.

## Repository Contents

### `resources/maximize_reproducibility.md`

A guide to writing Quarto documents whose narrative text updates automatically when the underlying data changes. It contrasts a hard-coded approach—where the conclusion is written as a static string—with a reproducible approach that uses Python's `if/else` logic and f-string interpolation to generate prose that always matches the statistical results. See the full guide: [Maximizing Reproducibility](resources/maximize_reproducibility.md).

### `manuscript.qmd` — Analytical Report

A mock analytical manuscript that demonstrates how to build a multi-section, publication-ready document in Quarto. It renders to **HTML**, **PDF**, and **Word** from a single source file. The report has a table of contents, numbered sections three levels deep, executable Python code blocks, figures, tables, callout boxes, bibliography citations, a references section, and cross-references throughout.

**For example**, the YAML front matter shows how to offer readers download links for alternate formats inside the HTML view/output:

```yaml
other-links:
  - text: Download PDF
    href: manuscript.pdf
  - text: Download Word Document
    href: resources/word_doc_base.docx
```

### `slides.qmd` — Slide Presentation

A Reveal.js slide deck that covers the same tipping analysis in presentation form. It demonstrates Quarto's presentation features including speaker view, slide overview, chalkboard mode, navigation controls, section-divider slides with custom background colors, user of the `{.smaller}` class to shrink text, and in-slide callouts.

**For example**, the YAML front matter enables speaker view and the built-in chalkboard with just a few lines:

```yaml
format:
  revealjs:
    chalkboard: true
    view:
      speaker: true
```

### `.gitignore`

A comprehensive, well-commented `.gitignore` covering Python, Jupyter, R/RStudio, Quarto build artifacts, common data file formats (CSV, Excel, Stata, SAS, SPSS, Parquet, and more), OS-generated files, and IDE configuration directories.

### `_quarto.yml`

The project-level configuration file (which is technically optiona, but which should not be overlooked). Quarto reads this file automatically when you render any `.qmd` in the directory. This templated file sets the project type to `default`, applies the `cosmo` Bootstrap theme, and enables a table of contents globally. Individual `.qmd` files can override or extend these settings in their own YAML front matter.

### `references.bib`

A BibTeX bibliography file containing five references used throughout the manuscript and slides. It demonstrates how Quarto integrates with standard citation workflows: you add entries to this `.bib` file, point to it with `bibliography: references.bib` in your YAML header, and cite entries in-text with `@key` or `[@key]` syntax. Quarto handles the rest. When implemented correctly Quarto will manage formatting, numbering, and it will also generate the references list. For more on BibTeX, see [Overview of BibTeX](resources/overview_of_bibtex.md).

### `resources/word_doc_base.docx`

A Word document that serves as a reference template for the `.docx` output format. When you render `manuscript.qmd` to Word, Quarto applies the styles (fonts, headings, spacing, margins) defined in this file. Customize the project Word output by customizing the `word_doc_base.docx` file (or by adding a different Word file and then specifying that file in the frontmatter). The manuscript's YAML header connects to the Word file with:

```yaml
docx:
  reference-doc: resources/word_doc_base.docx
```

---

## Feature-by-Feature Reference

This section walks through many Quarto features demonstrated in this repository, explains what it does, and shows the syntax so you can copy it into your own projects.

### Multi-Format Output

A single `.qmd` file can render to multiple formats. List each format under the `format:` key in the YAML header. `manuscript.qmd` renders to HTML, PDF, and Word:

```yaml
format:
  html:
    theme: cosmo
  pdf:
    toc: true
  docx:
    reference-doc: resources/word_doc_base.docx
```

Render a specific format from the terminal with:

```bash
quarto render manuscript.qmd --to html
quarto render manuscript.qmd --to pdf
quarto render manuscript.qmd --to docx
```

> [!NOTE]
> When getting started with Quarto it is a common practice to run `quarto preview manuscript.qmd` which will render the document to HTML and open it in your default browser. This is a quick way to see how your document will look when rendered to HTML. This approach also has the advantage of automatically reloading the document when you make changes to the source file.

### Table of Contents

Enable a table of contents and control its depth with:

```yaml
toc: true
toc-depth: 3
```

This generates a navigable sidebar (in HTML) or a traditional TOC page (in PDF/Word) from your headings.

### Numbered Sections

Turn on automatic section numbering with:

```yaml
number-sections: true
```

Quarto numbers your `##`, `###`, and `####` headings sequentially (1, 1.1, 1.1.1, etc.).

### Section Cross-References

Assign an ID to any heading and reference it elsewhere in the document:

```markdown
## Tipping Patterns by Day {#sec-tipping-by-day}

...later in the document...

As discussed in @sec-tipping-by-day, the patterns are clear.
```

Quarto replaces `@sec-tipping-by-day` with a clickable link showing the section number.

### Code Folding

Hide code by default but let readers expand it on demand:

```yaml
code-fold: true
code-summary: "Show code"
```

This default approach keeps the document clean for non-technical readers while (usually) preserving reproducibility. To modify the code folding behavior for a single code block add the `code-fold` and `code-summary` options at the beginning of a code block:

```yaml
#| code-fold: false
#| code-summary: "Show code"

print("Hello, World!")
```

### Executable Code Blocks

Quarto runs Python (or R, Julia, Observable JS) code blocks at render time. Use the `#|` comment syntax for cell-level options:

````markdown
```{python}
#| label: setup
#| include: false

import pandas as pd
import seaborn as sns
tips = sns.load_dataset("tips")
```
````

- **`label`** — gives the code block a referenceable name
- **`include: false`** — runs the code but hides both the code and its output

### Figure Labels, Captions, and Cross-References

Give a code block a `fig-` prefixed label and a `fig-cap` to create a numbered, cross-referenceable figure:

````markdown
```{python}
#| label: fig-tip-by-day
#| fig-cap: "Distribution of Tip Amounts by Day of the Week"

sns.boxplot(data=tips, x="day", y="tip")
plt.show()
```

As shown in @fig-tip-by-day, Sunday tips are highest.
````

> [!WARNING]
> A subtle, not well documented rule, that easily gets overlooked is that a figure (data visualization) label needs the `fig-` prefix. Also avoid the `fig-` prefis for tables and conversely avoid using the `cap-` prefix for figures (data visualizations).

### Table Labels, Captions, and Cross-References

The same pattern works for tables. Use a `tbl-` prefixed label and `tbl-cap`:

````markdown
```{python}
#| label: tbl-summary
#| tbl-cap: "Summary Statistics of Tips by Day of the Week"

tips.groupby("day")["tip"].describe()
```

@tbl-summary presents the summary statistics.
````

> [!WARNING]
> A subtle, not well documented rule, that easily gets overlooked is that a table label needs the `cap-` prefix. Also avoid the `cap-` prefis for figrues and conversely avoid using the `tbl-` prefix for figures (data visualizations).


### Callout Blocks

Callouts draw attention to important information. Quarto provides five built-in types:

```markdown
::: {.callout-note}
## Title
Content for general notes.
:::

::: {.callout-tip}
## Title
Content for helpful tips.
:::

::: {.callout-important}
## Title
Content for critical information.
:::

::: {.callout-warning}
## Title
Content for warnings about potential issues.
:::

::: {.callout-caution}
## Title
Content for things to be careful about.
:::
```

Quarto supports six heading levels.

### Bibliography and Citations

A step-by-step approach to configuring citations is as follows:

1. Create a `.bib` file with BibTeX entries (see `references.bib`).
2. Point to BibTeX file in your YAML front matter header:

   ```yaml
   bibliography: references.bib
   ```

3. Optionally specify a citation style also in YAML front matter header:

   ```yaml
   csl: https://www.zotero.org/styles/apa
   ```

4. Cite in-text with `@key` for narrative citations or `[@key]` for parenthetical:

   ```markdown
   As @tufte2001visual argues...
   ...effective visualization is essential [@wickham2014tidy].
   ```

5. Add a references section at the end of your document:

   ```markdown
   ## References {.unnumbered}

   ::: {#refs}
   :::
   ```

### Reveal.js Slide Presentations

The main difference beetween a manuscript or other related paper/document legacy formats and a slide presentation is a single entry in the YAML front matter header. Set the format to `revealjs` to create an HTML slide deck. Key options demonstrated in `slides.qmd`:

```yaml
format:
  revealjs:
    theme: moon                # Built-in theme
    transition: slide          # Slide transition animation
    slide-number: true         # Show slide numbers
    chalkboard: true           # Enable drawing on slides
    controls: true             # Show navigation arrows
    controls-tutorial: true    # Animate arrows on first load
    overview: true             # Enable "O" key overview
    navigation-mode: linear    # Step through slides linearly
    view:
      speaker: true            # Enable "S" key speaker view
```

### Section Divider Slides

Create visually distinct section breaks with a custom background color:

```markdown
# Section Title {background-color="#2d4059"}
```

### Markdown Tables with Captions

In addition to code-generated tables, you can write Markdown pipe tables and give them a caption and cross-reference label:

```markdown
| Finding | Detail |
|---------|--------|
| **Highest tips** | Sunday dinner |

: Summary of Key Findings {#tbl-slides-findings}
```

### Code Generated Tables with Captions

A code generated table uses a different syntax. Note how the following use `#|` instead of `#` to enter code block options including the label (for cross-referencing) and caption (for the table title):

```{python}
#| label: tbl-code-generated
#| tbl-cap: "Summary Statistics of Tips by Day of the Week"

 tips.groupby("day")["tip"].describe().transpose()
```

### Suppressing Warnings and Messages

Keep rendered output clean by suppressing Python/R warnings globally:

```yaml
execute:
  warning: false
  message: false
```

> [!NOTE]
> Consdider suppressing warnings and message towards completion of your document rather than at the start. This is a common practice when working with Quarto. It is a good idea to suppress warnings and messages when you are not interested in them. This will keep your rendered output clean and easy to read.

### Word Reference Documents

Customize Word output styling without writing code. Point to a `.docx` template:

```yaml
docx:
  reference-doc: resources/word_doc_base.docx
```

To customize: render once to Word, open the output, modify the styles (Heading 1, Normal, etc.) in Word's style editor, save it as your reference doc, and re-render.

### Other Links (Download Buttons)

Add download or navigation links to the HTML sidebar:

```yaml
other-links:
  - text: Download PDF
    href: manuscript.pdf
  - text: Download Word Document
    href: resources/word_doc_base.docx
```

---

## Getting Started

1. **Install Quarto** from [quarto.org/docs/get-started](https://quarto.org/docs/get-started/).

2. **Install Python dependencies**:

Install your favoraite distribution of Python, and if that distribution does not include common data science packages, install them using `pip`:

   ```bash
   pip install pandas seaborn matplotlib scipy
   ```

3. **Render the manuscript**:

  For a one-time render use:

   ```bash
   quarto render manuscript.qmd
   ```

  For a continuous render use (which opens the document in your default browser and updates automatically when you make changes to the `.qmd` document):

   ```bash
   quarto preview manuscript.qmd
   ```

4. **Render the slides**:

  Quarto render works the same for slides (opens slides in default browser and updates automatically when you make changes to the `.qmd`document):

   ```bash
   quarto render slides.qmd
   ```

5. **Preview with live reload**:

As mentioned above, but worth a second mention is that you can preview both the manuscript and slides at the same time:

   ```bash
   quarto preview manuscript.qmd
   quarto preview slides.qmd
   ```

Adapt any of these files for your own project. Replace the tips analysis with your data, swap in your references, and you have a fully-featured Quarto document ready to go.
