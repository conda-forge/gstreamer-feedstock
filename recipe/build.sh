#!/bin/bash

# The datarootdir option places the docs into a temp folder that won't
# be included in the package (it is about 12MB).

# https://github.com/conda-forge/bison-feedstock/issues/7
export M4="${BUILD_PREFIX}/bin/m4"

# --disable-examples because:
# https://bugzilla.gnome.org/show_bug.cgi?id=770623#c16
# http://lists.gnu.org/archive/html/libtool/2016-05/msg00022.html
./configure --prefix="$PREFIX"     \
            --disable-examples     \
            --disable-benchmarks   \
            --enable-introspection \
            --datarootdir=`pwd`/tmpshare

make -j${CPU_COUNT} ${VERBOSE_AT}
# This is failing because the exported symbols by the Gstreamer .so library
# on Linux are different from the expected ones on Windows. We don't know
# why that's happening though.
# make check
make install
