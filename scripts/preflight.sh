#!/usr/bin/env bash
set -euo pipefail

# Lightweight local preflight for the yeet skill.
# It does not modify the repository.

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: not inside a git work tree" >&2
  exit 2
fi

root="$(git rev-parse --show-toplevel)"
branch="$(git branch --show-current)"
head="$(git rev-parse HEAD)"
remote_url="$(git remote get-url origin 2>/dev/null || true)"
upstream="$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)"

echo "root=$root"
echo "branch=${branch:-DETACHED}"
echo "head=$head"
echo "origin=${remote_url:-NONE}"
echo "upstream=${upstream:-NONE}"

status="$(git status --porcelain=v1)"
if [[ -n "$status" ]]; then
  echo "dirty=true"
  printf '%s\n' "$status"
else
  echo "dirty=false"
fi

if [[ -n "$upstream" ]]; then
  # Fetch only when an origin exists; failure is surfaced rather than hidden.
  if [[ -n "$remote_url" ]]; then
    git fetch --quiet origin
  fi
  counts="$(git rev-list --left-right --count HEAD..."$upstream")"
  ahead="$(awk '{print $1}' <<<"$counts")"
  behind="$(awk '{print $2}' <<<"$counts")"
  echo "ahead=$ahead"
  echo "behind=$behind"
fi
