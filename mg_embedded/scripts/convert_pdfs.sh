#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <pdf-source-directory> <text-output-directory>" >&2
    exit 2
fi

if ! command -v pdftotext >/dev/null 2>&1; then
    echo "pdftotext is required; install poppler-utils first." >&2
    exit 1
fi

if [[ ! -d "$1" ]]; then
    echo "PDF source directory does not exist: $1" >&2
    exit 1
fi

source_dir="$(cd -- "$1" && pwd -P)"
mkdir -p -- "$2"
output_dir="$(cd -- "$2" && pwd -P)"

mapfile -d '' -t pdf_files < <(find "$source_dir" -type f -iname '*.pdf' -print0)
if [[ ${#pdf_files[@]} -eq 0 ]]; then
    echo "No PDF files found under: $source_dir" >&2
    exit 1
fi

for pdf in "${pdf_files[@]}"; do
    relative_path="${pdf#"$source_dir"/}"
    output_path="$output_dir/${relative_path%.*}.txt"
    mkdir -p -- "$(dirname -- "$output_path")"
    pdftotext -layout "$pdf" "$output_path"
    printf 'Converted: %s -> %s\n' "$relative_path" "${output_path#"$output_dir"/}"
done
