#!/bin/bash
set -ex

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig
EXTRA_FLAGS="-Dintrospection=enabled"

export PKG_CONFIG=$(which pkg-config)

meson ${MESON_ARGS} \ 
      --prefix=${PREFIX} \
      --buildtype=release \
      --libdir=$PREFIX/lib \
      $EXTRA_FLAGS \
      -Dptp-helper-permissions=none \
      -Dexamples=disabled \
      -Dtests=disabled \
      --wrap-mode=nofallback \
      ..
ninja -j${CPU_COUNT}
ninja install

# remove gdb files
rm -rf $PREFIX/share/gdb
rm -rf $PREFIX/share/gstreamer-1.0/gdb
