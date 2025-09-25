#!/usr/bin/env bash
set -euo pipefail

#set -x #debug
export GITLAB_TOKEN=#YOUR_TOKEN

: "${GITLAB_TOKEN:?Set GITLAB_TOKEN first}"

HOST="https://code.mipt.ru"
GROUP="" #      "db2025s"
REPOS="" #      "feldmanro-hw1 feldmanro-hw2 feldmanro-hw3 feldmanro-hw4 feldmanro-hw5"
DEST="${1:-sql-downloads-$(date +%Y%m%d_%H%M%S)}"
mkdir -p "$DEST"

auth=(-H "Authorization: Bearer $GITLAB_TOKEN")
api() { curl -fsSL "${auth[@]}" "$@"; }
urlenc() { jq -rn --arg s "$1" '$s|@uri' | tr -d '\n'; }

get_prefix() {
  case "$1" in
    *hw1) echo "hw1task" ;;
    *hw2) echo "hw2task" ;;
    *hw3) echo "hw3task" ;;
    *hw4) echo "hw4task" ;;
    *hw5) echo "hw5task" ;;
    *) echo "" ;;
  esac
}

download_sql_by_path() {
  local project_path_enc="$1" br="$2" out="$3"

  local file="${br}.sql"
  local file_enc; file_enc=$(urlenc "$file")
  local br_enc;   br_enc=$(urlenc "$br")

  local url1="$HOST/api/v4/projects/$project_path_enc/repository/files/$file_enc/raw?ref=$br_enc"
  if api "$url1" -o "$out" 2>/dev/null; then
    if grep -qiE '<!DOCTYPE html|<html|^{"message":' "$out"; then
      rm -f "$out"
    else
      echo "   ✓ $br → $out"
      return 0
    fi
  fi

  local tree; tree=$(api "$HOST/api/v4/projects/$project_path_enc/repository/tree?ref=$br_enc&recursive=true&per_page=200") || return 1
  local candidates; candidates=$(printf "%s" "$tree" | jq -r '.[] | select(.type=="blob") | .path' | grep -Ei '\.sql$' || true)
  local count; count=$(printf "%s\n" "$candidates" | sed '/^$/d' | wc -l | tr -d ' ')
  if [ "$count" = "1" ]; then
    local path; path=$(printf "%s" "$candidates")
    local path_enc; path_enc=$(urlenc "$path")
    local url2="$HOST/api/v4/projects/$project_path_enc/repository/files/$path_enc/raw?ref=$br_enc"
    if api "$url2" -o "$out" 2>/dev/null && ! grep -qiE '<!DOCTYPE html|<html|^{"message":' "$out"; then
      echo "   ✓ $br ($path) → $out"
      return 0
    fi
  else
    echo "   · $br → found $count SQL files; skipping (ambiguous)" >&2
  fi
  return 1
}

api "$HOST/api/v4/user" >/dev/null || { echo "Token invalid"; exit 1; }

for repo in $REPOS; do
  project_path="$GROUP/$repo"
  project_path_enc=$(urlenc "$project_path")

  echo "== $project_path =="

  prefix=$(get_prefix "$repo")
  [ -n "$prefix" ] || { echo "   (Unknown repo prefix)"; continue; }


  branches=$(api "$HOST/api/v4/projects/$project_path_enc/repository/branches?per_page=200&search=$(urlenc "$prefix")" \
             | jq -r '.[].name')

  outdir="$DEST/$repo"; mkdir -p "$outdir"
  saved_any=0
  while IFS= read -r br; do
    [ -n "$br" ] || continue
    out="$outdir/${br}.sql"
    if download_sql_by_path "$project_path_enc" "$br" "$out"; then
      saved_any=1
    fi
  done <<<"$branches"

  [ "$saved_any" -eq 1 ] || echo "   (No matching branches or SQL files)"
done

echo "All done → $DEST"
