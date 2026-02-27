SHELL := /bin/bash

OUT_DIR ?= build/docs-phase2-local
PHASE1_OUT ?= build/docs-phase1
STRICT ?= errors
SCOPE ?= core-plus
BASE_URL ?= /
KEEP_GOING ?= 1
SNAPSHOT_DIR ?= build/docs-phase2-snapshots
VENV ?=
PUBLISH_BRANCH ?= gh-pages
PUBLISH_REMOTE ?= origin
PUBLISH_DRY_RUN ?= 0
NO_PUSH ?= 0
FORCE ?= 0

KEEP_GOING_FLAG :=
ifeq ($(KEEP_GOING),1)
KEEP_GOING_FLAG := --keep-going
endif

NO_KEEP_GOING_FLAG :=
ifeq ($(KEEP_GOING),0)
NO_KEEP_GOING_FLAG := --no-keep-going
endif

PUBLISH_DRY_RUN_FLAG :=
ifeq ($(PUBLISH_DRY_RUN),1)
PUBLISH_DRY_RUN_FLAG := --dry-run
endif

NO_PUSH_FLAG :=
ifeq ($(NO_PUSH),1)
NO_PUSH_FLAG := --no-push
endif

FORCE_FLAG :=
ifeq ($(FORCE),1)
FORCE_FLAG := --force
endif

.PHONY: help man2md man2md-test man2md-clean docs-phase1 docs-phase2 docs-snapshot docs-publish docs-serve clean

help:
	@echo "devtools targets"
	@echo "  man2md        Build ./devtools/bin/man2md"
	@echo "  man2md-test   Run go tests for man2md"
	@echo "  docs-phase1   Run phase-1 docs compile (PHASE1_OUT, STRICT, KEEP_GOING)"
	@echo "  docs-phase2   Run phase-2 docs site build (OUT_DIR, STRICT, SCOPE, BASE_URL, KEEP_GOING)"
	@echo "  docs-snapshot Build and package a local docs snapshot (OUT_DIR, SNAPSHOT_DIR, STRICT, SCOPE, BASE_URL, KEEP_GOING, VENV)"
	@echo "  docs-publish  Build and publish docs to GitHub Pages (OUT_DIR, BASE_URL, STRICT, SCOPE, KEEP_GOING, PUBLISH_BRANCH, PUBLISH_REMOTE, PUBLISH_DRY_RUN, NO_PUSH, FORCE)"
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

docs-publish:
	./publish-docs-github-pages.sh --out-dir "$(OUT_DIR)" --base-url "$(BASE_URL)" --strict "$(STRICT)" --scope "$(SCOPE)" --branch "$(PUBLISH_BRANCH)" --remote "$(PUBLISH_REMOTE)" $(KEEP_GOING_FLAG) $(NO_KEEP_GOING_FLAG) $(PUBLISH_DRY_RUN_FLAG) $(NO_PUSH_FLAG) $(FORCE_FLAG)

docs-serve:
	python3 -m http.server 8765 --bind 127.0.0.1 --directory "$(OUT_DIR)/site"

clean: man2md-clean
