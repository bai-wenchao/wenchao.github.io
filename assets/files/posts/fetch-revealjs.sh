#!/usr/bin/env bash
# Fetch reveal.js into the shared, gitignored build-time cache (../_shared/reveal.js)
# so every post's `make` can inline it via pandoc --embed-resources with NO
# network access. Nothing here is committed (see the repo .gitignore). Re-run
# any time to refresh, or pass a version arg to upgrade: `bash fetch-revealjs.sh 5.1.0`.
set -euo pipefail

VER="${1:-5.1.0}"
BASE="https://cdn.jsdelivr.net/npm/reveal.js@${VER}"
ROOT="$(cd "$(dirname "$0")" && pwd)"   # .../assets/files/posts
DEST="$ROOT/_shared/reveal.js"

FILES=(
  dist/reset.css
  dist/reveal.css
  dist/reveal.js
  dist/theme/white.css
  plugin/notes/notes.js
  plugin/search/search.js
  plugin/zoom/zoom.js
)

echo "→ reveal.js ${VER} → _shared/reveal.js"
for f in "${FILES[@]}"; do
  mkdir -p "$DEST/$(dirname "$f")"
  curl -fsSL "$BASE/$f" -o "$DEST/$f"
  echo "   ✓ $f"
done

# The white theme @imports the Source Sans Pro fonts (~2 MB of eot/ttf/woff).
# Our theme.css overrides the font family to a serif stack, so the import is
# dead weight — strip it to keep each inlined deck slim.
sed -i.bak \
  's|^@import url(\./fonts/source-sans-pro/source-sans-pro.css);|/* font @import removed — theme.css overrides the family */|' \
  "$DEST/dist/theme/white.css"
rm -f "$DEST/dist/theme/white.css.bak"

echo "✓ reveal.js ${VER} ready at _shared/reveal.js"
