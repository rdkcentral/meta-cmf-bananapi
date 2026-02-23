SUMMARY = "Jinja2 is a modern and designer friendly templating language for Python"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE.rst;md5=5dc88300786f1c214c1e9827a5229462"

inherit native pypi setuptools3

PYPI_PACKAGE = "Jinja2"

SRC_URI[sha256sum] = "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"

DEPENDS += "python3-markupsafe-native"
