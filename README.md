# ehsancv

A single-column CV class for LuaLaTeX. It reads well for people and extracts in clean reading order for applicant tracking systems (ATS). Compiling needs no shell escape and no external tools.

## Quick start

Copy `ehsancv.cls`, `ehsancv.lua` and `ehsancv-icons.def` next to your document, then compile with LuaLaTeX (TeX Live 2023 or newer). `example.tex` is a complete starting point.

```latex
\documentclass[paper=a4, accent=blue]{ehsancv}

\cvname{Jane Doe}
\cvsubtitle{Software Engineer}
\cvemail{jane@example.com}
\cvgithub{janedoe}

\begin{document}
\makecvheader

\section{Experience}
\begin{cventry}[title = {Software Engineer}, org = {Example GmbH}, from = {2022-03}, to = {present}]
  \cvitem{Reduced average API response time by \textbf{40\%}.}
\end{cventry}
\end{document}
```

On Overleaf, set the compiler to LuaLaTeX in the project menu.

## Options

Set options in `\documentclass[...]{ehsancv}` or with `\cvsetup{...}` in the preamble. Order does not matter, and an unknown key stops the build with an error.

| Key | Values (default first) | Effect |
| --- | --- | --- |
| `paper` | `a4`, `letter` | Page size |
| `accent` | `blue`, `teal`, `green`, `red`, `purple`, `orange`, `slate`, `black`, or six hex digits | Accent colour; warns below 4.5:1 contrast on white |
| `font` | `Carlito`, or any font name | Main font |
| `fontpath`, `fontoptions` | empty | fontspec `Path` and extra options for a custom `font` |
| `fontsize`, `leading` | `10.5pt`, `1.3` | Body size and line height factor |
| `marginx`, `marginy` | `43.5pt`, `37.5pt` | Page margins |
| `density` | `normal`, `compact`, `relaxed` | Scales the gaps below |
| `sectiongap`, `entrygap`, `itemgap` | `10.5pt`, `4.5pt`, `0.75pt` | Individual gaps |
| `subtitle` | `true`, `false` | Shows or hides `\cvsubtitle`; hiding leaves no gap |
| `photo` | `true`, `false` | Shows or hides `\cvphoto` |
| `photosize`, `photoshape`, `photofocus` | `auto` or a length, `circle` or `square`, `0.3` | Photo size, shape and vertical crop position (0 top, 1 bottom); `auto` matches the name and contact block, up to `69pt` |
| `photoborder`, `photobordercolor` | `1.8pt` (`0pt` for none), a lighter accent, six hex digits or an xcolor colour | Photo border, drawn inside `photosize` |
| `icons`, `linkicons` | `true`, `false` | Contact icons and the icon after `\cvlink` |
| `contactstyle` | `grid`, `inline` | Aligned columns or wrapped text; a grid too wide for the header wraps automatically |
| `contactcolumns` | `4` | Columns in the grid |
| `dateformat` | `short`, `long`, `numeric` | `Nov 2025`, `November 2025` or `11/2025` |
| `presentlabel` | `Present` | Text for `to = {present}` |
| `variant` | empty | Selects tagged content; see below |
| `ats` | `false`, `true` | Removes photo, icons and colour, and prints full URLs |
| `maxpages` | `0` (off) | Warns when the CV runs longer |
| `pagenumbers` | `false`, `true` | `Page 1 of 2` in the footer |
| `lastupdated` | empty | Text on the left of the footer |
| `pdftitle`, `pdfkeywords`, `lang` | `<name> CV`, empty, `en-US` | PDF metadata |

## Commands

| Command | Purpose |
| --- | --- |
| `\cvname{}`, `\cvsubtitle{}`, `\cvphoto{file}` | Header content |
| `\cvlocation{}`, `\cvemail{}`, `\cvphone{}`, `\cvwebsite{example.com}` | Contact details |
| `\cvlinkedin{user}`, `\cvgithub{user}`, `\cvgitlab{user}`, `\cvorcid{id}`, `\cvcodeforces{user}`, `\cvleetcode{user}`, `\cvstackoverflow{id}{name}` | Profiles |
| `\cvcontact{icon}{text}[url]` | Any other contact item; `icon` may be empty |
| `\cvdeficon{name}{width}{height}{PDF path}` | Adds an icon; see `ehsancv-icons.def` for the format |
| `\makecvheader` | Prints the header |
| `\section[only={...}]{Title}` | Section heading; a heading always stays with what follows |
| `\begin{cventry}[keys] ... \end{cventry}` | An experience, project or education entry |
| `\cvitem[only={...}]{text}`, `\cvsubitem[only={...}]{text}` | Bullets |
| `\cvskill{Label}{items}` | A `Label: items` line |
| `\cvnote{text}` | A short paragraph set apart from the entry above |
| `\cvlink{url}{label}` | A labelled link, in italics, with an icon |
| `\cvonly{a,b}{content}` | Content for certain variants |

`cventry` keys: `title`, `org`, `location`, `type`, `from`, `to`, `date`, `right`, `detail`, `detailright`, `only`.

- `from` and `to` take `YYYY-MM`, a plain year, or `present`, and are formatted by `dateformat`. `date` takes free text instead.
- `right` replaces the date with anything else, such as a link.
- `detail` and `detailright` fill the grey second line when `location` and `type` do not apply.
- The first two bullets of an entry stay on the same page as its heading.

## One source, several CVs

Tag content with `only` and pick a `variant`. Untagged content always prints, and with no `variant` everything prints.

```latex
\documentclass[variant=backend]{ehsancv}
...
\begin{cventry}[title = {Developer}, org = {Example GmbH}, only = {backend,fullstack}]
  \cvitem{Shown for backend and fullstack.}
  \cvitem[only = backend]{Shown for backend only.}
\end{cventry}
```

`\section[only=...]` filters the heading only. Wrap the section's body in `\cvonly` to filter that too.

## Tagged PDF

Put this before `\documentclass` to produce a tagged PDF for screen readers:

```latex
\DocumentMetadata{lang=en-US, pdfversion=2.0, tagging=on}
```

## Building with Docker

The image holds a minimal TeX Live, so nothing else needs installing. `docker compose build` builds it once.

| Command | Result |
| --- | --- |
| `docker compose run --rm cv-builder` | Builds every `.tex` file in the root into `pdf/` |
| `docker compose run --rm -e TARGET=example.tex cv-builder` | Builds one file |
| `docker compose run --rm cv-watch` | Rebuilds on save |

Auxiliary files go to `build/`. The VS Code settings in `.vscode/` use the same image through LaTeX Workshop.

## Credits

Icons: [Font Awesome Free 5.15.4](https://fontawesome.com/license/free) (CC BY 4.0) and [Simple Icons](https://simpleicons.org) (CC0). Default font: [Carlito](https://ctan.org/pkg/carlito) (SIL OFL).
