Documentation Guide
===================

Writing Documentation
---------------------

Docs are generated using :doc:`Sphinx <sphinx:usage/index>`.

Documentation is written in :doc:`reStructuredText
<sphinx:usage/restructuredtext/basics>` - see this link for the basic format.

In reStructuredText documents, to create the section hierarchy (mapped in HTML
to ``<h1>`` through ``<h5>``) use these characters to underline headings in the
order given: ``=``, ``-`` ``"``, ``'``, ``^``.

Referencing other Documentation
-------------------------------

Other Sphinx-built documentation, both ONF and non-ONF can be linked to using
:doc:`Intersphinx <sphinx:usage/extensions/intersphinx>`.

You can see all link targets available on a remote Sphinx's docs by running::

  python -msphinx.ext.intersphinx http://otherdocs/objects.inv

Building the Docs
------------------

The documentation build process is stored in the ``Makefile``. Building docs
requires Python to be installed, and most steps will create a virtualenv
(``venv_docs``) which contains the required tools.  You may also need to
install the ``enchant`` C library using your system's package manager for the
spelling checker to function properly.

Run ``make html`` to generate html documentation in ``_build/html``.

To check the formatting of documentation, run ``make lint``. This will be done
in Jenkins to validate the documentation, so please do this before you create a
patchset.

To check spelling, run ``make spelling``. If there are additional words that
are correctly spelled but not in the dictionary (acronyms, trademarks, etc.)
please add them to the ``dict.txt`` file.

Creating new Versions of Docs
-----------------------------

To change the version shown on the built site, change the contents of the
``VERSION`` file.

There is a ``make multiversion`` target which will build all versions published
on the remote to ``_build``. This will use a fork of `sphinx-multiversion
<https://github.com/Holzhaus/sphinx-multiversion>`_ to build multiple versions
for the site.

Adding Images and Diagrams
--------------------------

There are multiple ways to add images and diagrams to the documentation.
Generally, you should prefer using `SVG
<https://en.wikipedia.org/wiki/Scalable_Vector_Graphics>`_ images, as these can
be scaled to any size without quality loss.

If you're creating diagrams, there are multiple tools available.
:doc:`Graphviz <sphinx:usage/extensions/graphviz>` can render inline text-based
graphs definitions and diagrams within the documentation, and is best for
simple diagrams.

More complex diagrams can be created in `Diagrams.net/Draw.io
<https://www.diagrams.net/>`_ format. When saving these diagrams, use the
SVG format, and check the "Include a copy of my diagram". This will let
someone open the SVG later directly from the documentation and edit it, without
any loss in functionality or quality.

The last resort is to use raster images. If they're drawings or screen
captures, use the `PNG
<https://en.wikipedia.org/wiki/Portable_Network_Graphics>`_ format.  Consider
compressing them with a tool like `OptiPNG <http://optipng.sourceforge.net/>`_,
or `pngquant <https://pngquant.org/>`_.  If it's a photograph, use `JPEG
<https://en.wikipedia.org/wiki/JPEG>`_.
