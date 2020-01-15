#!/bin/bash

pushd plugins_base

pkg-config --variable pc_path pkg-config
pkg-config --libs --cflags gl

# The datarootdir option places the docs into a temp folder that won't
# be included in the package (it is about 12MB).
# You need to enable opengl to get gstallocators

# warning: libgstbase-1.0.so.0, needed by ./.libs/libgstnet-1.0.so, not found (try using -rpath or -rpath-link)
if [[ ${target_platform} =~ .*linux.* ]]; then
  export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,${PREFIX}/lib"
fi

./configure --prefix="$PREFIX"  \
            --disable-examples  \
            --enable-opengl     \
            --enable-introspection \
            --with-html-dir=$(pwd)/tmphtml
make -j${CPU_COUNT} ${VERBOSE_AT}
# Some tests fail because not all plugins are built and it seems
# tests expect all plugins
# See this link for an explanation:
# https://bugzilla.gnome.org/show_bug.cgi?id=752778#c17
# make check || { cat tests/check/test-suite.log; exit 1;}
make install
