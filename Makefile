.PHONY: help test test-parallel docs package release-check check-changes clean

PYTHON ?= python3
VERSION ?=

help:
	@printf '%s\n' \
	  'make test          compile all TeX fixtures' \
	  'make test-parallel compile fixtures concurrently' \
	  'make docs          build the user guide' \
	  'make package VERSION=1.4.7  build a validated release archive' \
	  'make release-check VERSION=1.4.7  validate release arguments only'

check-changes:
	$(PYTHON) scripts/check_changes.py

test:
	bash scripts/test.sh

test-parallel:
	bash scripts/test.sh --parallel

docs:
	@mkdir -p .cache/biber-docs .cache/texmf-var .cache/texmf-config
	cd docs/user-guide && \
		PAR_GLOBAL_TEMP="$(CURDIR)/.cache/biber-docs" \
		PAR_GLOBAL_TMPDIR="$(CURDIR)/.cache/biber-docs" \
		TEXMFVAR="$(CURDIR)/.cache/texmf-var" \
		TEXMFCONFIG="$(CURDIR)/.cache/texmf-config" \
		latexmk -xelatex -g -interaction=nonstopmode -halt-on-error CCNUthesis-doc.tex

package:
	@test -n "$(VERSION)" || (echo 'VERSION is required, e.g. make package VERSION=1.4.7' >&2; exit 2)
	$(PYTHON) scripts/build.py $(VERSION) --non-interactive

release-check:
	@test -n "$(VERSION)" || (echo 'VERSION is required' >&2; exit 2)
	$(PYTHON) scripts/build.py $(VERSION) --non-interactive --dry-run

clean:
	find test docs/user-guide -type f \( -name '*.aux' -o -name '*.bbl' -o -name '*.bcf' -o -name '*.blg' -o -name '*.fdb_latexmk' -o -name '*.fls' -o -name '*.log' -o -name '*.out' -o -name '*.run.xml' -o -name '*.synctex.gz' -o -name '*.toc' -o -name '*.xdv' \) -delete
