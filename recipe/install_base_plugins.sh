#!/bin/bash

pushd plugins_base

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

meson_options=(
      -Dintrospection=enabled
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

meson --prefix=${PREFIX} \
      --libdir=$PREFIX/lib \
      --buildtype=release \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install
