#!/bin/bash

pushd python

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

meson_options=(
      -Dpython=$PYTHON
)

meson --prefix=${PREFIX} \
      --libdir=$PREFIX/lib \
      --buildtype=release \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install

