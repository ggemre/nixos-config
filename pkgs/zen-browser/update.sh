#!/usr/bin/env bash
set -euo pipefail

JSON_FILE="sources.json"
NAME="${NAME:-beta}"              # which version to update (beta or twilight)
TAG="${1:-1.15.4b}"               # release tag (defaults to 1.15.4b)

prefetch_sri() {
  local url="$1"
  if [[ "$url" =~ \.(tar\.(xz|gz|bz2)|zip)$ ]]; then
    nix store prefetch-file --unpack --hash-type sha256 --json "$url" | jq -r '.hash'
  else
    nix store prefetch-file --hash-type sha256 --json "$url" | jq -r '.hash'
  fi
}

update_entry() {
  local channel="$1" arch="$2" url="$3" version="$4"
  local sri
  sri="$(prefetch_sri "$url")"
  jq --arg url "$url" \
     --arg hash "$sri" \
     --arg ver "$version" \
     ".\"$channel\"[\"$arch-linux\"] = {version: \$ver, sha1: \"null\", url: \$url, sha256: \$hash}" \
     "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"
}

update_entry "$NAME" x86_64 "https://github.com/zen-browser/desktop/releases/download/$TAG/zen.linux-x86_64.tar.xz" "$TAG"
update_entry "$NAME" aarch64 "https://github.com/zen-browser/desktop/releases/download/$TAG/zen.linux-aarch64.tar.xz" "$TAG"

# Update timestamp metadata depending on channel
meta_key="${NAME}_metadata"
jq --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
   --arg key "$meta_key" \
   '.[$key].updated_at = $now' \
   "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"

echo "sources.json updated ($NAME)."
