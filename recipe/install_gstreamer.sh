#!/bin/bash

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig


meson --prefix=${PREFIX} \
      --buildtype=release \
      --libdir=$PREFIX/lib \
      -Dintrospection=enabled \
      -Dptp-helper-permissions=none \
      -Dexamples=disabled \
      -Dtests=disabled \
      --wrap-mode=nofallback \
      ..
ninja -j${CPU_COUNT}
ninja install
