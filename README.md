# CV Template

This repository now uses a reusable LuaLaTeX template so you can maintain several CV variants (backend, frontend, full-stack, etc.) without rewriting the layout each time.

## Quick Start

1. Ensure LuaLaTeX is installed (MiKTeX setup already works) and build with the provided VS Code tasks or Latex Workshop recipes.
2. Open `cv-config.tex` and adjust `\cvsetup{...}` to update name, tagline, colours, PDF metadata, and contact details.
3. Switch between content variants by changing the `\input{sections/...}` lines in `main.tex` (e.g. swap the `about` and `skills` files for backend or frontend versions).

## Customisation Points

- **Layout & Styling**: Centralised in `styles/ehsancv.sty`. You can tweak margins (`\cvsetgeometry{...}`), section spacing, bullet styles, and footer behaviour in one place.
- **Branding**: `\cvsetup` supports keys such as `primarycolor`, `linkcolor`, `contactcolor`, `headerlinespread`, `lastupdated`, and PDF metadata (`pdftitle`, `pdfauthor`, etc.). Add or remove contact methods with the helper commands `\cvcontact`, `\cvcontactsep`, and `\cvcontactbreak`.
- **Icons**: Define reusable SVG-based icons with `\cvsvgicon{name}{path}{height}` (see `cv-config.tex` for examples) and then call `\name` anywhere in the document.
- **Content Blocks**: The shared environments `highlights`, `onecolentry`, `twocolentry`, etc. live in the style file so every section (experience, projects, achievements, education) stays consistent.

## Creating Variants

You can maintain multiple role-specific configs:

```tex
% cv-config-backend.tex
\cvsetup{
  name     = {Md. Ehsan Khan},
  tagline  = {Backend Developer},
  contacts = { ... }
}
```

Then in `main.tex` swap which config file you `\input`. Everything else (layout, sections, and assets) remains reusable.

## Build Artifacts

Compiled files are ignored via `.gitignore` (`out/`, `*.pdf`, etc.). Commit only the `.tex`, `.sty`, and asset sources.

## VS Code

- The workspace already contains tasks for both direct `lualatex` and `latexmk` builds with `-shell-escape` enabled.
- The `.vscode/settings.json` sets LuaLaTeX as the default recipe for LaTeX Workshop.

Happy typesetting!
