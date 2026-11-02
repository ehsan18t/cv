# syntax=docker/dockerfile:1

# Debian's texlive-*-extra metapackages pull in several gigabytes for a handful
# of CTAN packages, so TeX Live comes from upstream, trimmed to what simplycv.cls needs.
FROM debian:trixie-slim AS texlive

ENV DEBIAN_FRONTEND=noninteractive
ARG TEXLIVE_MIRROR=https://mirror.ctan.org/systems/texlive/tlnet

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl perl xz-utils && \
    rm -rf /var/lib/apt/lists/*

COPY docker/texlive-packages.txt /tmp/texlive-packages.txt

# A single TEXMFVAR shared by every user bakes the luaotfload font cache into
# the image, so no runtime volume is needed to keep font loading fast.
RUN set -eux; \
    mkdir -p /tmp/install-tl; \
    curl -fsSL "${TEXLIVE_MIRROR}/install-tl-unx.tar.gz" \
      | tar -xz -C /tmp/install-tl --strip-components=1; \
    printf '%s\n' \
      'selected_scheme scheme-basic' \
      'TEXDIR /usr/local/texlive' \
      'TEXMFLOCAL /usr/local/texlive/texmf-local' \
      'TEXMFSYSVAR /usr/local/texlive/texmf-var' \
      'TEXMFSYSCONFIG /usr/local/texlive/texmf-config' \
      'TEXMFVAR /usr/local/texlive/texmf-var' \
      'TEXMFCONFIG /usr/local/texlive/texmf-config' \
      'TEXMFHOME /usr/local/texlive/texmf-home' \
      'option_doc 0' \
      'option_src 0' \
      'instopt_adjustpath 0' \
      > /tmp/texlive.profile; \
    /tmp/install-tl/install-tl \
      --profile=/tmp/texlive.profile \
      --repository="${TEXLIVE_MIRROR}"; \
    rm -rf /tmp/install-tl

ENV PATH="/usr/local/texlive/bin/x86_64-linux:${PATH}"

RUN set -eux; \
    tlmgr option repository "${TEXLIVE_MIRROR}"; \
    tlmgr install $(grep -vE '^\s*(#|$)' /tmp/texlive-packages.txt); \
    cd /usr/local/texlive; \
    rm -rf \
      texmf-dist/doc \
      texmf-dist/source \
      texmf-dist/fonts/afm \
      texmf-dist/fonts/source \
      texmf-dist/fonts/pk \
      tlpkg \
      install-tl \
      install-tl.log \
      /tmp/texlive-packages.txt; \
    find texmf-dist/fonts/type1 -mindepth 2 -maxdepth 2 -type d \
      ! -path '*/public/amsfonts' ! -path '*/public/lm' -exec rm -rf {} +; \
    find texmf-var/web2c -mindepth 1 -maxdepth 1 -type d ! -name luahbtex -exec rm -rf {} +; \
    mktexlsr; \
    cd bin/x86_64-linux; \
    rm -f tlmgr pdftex pdflatex etex latex tex xdvi* dvi* xdvipdfmx *pdfmx pk* gf* mf* mft mk* \
      otf* odv* ovf* ovp* ofm* opl* tf* vf* vp* web* tangle weave ctangle cweave twill \
      bibtex bibtex8 makeindex mendex upbibtex

FROM debian:trixie-slim

LABEL org.opencontainers.image.source="https://github.com/ehsan18t/cv" \
    org.opencontainers.image.description="Minimal TeX Live toolchain for building the CV"

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/usr/local/texlive/bin/x86_64-linux:${PATH}"

COPY docker/apt-packages.txt /tmp/apt-packages.txt
RUN apt-get update && \
    grep -vE '^\s*(#|$)' /tmp/apt-packages.txt | xargs -r apt-get install -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/apt-packages.txt \
      /usr/share/doc/* /usr/share/man/* /usr/share/info/*

COPY --from=texlive /usr/local/texlive /usr/local/texlive

# Warm the luaotfload cache so the first real build does not pay for a full font scan.
RUN luaotfload-tool --update

# tlmgr exits 0 when a mirror download fails, leaving a broken toolchain.
RUN latexmk -v > /dev/null && \
    kpsewhich fontspec.sty luaotfload.sty microtype.sty geometry.sty xcolor.sty \
      graphicx.sty hyperref.sty Carlito-Regular.ttf > /dev/null

COPY docker/entrypoint.sh /usr/local/bin/simplycv-latex
RUN chmod +x /usr/local/bin/simplycv-latex

WORKDIR /work

ENTRYPOINT ["/usr/local/bin/simplycv-latex"]
CMD []
