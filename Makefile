# SPDX-FileCopyrightText: 2026 Intel Corporation
# SPDX-FileCopyrightText: 2021 Open Networking Foundation <info@opennetworking.org>
# SPDX-License-Identifier: Apache-2.0

# Makefile for Sphinx documentation

# use bash for pushd/popd, and to fail quickly
SHELL = bash -e -o pipefail

# You can set these variables from the command line.
SPHINXOPTS   ?= -W
SPHINXBUILD  ?= sphinx-build
SOURCEDIR    ?= .
BUILDDIR     ?= _build

# name of python virtualenv that is used to run commands
VENV_NAME      := venv-docs

# Git repository information for versioning
GIT_BRANCH     := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
GIT_TAG        := $(shell git describe --tags --exact-match 2>/dev/null || echo "")
VERSION_TAGS   := $(shell git tag --sort=-version:refname | head -3)

# Temporary directory for git worktrees
WORKTREE_DIR   := $(BUILDDIR)/worktrees

# Use variable for file location
VERSION_INDEX_TEMPLATE = _templates/version_index.html

.PHONY: help Makefile test doc8 dict-check sort-dict license clean clean-all \
        multiversion add-nojekyll create-version-index version-info clean-worktrees

# Put it first so that "make" without argument is like "make help".
help: $(VENV_NAME)
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# Create the virtualenv with all the tools installed
$(VENV_NAME):
	python3 -m venv $@ ;\
	source $@/bin/activate ;\
	pip install --upgrade pip ;\
	pip install -r requirements.txt

# lint and link verification. linkcheck is part of sphinx
test: license doc8 dict-check spelling linkcheck

doc8: $(VENV_NAME)
	source $</bin/activate ; set -u ;\
	doc8 --ignore-path $< --ignore-path _build --ignore-path LICENSES --max-line-length 119

# Words in dict.txt must be in the correct alphabetical order and must not duplicated.
dict-check: sort-dict
	@set -u ;\
	git diff --exit-code dict.txt && echo "dict.txt is sorted" && exit 0 || \
	echo "dict.txt is unsorted or needs to be added to git index" ; exit 1

sort-dict:
	@sort -u < dict.txt > dict_sorted.txt
	@mv dict_sorted.txt dict.txt

license: $(VENV_NAME)
	source $</bin/activate ; set -u ;\
	reuse --version ;\
	reuse --root . lint

# clean up
clean:
	rm -rf $(BUILDDIR)

clean-all: clean
	rm -rf $(VENV_NAME)

