# syntax=docker/dockerfile:1

# ---------------------------------------------------------------------------
# Stage 1: install a minimal TeX Live from CTAN.
#
# Debian's texlive-*-extra metapackages pull in several gigabytes to provide a
# handful of CTAN packages, so the toolchain is installed from upstream instead
# and trimmed to exactly what styles/ehsancv.sty requires.
# ---------------------------------------------------------------------------
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
    rm -rf \
      /usr/local/texlive/texmf-dist/doc \
      /usr/local/texlive/texmf-dist/source \
      /usr/local/texlive/tlpkg/backups \
      /tmp/texlive-packages.txt

# ---------------------------------------------------------------------------
# Stage 2: runtime image.
# ---------------------------------------------------------------------------
FROM debian:trixie-slim

LABEL org.opencontainers.image.source="https://github.com/ehsan18t/cv" \
    org.opencontainers.image.description="Minimal TeX Live toolchain with Calibri fonts for building the CV"

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/usr/local/texlive/bin/x86_64-linux:${PATH}"

COPY docker/apt-packages.txt /tmp/apt-packages.txt
RUN apt-get update && \
    grep -vE '^\s*(#|$)' /tmp/apt-packages.txt | xargs -r apt-get install -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/apt-packages.txt \
      /usr/share/doc/* /usr/share/man/* /usr/share/info/*

COPY --from=texlive /usr/local/texlive /usr/local/texlive

# Copy Calibri from the repository, then warm the luaotfload cache so the first
# real build does not pay for a full font scan.
COPY assets/fonts/ /usr/local/share/fonts/ehsancv/

RUN set -eux; \
    find /usr/local/share/fonts/ehsancv -type d -exec chmod 755 {} +; \
    find /usr/local/share/fonts/ehsancv -type f -exec chmod 644 {} +; \
    fc-cache -f; \
    luaotfload-tool --update

# Provide an entrypoint script that wraps latexmk with the required defaults.
COPY docker/entrypoint.sh /usr/local/bin/ehsancv-latex
RUN chmod +x /usr/local/bin/ehsancv-latex

WORKDIR /work

ENTRYPOINT ["/usr/local/bin/ehsancv-latex"]
CMD []
