#!/bin/bash

set -ex

pushd plugins_base

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig
EXTRA_FLAGS="-Dintrospection=enabled"

export PKG_CONFIG=$(which pkg-config)

meson_options=(
      -Dgl=enabled
      -Dexamples=disabled
      -Dtests=disabled
)

if [ -n "$OSX_ARCH" ] ; then
	# disable X11 plugins on macOS
	meson_options+=(-Dx11=disabled)
	meson_options+=(-Dxvideo=disabled)
	meson_options+=(-Dxshm=disabled)
fi

meson ${MESON_ARGS} \
      --prefix=${PREFIX} \
      --libdir=$PREFIX/lib \
      --buildtype=release \
      $EXTRA_FLAGS \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install
