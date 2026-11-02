#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $# -gt 0 ]]; then
  exec "$@"
fi

OUTDIR=${OUTDIR:-pdf}
AUXDIR=${AUXDIR:-build}
EXTRA_ARGS=${EXTRA_ARGS:-}
TARGETS=${TARGET:-}

mkdir -p "${OUTDIR}" "${AUXDIR}"

IFS=' ' read -r -a extra_array <<< "${EXTRA_ARGS}"

declare -a targets=()

if [[ -n "${TARGETS}" ]]; then
  read -r -a targets <<< "${TARGETS}"
else
  search_dirs=(.)
  [[ -d cvs ]] && search_dirs+=(cvs)
  while IFS= read -r -d '' file; do
    file=${file#./}
    targets+=("${file}")
  done < <(find "${search_dirs[@]}" -maxdepth 1 -type f -name '*.tex' -print0)
fi

if [[ ${#targets[@]} -eq 0 ]]; then
  echo "entrypoint: no .tex files found in the root or cvs/; nothing to build."
  exit 0
fi

status=0
for target in "${targets[@]}"; do
  echo "entrypoint: building ${target}"
  if ! latexmk \
    -synctex=0 \
    -interaction=nonstopmode \
    -file-line-error \
    -lualatex \
    -outdir="${OUTDIR}" \
    -auxdir="${AUXDIR}" \
    "${extra_array[@]}" \
    "${target}"; then
    status=1
    break
  fi
done

exit "$status"
