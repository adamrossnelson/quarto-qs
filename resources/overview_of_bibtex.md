# Overview of BibTeX

BibTeX is the standard format for managing bibliographic references in LaTeX and Quarto documents. A `.bib` file is a plain-text file that is also a database where each entry describes a single source—article, book, conference paper, etc.—using a structured set of fields.

For readers new to BibTex, consider how the syntax compares and contrasts with other structured data formates including Python's `dict` (dictionaries), JSON (JavaScript Object Notation), and YAML (Yet Another Markup Language). There is a paried key-value structure.

## Anatomy of a BibTeX Entry

Every entry follows this general pattern:

```bibtex
@article{wickham2014tidy,
  title     = {Tidy Data},
  author    = {Wickham, Hadley},
  journal   = {Journal of Statistical Software},
  volume    = {59},
  number    = {10},
  pages     = {1--23},
  year      = {2014},
  publisher = {Foundation for Open Access Statistics},
  doi       = {10.18637/jss.v059.i10}
}
```

- **`@type` (showing `@article` above)** — The entry type. Common types include `@article`, `@book`, `@inproceedings`, `@techreport`, `@misc`, and `@phdthesis`.
- **`citation_key` (showing `wickham2014tidy` above)** — A short, unique identifier you choose (e.g., `wickham2014tidy`). This is what you type in your `.qmd` file when you write `@wickham2014tidy` or `[@wickham2014tidy]`.
- **Fields** — Key-value pairs like `title`, `author`, `year`, `doi`, etc. Required fields vary by entry type.

## Common Entry Types

| Type | Use For |
|------|---------|
| `@article` | Journal articles |
| `@book` | Books with a publisher |
| `@inproceedings` | Conference papers |
| `@incollection` | Chapters in edited volumes |
| `@techreport` | Technical reports, working papers |
| `@misc` | Websites, software, datasets, anything else |
| `@phdthesis` | Doctoral dissertations |
| `@mastersthesis` | Master's theses |

## Using BibTeX in Quarto

1. Save your entries in a `.bib` file (e.g., `references.bib`).

2. Point to it in your YAML front matter:

   ```yaml
   bibliography: references.bib
   ```

3. Cite in your text:
   - `@wickham2014tidy` produces a narrative citation: Wickham (2014)
   - `[@wickham2014tidy]` produces a parenthetical citation: (Wickham, 2014)
   - `[@wickham2014tidy; @mckinney2011pandas]` combines multiple citations

4. Add a references section at the end of your document:

   ```markdown
   ## References {.unnumbered}

   ::: {#refs}
   :::
   ```

Quarto (via Pandoc and citeproc) handles formatting, ordering, and generating the full reference list automatically.

# Suggested LLM-Supported Workflow for BibTeX

Since the rise of large language models, the fastest way to create BibTeX entries is no longer manually typing fields. Instead:

1. **Grab the unformatted citation information.** Copy the title, authors, journal name, year, volume, pages, DOI—whatever you have. It does not need to be in any particular format. A raw copy-paste from a journal website, a Google Scholar result, or even a screenshot's text is fine. It helps if you also reference the reference type (article, book, etc.)

2. **Prompt an LLM to produce a BibTeX entry.** Paste the raw information into your LLM of choice and ask it to generate a properly formatted BibTeX entry. The LLM will infer the correct entry type (if you didn't say it in the prompt) and return the standard fields. It will also generally give a sensible citation key (which you can update or change if you want to).

3. **Copy the result into your `.bib` file.** Review the output for accuracy (especially author names, year, and DOI), then paste it into `references.bib`.

This three-step workflow is faster and less error-prone than manual formatting, especially when you are adding many references at once.

## A Prompt You Can Use

Below is a tested prompt you can copy and adapt. Replace the placeholder text with your actual citation information.

---

> **Prompt:**
>
> I need a BibTeX entry for the following source. Please determine the correct entry type (e.g., `@article`, `@book`, `@inproceedings`, `@misc`) based on the information provided. Generate a citation key in the format `lastnameyearkeyword` (all lowercase, no spaces). Include all standard fields appropriate for the entry type. If a DOI is available, include it. If any information is missing, omit that field rather than guessing.
>
> Here is the source information:
>
> ```
> [Paste your unformatted citation information here. This can be a messy
> copy-paste from a website, a plain-text reference, or even just a title
> and author list. The more information you provide, the more complete
> the entry will be.]
> ```
>
> I'll be using your output in a Quarto project. Please return only the BibTeX entry in a code block, with no additional commentary.

---

### Example

If you paste this into the prompt:

```
Tidy Data, Hadley Wickham, Journal of Statistical Software, 2014,
Volume 59, Issue 10, pages 1-23, doi 10.18637/jss.v059.i10
```

The LLM will return something like:

```bibtex
@article{wickham2014tidy,
  title     = {Tidy Data},
  author    = {Wickham, Hadley},
  journal   = {Journal of Statistical Software},
  year      = {2014},
  volume    = {59},
  number    = {10},
  pages     = {1--23},
  doi       = {10.18637/jss.v059.i10}
}
```

You then paste that directly into your `references.bib` file.

## Tips for Maintaining a `.bib` File

- **Keep citation keys consistent.** A convention like `lastnameyearkeyword` (e.g., `wickham2014tidy`) makes keys predictable and easy to remember.
- **One entry per source.** Duplicate keys will cause rendering errors.
- **Verify DOIs.** A correct DOI ensures Quarto can generate a working link in the reference list. You can verify any DOI at [doi.org](https://doi.org).
- **Use an LLM for batch entry.** If you have a long reference list, paste multiple citations into a single prompt and ask for all entries at once.
- **Let Quarto handle formatting.** Do not manually format author names or titles to match a citation style. Specify a CSL style in your YAML header (e.g., `csl: https://www.zotero.org/styles/apa`) and let the rendering engine do the work.
