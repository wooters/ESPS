#!/usr/bin/env bash

set -u

usage() {
  cat <<'USAGE'
Usage: devtools/snapshot-docs-phase2-local.sh [options]

Run the phase-2 docs website build locally and package a one-time snapshot.

Options:
  --out-dir <path>           Build output directory (default: build/docs-phase2-local)
  --snapshot-dir <path>      Snapshot package directory (default: build/docs-phase2-snapshots)
  --strict <errors|warnings|none>
                             Strictness passed to phase-2 build (default: errors)
  --scope <core-plus>        Scope passed to phase-2 build (default: core-plus)
  --keep-going               Continue processing on per-item failures
  --base-url <path>          Base URL passed to phase-2 build (default: /)
  --venv <path>              Optional Python virtualenv path (prepends <venv>/bin to PATH)
  --dry-run                  Pass --dry-run to phase-2 build and skip packaging
  -h, --help                 Show help
USAGE
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

OUT_DIR="build/docs-phase2-local"
SNAPSHOT_DIR="build/docs-phase2-snapshots"
STRICT="errors"
SCOPE="core-plus"
KEEP_GOING=0
BASE_URL="/"
VENV_PATH=""
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out-dir)
      [[ $# -ge 2 ]] || { echo "error: --out-dir requires a value" >&2; exit 2; }
      OUT_DIR="$2"
      shift 2
      ;;
    --snapshot-dir)
      [[ $# -ge 2 ]] || { echo "error: --snapshot-dir requires a value" >&2; exit 2; }
      SNAPSHOT_DIR="$2"
      shift 2
      ;;
    --strict)
      [[ $# -ge 2 ]] || { echo "error: --strict requires a value" >&2; exit 2; }
      STRICT="$2"
      shift 2
      ;;
    --scope)
      [[ $# -ge 2 ]] || { echo "error: --scope requires a value" >&2; exit 2; }
      SCOPE="$2"
      shift 2
      ;;
    --keep-going)
      KEEP_GOING=1
      shift
      ;;
    --base-url)
      [[ $# -ge 2 ]] || { echo "error: --base-url requires a value" >&2; exit 2; }
      BASE_URL="$2"
      shift 2
      ;;
    --venv)
      [[ $# -ge 2 ]] || { echo "error: --venv requires a value" >&2; exit 2; }
      VENV_PATH="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ "$OUT_DIR" != /* ]]; then
  OUT_DIR="$REPO_ROOT/$OUT_DIR"
fi
if [[ "$SNAPSHOT_DIR" != /* ]]; then
  SNAPSHOT_DIR="$REPO_ROOT/$SNAPSHOT_DIR"
fi

if [[ -n "$VENV_PATH" ]]; then
  if [[ ! -d "$VENV_PATH/bin" ]]; then
    echo "error: --venv '$VENV_PATH' does not contain bin/" >&2
    exit 2
  fi
  export PATH="$VENV_PATH/bin:$PATH"
fi

build_cmd=(
  "$REPO_ROOT/devtools/build-docs-phase2.sh"
  --out-dir "$OUT_DIR"
  --strict "$STRICT"
  --scope "$SCOPE"
  --base-url "$BASE_URL"
)
if [[ "$KEEP_GOING" -eq 1 ]]; then
  build_cmd+=(--keep-going)
fi
if [[ "$DRY_RUN" -eq 1 ]]; then
  build_cmd+=(--dry-run)
fi

echo "running: ${build_cmd[*]}"
"${build_cmd[@]}"

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "dry-run requested; snapshot packaging skipped"
  exit 0
fi

required_outputs=(
  "$OUT_DIR/site"
  "$OUT_DIR/site-src"
  "$OUT_DIR/summary.md"
  "$OUT_DIR/summary.json"
  "$OUT_DIR/manifest.content.json"
  "$OUT_DIR/manifest.figures.json"
)
for p in "${required_outputs[@]}"; do
  if [[ ! -e "$p" ]]; then
    echo "error: expected output missing: $p" >&2
    exit 1
  fi
done

ts=$(date -u +%Y%m%dT%H%M%SZ)
sha=$(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)
name="esps-docs-phase2-${ts}-${sha}"
workdir="$SNAPSHOT_DIR/$name"
mkdir -p "$workdir"

cp -R "$OUT_DIR/site" "$workdir/"
cp -R "$OUT_DIR/site-src" "$workdir/"
cp -R "$OUT_DIR/assets" "$workdir/" 2>/dev/null || true
cp -R "$OUT_DIR/logs" "$workdir/" 2>/dev/null || true
cp "$OUT_DIR/summary.md" "$workdir/"
cp "$OUT_DIR/summary.json" "$workdir/"
cp "$OUT_DIR/manifest.content.json" "$workdir/"
cp "$OUT_DIR/manifest.figures.json" "$workdir/"

cat > "$workdir/SNAPSHOT_INFO.txt" <<INFO
ESPS Phase-2 Local Snapshot
Generated: ${ts}
Git commit: ${sha}
Source repo: ${REPO_ROOT}
Build out dir: ${OUT_DIR}
INFO

mkdir -p "$SNAPSHOT_DIR"
tar_path="$SNAPSHOT_DIR/${name}.tar.gz"
tar -czf "$tar_path" -C "$SNAPSHOT_DIR" "$name"

zip_path="$SNAPSHOT_DIR/${name}.zip"
if command -v zip >/dev/null 2>&1; then
  (
    cd "$SNAPSHOT_DIR"
    zip -qr "$zip_path" "$name"
  )
else
  echo "warning: zip command not found; zip package was not created" >&2
  zip_path=""
fi

echo "snapshot directory: $workdir"
echo "snapshot tarball: $tar_path"
if [[ -n "$zip_path" ]]; then
  echo "snapshot zip: $zip_path"
fi

exit 0
