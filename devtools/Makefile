SHELL := /bin/bash

OUT_DIR ?= build/docs-phase2-local
PHASE1_OUT ?= build/docs-phase1
STRICT ?= errors
SCOPE ?= core-plus
BASE_URL ?= /
KEEP_GOING ?= 1
SNAPSHOT_DIR ?= build/docs-phase2-snapshots
VENV ?=

KEEP_GOING_FLAG :=
ifeq ($(KEEP_GOING),1)
KEEP_GOING_FLAG := --keep-going
endif

.PHONY: help man2md man2md-test man2md-clean docs-phase1 docs-phase2 docs-snapshot docs-serve clean

help:
	@echo "devtools targets"
	@echo "  man2md        Build ./devtools/bin/man2md"
	@echo "  man2md-test   Run go tests for man2md"
	@echo "  docs-phase1   Run phase-1 docs compile (PHASE1_OUT, STRICT, KEEP_GOING)"
	@echo "  docs-phase2   Run phase-2 docs site build (OUT_DIR, STRICT, SCOPE, BASE_URL, KEEP_GOING)"
	@echo "  docs-snapshot Build and package a local docs snapshot (OUT_DIR, SNAPSHOT_DIR, STRICT, SCOPE, BASE_URL, KEEP_GOING, VENV)"
	@echo "  docs-serve    Serve $(OUT_DIR)/site at http://127.0.0.1:8765"
	@echo "  clean         Remove ./devtools/bin/man2md"

man2md:
	$(MAKE) -C man2md build

man2md-test:
	$(MAKE) -C man2md test

man2md-clean:
	$(MAKE) -C man2md clean

docs-phase1:
	./compile-docs-phase1.sh --out-dir "$(PHASE1_OUT)" --strict "$(STRICT)" --scope core $(KEEP_GOING_FLAG)

docs-phase2:
	./build-docs-phase2.sh --out-dir "$(OUT_DIR)" --strict "$(STRICT)" --scope "$(SCOPE)" --base-url "$(BASE_URL)" $(KEEP_GOING_FLAG)

docs-snapshot:
	./snapshot-docs-phase2-local.sh --out-dir "$(OUT_DIR)" --snapshot-dir "$(SNAPSHOT_DIR)" --strict "$(STRICT)" --scope "$(SCOPE)" --base-url "$(BASE_URL)" $(KEEP_GOING_FLAG) $(if $(strip $(VENV)),--venv "$(VENV)",)

docs-serve:
	python3 -m http.server 8765 --bind 127.0.0.1 --directory "$(OUT_DIR)/site"

clean: man2md-clean
