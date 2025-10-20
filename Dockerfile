# syntax=docker/dockerfile:1
FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/ehsan18t/cv" \
    org.opencontainers.image.description="TeX Live toolchain with Calibri fonts for building the CV"

ENV DEBIAN_FRONTEND=noninteractive

# Install TeX Live full distribution, latexmk, and Inkscape for SVG conversion.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    texlive-full \
    latexmk \
    inkscape \
    python3 \
    make \
    fontconfig && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy Calibri fonts from the repository into the container and refresh the font cache.
COPY assets/fonts/ /usr/local/share/fonts/ehsancv/

RUN find /usr/local/share/fonts/ehsancv -type d -exec chmod 755 {} \; && \
    find /usr/local/share/fonts/ehsancv -type f -exec chmod 644 {} \; && \
    fc-cache -f && \
    luaotfload-tool --update

# Provide an entrypoint script that wraps latexmk with the required defaults.
COPY docker/entrypoint.sh /usr/local/bin/ehsancv-latex
RUN chmod +x /usr/local/bin/ehsancv-latex

WORKDIR /work

ENTRYPOINT ["/usr/local/bin/ehsancv-latex"]
CMD []
