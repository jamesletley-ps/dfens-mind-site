#!/usr/bin/env bash
# check-links.sh — offline integrity check for the static site.
#
# Verifies, with no network calls:
#   1. every internal link (root-relative "/…" to a page or asset) exists;
#   2. every "#anchor" resolves to a matching id="" in the target page.
#
# The site uses directory-index pages (pricing/index.html served at /pricing/)
# and root-relative links, so this resolves "/pricing/" -> pricing/index.html.
# Anything internal that is not root-relative ("/…") or a same-page anchor
# ("#…") is flagged — we standardise on root-relative links.
#
# Runs in CI and locally: ./scripts/check-links.sh
set -euo pipefail
cd "$(dirname "$0")/.."   # repo root

mapfile -t pages < <(find . -name '*.html' -not -path './dist/*' | sed 's|^\./||' | sort)
fail=0

# Resolve a root-relative path to the file that serves it.
#   /            -> index.html
#   /pricing/    -> pricing/index.html
#   /a/b.css     -> a/b.css
resolve_file() {
  local rel="$1"
  if [ -z "$rel" ] || [ "${rel: -1}" = "/" ]; then
    printf '%sindex.html' "$rel"
  else
    printf '%s' "$rel"
  fi
}

for f in "${pages[@]}"; do
  refs=$(grep -oE '(href|src)="[^"]+"' "$f" | sed -E 's/^(href|src)="(.*)"$/\2/' || true)
  while IFS= read -r ref; do
    [ -z "$ref" ] && continue
    case "$ref" in
      http://*|https://*|mailto:*|tel:*|data:*) continue ;;
    esac

    if [ "${ref:0:1}" = "#" ]; then                 # same-page anchor
      target_file="$f"; anchor="${ref#\#}"
    elif [ "${ref:0:1}" = "/" ]; then               # root-relative
      rel="${ref#/}"
      filepart="${rel%%#*}"
      anchor=""; case "$rel" in *"#"*) anchor="${rel#*#}" ;; esac
      target_file="$(resolve_file "$filepart")"
      if [ ! -e "$target_file" ]; then
        echo "BROKEN LINK    $f -> $ref   (no file '$target_file')"; fail=1; continue
      fi
    else
      echo "NON-ROOT LINK  $f -> $ref   (use a root-relative '/…' link)"; fail=1; continue
    fi

    if [ -n "$anchor" ]; then
      case "$target_file" in
        *.html)
          if ! grep -qE "id=\"$anchor\"" "$target_file"; then
            echo "BROKEN ANCHOR  $f -> $ref   (no id=\"$anchor\" in $target_file)"; fail=1
          fi ;;
      esac
    fi
  done <<< "$refs"
done

if [ "$fail" -ne 0 ]; then
  echo "FAIL: link check found problems."
  exit 1
fi
echo "OK: ${#pages[@]} page(s) checked, all internal links and anchors resolve."
