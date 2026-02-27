#!/usr/bin/env bash

set -u

usage() {
  cat <<'USAGE'
Usage: devtools/publish-docs-github-pages.sh [options]

Build ESPS docs and publish them to a GitHub Pages branch.

Options:
  --out-dir <path>           Build output directory (default: build/docs-phase2-publish)
  --base-url <path>          Site base URL (default: /ESPS/)
  --branch <name>            Publish branch (default: gh-pages)
  --remote <name>            Git remote to push to (default: origin)
  --strict <errors|warnings|none>
                             Validation strictness passed to phase2 build (default: errors)
  --scope <core-plus>        Scope passed to phase2 build (default: core-plus)
  --keep-going               Continue after per-item failures during build (default: on)
  --no-keep-going            Disable --keep-going for phase2 build
  --dry-run                  Run full build/checks but skip branch mutation and push
  --no-push                  Prepare/commit branch contents but skip push
  --force                    Allow dirty working tree
  -h, --help                 Show help
USAGE
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

OUT_DIR="build/docs-phase2-publish"
BASE_URL="/ESPS/"
BRANCH="gh-pages"
REMOTE="origin"
STRICT="errors"
SCOPE="core-plus"
KEEP_GOING=1
DRY_RUN=0
NO_PUSH=0
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out-dir)
      [[ $# -ge 2 ]] || { echo "error: --out-dir requires a value" >&2; exit 2; }
      OUT_DIR="$2"
      shift 2
      ;;
    --base-url)
      [[ $# -ge 2 ]] || { echo "error: --base-url requires a value" >&2; exit 2; }
      BASE_URL="$2"
      shift 2
      ;;
    --branch)
      [[ $# -ge 2 ]] || { echo "error: --branch requires a value" >&2; exit 2; }
      BRANCH="$2"
      shift 2
      ;;
    --remote)
      [[ $# -ge 2 ]] || { echo "error: --remote requires a value" >&2; exit 2; }
      REMOTE="$2"
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
    --no-keep-going)
      KEEP_GOING=0
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --no-push)
      NO_PUSH=1
      shift
      ;;
    --force)
      FORCE=1
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

if [[ "$STRICT" != "errors" && "$STRICT" != "warnings" && "$STRICT" != "none" ]]; then
  echo "error: --strict must be one of: errors, warnings, none" >&2
  exit 2
fi

if [[ "$SCOPE" != "core-plus" ]]; then
  echo "error: unsupported scope '$SCOPE' (only 'core-plus' is supported)" >&2
  exit 2
fi

normalize_base_url() {
  local b="${1:-/}"
  b="${b#"${b%%[![:space:]]*}"}"
  b="${b%"${b##*[![:space:]]}"}"
  if [[ -z "$b" ]]; then
    b="/"
  fi
  if [[ "${b:0:1}" != "/" ]]; then
    b="/$b"
  fi
  if [[ "${b: -1}" != "/" ]]; then
    b="$b/"
  fi
  printf '%s\n' "$b"
}

BASE_URL="$(normalize_base_url "$BASE_URL")"

if [[ "$OUT_DIR" != /* ]]; then
  OUT_DIR="$REPO_ROOT/$OUT_DIR"
fi

if ! git -C "$REPO_ROOT" remote get-url "$REMOTE" >/dev/null 2>&1; then
  echo "error: remote '$REMOTE' does not exist" >&2
  exit 2
fi

if [[ "$FORCE" -eq 0 ]]; then
  if [[ -n "$(git -C "$REPO_ROOT" status --porcelain)" ]]; then
    echo "error: working tree is not clean; commit/stash changes or use --force" >&2
    exit 1
  fi
fi

build_cmd=(
  "$REPO_ROOT/devtools/build-docs-phase2.sh"
  --out-dir "$OUT_DIR"
  --base-url "$BASE_URL"
  --strict "$STRICT"
  --scope "$SCOPE"
)
if [[ "$KEEP_GOING" -eq 1 ]]; then
  build_cmd+=(--keep-going)
fi

echo "running: ${build_cmd[*]}"
"${build_cmd[@]}"

SITE_BUILD="$OUT_DIR/site"
if [[ ! -d "$SITE_BUILD" ]]; then
  echo "error: expected site build output missing: $SITE_BUILD" >&2
  exit 1
fi

source_sha=$(git -C "$REPO_ROOT" rev-parse --short HEAD)

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "dry-run: build completed; branch update/push skipped"
  echo "would publish branch '$BRANCH' to: https://wooters.github.io${BASE_URL}"
  exit 0
fi

worktree_parent=$(mktemp -d "${TMPDIR:-/tmp}/esps-gh-pages.XXXXXX")
worktree_dir="$worktree_parent/worktree"

cleanup() {
  if [[ -n "${worktree_dir:-}" && -d "$worktree_dir" ]]; then
    git -C "$REPO_ROOT" worktree remove --force "$worktree_dir" >/dev/null 2>&1 || true
  fi
  if [[ -n "${worktree_parent:-}" && -d "$worktree_parent" ]]; then
    rm -rf "$worktree_parent"
  fi
}
trap cleanup EXIT

if ! git -C "$REPO_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  if git -C "$REPO_ROOT" ls-remote --exit-code --heads "$REMOTE" "$BRANCH" >/dev/null 2>&1; then
    git -C "$REPO_ROOT" fetch "$REMOTE" "$BRANCH:$BRANCH"
  fi
fi

if git -C "$REPO_ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git -C "$REPO_ROOT" worktree add "$worktree_dir" "$BRANCH"
else
  git -C "$REPO_ROOT" worktree add -b "$BRANCH" "$worktree_dir"
fi

find "$worktree_dir" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
cp -R "$SITE_BUILD"/. "$worktree_dir"/
touch "$worktree_dir/.nojekyll"

git -C "$worktree_dir" add -A
if git -C "$worktree_dir" diff --cached --quiet; then
  echo "publish branch '$BRANCH' already up to date"
else
  git -C "$worktree_dir" commit -m "docs: publish ESPS site from $source_sha"
fi

if [[ "$NO_PUSH" -eq 1 ]]; then
  echo "publish prepared locally on branch '$BRANCH'; push skipped (--no-push)"
else
  git -C "$worktree_dir" push "$REMOTE" "$BRANCH"
  echo "published to: https://wooters.github.io${BASE_URL}"
fi

exit 0
