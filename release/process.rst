..
   SPDX-FileCopyrightText: © 2020 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

Release Process
===============

NOTE -- On or around Oct 16, 2024, the 'master' branch was renamed to be 
'main'.  Interpret documentation and expectations accordingly.  Not all 
references were updated to reflect the change.  Hopefully, all build 
statements were.

Prerequisites
-------------

SD-Core makes the following assumptions about the components are included in a
release:

Git tags
""""""""

Code receives Git tags as a part of the CI process

* Tag content comes from a **VERSION** file within the repo, and tags are
  created only the version is a SemVer released version (example: ``1.2.3``, no
  ``-dev`` or ``-rc`` extensions)

* Tagging is *only done by the CI system* (GitHub Actions), which pushes tags to git
  repos after a submit/merge of code which changes the **VERSION** file.

* CI system enforces tag uniqueness - no two commits have the same released
  version tags.

  * You can't re-release or "fix" a version that has problem - make a new
    version with fixes in it.

Docker container images
"""""""""""""""""""""""

All docker images are tagged based on their git tags.

* For released versions, the CI system should prevent a Dockerfile from
  referencing a parent containers that are a moving target, such as ``latest``
  or ``main``.

  * This allows a container to be rebuilt given an arbitrary git commit with
    fair confidence that it will result in the same code in the container.

* There are two sets of Docker images that are created

  * The first set of Docker images is created based on every Pull Request that
    is merged in the source code and the image has the following two tags:
    ``latest`` and ``master-hashId``, where the ``hashId`` is the short commit ID.
    These 2 images are pushed into the ``sdcore`` project in ``registry.aetherproject.org``
    (https://registry.aetherproject.org/harbor/projects/9/repositories)
  * The second set is the official release image which is created only when
    there is a new code release (when **VERSION** file changed). This image is
    pushed to ``DockerHub`` (https://hub.docker.com/u/omecproject) and has a tag
    named ``rel-semver`` (e.g., rel-1.4.0).

* Official images are only pushed to registries by the CI system

    * Increases repeatability of the process, and prevents human accidents.

Helm charts
"""""""""""

* Each chart may only contain references to released, SemVer tagged container images

  * Chart CI process must check that a chart version is unique - a chart can't
    be created with the same version twice.  This should be done against the
    chart repo.

Release Steps
-------------

All Helm charts are checked that the containers they use have a SemVer version
tag

A branch is created on the Helm charts repo, with the abbreviated name of the
release - for example **sdcore-1.0**.

To allow for future patches to go into the repo in a way that does not conflict
with the version branch, each component repo's **VERSION** file should have it's
minor version increased. (ex: 1.2.n to 1.3.0-dev, so future 1.3.n+1 component
release can easily be created).

The same should be done on Helm charts in the chart repos post release, but the
versions there should not include a ``-dev`` suffix because chart publishing
requires that every new chart version be unique and unsuffixed SemVer is a
more consistent release numbering pattern.

Finally, the ``sdcore-helm-charts`` repo overall **VERSION** should also be incremented
to the next minor version (1.6.0-dev) on the **master** branch, so all 1.0.x
releases of the overall charts repo will happen on the **sdcore-1.0** branch.

Creating releases on the 1.0.x branch
"""""""""""""""""""""""""""""""""""""

If a fix is needed only to the helm charts:

1. Make the fix on the master branch of sdcore-helm-charts (assuming that it is
   required in both places).

2. After the master tests pass, manually cherry-pick the fix to the **sdcore-1.0**
   branch (the Chart version would be different, requiring the manual step).

3. Cherry-picked patchsets on that branch will be checked by the **sdcore-1.0**
   branch of tests.

4. When it passes, submitting the change will make a new 1.0.x release

5. Update the documentation to reflect the chart changes, a description of the
   changes m, and increment the tag on the docs from 1.0.n to 1.0.n+1, to
   reflect the patch change.

6. If all the charts are updated and working correctly, create a new charts
   point release by increasing the 1.0.n **VERSION** file in the
   sdcore-helm-charts repo.  This should be the same as the version in the
   documentation.  Immediately make another patch that returns the
   ``sdcore-helm-charts`` **VERSION** to 1.0.n+1-dev, so that development
   patches can continue on that branch.

If a fix is needed to the components/containers that are included by the helm charts:

1. Develop a fix to the issue on the master branch, get it approved after
   passing master tests.

2. If it does not exist, create an **sdcore-1.0** branch on the component repo,
   starting at the commit where the **VERSION** of the component used in 1.0 was
   created - this is known as "lazy branching".


3. Manually cherry-pick to the **sdcore-1.0** branch of the component, increment
   the patch version, and test with the **sdcore-1.0** version of
   sdcore-system-tests and helm charts.

4. Update helm charts and go through the helm chart update process above