# Clean up git worktrees
clean-worktrees:
	@echo "Cleaning up git worktrees..."
	@if [ -d "$(WORKTREE_DIR)" ]; then \
		for worktree in $(WORKTREE_DIR)/*; do \
			if [ -d "$$worktree" ]; then \
				echo "Removing worktree: $$worktree" ;\
				git worktree remove "$$worktree" 2>/dev/null || rm -rf "$$worktree" ;\
			fi ;\
		done ;\
		rmdir "$(WORKTREE_DIR)" 2>/dev/null || true ;\
	fi

# Ensure .nojekyll file exists for GitHub Pages
add-nojekyll:
	@echo "Adding .nojekyll file for GitHub Pages..."
	@if [ -d "$(BUILDDIR)/html" ]; then \
		touch "$(BUILDDIR)/html/.nojekyll"; \
		echo "Created .nojekyll in $(BUILDDIR)/html/"; \
	fi
	@if [ -d "$(BUILDDIR)/multiversion" ]; then \
		touch "$(BUILDDIR)/multiversion/.nojekyll"; \
		echo "Created .nojekyll in $(BUILDDIR)/multiversion/"; \
	fi

# Build single version (current branch/tag)
build: $(VENV_NAME) Makefile
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/html" $(SPHINXOPTS)
	$(MAKE) add-nojekyll
	@echo "Documentation built successfully!"
	@echo "Open $(BUILDDIR)/html/index.html in your browser"

# Build multiple versions
multiversion: $(VENV_NAME) Makefile clean-worktrees
	@echo "Building multi-version documentation..."
	@echo "Current branch: $(GIT_BRANCH)"
	@echo "Available tags: $(VERSION_TAGS)"
	rm -rf "$(BUILDDIR)/multiversion"
	mkdir -p "$(BUILDDIR)/multiversion"
	mkdir -p "$(WORKTREE_DIR)"
	@echo "Building latest version from current working directory..."
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/multiversion/latest" $(SPHINXOPTS)
	@if [ -n "$(VERSION_TAGS)" ]; then \
		for tag in $(VERSION_TAGS); do \
			echo "Building documentation for tag: $$tag using git worktree..." ;\
			worktree_path="$(WORKTREE_DIR)/$$tag" ;\
			if git worktree add "$$worktree_path" "$$tag" 2>/dev/null; then \
				echo "Created worktree for $$tag at $$worktree_path" ;\
				source $</bin/activate ; set -u ;\
				$(SPHINXBUILD) -b html "$$worktree_path" "$(BUILDDIR)/multiversion/$$tag" $(SPHINXOPTS) || echo "Warning: Failed to build $$tag" ;\
				git worktree remove "$$worktree_path" 2>/dev/null || echo "Warning: Failed to remove worktree $$worktree_path" ;\
			else \
				echo "Warning: Could not create worktree for tag $$tag" ;\
			fi ;\
		done ;\
	else \
		echo "No version tags found, building only latest version" ;\
	fi
	$(MAKE) create-version-index
	$(MAKE) add-nojekyll
	$(MAKE) clean-worktrees
	@echo "Multi-version documentation built successfully!"
	@echo "Open $(BUILDDIR)/multiversion/index.html in your browser"

# Create version selection index page
create-version-index:
	@echo "Creating version index page..."
	@mkdir -p "$(BUILDDIR)/multiversion"
	@if [ ! -f "$(VERSION_INDEX_TEMPLATE)" ]; then \
		echo "Error: Template file $(VERSION_INDEX_TEMPLATE) not found"; \
		exit 1; \
	fi
	@cp "$(VERSION_INDEX_TEMPLATE)" "$(BUILDDIR)/multiversion/index.html"
	@if [ -n "$(VERSION_TAGS)" ]; then \
		version_cards="" ;\
		for tag in $(VERSION_TAGS); do \
			version_cards="$$version_cards        <a href=\"$$tag/\" class=\"version-card\">"$$'\n' ;\
			version_cards="$$version_cards            <div class=\"version-title\">$$tag</div>"$$'\n' ;\
			version_cards="$$version_cards            <div class=\"version-desc\">Release $$tag documentation</div>"$$'\n' ;\
			version_cards="$$version_cards        </a>"$$'\n' ;\
		done ;\
		sed -i.bak "s|{{VERSION_CARDS}}|$$version_cards|g" "$(BUILDDIR)/multiversion/index.html" ;\
		rm -f "$(BUILDDIR)/multiversion/index.html.bak" ;\
	else \
		sed -i.bak "s|{{VERSION_CARDS}}||g" "$(BUILDDIR)/multiversion/index.html" ;\
		rm -f "$(BUILDDIR)/multiversion/index.html.bak" ;\
	fi

# Show current version information
version-info:
	@echo "=== Version Information ==="
	@echo "Git Branch: $(GIT_BRANCH)"
	@echo "Git Tag: $(GIT_TAG)"
	@echo "Recent Tags: $(VERSION_TAGS)"
	@if [ -f "VERSION" ]; then echo "Version File: $$(cat VERSION)"; fi
	@echo "Build Directory: $(BUILDDIR)"
	@echo "Worktree Directory: $(WORKTREE_DIR)"
	@echo "=========================="

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: $(VENV_NAME) Makefile
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
