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

.PHONY: help Makefile test doc8 dict-check sort-dict license clean clean-all \
        multiversion build-versions

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

# Build single version (current branch/tag)
build: $(VENV_NAME) Makefile
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/html" $(SPHINXOPTS)
	@echo "Documentation built successfully!"
	@echo "Open $(BUILDDIR)/html/index.html in your browser"

# Build multiple versions
multiversion: build-versions

build-versions: $(VENV_NAME) Makefile
	@echo "Building multi-version documentation..."
	@echo "Current branch: $(GIT_BRANCH)"
	@echo "Available tags: $(VERSION_TAGS)"

	# Clean and create versions directory
	rm -rf "$(BUILDDIR)/versions"
	mkdir -p "$(BUILDDIR)/versions"

	# Build current version (main/current branch)
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/versions/latest" $(SPHINXOPTS)

	# Build tagged versions
	@current_branch=$$(git rev-parse --abbrev-ref HEAD) ;\
	for tag in $(VERSION_TAGS); do \
		echo "Building documentation for tag: $$tag" ;\
		git checkout $$tag ;\
		source $</bin/activate ; set -u ;\
		$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/versions/$$tag" $(SPHINXOPTS) ;\
	done ;\
	git checkout $$current_branch

	# Create version index page
	$(MAKE) create-version-index

	@echo "Multi-version documentation built successfully!"
	@echo "Open $(BUILDDIR)/versions/index.html in your browser"

# Create version selection index page
create-version-index: $(VENV_NAME)
	@echo "Creating version index page..."
	@cat > "$(BUILDDIR)/versions/index.html" << 'EOF' ;\
	<!DOCTYPE html>\
	<html lang="en">\
	<head>\
	    <meta charset="UTF-8">\
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">\
	    <title>SD-Core Documentation Versions</title>\
	    <link rel="icon" href="latest/_static/sdcore-favicon-128.png">\
	    <style>\
	        body {\
	            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;\
	            max-width: 800px;\
	            margin: 2rem auto;\
	            padding: 0 1rem;\
	            line-height: 1.6;\
	        }\
	        .header {\
	            text-align: center;\
	            margin-bottom: 3rem;\
	        }\
	        .logo {\
	            max-width: 200px;\
	            margin-bottom: 1rem;\
	        }\
	        .version-grid {\
	            display: grid;\
	            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));\
	            gap: 1.5rem;\
	            margin: 2rem 0;\
	        }\
	        .version-card {\
	            border: 2px solid #e9ecef;\
	            border-radius: 12px;\
	            padding: 2rem;\
	            text-decoration: none;\
	            color: inherit;\
	            transition: all 0.3s ease;\
	            background: #fff;\
	        }\
	        .version-card:hover {\
	            border-color: #1f5582;\
	            box-shadow: 0 8px 25px rgba(31, 85, 130, 0.15);\
	            transform: translateY(-2px);\
	        }\
	        .version-title {\
	            font-size: 1.3rem;\
	            font-weight: 600;\
	            margin-bottom: 0.5rem;\
	            color: #1f5582;\
	        }\
	        .version-desc {\
	            color: #6c757d;\
	            font-size: 0.95rem;\
	        }\
	        .latest-badge {\
	            background: #28a745;\
	            color: white;\
	            padding: 0.25rem 0.5rem;\
	            border-radius: 4px;\
	            font-size: 0.8rem;\
	            margin-left: 0.5rem;\
	        }\
	    </style>\
	</head>\
	<body>\
	    <div class="header">\
	        <img src="latest/_static/sdcore.svg" alt="SD-Core" class="logo">\
	        <h1>SD-Core Documentation</h1>\
	        <p>Select a version to view the documentation</p>\
	    </div>\
	    \
	    <div class="version-grid">\
	        <a href="latest/" class="version-card">\
	            <div class="version-title">Latest<span class="latest-badge">CURRENT</span></div>\
	            <div class="version-desc">Latest development version from main branch</div>\
	        </a>

	@for tag in $(VERSION_TAGS); do \
		echo "        <a href=\"$$tag/\" class=\"version-card\">" >> "$(BUILDDIR)/versions/index.html" ;\
		echo "            <div class=\"version-title\">$$tag</div>" >> "$(BUILDDIR)/versions/index.html" ;\
		echo "            <div class=\"version-desc\">Release $$tag documentation</div>" >> "$(BUILDDIR)/versions/index.html" ;\
		echo "        </a>" >> "$(BUILDDIR)/versions/index.html" ;\
	done

	@cat >> "$(BUILDDIR)/versions/index.html" << 'EOF'
	    </div>

	    <footer style="text-align: center; margin-top: 3rem; padding-top: 2rem; border-top: 1px solid #e9ecef; color: #6c757d;">
	        <p>&copy; 2021-current, Open Networking Foundation</p>
	    </footer>
	</body>
	</html>
	EOF

# Build for production deployment
production: $(VENV_NAME) Makefile
	@echo "Building production documentation..."
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/html" -E -a $(SPHINXOPTS)
	@echo "Production build complete!"

# Quick development build (no warnings as errors)
dev: $(VENV_NAME) Makefile
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/html" -W --keep-going

# Show current version information
version-info:
	@echo "Git Branch: $(GIT_BRANCH)"
	@echo "Git Tag: $(GIT_TAG)"
	@echo "Recent Tags: $(VERSION_TAGS)"
	@if [ -f "VERSION" ]; then echo "Version File: $$(cat VERSION)"; fi

# Build and deploy to GitHub Pages (if using GitHub Actions)
deploy-github: build-versions
	@echo "Preparing deployment to GitHub Pages..."
	@if [ ! -d "$(BUILDDIR)/versions" ]; then \
		echo "Error: No versions built. Run 'make build-versions' first."; \
		exit 1; \
	fi
	@echo "Documentation ready for deployment from $(BUILDDIR)/versions/"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: $(VENV_NAME) Makefile
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
