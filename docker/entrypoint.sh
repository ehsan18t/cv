#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $# -gt 0 ]]; then
  exec "$@"
fi

TARGET=${TARGET:-fullstack.tex}
OUTDIR=${OUTDIR:-pdf}
AUXDIR=${AUXDIR:-build}
EXTRA_ARGS=${EXTRA_ARGS:-}

mkdir -p "${OUTDIR}" "${AUXDIR}"

IFS=' ' read -r -a extra_array <<< "${EXTRA_ARGS}"

exec latexmk \
  -synctex=0 \
  -interaction=nonstopmode \
  -file-line-error \
  -lualatex \
  -shell-escape \
  -outdir="${OUTDIR}" \
  -auxdir="${AUXDIR}" \
  "${extra_array[@]}" \
  "${TARGET}"
