# Makefile for reveal.js slides (Markdown → pandoc → HTML)
#
# Workflow mirrors the Beamer posts (2507_pce/Makefile):
#   edit source  →  existing tool compiles  →  final output
# but the source is Markdown and the compiler is pandoc.

# ── Configuration ────────────────────────────────────────────────
SRC      = slides.md
WORDS    = words.txt
HTML     = index.html
THEME    = theme.css
PDF      = $(SRC:.md=.pdf)

PANDOC   = pandoc
PORT     = 8000

# reveal.js runtime (jsDelivr CDN, pinned to 5.1.0)
REVEAL_URL = https://cdn.jsdelivr.net/npm/reveal.js@5.1.0/

# Flags shared by every reveal.js build
REVEAL_FLAGS = \
	-t revealjs -s --slide-level 2 \
	--css $(THEME) \
	-V revealjsUrl='$(REVEAL_URL)' \
	-V theme=white -V transition=slide \
	-V center=false -V hash=true \
	-V width=1280 -V height=720 \
	-V mouseWheel=true

# ── Primary target ───────────────────────────────────────────────
all: $(HTML)

# Build a self-contained HTML: --embed-resources inlines theme.css AND
# pandoc's bundled reveal.js (5.2.0), so the deck has zero external
# dependencies and loads like the old PDFs did.
$(HTML): $(SRC) $(THEME) $(WORDS)
	$(PANDOC) $(REVEAL_FLAGS) --embed-resources $(SRC) -o $(HTML)

# ── PDF via the SAME Markdown through Beamer ────────────────────
# NB: reveal.js vertical slides flatten to one sequence in Beamer, and the
# custom .verb/.ipa spans are unstyled. The canonical PDF path is the
# reveal.js print view (posts.json links to index.html?print-pdf).
# xelatex + ctex are required for the Chinese text (pdflatex cannot render CJK).
pdf: $(SRC) $(WORDS)
	$(PANDOC) -t beamer --slide-level 2 -V aspectratio=169 \
		--pdf-engine=xelatex -V documentclass=ctexart \
		-V theme=Madrid -V colortheme=seahorse -V mainfont="Noto Sans CJK SC" \
		$(SRC) -o $(SRC:.md=.pdf)

# ── Completeness check: every word in words.txt is in the source ─
verify: $(SRC) $(WORDS)
	@missing=0; \
	while IFS= read -r w; do \
		[ -z "$$w" ] && continue; \
		grep -qi -- "$$w" $(SRC) || { echo "  MISSING: $$w"; missing=$$((missing+1)); }; \
	done < $(WORDS); \
	total=$$(grep -c . $(WORDS)); \
	if [ $$missing -eq 0 ]; then \
		echo "✓ all $$total words present in $(SRC)"; \
	else \
		echo "✗ $$missing / $$total words missing"; exit 1; \
	fi

# ── Live preview ────────────────────────────────────────────────
serve: all
	@echo "→ http://localhost:$(PORT)/"
	@python3 -m http.server $(PORT)

# ── Clean ───────────────────────────────────────────────────────
clean:
	rm -f $(HTML)

distclean: clean
	rm -f $(PDF)

rebuild: clean all

.PHONY: all pdf verify serve clean distclean rebuild
