#!/usr/bin/env bash

set -u

usage() {
  cat <<'USAGE'
Usage: devtools/build-docs-phase2.sh [options]

Build a navigable docs website from ESPS legacy documentation sources.

Options:
  --out-dir <path>           Output directory (default: build/docs-phase2)
  --strict <errors|warnings|none>
                             Validation strictness (default: errors)
  --scope <core-plus>        Scope to build (default: core-plus)
  --keep-going               Continue after per-item failures
  --dry-run                  Discover/report only; no rendering
  --base-url <path>          Site base URL metadata (default: /)
  -h, --help                 Show help
USAGE
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
GENERAL_MAN_ROOT="$REPO_ROOT/ESPS/general/man"

OUT_DIR="build/docs-phase2"
STRICT="errors"
SCOPE="core-plus"
KEEP_GOING=0
DRY_RUN=0
BASE_URL="/"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out-dir)
      [[ $# -ge 2 ]] || { echo "error: --out-dir requires a value" >&2; exit 2; }
      OUT_DIR="$2"
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
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --base-url)
      [[ $# -ge 2 ]] || { echo "error: --base-url requires a value" >&2; exit 2; }
      BASE_URL="$2"
      shift 2
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

if [[ "$OUT_DIR" != /* ]]; then
  OUT_DIR="$REPO_ROOT/$OUT_DIR"
fi

PHASE1_OUT="$OUT_DIR/phase1-staging"
SITE_SRC="$OUT_DIR/site-src"
SITE_DOCS="$SITE_SRC/docs"
SITE_BUILD="$OUT_DIR/site"
ASSETS_DIR="$OUT_DIR/assets/figures"
SITE_ASSETS_DIR="$SITE_DOCS/assets/figures"
LOG_ROOT="$OUT_DIR/logs"

RESULTS_TSV="$OUT_DIR/.results.tsv"
CONTENT_TSV="$OUT_DIR/.content.tsv"
FIGURE_TSV="$OUT_DIR/.figures.tsv"

SUMMARY_JSON="$OUT_DIR/summary.json"
SUMMARY_MD="$OUT_DIR/summary.md"
MANIFEST_CONTENT_JSON="$OUT_DIR/manifest.content.json"
MANIFEST_FIGURES_JSON="$OUT_DIR/manifest.figures.json"

MISSING_REQUIRED_TXT="$OUT_DIR/.missing_required.txt"
MISSING_OPTIONAL_TXT="$OUT_DIR/.missing_optional.txt"

mkdir -p "$OUT_DIR" "$SITE_DOCS" "$ASSETS_DIR" "$SITE_ASSETS_DIR" "$LOG_ROOT"
: > "$RESULTS_TSV"
: > "$CONTENT_TSV"
: > "$FIGURE_TSV"
: > "$MISSING_REQUIRED_TXT"
: > "$MISSING_OPTIONAL_TXT"

escape_json() {
  printf '%s' "$1" | perl -0777 -pe 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g; s/\r/\\r/g; s/\t/\\t/g'
}

ensure_parent_dir() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
}

tool_hint() {
  case "$1" in
    pandoc)
      printf 'Install pandoc (macOS/Homebrew: brew install pandoc)'
      ;;
    mkdocs)
      printf 'Install MkDocs + Material (python3 -m pip install mkdocs mkdocs-material)'
      ;;
    nroff|troff|groff|refer|tbl|eqn|soelim)
      printf 'Install groff (macOS/Homebrew: brew install groff)'
      ;;
    col|ul|sed|awk|find)
      printf 'Provided by base system or bsdextrautils'
      ;;
    *)
      printf 'Install this tool and ensure it is on PATH'
      ;;
  esac
}

record_result() {
  local category="$1"
  local source="$2"
  local out_path="$3"
  local log_path="$4"
  local status="$5"
  local warn_count="$6"
  local err_count="$7"
  local message="$8"

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$category" "$source" "$out_path" "$log_path" "$status" "$warn_count" "$err_count" "$message" >> "$RESULTS_TSV"
}

add_content_entry() {
  local category="$1"
  local title="$2"
  local doc_rel="$3"
  local source_rel="$4"
  local section="${5:-}"
  printf '%s\t%s\t%s\t%s\t%s\n' "$category" "$title" "$doc_rel" "$source_rel" "$section" >> "$CONTENT_TSV"
}

add_figure_entry() {
  local kind="$1"
  local title="$2"
  local doc_rel="$3"
  local source_rel="$4"
  local asset_rel="$5"
  local status="$6"
  local warn_count="$7"
  local message="$8"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$kind" "$title" "$doc_rel" "$source_rel" "$asset_rel" "$status" "$warn_count" "$message" >> "$FIGURE_TSV"
}

resolve_man_so_target_path() {
  local token="$1"
  local base_dir="$2"

  case "$token" in
    \$MANDIR\$/man[135]/*)
      printf '%s/%s\n' "$GENERAL_MAN_ROOT" "${token#\$MANDIR\$/}"
      ;;
    /usr/esps/man/man[135]/*)
      printf '%s/%s\n' "$GENERAL_MAN_ROOT" "${token#/usr/esps/man/}"
      ;;
    man[135]/*)
      printf '%s/%s\n' "$GENERAL_MAN_ROOT" "$token"
      ;;
    /*)
      printf '%s\n' "$token"
      ;;
    *)
      printf '%s/%s\n' "$base_dir" "$token"
      ;;
  esac
}

resolve_man_stub_source() {
  local start_file="$1"
  local current="$start_file"
  local depth=0
  local token=""
  local next=""
  local visited=""

  while [[ "$depth" -lt 24 ]]; do
    token=$(awk '
      /^[[:space:]]*$/ { next }
      {
        if ($1 == ".\\\"") { next }
        if ($1 == ".so") { print $2 }
        exit
      }
    ' "$current")

    if [[ -z "$token" ]]; then
      break
    fi

    next=$(resolve_man_so_target_path "$token" "$(dirname "$current")")
    if [[ ! -f "$next" ]]; then
      break
    fi
    if [[ "$next" == "$current" ]]; then
      break
    fi
    if printf '%s\n' "$visited" | grep -Fxq "$next"; then
      break
    fi

    visited="${visited}"$'\n'"$next"
    current="$next"
    depth=$((depth + 1))
  done

  printf '%s\n' "$current"
}

write_manifest_files() {
  python3 - "$CONTENT_TSV" "$FIGURE_TSV" "$MANIFEST_CONTENT_JSON" "$MANIFEST_FIGURES_JSON" <<'PY'
import csv
import datetime as dt
import json
import sys

content_tsv, figure_tsv, out_content, out_figures = sys.argv[1:5]

generated_at = dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
content = {
    "generated_at": generated_at,
    "categories": {
        "man": [],
        "notes": [],
        "help": [],
        "extras": [],
    },
}

with open(content_tsv, newline="", encoding="utf-8") as f:
    for row in csv.reader(f, delimiter="\t"):
        if len(row) < 5:
            continue
        category, title, doc_rel, source_rel, section = row[:5]
        ent = {
            "title": title,
            "doc": doc_rel,
            "source": source_rel,
        }
        if section:
            ent["section"] = section
        content["categories"].setdefault(category, []).append(ent)

figures = {
    "generated_at": generated_at,
    "gps": [],
    "aw": [],
    "summary": {"gps_total": 0, "gps_warning": 0, "aw_total": 0, "aw_warning": 0},
}

with open(figure_tsv, newline="", encoding="utf-8") as f:
    for row in csv.reader(f, delimiter="\t"):
        if len(row) < 8:
            continue
        kind, title, doc_rel, source_rel, asset_rel, status, warn_count, message = row[:8]
        ent = {
            "title": title,
            "doc": doc_rel,
            "source": source_rel,
            "asset": asset_rel,
            "status": status,
            "warning_count": int(warn_count or 0),
            "message": message,
        }
        figures.setdefault(kind, []).append(ent)

figures["summary"]["gps_total"] = len(figures.get("gps", []))
figures["summary"]["gps_warning"] = sum(1 for x in figures.get("gps", []) if x.get("status") == "warning")
figures["summary"]["aw_total"] = len(figures.get("aw", []))
figures["summary"]["aw_warning"] = sum(1 for x in figures.get("aw", []) if x.get("status") == "warning")

with open(out_content, "w", encoding="utf-8") as f:
    json.dump(content, f, indent=2, ensure_ascii=True)
    f.write("\n")

with open(out_figures, "w", encoding="utf-8") as f:
    json.dump(figures, f, indent=2, ensure_ascii=True)
    f.write("\n")
PY
}

write_summary_files() {
  python3 - "$RESULTS_TSV" "$SUMMARY_JSON" "$SUMMARY_MD" "$MISSING_REQUIRED_TXT" "$MISSING_OPTIONAL_TXT" <<'PY'
import csv
import json
import sys

results_tsv, out_json, out_md, missing_req, missing_opt = sys.argv[1:6]

rows = []
with open(results_tsv, newline="", encoding="utf-8") as f:
    for row in csv.reader(f, delimiter="\t"):
        if len(row) < 8:
            continue
        rows.append({
            "category": row[0],
            "source": row[1],
            "output": row[2],
            "log": row[3],
            "status": row[4],
            "warnings": int(row[5] or 0),
            "errors": int(row[6] or 0),
            "message": row[7],
        })

totals = {
    "processed": len(rows),
    "success": sum(1 for r in rows if r["status"] == "success"),
    "warning": sum(1 for r in rows if r["status"] == "warning"),
    "error": sum(1 for r in rows if r["status"] == "error"),
}

categories = {}
for r in rows:
    c = categories.setdefault(r["category"], {"processed": 0, "success": 0, "warning": 0, "error": 0})
    c["processed"] += 1
    c[r["status"]] += 1

missing_required = []
with open(missing_req, encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if line:
            missing_required.append(line)

missing_optional = []
with open(missing_opt, encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if line:
            missing_optional.append(line)

status = "ok"
if missing_required:
    status = "preflight_failed"
elif totals["error"] > 0:
    status = "failed"

top_failures = [r for r in rows if r["status"] == "error"][:10]
top_warnings = [r for r in rows if r["status"] == "warning"][:10]

summary = {
    "status": status,
    "totals": totals,
    "categories": categories,
    "missing_required_tools": missing_required,
    "missing_optional_tools": missing_optional,
    "top_failures": top_failures,
    "top_warnings": top_warnings,
}

with open(out_json, "w", encoding="utf-8") as f:
    json.dump(summary, f, indent=2, ensure_ascii=True)
    f.write("\n")

md = []
md.append("# ESPS Phase-2 Docs Site Build Summary")
md.append("")
md.append(f"- Status: `{status}`")
md.append(f"- Processed: `{totals['processed']}`")
md.append(f"- Success: `{totals['success']}`")
md.append(f"- Warning: `{totals['warning']}`")
md.append(f"- Error: `{totals['error']}`")
md.append("")
md.append("## Categories")
md.append("")
md.append("| Category | Processed | Success | Warning | Error |")
md.append("|---|---:|---:|---:|---:|")
for cat in sorted(categories.keys()):
    c = categories[cat]
    md.append(f"| {cat} | {c['processed']} | {c['success']} | {c['warning']} | {c['error']} |")

if missing_required:
    md.append("")
    md.append("## Missing Required Tools")
    md.append("")
    for item in missing_required:
        md.append(f"- {item}")

if missing_optional:
    md.append("")
    md.append("## Missing Optional Tools")
    md.append("")
    for item in missing_optional:
        md.append(f"- {item}")

if top_failures:
    md.append("")
    md.append("## Top Failures")
    md.append("")
    for r in top_failures:
        md.append(f"- `{r['source']}` ({r['category']}): {r['message']}")

if top_warnings:
    md.append("")
    md.append("## Top Warnings")
    md.append("")
    for r in top_warnings:
        md.append(f"- `{r['source']}` ({r['category']}): {r['message']}")

with open(out_md, "w", encoding="utf-8") as f:
    f.write("\n".join(md) + "\n")
PY
}

required_tools=(pandoc python3 mkdocs nroff refer tbl eqn soelim col ul find awk sed)
optional_tools=(gs convert magick)

PRECHECK_FAILED=0
for t in "${required_tools[@]}"; do
  if ! command -v "$t" >/dev/null 2>&1; then
    PRECHECK_FAILED=1
    printf '%s - %s\n' "$t" "$(tool_hint "$t")" >> "$MISSING_REQUIRED_TXT"
  fi
done

for t in "${optional_tools[@]}"; do
  if ! command -v "$t" >/dev/null 2>&1; then
    printf '%s - %s\n' "$t" "optional; conversion fallback will be used" >> "$MISSING_OPTIONAL_TXT"
    record_result "preflight" "$t" "-" "-" "warning" "1" "0" "optional tool missing"
  fi
done

DOC_FIND=("$REPO_ROOT/ESPS/general/src/doc")
MAN_FIND=(
  "$REPO_ROOT/ESPS/general/man"
  "$REPO_ROOT/ESPS/ATT/waves/man"
  "$REPO_ROOT/ESPS/ATT/formant/man"
  "$REPO_ROOT/ESPS/general/src/lib_header/sphere2.6/doc/man"
)
HELP_FIND="$REPO_ROOT/ESPS/ATT/waves/text"

DOC_LIST=$(mktemp)
MAN_LIST=$(mktemp)
HELP_LIST=$(mktemp)
GPS_LIST=$(mktemp)
AW_LIST=$(mktemp)
EXTRA_MD_LIST=$(mktemp)

find "${DOC_FIND[@]}" -maxdepth 1 -type f \
  \( -name '*.me' -o -name '*.tme' -o -name '*.prme' -o -name '*.vrme' -o -name '*.vme' -o -name '*.vtme' \) \
  | LC_ALL=C sort > "$DOC_LIST"

find "${MAN_FIND[@]}" -type f \
  \( -name '*.1' -o -name '*.1t' -o -name '*.3' -o -name '*.3t' -o -name '*.5' -o -name '*.5t' \) \
  | LC_ALL=C sort > "$MAN_LIST"

find "$HELP_FIND" -maxdepth 1 -type f -name '*.help.src' | LC_ALL=C sort > "$HELP_LIST"
find "$REPO_ROOT/ESPS/general/src/doc" -type f -name '*.gps' | LC_ALL=C sort > "$GPS_LIST"
find "$REPO_ROOT/ESPS/general/src/doc" -type f -name '*.aw' | LC_ALL=C sort > "$AW_LIST"
find "$REPO_ROOT/ESPS" -type f -name '*.md' | LC_ALL=C sort > "$EXTRA_MD_LIST"

DOC_DISCOVERED=$(wc -l < "$DOC_LIST" | tr -d ' ')
MAN_DISCOVERED=$(wc -l < "$MAN_LIST" | tr -d ' ')
HELP_DISCOVERED=$(wc -l < "$HELP_LIST" | tr -d ' ')
GPS_DISCOVERED=$(wc -l < "$GPS_LIST" | tr -d ' ')
AW_DISCOVERED=$(wc -l < "$AW_LIST" | tr -d ' ')
EXTRA_DISCOVERED=$(wc -l < "$EXTRA_MD_LIST" | tr -d ' ')

record_result "discover" "doc" "-" "-" "success" "0" "0" "discovered $DOC_DISCOVERED"
record_result "discover" "man" "-" "-" "success" "0" "0" "discovered $MAN_DISCOVERED"
record_result "discover" "help" "-" "-" "success" "0" "0" "discovered $HELP_DISCOVERED"
record_result "discover" "gps" "-" "-" "success" "0" "0" "discovered $GPS_DISCOVERED"
record_result "discover" "aw" "-" "-" "success" "0" "0" "discovered $AW_DISCOVERED"
record_result "discover" "extras-md" "-" "-" "success" "0" "0" "discovered $EXTRA_DISCOVERED"

if [[ "$PRECHECK_FAILED" -ne 0 ]]; then
  write_manifest_files
  write_summary_files
  rm -f "$DOC_LIST" "$MAN_LIST" "$HELP_LIST" "$GPS_LIST" "$AW_LIST" "$EXTRA_MD_LIST"
  echo "preflight failed: missing required tools" >&2
  cat "$MISSING_REQUIRED_TXT" >&2
  exit 1
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  write_manifest_files
  write_summary_files
  rm -f "$DOC_LIST" "$MAN_LIST" "$HELP_LIST" "$GPS_LIST" "$AW_LIST" "$EXTRA_MD_LIST"
  echo "summary: $SUMMARY_MD"
  echo "summary-json: $SUMMARY_JSON"
  echo "dry-run complete"
  exit 0
fi

stop_now=0

PHASE1_LOG="$LOG_ROOT/phase1-staging.log"
if ! "$REPO_ROOT/devtools/compile-docs-phase1.sh" \
  --out-dir "$PHASE1_OUT" \
  --strict errors \
  --scope core \
  --keep-going > "$PHASE1_LOG" 2>&1; then
  record_result "phase1" "compile-docs-phase1" "$PHASE1_OUT" "$PHASE1_LOG" "error" "0" "1" "phase1 staging failed"
  stop_now=1
else
  record_result "phase1" "compile-docs-phase1" "$PHASE1_OUT" "$PHASE1_LOG" "success" "0" "0" "phase1 staging ok"
fi

if [[ "$stop_now" -eq 0 ]]; then
  while IFS= read -r src_abs; do
    rel="${src_abs#$REPO_ROOT/}"
    ext="${src_abs##*.}"
    section=""
    case "$ext" in
      1|1t) section="1" ;;
      3|3t) section="3" ;;
      5|5t) section="5" ;;
      *) section="misc" ;;
    esac

    base_name="$(basename "$src_abs")"
    name_noext="${base_name%.*}"

    resolved_src=$(resolve_man_stub_source "$src_abs")

    out_rel="man/$section/$name_noext.md"
    if [[ -f "$SITE_DOCS/$out_rel" ]]; then
      tree_key="generic"
      case "$rel" in
        ESPS/general/man/*) tree_key="general" ;;
        ESPS/ATT/waves/man/*) tree_key="waves" ;;
        ESPS/ATT/formant/man/*) tree_key="formant" ;;
        ESPS/general/src/lib_header/sphere2.6/doc/man/*) tree_key="sphere" ;;
      esac
      out_rel="man/$section/${name_noext}-${tree_key}.md"
      n=2
      while [[ -f "$SITE_DOCS/$out_rel" ]]; do
        out_rel="man/$section/${name_noext}-${tree_key}-${n}.md"
        n=$((n + 1))
      done
      collision_warn=1
    else
      collision_warn=0
    fi

    out_path="$SITE_DOCS/$out_rel"
    ensure_parent_dir "$out_path"
    log_path="$LOG_ROOT/${rel}.pandoc.log"
    ensure_parent_dir "$log_path"

    tmp_md=$(mktemp)
    if pandoc -f man -t gfm "$resolved_src" -o "$tmp_md" > "$log_path" 2>&1; then
      {
        printf '# %s (%s)\n\n' "$name_noext" "$section"
        printf -- '- Source: `%s`\n' "$rel"
        if [[ "$resolved_src" != "$src_abs" ]]; then
          printf -- '- Resolved from stub: `%s`\n' "${resolved_src#$REPO_ROOT/}"
        fi
        printf '\n'
        cat "$tmp_md"
        printf '\n'
      } > "$out_path"

      warn_count=0
      msg="ok"
      status="success"
      if [[ "$collision_warn" -eq 1 ]]; then
        msg="name collision; suffix applied"
      fi

      record_result "man" "$rel" "$out_path" "$log_path" "$status" "$warn_count" "0" "$msg"
      add_content_entry "man" "$name_noext($section)" "$out_rel" "$rel" "$section"

      if [[ "$ext" == "1t" || "$ext" == "3t" || "$ext" == "5t" ]]; then
        alias_rel="man/$section/${name_noext}.${ext}.md"
        alias_out="$SITE_DOCS/$alias_rel"
        ensure_parent_dir "$alias_out"
        {
          printf '# Alias: %s\n\n' "${name_noext}.${ext}"
          printf 'Canonical page: [%s](./%s)\n' "$name_noext" "$(basename "$out_rel")"
        } > "$alias_out"
        record_result "man-alias" "$rel" "$alias_out" "$log_path" "success" "0" "0" "alias stub created"
      fi
    else
      phase1_txt="$PHASE1_OUT/$rel.txt"
      if [[ -f "$phase1_txt" ]]; then
        {
          printf '# %s (%s)\n\n' "$name_noext" "$section"
          printf -- '- Source: `%s`\n' "$rel"
          printf -- '- Fallback: `pandoc` parse failed; using phase1 nroff text render\n\n'
          printf '```text\n'
          cat "$phase1_txt"
          printf '\n```\n'
        } > "$out_path"
        record_result "man" "$rel" "$out_path" "$log_path" "warning" "1" "0" "pandoc parse failed; used phase1 text fallback"
        add_content_entry "man" "$name_noext($section)" "$out_rel" "$rel" "$section"
      else
        record_result "man" "$rel" "$out_path" "$log_path" "error" "0" "1" "pandoc conversion failed and no phase1 fallback found"
        if [[ "$KEEP_GOING" -eq 0 ]]; then
          stop_now=1
          rm -f "$tmp_md"
          break
        fi
      fi
    fi
    rm -f "$tmp_md"
  done < "$MAN_LIST"
fi

if [[ "$stop_now" -eq 0 ]]; then
  find "$PHASE1_OUT/ESPS/general/src/doc" -maxdepth 1 -type f -name '*.txt' | LC_ALL=C sort | while IFS= read -r txt_abs; do
    rel_txt="${txt_abs#$PHASE1_OUT/}"
    rel_src="${rel_txt%.txt}"
    note_rel="notes/${rel_src}.md"
    note_out="$SITE_DOCS/$note_rel"
    log_path="$LOG_ROOT/${rel_src}.notes.log"
    ensure_parent_dir "$note_out"
    ensure_parent_dir "$log_path"

    {
      printf '# %s\n\n' "$(basename "$rel_src")"
      printf -- '- Source: `%s`\n\n' "$rel_src"
      printf '```text\n'
      cat "$txt_abs"
      printf '\n```\n'
    } > "$note_out" 2> "$log_path"

    record_result "notes" "$rel_src" "$note_out" "$log_path" "success" "0" "0" "rendered from phase1 text"
    add_content_entry "notes" "$(basename "$rel_src")" "$note_rel" "$rel_src" ""
  done
fi

if [[ "$stop_now" -eq 0 ]]; then
  find "$PHASE1_OUT/ESPS/ATT/waves/text" -maxdepth 1 -type f -name '*.help' | LC_ALL=C sort | while IFS= read -r help_abs; do
    rel_help="${help_abs#$PHASE1_OUT/}"
    help_rel="help/${rel_help}.md"
    help_out="$SITE_DOCS/$help_rel"
    log_path="$LOG_ROOT/${rel_help}.help.log"
    ensure_parent_dir "$help_out"
    ensure_parent_dir "$log_path"

    {
      printf '# %s\n\n' "$(basename "$rel_help")"
      printf -- '- Source: `%s`\n\n' "$rel_help"
      printf '```text\n'
      cat "$help_abs"
      printf '\n```\n'
    } > "$help_out" 2> "$log_path"

    record_result "help" "$rel_help" "$help_out" "$log_path" "success" "0" "0" "rendered from phase1 help"
    add_content_entry "help" "$(basename "$rel_help")" "$help_rel" "$rel_help" ""
  done
fi

if [[ "$stop_now" -eq 0 ]]; then
  while IFS= read -r md_abs; do
    rel="${md_abs#$REPO_ROOT/}"

    case "$rel" in
      ESPS/general/man/*|ESPS/ATT/waves/man/*|ESPS/ATT/formant/man/*|ESPS/general/src/lib_header/sphere2.6/doc/man/*)
        continue
        ;;
    esac

    extra_rel="extras/$rel"
    extra_out="$SITE_DOCS/$extra_rel"
    log_path="$LOG_ROOT/${rel}.extras.log"
    ensure_parent_dir "$extra_out"
    ensure_parent_dir "$log_path"

    {
      printf '<!-- Source: %s -->\n\n' "$rel"
      cat "$md_abs"
      printf '\n'
    } > "$extra_out" 2> "$log_path"

    record_result "extras" "$rel" "$extra_out" "$log_path" "success" "0" "0" "copied markdown extra"
    add_content_entry "extras" "$(basename "${rel%.md}")" "$extra_rel" "$rel" ""
  done < "$EXTRA_MD_LIST"
fi

if [[ "$stop_now" -eq 0 ]]; then
  while IFS= read -r gps_abs; do
    rel="${gps_abs#$REPO_ROOT/}"
    rel_under_doc="${rel#ESPS/general/src/doc/}"
    asset_rel="gps/${rel_under_doc%.gps}.svg"
    asset_out="$ASSETS_DIR/$asset_rel"
    site_asset_out="$SITE_ASSETS_DIR/$asset_rel"
    doc_rel="figures/gps/${rel_under_doc}.md"
    doc_rel="${doc_rel%.gps.md}.md"
    doc_out="$SITE_DOCS/$doc_rel"
    log_path="$LOG_ROOT/${rel}.gps.log"
    json_path="$LOG_ROOT/${rel}.gps.json"

    ensure_parent_dir "$asset_out"
    ensure_parent_dir "$site_asset_out"
    ensure_parent_dir "$doc_out"
    ensure_parent_dir "$log_path"
    ensure_parent_dir "$json_path"

    if "$REPO_ROOT/devtools/docs_phase2/gps_to_svg.py" "$gps_abs" "$asset_out" > "$json_path" 2> "$log_path"; then
      status=$(python3 - "$json_path" <<'PY'
import json,sys
j=json.load(open(sys.argv[1]))
print(j.get('status','error'))
PY
)
      warn_count=$(python3 - "$json_path" <<'PY'
import json,sys
j=json.load(open(sys.argv[1]))
print(len(j.get('warnings',[])))
PY
)
      message=$(python3 - "$json_path" <<'PY'
import json,sys
j=json.load(open(sys.argv[1]))
w=j.get('warnings',[])
print(w[0] if w else 'ok')
PY
)

      cp "$asset_out" "$site_asset_out"
      web_asset="assets/figures/$asset_rel"
      {
        printf '# %s\n\n' "$(basename "$rel_under_doc")"
        printf -- '- Source: `%s`\n' "$rel"
        printf -- '- Status: `%s`\n\n' "$status"
        printf '![%s](/%s)\n\n' "$(basename "$rel_under_doc")" "$web_asset"
      } > "$doc_out"

      if [[ "$status" == "success" ]]; then
        record_result "figure:gps" "$rel" "$asset_out" "$log_path" "success" "0" "0" "$message"
      else
        record_result "figure:gps" "$rel" "$asset_out" "$log_path" "warning" "$warn_count" "0" "$message"
      fi
      add_figure_entry "gps" "$(basename "$rel_under_doc")" "$doc_rel" "$rel" "$web_asset" "$status" "$warn_count" "$message"
    else
      record_result "figure:gps" "$rel" "$asset_out" "$log_path" "error" "0" "1" "gps conversion command failed"
      add_figure_entry "gps" "$(basename "$rel_under_doc")" "$doc_rel" "$rel" "assets/figures/$asset_rel" "error" "0" "gps conversion command failed"
      if [[ "$KEEP_GOING" -eq 0 ]]; then
        stop_now=1
        break
      fi
    fi
  done < "$GPS_LIST"
fi

if [[ "$stop_now" -eq 0 ]]; then
  while IFS= read -r aw_abs; do
    rel="${aw_abs#$REPO_ROOT/}"
    rel_under_doc="${rel#ESPS/general/src/doc/}"
    out_base_rel="aw/${rel_under_doc%.aw}"
    out_base="$ASSETS_DIR/$out_base_rel"
    log_path="$LOG_ROOT/${rel}.aw.log"
    json_path="$LOG_ROOT/${rel}.aw.json"

    ensure_parent_dir "$out_base"
    ensure_parent_dir "$log_path"
    ensure_parent_dir "$json_path"

    if "$REPO_ROOT/devtools/docs_phase2/aw_convert.py" "$aw_abs" "$out_base" > "$json_path" 2> "$log_path"; then
      status=$(python3 - "$json_path" <<'PY'
import json,sys
j=json.load(open(sys.argv[1]))
print(j.get('status','warning'))
PY
)
      warn_count=$(python3 - "$json_path" <<'PY'
import json,sys
j=json.load(open(sys.argv[1]))
print(len(j.get('warnings',[])))
PY
)
      message=$(python3 - "$json_path" <<'PY'
import json,sys
j=json.load(open(sys.argv[1]))
w=j.get('warnings',[])
print(w[0] if w else 'ok')
PY
)
      asset_path=$(python3 - "$json_path" <<'PY'
import json,sys
j=json.load(open(sys.argv[1]))
print(j.get('asset',''))
PY
)
      report_path=$(python3 - "$json_path" <<'PY'
import json,sys
j=json.load(open(sys.argv[1]))
print(j.get('report',''))
PY
)

      asset_rel="${asset_path#$ASSETS_DIR/}"
      report_rel="${report_path#$ASSETS_DIR/}"
      site_asset_out="$SITE_ASSETS_DIR/$asset_rel"
      site_report_out="$SITE_ASSETS_DIR/$report_rel"
      ensure_parent_dir "$site_asset_out"
      ensure_parent_dir "$site_report_out"
      if [[ -f "$asset_path" ]]; then
        cp "$asset_path" "$site_asset_out"
      fi
      if [[ -f "$report_path" ]]; then
        cp "$report_path" "$site_report_out"
      fi

      doc_rel="figures/aw/${rel_under_doc}.md"
      doc_rel="${doc_rel%.aw.md}.md"
      doc_out="$SITE_DOCS/$doc_rel"
      ensure_parent_dir "$doc_out"

      {
        printf '# %s\n\n' "$(basename "$rel_under_doc")"
        printf -- '- Source: `%s`\n' "$rel"
        printf -- '- Status: `%s`\n' "$status"
        printf -- '- Adapter report: `/assets/figures/%s`\n\n' "$report_rel"
        if [[ -n "$asset_rel" ]]; then
          printf '![%s](/assets/figures/%s)\n\n' "$(basename "$rel_under_doc")" "$asset_rel"
        fi
      } > "$doc_out"

      if [[ "$status" == "success" ]]; then
        record_result "figure:aw" "$rel" "$asset_path" "$log_path" "success" "0" "0" "$message"
      else
        record_result "figure:aw" "$rel" "$asset_path" "$log_path" "warning" "$warn_count" "0" "$message"
      fi
      add_figure_entry "aw" "$(basename "$rel_under_doc")" "$doc_rel" "$rel" "assets/figures/$asset_rel" "$status" "$warn_count" "$message"
    else
      record_result "figure:aw" "$rel" "$out_base" "$log_path" "error" "0" "1" "aw conversion command failed"
      add_figure_entry "aw" "$(basename "$rel_under_doc")" "" "$rel" "" "error" "0" "aw conversion command failed"
      if [[ "$KEEP_GOING" -eq 0 ]]; then
        stop_now=1
        break
      fi
    fi
  done < "$AW_LIST"
fi

write_manifest_files

# Build report pages (copied into the site source).
mkdir -p "$SITE_DOCS/build-reports"
{
  printf '# Content Manifest\n\n'
  printf '```json\n'
  cat "$MANIFEST_CONTENT_JSON"
  printf '```\n'
} > "$SITE_DOCS/build-reports/manifest-content.md"

{
  printf '# Figure Manifest\n\n'
  printf '```json\n'
  cat "$MANIFEST_FIGURES_JSON"
  printf '```\n'
} > "$SITE_DOCS/build-reports/manifest-figures.md"

{
  printf '# Summary\n\n'
  printf 'Build is in progress; this placeholder is replaced with final summary output.\n'
} > "$SITE_DOCS/build-reports/summary.md"

if [[ "$stop_now" -eq 0 ]]; then
  NAV_LOG="$LOG_ROOT/build-nav.log"
  if "$REPO_ROOT/devtools/docs_phase2/build_nav.py" \
    --site-src "$SITE_SRC" \
    --manifest-content "$MANIFEST_CONTENT_JSON" \
    --manifest-figures "$MANIFEST_FIGURES_JSON" \
    --base-url "$BASE_URL" > "$NAV_LOG" 2>&1; then
    record_result "nav" "build_nav.py" "$SITE_SRC/mkdocs.yml" "$NAV_LOG" "success" "0" "0" "mkdocs nav generated"
  else
    record_result "nav" "build_nav.py" "$SITE_SRC/mkdocs.yml" "$NAV_LOG" "error" "0" "1" "failed to generate nav"
    if [[ "$KEEP_GOING" -eq 0 ]]; then
      stop_now=1
    fi
  fi
fi

if [[ "$stop_now" -eq 0 ]]; then
  MKDOCS_LOG="$LOG_ROOT/mkdocs-build.log"
  if mkdocs build -f "$SITE_SRC/mkdocs.yml" -d "$SITE_BUILD" > "$MKDOCS_LOG" 2>&1; then
    record_result "site-build" "mkdocs" "$SITE_BUILD" "$MKDOCS_LOG" "success" "0" "0" "site build complete"
  else
    record_result "site-build" "mkdocs" "$SITE_BUILD" "$MKDOCS_LOG" "error" "0" "1" "mkdocs build failed"
    if [[ "$KEEP_GOING" -eq 0 ]]; then
      stop_now=1
    fi
  fi
fi

if [[ "$stop_now" -eq 0 && -d "$SITE_BUILD" ]]; then
  LINKCHECK_LOG="$LOG_ROOT/linkcheck.log"
  LINKCHECK_JSON="$LOG_ROOT/linkcheck.json"
  if "$REPO_ROOT/devtools/docs_phase2/linkcheck.py" --site-dir "$SITE_BUILD" --out-json "$LINKCHECK_JSON" > "$LINKCHECK_LOG" 2>&1; then
    record_result "linkcheck" "site" "$SITE_BUILD" "$LINKCHECK_LOG" "success" "0" "0" "internal links OK"
  else
    record_result "linkcheck" "site" "$SITE_BUILD" "$LINKCHECK_LOG" "error" "0" "1" "broken internal links"
  fi
fi

write_summary_files

cp "$SUMMARY_MD" "$SITE_DOCS/build-reports/summary.md"

# Re-run nav once after build-report pages exist, then rebuild site quickly.
if [[ -f "$SITE_SRC/mkdocs.yml" ]]; then
  "$REPO_ROOT/devtools/docs_phase2/build_nav.py" \
    --site-src "$SITE_SRC" \
    --manifest-content "$MANIFEST_CONTENT_JSON" \
    --manifest-figures "$MANIFEST_FIGURES_JSON" \
    --base-url "$BASE_URL" >/dev/null 2>&1 || true
  mkdocs build -f "$SITE_SRC/mkdocs.yml" -d "$SITE_BUILD" >/dev/null 2>&1 || true
fi

TOTAL_WARNING=$(awk -F'\t' '($5=="warning"){c++} END{print c+0}' "$RESULTS_TSV")
TOTAL_ERROR=$(awk -F'\t' '($5=="error"){c++} END{print c+0}' "$RESULTS_TSV")
TOTAL_PROCESSED=$(awk -F'\t' 'END{print NR+0}' "$RESULTS_TSV")
TOTAL_SUCCESS=$(awk -F'\t' '($5=="success"){c++} END{print c+0}' "$RESULTS_TSV")

exit_code=0
run_status="ok"

if [[ "$TOTAL_ERROR" -gt 0 ]]; then
  run_status="failed"
fi

case "$STRICT" in
  errors)
    if [[ "$TOTAL_ERROR" -gt 0 ]]; then
      exit_code=1
      run_status="failed"
    fi
    ;;
  warnings)
    if [[ "$TOTAL_ERROR" -gt 0 || "$TOTAL_WARNING" -gt 0 ]]; then
      exit_code=1
      run_status="failed"
    fi
    ;;
  none)
    exit_code=0
    ;;
esac

if [[ -s "$MISSING_REQUIRED_TXT" ]]; then
  exit_code=1
  run_status="preflight_failed"
fi

echo "summary: $SUMMARY_MD"
echo "summary-json: $SUMMARY_JSON"
echo "manifest-content: $MANIFEST_CONTENT_JSON"
echo "manifest-figures: $MANIFEST_FIGURES_JSON"
echo "site-src: $SITE_SRC"
echo "site: $SITE_BUILD"
echo "processed: $TOTAL_PROCESSED success=$TOTAL_SUCCESS warning=$TOTAL_WARNING error=$TOTAL_ERROR status=$run_status"

rm -f "$DOC_LIST" "$MAN_LIST" "$HELP_LIST" "$GPS_LIST" "$AW_LIST" "$EXTRA_MD_LIST"

exit "$exit_code"
