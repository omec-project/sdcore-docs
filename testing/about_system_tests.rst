..
   SPDX-FileCopyrightText: © 2021 Open Networking Foundation <support@opennetworking.org>
   SPDX-License-Identifier: Apache-2.0

Overview
========

The goal and objective of SD-Core test automation is to build a framework that
provides highly scalable and low maintenance code which will help cover various
categories of tests.  Framework includes libraries and tools that allows both
component level and integration level tests. Robot Framework will be used for
covering integration tests. Component level test coverage have been
accomplished by leveraging the existing test frameworks that were developed in
their respective projects. Component level tests include tests for SD-CORE areas.

Test Frameworks
---------------

The following diagram outlines each SD-Core component, followed by an online
of the test frameworks used:

.. image:: images/4G-Common-Testing.png
  :width: 840
  :height: 540
  :alt: Aether Overview Diagram

Test Automation
---------------

`Jenkins <https://www.jenkins.io/>`_ is the primary automation server that is
used to help trigger our automated tests. All Aether Jenkins jobs are
created and run on the Aether Jenkins instance.
