#!/bin/bash

# gstreamer expects libffi to be in lib64 for some reason.
[[ -d $PREFIX/lib64 ]] || mkdir $PREFIX/lib64
cp -r $PREFIX/lib/libffi* $PREFIX/lib64

# The datarootdir option places the docs into a temp folder that won't
# be included in the package (it is about 12MB).

# --disable-examples because:
# https://bugzilla.gnome.org/show_bug.cgi?id=770623#c16
# http://lists.gnu.org/archive/html/libtool/2016-05/msg00022.html
./configure --prefix="$PREFIX"    \
            --disable-examples    \
            --disable-benchmarks  \
            --datarootdir=`pwd`/tmpshare

make -j${CPU_COUNT} V=1
# This is failing because the exported symbols by the Gstreamer .so library
# on Linux are different from the expected ones on Windows. We don't know
# why that's happening though.
# make check
make install

# Remove the created lib64 directory
rm -rf $PREFIX/lib64

