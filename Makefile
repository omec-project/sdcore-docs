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

.PHONY: help test lint doc8 reload Makefile prep

# Put it first so that "make" without argument is like "make help".
help: $(VENV_NAME)
	source $</bin/activate ; set -u ;\
  $(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# Create the virtualenv with all the tools installed
$(VENV_NAME):
	python3 -m venv $(VENV_NAME) ;\
  source $@/bin/activate ;\
  pip install -r requirements.txt

# automatically reload changes in browser as they're made
reload: $(VENV_NAME)
	source $</bin/activate ; set -u ;\
  sphinx-reload $(SOURCEDIR)

# lint and link verification. linkcheck is part of sphinx
test: lint spelling linkcheck

lint: doc8

doc8: $(VENV_NAME) | $(OTHER_REPO_DOCS)
	source $</bin/activate ; set -u ;\
  doc8 --max-line-length 119 \
  $$(find . -name \*.rst ! -path "*venv*" ! -path "*vendor*" ! -path "*repos*" )

# clean up
clean:
	rm -rf $(BUILDDIR)

clean-all: clean
	rm -rf $(VENV_NAME)

# build multiple versions
multiversion: $(VENV_NAME) Makefile | prep $(OTHER_REPO_DOCS)
	source $</bin/activate ; set -u ;\
  sphinx-multiversion "$(SOURCEDIR)" "$(BUILDDIR)/multiversion" $(SPHINXOPTS)
	cp "$(SOURCEDIR)/_templates/meta_refresh.html" "$(BUILDDIR)/multiversion/index.html"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: $(VENV_NAME) Makefile | $(OTHER_REPO_DOCS) $(STATIC_DOCS)
	source $</bin/activate ; set -u ;\
  $(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
