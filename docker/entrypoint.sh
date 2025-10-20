#!/usr/bin/env bash
set -Eeuo pipefail

cleanup() {
  local aux_dir=${AUXDIR:-build}
  rm -rf "${aux_dir}" 2>/dev/null || true
  rm -rf svg-inkscape 2>/dev/null || true
}

run_external_command() {
  "$@"
  local status=$?
  cleanup
  exit "$status"
}

if [[ $# -gt 0 ]]; then
  run_external_command "$@"
fi

TARGET=${TARGET:-fullstack.tex}
OUTDIR=${OUTDIR:-pdf}
AUXDIR=${AUXDIR:-build}
EXTRA_ARGS=${EXTRA_ARGS:-}

mkdir -p "${OUTDIR}" "${AUXDIR}"

IFS=' ' read -r -a extra_array <<< "${EXTRA_ARGS}"

latexmk \
  -synctex=0 \
  -interaction=nonstopmode \
  -file-line-error \
  -lualatex \
  -shell-escape \
  -outdir="${OUTDIR}" \
  -auxdir="${AUXDIR}" \
  "${extra_array[@]}" \
  "${TARGET}"
status=$?

cleanup

exit "$status"
