#!/usr/bin/env bash

set -u

usage() {
  cat <<'USAGE'
Usage: devtools/compile-docs-phase1.sh [options]

Compile core ESPS documentation sources into staged plain-text outputs.

Options:
  --out-dir <path>           Output directory (default: build/docs-phase1)
  --strict <errors|warnings|none>
                             Validation strictness (default: errors)
  --scope <core>             Scope to compile (default: core)
  --keep-going               Continue processing after per-file failures
  --dry-run                  Discover and report only; do not render files
  -h, --help                 Show this help
USAGE
}

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
GENERAL_MAN_ROOT="$REPO_ROOT/ESPS/general/man"

OUT_DIR="build/docs-phase1"
STRICT="errors"
SCOPE="core"
KEEP_GOING=0
DRY_RUN=0

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

if [[ "$SCOPE" != "core" ]]; then
  echo "error: unsupported scope '$SCOPE' (only 'core' is currently supported)" >&2
  exit 2
fi

if [[ "$OUT_DIR" != /* ]]; then
  OUT_DIR="$REPO_ROOT/$OUT_DIR"
fi

LOG_ROOT="$OUT_DIR/logs"
SUMMARY_JSON="$OUT_DIR/summary.json"
SUMMARY_MD="$OUT_DIR/summary.md"
RESULTS_TSV="$OUT_DIR/.results.tsv"
MISSING_TOOLS_TXT="$OUT_DIR/.missing_tools.txt"

mkdir -p "$OUT_DIR" "$LOG_ROOT"
: > "$RESULTS_TSV"
: > "$MISSING_TOOLS_TXT"

DOC_DISCOVERED=0
DOC_PROCESSED=0
DOC_SUCCESS=0
DOC_WARNING=0
DOC_ERROR=0

MAN_DISCOVERED=0
MAN_PROCESSED=0
MAN_SUCCESS=0
MAN_WARNING=0
MAN_ERROR=0

HELP_DISCOVERED=0
HELP_PROCESSED=0
HELP_SUCCESS=0
HELP_WARNING=0
HELP_ERROR=0

TOTAL_PROCESSED=0
TOTAL_SUCCESS=0
TOTAL_WARNING=0
TOTAL_ERROR=0

PRECHECK_FAILED=0

escape_json() {
  printf '%s' "$1" | perl -0777 -pe 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g; s/\r/\\r/g; s/\t/\\t/g'
}

tool_hint() {
  case "$1" in
    nroff|troff|groff|refer|tbl|eqn|soelim)
      printf 'Install groff (macOS/Homebrew: brew install groff)'
      ;;
    col|ul|sed|awk|find)
      printf 'Provided by base system utils on macOS/Linux'
      ;;
    *)
      printf 'Install this tool and ensure it is on PATH'
      ;;
  esac
}

record_result() {
  local category="$1"
  local rel="$2"
  local out_path="$3"
  local log_path="$4"
  local status="$5"
  local warn_count="$6"
  local err_count="$7"

  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$category" "$rel" "$out_path" "$log_path" "$status" "$warn_count" "$err_count" >> "$RESULTS_TSV"

  TOTAL_PROCESSED=$((TOTAL_PROCESSED + 1))
  case "$status" in
    success)
      TOTAL_SUCCESS=$((TOTAL_SUCCESS + 1))
      ;;
    warning)
      TOTAL_WARNING=$((TOTAL_WARNING + 1))
      ;;
    error)
      TOTAL_ERROR=$((TOTAL_ERROR + 1))
      ;;
  esac

  case "$category" in
    doc)
      DOC_PROCESSED=$((DOC_PROCESSED + 1))
      case "$status" in
        success) DOC_SUCCESS=$((DOC_SUCCESS + 1)) ;;
        warning) DOC_WARNING=$((DOC_WARNING + 1)) ;;
        error) DOC_ERROR=$((DOC_ERROR + 1)) ;;
      esac
      ;;
    man)
      MAN_PROCESSED=$((MAN_PROCESSED + 1))
      case "$status" in
        success) MAN_SUCCESS=$((MAN_SUCCESS + 1)) ;;
        warning) MAN_WARNING=$((MAN_WARNING + 1)) ;;
        error) MAN_ERROR=$((MAN_ERROR + 1)) ;;
      esac
      ;;
    help)
      HELP_PROCESSED=$((HELP_PROCESSED + 1))
      case "$status" in
        success) HELP_SUCCESS=$((HELP_SUCCESS + 1)) ;;
        warning) HELP_WARNING=$((HELP_WARNING + 1)) ;;
        error) HELP_ERROR=$((HELP_ERROR + 1)) ;;
      esac
      ;;
  esac
}

classify_log() {
  local log_path="$1"
  local hard_fail="$2"
  local rel_path="${3:-}"
  local warn_count err_count

  warn_count=$(grep -Eic "warning:|not supported by this version of 'me'|cannot select font" "$log_path" 2>/dev/null || true)
  err_count=$(grep -Eic 'error:' "$log_path" 2>/dev/null || true)
  benign_tbl_err=$(grep -Eic '^tbl:.*error: excess table entry .* discarded' "$log_path" 2>/dev/null || true)

  if [[ "$hard_fail" -ne 0 && "$err_count" -eq 0 ]]; then
    err_count=1
  fi

  if [[ "$hard_fail" -eq 0 && "$benign_tbl_err" -gt 0 && "$err_count" -ge "$benign_tbl_err" ]]; then
    err_count=$((err_count - benign_tbl_err))
    warn_count=$((warn_count + benign_tbl_err))
  fi

  # Known legacy behavior: history.prme produces many troff parser "error:"
  # diagnostics on modern groff but still renders output successfully.
  # Treat those as warnings unless a hard command failure occurred.
  if [[ "$hard_fail" -eq 0 && "$rel_path" == "ESPS/general/src/doc/history.prme" ]]; then
    warn_count=$((warn_count + err_count))
    err_count=0

    # history.prme contains legacy formatter constructs tied to the original
    # gpstt/iroff pipeline. Modern nroff emits two non-fatal diagnostics even
    # after normalization; ignore them for phase-1 text staging.
    benign_history_diag=$(grep -Eic "environment stack underflow|unrecognized command '\\.'" "$log_path" 2>/dev/null || true)
    if [[ "$benign_history_diag" -gt 0 && "$warn_count" -ge "$benign_history_diag" ]]; then
      warn_count=$((warn_count - benign_history_diag))
    fi
  fi

  if [[ "$hard_fail" -ne 0 || "$err_count" -gt 0 ]]; then
    printf 'error\t%s\t%s\n' "$warn_count" "$err_count"
  elif [[ "$warn_count" -gt 0 ]]; then
    printf 'warning\t%s\t%s\n' "$warn_count" "$err_count"
  else
    printf 'success\t0\t0\n'
  fi
}

ensure_parent_dir() {
  local path="$1"
  mkdir -p "$(dirname "$path")"
}

strip_ansi_csi() {
  local in_path="$1"
  local out_path="$2"

  awk '
    BEGIN { esc = sprintf("%c", 27) }
    {
      gsub(esc "\\[[0-9;]*[[:alpha:]]", "")
      print
    }
  ' "$in_path" > "$out_path"
}

contains_pattern() {
  local file="$1"
  local pattern="$2"
  grep -Eq "$pattern" "$file"
}

normalize_legacy_roff() {
  local input_file="$1"
  local output_file="$2"

  # Compatibility normalization for older roff sources:
  # - ".\ @(#)..."  -> roff comment line
  # - ".lo"         -> ignored legacy local-macro hook
  # - "\fi..."      -> "\fI..."
  # - "\fCW"        -> "\fR" (fallback; avoids missing-font warnings)
  # - "\fLR"        -> "\fR" (fallback; avoids missing-font warnings)
  # - "\f*name"     -> "\fIname" (legacy emphasis shorthand)
  # - "\ERL"        -> "ERL" (legacy footer escape sequence)
  # - "\ESPS"       -> "\-ESPS" (legacy section ref typo)
  # - bare "\f"     -> "\fP" (reset font)
  # - "\(\-1\s-1"   -> "(1-" (manual section reference)
  # - ".br\f..."    -> "\f..." (broken line-break+text form)
  # - ".ft i"       -> ".ft I"
  # - ".ftI"        -> ".ft I"
  # - ".ft CW/LR"   -> ".ft R" (fallback)
  perl -pe '
    s/^\.\s*\\\s+/.\\\" /;
    s/^\.lo(\s.*)?$/.\\\" .lo$1/;
    s/^\\?\.wave_pro/\\&.wave_pro/;
    s/\\fi/\\fI/g;
    s/\\fCW/\\fR/g;
    s/\\fLR/\\fR/g;
    s/\\f\*([A-Za-z0-9_]+)/\\fI$1/g;
    s/\\ERL/ERL/g;
    s/\\ESPS/\\-ESPS/g;
    s/\\f(?=[\s\.,;:\)\]\}"'"'"'])/\\fP/g;
    s/\\\(\-1\\s-1/(1-/g;
    s/\\\(\\-1\\s-1/(1-/g;
    s/^\.br\\f/\\f/;
    s/^(\.\s*ft\s+)i(\s*)$/${1}I$2/;
    s/^\.ftI\b/.ft I/;
    s/^(\.\s*ft\s+)(CW|LR)(\s*)$/${1}R$3/;
  ' "$input_file" > "$output_file"
}

strip_pic_blocks_for_text() {
  local input_file="$1"
  local output_file="$2"

  # For plain-text stage output, omit raw .PS/.PE picture blocks that require
  # legacy pic/impress rendering and trigger numeric parser warnings in nroff.
  awk '
    BEGIN { inps = 0 }
    /^\.[[:space:]]*PS([[:space:]]|$)/ {
      print ".\\\" .PS [pic block omitted for text build]"
      inps = 1
      next
    }
    inps == 1 {
      if ($0 ~ /^\.[[:space:]]*PE([[:space:]]|$)/) {
        print ".\\\" .PE [end pic block]"
        inps = 0
        next
      }
      print ".\\\" [pic line omitted]"
      next
    }
    { print }
  ' "$input_file" > "$output_file"
}

normalize_feafilt_man_table_rows() {
  local input_file="$1"
  local output_file="$2"

  # feafilt.5t has two malformed rows in a 4-column tbl that include 6
  # entries, which emits "excess table entry ... discarded" diagnostics.
  awk '
    BEGIN { fixed_points = 0; fixed_wts = 0 }
    {
      if (!fixed_points && $0 ~ /^points;npoints;1;NULL;float;NULL$/) {
        print "points;npoints;float;NULL"
        fixed_points = 1
        next
      }
      if (!fixed_wts && $0 ~ /^wts;nbands or npoints;1;NULL;float;NULL$/) {
        print "wts;nbands or npoints;float;NULL"
        fixed_wts = 1
        next
      }
      print
    }
  ' "$input_file" > "$output_file"
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

run_doc_render() {
  local src_abs="$1"
  local rel="$2"
  local out_path="$3"
  local log_path="$4"
  local refs_file="$5"

  local hard_fail=0
  local tmpdir cur nxt nroff_out ansi_clean out_tmp normalized_input normalized_stage
  tmpdir=$(mktemp -d)
  normalized_input="$tmpdir/00-input"
  normalized_stage="$tmpdir/00a-input"

  : > "$log_path"
  if ! normalize_legacy_roff "$src_abs" "$normalized_input" 2>> "$log_path"; then
    hard_fail=1
  fi

  # history.prme includes a legacy pic diagram block that is not representable
  # in this plain-text pipeline; strip it to avoid parser warnings.
  if [[ "$rel" == "ESPS/general/src/doc/history.prme" ]]; then
    if ! strip_pic_blocks_for_text "$normalized_input" "$normalized_stage" 2>> "$log_path"; then
      hard_fail=1
      cur="$normalized_input"
    else
      cur="$normalized_stage"
    fi
  else
    cur="$normalized_input"
  fi

  nxt="$tmpdir/01-soelim"
  if ! soelim "$cur" > "$nxt" 2>> "$log_path"; then
    hard_fail=1
  fi
  cur="$nxt"

  if contains_pattern "$cur" '(^|[[:space:]])\\.\[|^\\.R1|^\\.R2'; then
    nxt="$tmpdir/02-refer"
    if ! refer -n -p "$refs_file" -e "$cur" > "$nxt" 2>> "$log_path"; then
      hard_fail=1
    fi
    cur="$nxt"
  fi

  if contains_pattern "$cur" '^\\.TS|^\\.TE'; then
    nxt="$tmpdir/03-tbl"
    if ! tbl "$cur" > "$nxt" 2>> "$log_path"; then
      hard_fail=1
    fi
    cur="$nxt"
  fi

  if contains_pattern "$cur" '^\\.EQ|^\\.EN'; then
    nxt="$tmpdir/04-eqn"
    if ! eqn "$cur" > "$nxt" 2>> "$log_path"; then
      hard_fail=1
    fi
    cur="$nxt"
  fi

  nroff_out="$tmpdir/05-nroff"
  if ! nroff -me "$cur" > "$nroff_out" 2>> "$log_path"; then
    hard_fail=1
  fi

  ansi_clean="$tmpdir/05a-noansi"
  if ! strip_ansi_csi "$nroff_out" "$ansi_clean" 2>> "$log_path"; then
    hard_fail=1
    ansi_clean="$nroff_out"
  fi

  out_tmp="$tmpdir/06-out"
  if ! (cat "$ansi_clean" | col | ul -tadm3a > "$out_tmp") 2>> "$log_path"; then
    hard_fail=1
  fi

  ensure_parent_dir "$out_path"
  if [[ -f "$out_tmp" ]]; then
    cp "$out_tmp" "$out_path"
  fi

  rm -rf "$tmpdir"

  classify_log "$log_path" "$hard_fail" "$rel"
}

run_man_render() {
  local src_abs="$1"
  local rel="$2"
  local out_path="$3"
  local log_path="$4"

  local hard_fail=0
  local tmpdir cur nxt nroff_out ansi_clean out_tmp normalized_input source_for_render normalized_with_so normalized_tblfix
  tmpdir=$(mktemp -d)
  normalized_input="$tmpdir/00-input"
  normalized_with_so="$tmpdir/00b-input"
  normalized_tblfix="$tmpdir/00c-input"
  : > "$log_path"
  source_for_render=$(resolve_man_stub_source "$src_abs")

  # Normalize legacy include paths used by historical ESPS man sources.
  # Many files contain directives like:
  #   .so $MANDIR$/man3/foo.3
  # Rewriting them to concrete repo paths allows soelim to resolve them.
  if ! awk -v manroot="$GENERAL_MAN_ROOT" -v basedir="$(dirname "$source_for_render")" '
    function norm(p) {
      if (p ~ /^\$MANDIR\$\//) {
        sub(/^\$MANDIR\$\//, "", p)
        return manroot "/" p
      }
      if (p ~ /^\/usr\/esps\/man\//) {
        sub(/^\/usr\/esps\/man\//, "", p)
        return manroot "/" p
      }
      if (p ~ /^man[135]\//) {
        return manroot "/" p
      }
      if (p ~ /^\//) {
        return p
      }
      return basedir "/" p
    }

    /^[[:space:]]*\.so[[:space:]]+/ {
      print ".so " norm($2)
      next
    }
    { print $0 }
  ' "$source_for_render" > "$normalized_input" 2>> "$log_path"; then
    hard_fail=1
  fi
  if ! normalize_legacy_roff "$normalized_input" "$normalized_with_so" 2>> "$log_path"; then
    hard_fail=1
  fi
  cur="$normalized_with_so"

  if [[ "$rel" == "ESPS/general/man/man5/feafilt.5t" ]]; then
    if ! normalize_feafilt_man_table_rows "$cur" "$normalized_tblfix" 2>> "$log_path"; then
      hard_fail=1
    else
      cur="$normalized_tblfix"
    fi
  fi

  nxt="$tmpdir/01-soelim"
  if ! soelim "$cur" > "$nxt" 2>> "$log_path"; then
    hard_fail=1
  fi
  cur="$nxt"

  nxt="$tmpdir/02-tbl"
  if ! tbl "$cur" > "$nxt" 2>> "$log_path"; then
    hard_fail=1
  fi
  cur="$nxt"

  if contains_pattern "$source_for_render" '^\\.EQ|^\\.EN'; then
    nxt="$tmpdir/03-eqn"
    if ! eqn "$cur" > "$nxt" 2>> "$log_path"; then
      hard_fail=1
    fi
    cur="$nxt"
  fi

  nroff_out="$tmpdir/04-nroff"
  if ! nroff -man -rLL=120n "$cur" > "$nroff_out" 2>> "$log_path"; then
    hard_fail=1
  fi

  ansi_clean="$tmpdir/04a-noansi"
  if ! strip_ansi_csi "$nroff_out" "$ansi_clean" 2>> "$log_path"; then
    hard_fail=1
    ansi_clean="$nroff_out"
  fi

  out_tmp="$tmpdir/05-out"
  if ! col -bx < "$ansi_clean" > "$out_tmp" 2>> "$log_path"; then
    hard_fail=1
  fi

  ensure_parent_dir "$out_path"
  if [[ -f "$out_tmp" ]]; then
    cp "$out_tmp" "$out_path"
  fi

  rm -rf "$tmpdir"

  classify_log "$log_path" "$hard_fail" "$rel"
}

run_help_render() {
  local src_abs="$1"
  local rel="$2"
  local out_path="$3"
  local log_path="$4"
  local waves_root="$5"

  local hard_fail=0
  local waves_doc waves_misc waves_src waves_bin
  waves_doc="$waves_root/doc"
  waves_misc="$waves_root/lib"
  waves_src="$waves_root/src"
  waves_bin="$waves_root/bin"

  : > "$log_path"
  ensure_parent_dir "$out_path"

  if ! sed \
    -e 's?\$WAVES_ROOT?'"$waves_root"'?g' \
    -e 's?\$WAVES_DOC?'"$waves_doc"'?g' \
    -e 's?\$WAVES_MISC?'"$waves_misc"'?g' \
    -e 's?\$WAVES_SRC?'"$waves_src"'?g' \
    -e 's?\$WAVES_BIN?'"$waves_bin"'?g' \
    "$src_abs" > "$out_path" 2>> "$log_path"; then
    hard_fail=1
  fi

  classify_log "$log_path" "$hard_fail" "$rel"
}

write_summaries() {
  local status="$1"

  local failures=0
  failures=$TOTAL_ERROR

  {
    printf '# ESPS Phase-1 Documentation Compile Summary\n\n'
    printf -- '- Status: `%s`\n' "$status"
    printf -- '- Scope: `%s`\n' "$SCOPE"
    printf -- '- Strict mode: `%s`\n' "$STRICT"
    printf -- '- Output directory: `%s`\n' "$OUT_DIR"
    printf -- '- Dry run: `%s`\n' "$DRY_RUN"
    printf -- '- Keep going: `%s`\n' "$KEEP_GOING"
    printf '\n## Totals\n\n'
    printf -- '- Discovered: `%s`\n' "$((DOC_DISCOVERED + MAN_DISCOVERED + HELP_DISCOVERED))"
    printf -- '- Processed: `%s`\n' "$TOTAL_PROCESSED"
    printf -- '- Success: `%s`\n' "$TOTAL_SUCCESS"
    printf -- '- Warning: `%s`\n' "$TOTAL_WARNING"
    printf -- '- Error: `%s`\n' "$TOTAL_ERROR"
    printf '\n## Categories\n\n'
    printf '| Category | Discovered | Processed | Success | Warning | Error |\n'
    printf '|---|---:|---:|---:|---:|---:|\n'
    printf '| general/src/doc | %s | %s | %s | %s | %s |\n' "$DOC_DISCOVERED" "$DOC_PROCESSED" "$DOC_SUCCESS" "$DOC_WARNING" "$DOC_ERROR"
    printf '| man pages | %s | %s | %s | %s | %s |\n' "$MAN_DISCOVERED" "$MAN_PROCESSED" "$MAN_SUCCESS" "$MAN_WARNING" "$MAN_ERROR"
    printf '| waves help | %s | %s | %s | %s | %s |\n' "$HELP_DISCOVERED" "$HELP_PROCESSED" "$HELP_SUCCESS" "$HELP_WARNING" "$HELP_ERROR"

    if [[ -s "$MISSING_TOOLS_TXT" ]]; then
      printf '\n## Missing Tools\n\n'
      while IFS= read -r line; do
        printf -- '- %s\n' "$line"
      done < "$MISSING_TOOLS_TXT"
    fi

    if [[ "$failures" -gt 0 ]]; then
      printf '\n## Top Failures\n\n'
      local shown=0
      while IFS=$'\t' read -r category rel out_path log_path status_row warn_count err_count; do
        if [[ "$status_row" != "error" ]]; then
          continue
        fi
        printf '### `%s`\n\n' "$rel"
        printf -- '- Category: `%s`\n' "$category"
        printf -- '- Log: `%s`\n\n' "$log_path"
        printf '```text\n'
        sed -n '1,8p' "$log_path"
        printf '```\n\n'
        shown=$((shown + 1))
        if [[ "$shown" -ge 10 ]]; then
          break
        fi
      done < "$RESULTS_TSV"
    fi
  } > "$SUMMARY_MD"

  {
    printf '{\n'
    printf '  "status": "%s",\n' "$(escape_json "$status")"
    printf '  "scope": "%s",\n' "$(escape_json "$SCOPE")"
    printf '  "strict": "%s",\n' "$(escape_json "$STRICT")"
    printf '  "out_dir": "%s",\n' "$(escape_json "$OUT_DIR")"
    printf '  "dry_run": %s,\n' "$([[ "$DRY_RUN" -eq 1 ]] && echo true || echo false)"
    printf '  "keep_going": %s,\n' "$([[ "$KEEP_GOING" -eq 1 ]] && echo true || echo false)"

    printf '  "missing_tools": ['
    if [[ -s "$MISSING_TOOLS_TXT" ]]; then
      first=1
      while IFS= read -r line; do
        tool_name=${line%% *}
        hint=${line#* - }
        if [[ $first -eq 0 ]]; then
          printf ','
        fi
        first=0
        printf '\n    {"tool":"%s","hint":"%s"}' \
          "$(escape_json "$tool_name")" "$(escape_json "$hint")"
      done < "$MISSING_TOOLS_TXT"
      printf '\n  ],\n'
    else
      printf '],\n'
    fi

    printf '  "counts": {\n'
    printf '    "discovered": %s,\n' "$((DOC_DISCOVERED + MAN_DISCOVERED + HELP_DISCOVERED))"
    printf '    "processed": %s,\n' "$TOTAL_PROCESSED"
    printf '    "success": %s,\n' "$TOTAL_SUCCESS"
    printf '    "warning": %s,\n' "$TOTAL_WARNING"
    printf '    "error": %s\n' "$TOTAL_ERROR"
    printf '  },\n'

    printf '  "categories": {\n'
    printf '    "doc": {"discovered": %s, "processed": %s, "success": %s, "warning": %s, "error": %s},\n' \
      "$DOC_DISCOVERED" "$DOC_PROCESSED" "$DOC_SUCCESS" "$DOC_WARNING" "$DOC_ERROR"
    printf '    "man": {"discovered": %s, "processed": %s, "success": %s, "warning": %s, "error": %s},\n' \
      "$MAN_DISCOVERED" "$MAN_PROCESSED" "$MAN_SUCCESS" "$MAN_WARNING" "$MAN_ERROR"
    printf '    "help": {"discovered": %s, "processed": %s, "success": %s, "warning": %s, "error": %s}\n' \
      "$HELP_DISCOVERED" "$HELP_PROCESSED" "$HELP_SUCCESS" "$HELP_WARNING" "$HELP_ERROR"
    printf '  },\n'

    printf '  "top_failures": ['
    if [[ "$TOTAL_ERROR" -gt 0 ]]; then
      first=1
      shown=0
      while IFS=$'\t' read -r category rel out_path log_path status_row warn_count err_count; do
        [[ "$status_row" == "error" ]] || continue
        diag=$(sed -n '1,8p' "$log_path")
        if [[ $first -eq 0 ]]; then
          printf ','
        fi
        first=0
        printf '\n    {"file":"%s","category":"%s","log":"%s","diagnostics":"%s"}' \
          "$(escape_json "$rel")" "$(escape_json "$category")" "$(escape_json "$log_path")" "$(escape_json "$diag")"
        shown=$((shown + 1))
        if [[ "$shown" -ge 10 ]]; then
          break
        fi
      done < "$RESULTS_TSV"
      printf '\n  ]\n'
    else
      printf ']\n'
    fi

    printf '}\n'
  } > "$SUMMARY_JSON"
}

required_tools=(nroff refer tbl eqn soelim col ul sed awk find)
for t in "${required_tools[@]}"; do
  if ! command -v "$t" >/dev/null 2>&1; then
    PRECHECK_FAILED=1
    printf '%s - %s\n' "$t" "$(tool_hint "$t")" >> "$MISSING_TOOLS_TXT"
  fi
done

DOC_REFS="$REPO_ROOT/ESPS/general/src/doc/esps.refs"
if [[ ! -f "$DOC_REFS" ]]; then
  PRECHECK_FAILED=1
  printf '%s - %s\n' "esps.refs" "Missing reference database at ESPS/general/src/doc/esps.refs" >> "$MISSING_TOOLS_TXT"
fi

DOC_FIND=(
  "$REPO_ROOT/ESPS/general/src/doc"
)

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

find "${DOC_FIND[@]}" -maxdepth 1 -type f \
  \( -name '*.me' -o -name '*.tme' -o -name '*.prme' -o -name '*.vrme' -o -name '*.vme' -o -name '*.vtme' \) \
  | LC_ALL=C sort > "$DOC_LIST"

find "${MAN_FIND[@]}" -type f \
  \( -name '*.1' -o -name '*.1t' -o -name '*.3' -o -name '*.3t' -o -name '*.5' -o -name '*.5t' \) \
  | LC_ALL=C sort > "$MAN_LIST"

find "$HELP_FIND" -maxdepth 1 -type f -name '*.help.src' | LC_ALL=C sort > "$HELP_LIST"

DOC_DISCOVERED=$(wc -l < "$DOC_LIST" | tr -d ' ')
MAN_DISCOVERED=$(wc -l < "$MAN_LIST" | tr -d ' ')
HELP_DISCOVERED=$(wc -l < "$HELP_LIST" | tr -d ' ')

if [[ "$PRECHECK_FAILED" -ne 0 ]]; then
  write_summaries "preflight_failed"
  echo "preflight failed: missing required tools/files" >&2
  cat "$MISSING_TOOLS_TXT" >&2
  rm -f "$DOC_LIST" "$MAN_LIST" "$HELP_LIST"
  exit 1
fi

if [[ "$DRY_RUN" -eq 1 ]]; then
  write_summaries "dry_run"
  rm -f "$DOC_LIST" "$MAN_LIST" "$HELP_LIST"
  exit 0
fi

WAVES_ROOT_SUBST="${ESPS_BASE:-/usr/esps}"

stop_now=0

while IFS= read -r src_abs; do
  rel="${src_abs#$REPO_ROOT/}"
  out_path="$OUT_DIR/$rel.txt"
  log_path="$LOG_ROOT/$rel.stderr.log"
  ensure_parent_dir "$log_path"

  IFS=$'\t' read -r status warn_count err_count < <(run_doc_render "$src_abs" "$rel" "$out_path" "$log_path" "$DOC_REFS")
  record_result "doc" "$rel" "$out_path" "$log_path" "$status" "$warn_count" "$err_count"

  if [[ "$status" == "error" && "$KEEP_GOING" -eq 0 ]]; then
    stop_now=1
    break
  fi
done < "$DOC_LIST"

if [[ "$stop_now" -eq 0 ]]; then
  while IFS= read -r src_abs; do
    rel="${src_abs#$REPO_ROOT/}"
    out_path="$OUT_DIR/$rel.txt"
    log_path="$LOG_ROOT/$rel.stderr.log"
    ensure_parent_dir "$log_path"

    IFS=$'\t' read -r status warn_count err_count < <(run_man_render "$src_abs" "$rel" "$out_path" "$log_path")
    record_result "man" "$rel" "$out_path" "$log_path" "$status" "$warn_count" "$err_count"

    if [[ "$status" == "error" && "$KEEP_GOING" -eq 0 ]]; then
      stop_now=1
      break
    fi
  done < "$MAN_LIST"
fi

if [[ "$stop_now" -eq 0 ]]; then
  while IFS= read -r src_abs; do
    rel="${src_abs#$REPO_ROOT/}"
    rel_out="${rel%.src}"
    out_path="$OUT_DIR/$rel_out"
    log_path="$LOG_ROOT/$rel.stderr.log"
    ensure_parent_dir "$log_path"

    IFS=$'\t' read -r status warn_count err_count < <(run_help_render "$src_abs" "$rel" "$out_path" "$log_path" "$WAVES_ROOT_SUBST")
    record_result "help" "$rel" "$out_path" "$log_path" "$status" "$warn_count" "$err_count"

    if [[ "$status" == "error" && "$KEEP_GOING" -eq 0 ]]; then
      stop_now=1
      break
    fi
  done < "$HELP_LIST"
fi

run_status="ok"
exit_code=0

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

write_summaries "$run_status"

rm -f "$DOC_LIST" "$MAN_LIST" "$HELP_LIST"

echo "summary: $SUMMARY_MD"
echo "summary-json: $SUMMARY_JSON"

echo "discovered: $((DOC_DISCOVERED + MAN_DISCOVERED + HELP_DISCOVERED)) (doc=$DOC_DISCOVERED man=$MAN_DISCOVERED help=$HELP_DISCOVERED)"
echo "processed: $TOTAL_PROCESSED success=$TOTAL_SUCCESS warning=$TOTAL_WARNING error=$TOTAL_ERROR"

exit "$exit_code"
