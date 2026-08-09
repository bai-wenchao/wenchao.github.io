# Makefile for reveal.js slides (Markdown → pandoc → HTML)
#
# Workflow mirrors the Beamer posts (2507_pce/Makefile):
#   edit source  →  existing tool compiles  →  final output
# but the source is Markdown and the compiler is pandoc.

# ── Configuration ────────────────────────────────────────────────
SRC      = slides.md
HTML     = index.html
THEME    = theme.css

PANDOC   = pandoc
PORT     = 8000

# reveal.js is shared across ALL posts and kept OUT of git: it lives in the
# gitignored ../_shared/reveal.js/ (populated by ../fetch-revealjs.sh). The build
# inlines it via --embed-resources, so the published index.html is self-contained
# and the shared cache is never uploaded.
REVEAL_URL = ../_shared/reveal.js
FETCH      = ../fetch-revealjs.sh

# Flags shared by every reveal.js build.
# NB: the variable is `revealjs-url` (with hyphen) — pandoc ignores `revealjsUrl`.
REVEAL_FLAGS = \
	-t revealjs -s --slide-level 2 \
	--css $(THEME) \
	-V revealjs-url=$(REVEAL_URL) \
	-V theme=white -V transition=slide \
	-V center=false -V hash=true \
	-V width=1280 -V height=720 \
	-V mouseWheel=true

# ── Primary target ───────────────────────────────────────────────
all: check-shared $(HTML)

# Ensure the shared reveal.js cache exists before building (fetched on demand).
# Phony, so it runs every `make` — a cheap no-op once the cache is present.
check-shared:
	@if [ ! -f $(REVEAL_URL)/dist/reveal.js ]; then echo "→ reveal.js not found, fetching via $(FETCH)..."; bash $(FETCH); fi

# Build a self-contained HTML: --embed-resources inlines theme.css AND the
# shared reveal.js, so the deck has zero external dependencies and the published
# file needs no siblings. Run `make fetch` to refresh/upgrade the shared cache.
$(HTML): $(SRC) $(THEME)
	$(PANDOC) $(REVEAL_FLAGS) --embed-resources $(SRC) -o $(HTML)

# ── Shared reveal.js cache ──────────────────────────────────────
# (Re)fetch the shared, gitignored reveal.js used by the build. Pass a version
# to upgrade, e.g. `make fetch VER=5.2.0`.
fetch:
	@bash $(FETCH) $(VER)

# ── Live preview ────────────────────────────────────────────────
serve: all
	@echo "→ http://localhost:$(PORT)/"
	@python3 -m http.server $(PORT)

# ── Clean ───────────────────────────────────────────────────────
clean:
	rm -f $(HTML)

rebuild: clean all

.PHONY: all check-shared serve fetch clean rebuild
