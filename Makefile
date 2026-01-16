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

.PHONY: help Makefile test doc8 dict-check sort-dict license clean clean-all

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

# build multiple versions
multiversion: $(VENV_NAME) Makefile
	source $</bin/activate ; set -u ;\
	sphinx-multiversion "$(SOURCEDIR)" "$(BUILDDIR)/multiversion" $(SPHINXOPTS)
	cp "$(SOURCEDIR)/_templates/meta_refresh.html" "$(BUILDDIR)/multiversion/index.html"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: $(VENV_NAME) Makefile
	source $</bin/activate ; set -u ;\
	$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
