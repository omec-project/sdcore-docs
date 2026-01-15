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
        multiversion add-nojekyll create-version-index version-info

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
multiversion: $(VENV_NAME) Makefile
	@echo "Building multi-version documentation..."
	@echo "Current branch: $(GIT_BRANCH)"
	@echo "Available tags: $(VERSION_TAGS)"
	rm -rf "$(BUILDDIR)/multiversion"
	mkdir -p "$(BUILDDIR)/multiversion"
	@echo "Building latest version from branch: $(GIT_BRANCH)"
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/multiversion/latest" $(SPHINXOPTS)
	@if [ -n "$(VERSION_TAGS)" ]; then \
		current_branch=$$(git rev-parse --abbrev-ref HEAD) ;\
		for tag in $(VERSION_TAGS); do \
			echo "Building documentation for tag: $$tag" ;\
			if git checkout $$tag 2>/dev/null; then \
				source $</bin/activate ; set -u ;\
				$(SPHINXBUILD) -b html "$(SOURCEDIR)" "$(BUILDDIR)/multiversion/$$tag" $(SPHINXOPTS) || echo "Warning: Failed to build $$tag" ;\
			else \
				echo "Warning: Could not checkout tag $$tag" ;\
			fi ;\
		done ;\
		git checkout $$current_branch ;\
	else \
		echo "No version tags found, building only latest version" ;\
	fi
	$(MAKE) create-version-index
	$(MAKE) add-nojekyll
	@echo "Multi-version documentation built successfully!"
	@echo "Open $(BUILDDIR)/multiversion/index.html in your browser"

# Create version selection index page
create-version-index:
	@echo "Creating version index page..."
	@mkdir -p "$(BUILDDIR)/multiversion"
	@cat > "$(BUILDDIR)/multiversion/index.html" << 'EOF'
	<!DOCTYPE html>
	<html lang="en">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>SD-Core Documentation Versions</title>
	    <link rel="icon" href="latest/_static/sdcore-favicon-128.png">
	    <style>
	        body {
	            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
	            max-width: 800px;
	            margin: 2rem auto;
	            padding: 0 1rem;
	            line-height: 1.6;
	            background-color: #f8f9fa;
	        }
	        .header {
	            text-align: center;
	            margin-bottom: 3rem;
	            background: white;
	            padding: 2rem;
	            border-radius: 12px;
	            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
	        }
	        .logo {
	            max-width: 200px;
	            margin-bottom: 1rem;
	        }
	        .version-grid {
	            display: grid;
	            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
	            gap: 1.5rem;
	            margin: 2rem 0;
	        }
	        .version-card {
	            border: 2px solid #e9ecef;
	            border-radius: 12px;
	            padding: 2rem;
	            text-decoration: none;
	            color: inherit;
	            transition: all 0.3s ease;
	            background: #fff;
	            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
	        }
	        .version-card:hover {
	            border-color: #1f5582;
	            box-shadow: 0 8px 25px rgba(31, 85, 130, 0.15);
	            transform: translateY(-2px);
	            text-decoration: none;
	        }
	        .version-title {
	            font-size: 1.3rem;
	            font-weight: 600;
	            margin-bottom: 0.5rem;
	            color: #1f5582;
	        }
	        .version-desc {
	            color: #6c757d;
	            font-size: 0.95rem;
	        }
	        .latest-badge {
	            background: #28a745;
	            color: white;
	            padding: 0.25rem 0.5rem;
	            border-radius: 4px;
	            font-size: 0.8rem;
	            margin-left: 0.5rem;
	        }
	        .footer {
	            text-align: center;
	            margin-top: 3rem;
	            padding-top: 2rem;
	            border-top: 1px solid #e9ecef;
	            color: #6c757d;
	            background: white;
	            padding: 2rem;
	            border-radius: 12px;
	            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
	        }
	        .footer a {
	            color: #1f5582;
	            text-decoration: none;
	        }
	        .footer a:hover {
	            text-decoration: underline;
	        }
	    </style>
	</head>
	<body>
	    <div class="header">
	        <img src="latest/_static/sdcore.svg" alt="SD-Core" class="logo" onerror="this.style.display='none'">
	        <h1>SD-Core Documentation</h1>
	        <p>Select a version to view the documentation</p>
	    </div>
	    <div class="version-grid">
	        <a href="latest/" class="version-card">
	            <div class="version-title">Latest<span class="latest-badge">CURRENT</span></div>
	            <div class="version-desc">Latest development version from main branch</div>
	        </a>
	EOF
	@if [ -n "$(VERSION_TAGS)" ]; then \
		for tag in $(VERSION_TAGS); do \
			echo "        <a href=\"$$tag/\" class=\"version-card\">" >> "$(BUILDDIR)/multiversion/index.html" ;\
			echo "            <div class=\"version-title\">$$tag</div>" >> "$(BUILDDIR)/multiversion/index.html" ;\
			echo "            <div class=\"version-desc\">Release $$tag documentation</div>" >> "$(BUILDDIR)/multiversion/index.html" ;\
			echo "        </a>" >> "$(BUILDDIR)/multiversion/index.html" ;\
		done ;\
	fi
	@cat >> "$(BUILDDIR)/multiversion/index.html" << 'EOF'
	    </div>
	    <div class="footer">
	        <p>&copy; 2021-current, <a href="https://opennetworking.org/">Open Networking Foundation</a></p>
	        <p>
	            <a href="https://github.com/omec-project">GitHub</a> |
	            <a href="https://aetherproject.org/">Aether Project</a> |
	            <a href="https://opennetworking.org/">ONF</a>
	        </p>
	    </div>
	</body>
	</html>
	EOF

# Show current version information
version-info:
	@echo "=== Version Information ==="
	@echo "Git Branch: $(GIT_BRANCH)"
	@echo "Git Tag: $(GIT_TAG)"
	@echo "Recent Tags: $(VERSION_TAGS)"
	@if [ -f "VERSION" ]; then echo "Version File: $$(cat VERSION)"; fi
	@echo "Build Directory: $(BUILDDIR)"
	@echo "=========================="

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: $(VENV_NAME) Makefile
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
