# clearcv

A single-column CV class for LuaLaTeX. It reads well for people and extracts in clean reading order for applicant tracking systems (ATS). Compiling needs no shell escape and no external tools.

- [Getting started](#getting-started)
- [Writing your CV](#writing-your-cv)
- [Options](#options)
- [Commands](#commands)
- [One source, several CVs](#one-source-several-cvs)
- [ATS and accessibility](#ats-and-accessibility)
- [Customising](#customising)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Repository layout

| Path | Contents |
| --- | --- |
| `theme/` | The class: `clearcv.cls`, `clearcv.lua`, `clearcv-icons.def` |
| `cvs/` | The author's CVs, with their `sections/` and `assets/`, as a larger example |
| `latexmkrc` | Adds `theme/` and `cvs/` to the TeX search path for `latexmk` |
| `Dockerfile`, `docker/`, `docker-compose.yml` | A minimal TeX Live image |
| `pdf/`, `build/` | Generated output and auxiliary files; not tracked |

## Getting started

Save the [complete document](#writing-your-cv) below as `my-cv.tex` in the repository root, then pick a route.

### Docker (nothing else to install)

```sh
docker compose build
docker compose run --rm -e TARGET=my-cv.tex cv-builder
```

The PDF is written to `pdf/my-cv.pdf`.

| Command | Result |
| --- | --- |
| `docker compose run --rm cv-builder` | Builds every `.tex` file in the root and in `cvs/` |
| `docker compose run --rm -e TARGET=my-cv.tex cv-builder` | Builds one file; separate several with spaces |
| `docker compose run --rm cv-watch` | Rebuilds `cvs/Ehsan_Khan__FullStack.tex` on save; change the target in `docker-compose.yml` |

Rebuild the image with `docker compose build` after changing anything in `docker/` or the `Dockerfile`.

### Local TeX Live

Needs TeX Live 2023 or newer with `latexmk`, `fontspec`, `luaotfload`, `microtype`, `carlito`, `geometry`, `xcolor`, `graphics` and `hyperref`. Run from the repository root, where `latexmk` reads `latexmkrc`:

```sh
latexmk -lualatex -outdir=pdf -auxdir=build my-cv.tex
```

Plain `lualatex` does not read `latexmkrc`, so it cannot find a class in `theme/`. To use plain `lualatex`, copy the three theme files next to your document.

### Overleaf or any single folder

Copy the three files from `theme/` next to your document, with the `.tex` file at the top level of the project. On Overleaf, set the compiler to LuaLaTeX in the project menu. This route has not been tested on Overleaf itself.

### VS Code

`.vscode/settings.json` configures LaTeX Workshop to build through `docker compose`, with output in `pdf/`. Open the repository root as the workspace and run `docker compose build` once. The default build task runs `cv-builder` for every CV.

## Writing your CV

A complete document:

```latex
\documentclass[paper=a4, accent=blue]{clearcv}

\cvname{Jane Doe}
\cvsubtitle{Software Engineer}
% \cvphoto{photo.jpg}

\cvlocation{Berlin, Germany}
\cvemail{jane@example.com}
\cvgithub{janedoe}
\cvlinkedin{janedoe}

\begin{document}
\makecvheader

\section{About Me}
Software engineer who builds reliable web services.

\section{Skills}
\cvskill{Languages}{TypeScript, Python, SQL}

\section{Experience}
\begin{cventry}[
  title = {Software Engineer},
  org = {Example GmbH},
  location = {Berlin, Germany},
  type = {Full-time},
  from = {2022-03},
  to = {present},
]
  \cvitem{Reduced average API response time by \textbf{40\%}.}
  \cvitem{\textbf{LIVE:} \url{https://example.com}}
\end{cventry}

\section{Projects}
\begin{cventry}[
  title = {Example Project},
  right = {\cvlink{https://github.com/janedoe/example}{GITHUB}},
]
  \cvitem{A command-line tool for checking links in documentation.}
\end{cventry}

\section{Education}
\begin{cventry}[
  title = {Example University},
  from = {2015-09},
  to = {2019-05},
  detail = {B.Sc in Computer Science},
  detailright = {GPA: 3.8},
]
\end{cventry}
\end{document}
```

The header commands go in the preamble and print at `\makecvheader`. Remove the `%` before `\cvphoto` once your photo is in place. Contact items appear in the order you write them.

For a CV in several files, keep the documents in `cvs/` and shared content in `cvs/sections/`, as this repository does. Paths are written from `cvs/`, for example `\input{sections/profile}` and `\cvphoto{assets/me.png}`. Build these from the repository root with `TARGET=cvs/<name>.tex`.

### Entries

`cventry` covers experience, projects and education. All keys are optional.

| Key | Prints |
| --- | --- |
| `title` | Bold entry title on the left |
| `org` | Organisation, after the title |
| `from`, `to` | Dates on the right: `YYYY-MM`, a plain year, or `present` for `to`; formatted by `dateformat` |
| `date` | Free-text date, instead of `from` and `to` |
| `right` | Anything else on the right, instead of a date, such as a `\cvlink` |
| `location`, `type` | The grey second line, for example `Berlin, Germany` and `Full-time` |
| `detail`, `detailright` | The grey second line when `location` and `type` do not apply |
| `only` | The variants this entry belongs to; see [below](#one-source-several-cvs) |

The first two bullets of an entry stay on the same page as its heading, and a section heading always stays with what follows. Month names are English only.

## Options

Set options in `\documentclass[...]{clearcv}` or with `\cvsetup{...}` in the preamble. Order does not matter, and an unknown key stops the build with an error.

### Page and type

| Key | Values (default first) | Effect |
| --- | --- | --- |
| `paper` | `a4`, `letter` | Page size |
| `marginx`, `marginy` | `43.5pt`, `37.5pt` | Page margins |
| `font` | `Carlito`, or any font name | Main font |
| `fontpath`, `fontoptions` | empty | fontspec `Path` and extra options for a custom `font` |
| `fontsize`, `leading` | `10.5pt`, `1.3` | Body size and line height factor |
| `density` | `normal`, `compact`, `relaxed` | Scales the three gaps below |
| `sectiongap`, `entrygap`, `itemgap` | `10.5pt`, `4.5pt`, `0.75pt` | Individual gaps |

### Colour

| Key | Values (default first) | Effect |
| --- | --- | --- |
| `accent` | `blue`, `teal`, `green`, `red`, `purple`, `orange`, `slate`, `black`, or six hex digits | Accent colour; warns below 4.5:1 contrast on white |

### Header

| Key | Values (default first) | Effect |
| --- | --- | --- |
| `subtitle` | `true`, `false` | Shows or hides `\cvsubtitle`; hiding leaves no gap |
| `photo` | `true`, `false` | Shows or hides `\cvphoto` |
| `photosize` | `auto`, or a length | `auto` matches the name and contact block, up to `69pt` |
| `photoshape` | `circle`, `square` | Crop shape |
| `photofocus` | `0.3`, from `0` (top) to `1` (bottom) | Vertical crop position |
| `photoborder` | `1.8pt`, or `0pt` for none | Border width, drawn inside `photosize` |
| `photobordercolor` | a lighter accent, six hex digits, or an xcolor colour | Border colour |
| `icons` | `true`, `false` | Contact icons |
| `contactstyle` | `grid`, `inline` | Aligned columns or wrapped text; a grid too wide for the header wraps automatically |
| `contactcolumns` | `4` | Columns in the grid |

### Content

| Key | Values (default first) | Effect |
| --- | --- | --- |
| `dateformat` | `short`, `long`, `numeric` | `Nov 2025`, `November 2025` or `11/2025` |
| `presentlabel` | `Present` | Text for `to = {present}` |
| `linkicons` | `true`, `false` | The icon after `\cvlink` |
| `variant` | empty | Selects tagged content; see [below](#one-source-several-cvs) |
| `ats` | `false`, `true` | Removes photo, icons and colour, and prints full URLs |

### Page furniture and metadata

| Key | Values (default first) | Effect |
| --- | --- | --- |
| `maxpages` | `0` (off) | Warns when the CV runs longer |
| `pagenumbers` | `false`, `true` | `Page 1 of 2` in the footer |
| `lastupdated` | empty | Text on the left of the footer |
| `pdftitle` | `<name> CV` | PDF title |
| `pdfkeywords` | empty | PDF keywords |
| `lang` | `en-US` | PDF language |

## Commands

| Command | Purpose |
| --- | --- |
| `\cvsetup{keys}` | Sets options; see [Options](#options) |
| `\cvname{}`, `\cvsubtitle{}`, `\cvphoto{file}` | Header content |
| `\cvlocation{}`, `\cvemail{}`, `\cvphone{}`, `\cvwebsite{example.com}` | Contact details |
| `\cvlinkedin{user}`, `\cvgithub{user}`, `\cvgitlab{user}`, `\cvorcid{id}`, `\cvcodeforces{user}`, `\cvleetcode{user}`, `\cvstackoverflow{id}{name}` | Profiles |
| `\cvcontact{icon}{text}[url]` | Any other contact item; `icon` may be empty |
| `\cvdeficon{name}{width}{height}{PDF path}` | Adds an icon; see [Customising](#customising) |
| `\makecvheader` | Prints the header |
| `\section[only={...}]{Title}` | Section heading |
| `\begin{cventry}[keys] ... \end{cventry}` | An experience, project or education entry |
| `\cvitem[only={...}]{text}`, `\cvsubitem[only={...}]{text}` | Bullets |
| `\cvskill{Label}{items}` | A `Label: items` line |
| `\cvnote{text}` | A short paragraph set apart from the entry above |
| `\cvlink{url}{label}` | A labelled link, in italics, with an icon; `ats` prints `label: url` instead |
| `\cvonly{a,b}{content}` | Content for certain variants |

## One source, several CVs

Tag content with `only` and pick a `variant`. Untagged content always prints, and with no `variant` everything prints.

```latex
\documentclass[variant=backend]{clearcv}

\begin{document}
\section{Experience}
\begin{cventry}[title = {Developer}, org = {Example GmbH}, only = {backend,fullstack}]
  \cvitem{Shown for backend and fullstack.}
  \cvitem[only = backend]{Shown for backend only.}
\end{cventry}
\end{document}
```

`\section[only=...]` filters the heading only. Wrap the section's body in `\cvonly` to filter that too.

Another way is one short document per CV, each with its own `\input` list, as the files in `cvs/` do. The two approaches can be combined.

## ATS and accessibility

The default output is already built for parsers: a single column, real text in reading order, and readable contact details beside each icon.

For portals with strict parsers, `ats=true` removes the photo, icons and colour, and prints full URLs. Make it a separate document so that the normal CV stays as it is.

To produce a tagged PDF for screen readers, put this before `\documentclass`:

```latex
\DocumentMetadata{lang=en-US, pdfversion=2.0, tagging=on}
```

A tagged build compiles and contains a PDF structure tree. It has not been checked with a PDF/UA validator or a commercial ATS, so test the PDF on the portal you are applying through.

## Customising

### Accent colour

```latex
\cvsetup{accent = teal}      % a preset
\cvsetup{accent = 0B4F8A}    % six hex digits, no #
```

A colour below 4.5:1 contrast on white compiles with a warning.

### Font

`font` takes any font installed on the system. The Docker image only has Carlito, so point `fontpath` at a folder of font files for anything else, with the path written from the repository root:

```latex
\cvsetup{
  font = SourceSans3,
  fontpath = fonts/,
  fontoptions = {
    Extension = .ttf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
    ItalicFont = *-Italic,
    BoldItalicFont = *-BoldItalic,
  },
}
```

### Icons

Use `\cvcontact` with a built-in icon for a contact type that has no command of its own:

```latex
\cvcontact{external-link}{My Portfolio}[https://example.com]
```

Built-in icons: `location`, `email`, `phone`, `website`, `linkedin`, `github`, `gitlab`, `stackoverflow`, `orcid`, `external-link`, `codeforces`, `leetcode`.

To add one, give `\cvdeficon` a name, the size of its drawing area and its outline as PDF path operators. The origin is the bottom-left corner, `m` moves, `l` draws a line, `c` draws a curve and `h` closes the path:

```latex
\cvdeficon{square}{512}{512}{64 64 m 448 64 l 448 448 l 64 448 l h}
\cvcontact{square}{Example}[https://example.com]
```

`theme/clearcv-icons.def` holds the built-in outlines, converted from SVG.

### Fitting the page

`density=compact` tightens all gaps at once. `sectiongap`, `entrygap`, `itemgap`, `fontsize`, `leading`, `marginx` and `marginy` adjust one thing at a time. `maxpages=2` warns when the CV runs over.

## Troubleshooting

| Message | Cause and fix |
| --- | --- |
| ``File `clearcv.cls' not found`` | The class is not on the search path. Run `latexmk` from the repository root, or copy the three theme files next to your document. |
| `clearcv requires LuaLaTeX` | The document was compiled with another engine. Use `latexmk -lualatex`, or set the compiler to LuaLaTeX. |
| `Unknown option 'x'` | A misspelt key in `\documentclass`, `\cvsetup`, `cventry` or the optional argument of `\cvitem`. Check the lists above. |
| `accent 'x' is neither a preset nor six hex digits` | Use a preset name, or a hex colour without `#`. |
| `accent x has 1.1:1 contrast on white` | A warning: the colour is hard to read on white. Pick a darker one. |
| `The CV has 3 pages; maxpages is 2` | A warning from `maxpages`. Shorten the content or use `density=compact`. |
| `The font "x" cannot be found` | The font is not installed where the compiler looks. Set `fontpath` and `fontoptions`; see [Font](#font). |
| ``File `photo.jpg' not found: using draft setting`` | Image paths are written from the document's folder or a folder on the search path. |
| An old layout stays after a change | Delete `build/` and build again. |

## License

The theme is released under the [MIT License](LICENSE). The bundled icons keep their own licenses, listed below.

Icons: [Font Awesome Free 5.15.4](https://fontawesome.com/license/free) (CC BY 4.0) and [Simple Icons](https://simpleicons.org) (CC0). Default font: [Carlito](https://ctan.org/pkg/carlito) (SIL OFL).
