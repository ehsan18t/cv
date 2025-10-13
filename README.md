# CV Template

This repository now uses a reusable LuaLaTeX template so you can maintain several CV variants (backend, frontend, full-stack, etc.) without rewriting the layout each time.

## Quick Start

1. Ensure LuaLaTeX is installed (MiKTeX setup already works) and build with the provided VS Code tasks or Latex Workshop recipes.
2. Open `cv-config.tex` and adjust `\cvsetup{...}` to update name, tagline, colours, PDF metadata, and contact details.
3. Switch between content variants by changing the `\input{sections/...}` lines in `main.tex` (e.g. swap the `about` and `skills` files for backend or frontend versions).

## Customisation Points

### `\cvsetup` quick reference

The template exposes a pgfkeys interface so you can keep layout logic in `styles/ehsancv.sty` while describing your personal flavour in `cv-config.tex`. You can combine any of the keys below inside a single `\cvsetup{...}` call.

| Area            | Keys                                                                                                                                                                                                                                                                                                                                                                                              | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Identity        | `name`, `tagline`                                                                                                                                                                                                                                                                                                                                                                                 | Strings appear in the header. Leave `tagline` empty to drop the line.                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| Colours         | `primarycolor`, `linkcolor`, `contactcolor`, `taglinecolor`, `namecolor`, `footercolor`                                                                                                                                                                                                                                                                                                           | Supply comma-separated RGB values (`{0,79,144}`) or an existing colour name (`{primaryColor}`). `primarycolor` also drives link colours unless you override `linkcolor`/`urlcolor`.                                                                                                                                                                                                                                                                                                                                                                |
| Typography      | `font`, `fontoptions`, `namefont`, `taglinefont`, `contactfont`, `headerlinespread`, `bodylinespread`                                                                                                                                                                                                                                                                                             | `font` targets both main and sans families (use your system font name). Pair it with `fontoptions` for `\setmainfont` / `\setsansfont` options (e.g. `Path = ./assets/fonts/`).                                                                                                                                                                                                                                                                                                                                                                    |
| Header          | `contacts`, `contactsep`, `contactbreak`, `headercontactslinegap`, `headercontactsleading`, `headercontactsbaseline`, `headerlayout`, `headerimage`, `headerimagesize`, `headerimagegap`, `headerimagepagegap`, `headerimagetextgap`, `namesize`, `nameaftergap`, `titlesize`, `titleaftergap`, `headerinfoaftergap`, `headertopgap`, `headerbottomgap`, `headertopoffset`, `headerimageposition` | Use `\cvcontact{icon}{text}[link]` per item. `namesize`/`titlesize` adjust the font sizes without redefining macros, while the gap keys set the total vertical distance between header elements (no hidden padding). Set `headerlayout = {left}` to align text left; `headerimageposition = {page}` pins the optional circular image to the top-right edge. `headerimagegap` updates both dedicated image gap knobs at once. Legacy keys `contactlinegap`, `contactlinespread`, and `contactbaselineskip` still work but forward to the new names. |
| Lists & spacing | `itemgap`                                                                                                                                                                                                                                                                                                                                                                                         | Controls vertical space (`itemsep`) between list entries in the provided highlight environments.                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| Footer          | `showfooter`, `showupdated`, `showpage`, `footer-left`, `footer-right`, `footerfont`, `pageformat`, `updatedlabel`, `lastupdated`                                                                                                                                                                                                                                                                 | Set boolean flags to `true`/`false`. `footer-left` and `footer-right` accept arbitrary LaTeX (defaults render last-updated + page count).                                                                                                                                                                                                                                                                                                                                                                                                          |
| PDF metadata    | `pdftitle`, `pdfauthor`, `pdfsubject`, `pdfkeywords`                                                                                                                                                                                                                                                                                                                                              | Passed through to `hyperref`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| Section styling | `sectionformat`, `sectionpost`, `sectionleft`, `sectionbefore`, `sectionafter`                                                                                                                                                                                                                                                                                                                    | Provide the desired formatting tokens; the defaults already include `\needspace` and `\titlerule`.                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

Example: hide the footer, swap the base font, and tone down the section weight:

```tex
\cvsetup{
  font          = {Inter},
  fontoptions   = {Path = ./assets/fonts/},
  showfooter    = {false},
  sectionformat = {\Large\bfseries\color{black}},
  sectionpost   = {},
  sectionafter  = {0.4 cm}
}
```

### Runtime helpers

- `\cvrefreshstyle` re-applies the current section styling. Call it immediately after a second `\cvsetup{...}` block inside the document body if you change section keys mid-stream.
- `\cvsetgeometry{...}` lets you override the page geometry later (useful for alternate one-page vs multi-page variants).
- `\cvsvgicon{name}{path}{height}` defines reusable SVG icons. After calling it in your config you can use `\name` inside contacts or elsewhere.
- `headerimage`, `headerimagesize`, `headerimagegap`, `headerimagepagegap`, `headerimagetextgap`, `namesize`, `nameaftergap`, `titlesize`, `titleaftergap`, `headerinfoaftergap`, `headercontactslinegap`, `headercontactsleading`, `headercontactsbaseline`, `headertopgap`, `headerbottomgap`, `headertopoffset`, `headerlayout`, and `headerimageposition` let you dial in both imagery and typography. `headerimagepagegap` nudges the image in from the page edge, `headerimagetextgap` trims space from the text column, the size keys rescale the name/tagline, and the gap keys now set the absolute spacing between stacked header blocks. Use `headertopoffset` to pull the header upward into the page margin when you need a tighter top edge. Switch `headerimageposition` to `flow` if you prefer it inline with the name.

### Layout and content building blocks

- `\makecvheader` prints the header with the configured name, tagline, and contacts.
- Environments `highlights`, `highlightsforbulletentries`, `onecolentry`, and `twocolentry` keep experience/projects aligned. Wrap bullet lists in the highlights environments for consistent spacing.

See `styles/ehsancv.sty` for the authoritative defaults if you want to clone the structure into another project.

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
