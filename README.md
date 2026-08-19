# CV Template

This repository now uses a reusable LuaLaTeX template so you can maintain several CV variants (backend, frontend, full-stack, etc.) without rewriting the layout each time.

## Quick Start

1. Install Docker and run `docker compose build` once to create the `ehsancv/latex:latest` image with LuaLaTeX, Inkscape (for SVG conversion), bundled Calibri fonts, and `latexmk`.
2. Build every root-level CV variant with `docker compose run --rm cv-builder`. PDFs land in `pdf/` and the build directory is cleaned automatically.

> You can skip step 1. The `cv-builder` service builds its own image on first use, so `docker compose run --rm cv-builder` works from a fresh clone.

3. Open `cv-config.tex` and adjust `\cvsetup{...}` to update name, tagline, colours, PDF metadata, and contact details.
4. Switch between content variants by changing the `\input{sections/...}` lines in any root `.tex` file (e.g. swap the `about` and `skills` files for backend or frontend versions).

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

## Build Artifacts

Compiled files are ignored via `.gitignore` (`out/`, `*.pdf`, etc.). Commit only the `.tex`, `.sty`, and asset sources.

## Dockerised Workflow

Everything runs through Docker Compose, so the only prerequisite is Docker itself. No LaTeX distribution is installed on your machine.

### Command reference

| What you want | Command |
| --- | --- |
| Build every root-level `.tex` into `pdf/` | `docker compose run --rm cv-builder` |
| Build one variant | `docker compose run --rm -e TARGET="Ehsan_Khan__Frontend.tex" cv-builder` |
| Build a subset | `docker compose run --rm -e TARGET="Ehsan_Khan__Frontend.tex Ehsan_Khan__Backend.tex" cv-builder` |
| Rebuild continuously as you save | `docker compose run --rm cv-watch` |
| Delete auxiliary files and PDFs | `docker compose run --rm -e EXTRA_ARGS="-C" cv-builder` |

Run these from the repository root. Every command uses `--rm`, so no containers are left behind.

### Maintaining the image

| When | Command |
| --- | --- |
| First run, or after editing `Dockerfile`, `docker/apt-packages.txt`, `docker/texlive-packages.txt`, or `assets/fonts/` | `docker compose build` |
| The image is in a bad state and you want it rebuilt from scratch | `docker compose build --no-cache` |
| Free the disk space the image occupies | `docker image rm ehsancv/latex:latest` |

Day-to-day editing of `.tex`, `.sty`, and `sections/` files needs no rebuild. The repository is bind-mounted into the container at `/work`, so the running image always sees your latest sources.

### Running an arbitrary command in the container

The entrypoint executes any arguments you pass instead of its default build loop, which is useful for one-off tooling:

```sh
docker compose run --rm cv-builder texcount Ehsan_Khan__FullStack.tex
docker compose run --rm cv-builder kpsewhich paracol.sty
docker compose run --rm cv-builder bash
```

### How it works

- The container entrypoint (`docker/entrypoint.sh`) scans the repository root for `*.tex` files and runs `latexmk` over each one unless you provide a specific list through `TARGET="frontend.tex backend.tex"`.
- Override auxiliary paths via `OUTDIR` and `AUXDIR` environment variables (defaults are `pdf` and `build`). Temporary directories are removed after each run.
- `EXTRA_ARGS` is forwarded verbatim to `latexmk`, so any flag that tool accepts can be passed through.
- Fonts in `assets/fonts/Calibri` are baked into the image and registered with `fontconfig`/`luaotfload`, so the CV always renders with the intended family and weights.

### Image contents

The image is built in two stages to keep it small: roughly 890 MB, down from 4.3 GB. Rather than installing Debian's `texlive-*-extra` metapackages, which ship thousands of CTAN packages to deliver the couple of dozen this template needs, TeX Live is installed from CTAN with `scheme-basic` plus an explicit package list.

- `docker/texlive-packages.txt` lists the CTAN packages. **If you add a `\RequirePackage` to `styles/ehsancv.sty`, add it here too and run `docker compose build`**, otherwise the build will fail with a missing `.sty` file. To find the right name before committing to a rebuild, experiment inside the container with `docker compose run --rm cv-builder tlmgr install <package>`.
- `docker/apt-packages.txt` lists the operating system packages in the final image (`fontconfig`, `perl` for `latexmk`, `curl` so `tlmgr` can fetch packages, and `inkscape` for the `svg` package).
- Documentation and sources are excluded from the TeX Live install, and the `luaotfload` font cache is warmed at build time so the first compile is not slower than the rest.

### VS Code integration

- LaTeX Workshop is configured to execute all recipes inside the Docker image. Trigger `Build LaTeX project` and the active root `.tex` compiles in the container, keeping the workflow consistent across operating systems.
- The default task `Docker latexmk (all root tex)` simply calls `docker compose run --rm cv-builder`, so you can rebuild every variant from the command palette without remembering the CLI.
- Word counts (`LaTeX Workshop: Count words in LaTeX project`) also run inside the container via `texcount`, matching the fonts and macros available to the build.

## VS Code

- The workspace ships with LaTeX Workshop settings pointing at LuaLaTeX + `latexmk` recipes (Docker-backed) and disables the outline to reduce log noise.
- If you prefer manual builds, run `docker compose run --rm cv-builder` directly or invoke the provided VS Code task.

Happy typesetting!
