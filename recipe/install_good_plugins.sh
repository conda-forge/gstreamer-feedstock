#!/bin/bash
set -ex

pushd plugins_good

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig
EXTRA_FLAGS=""
if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  # Use Meson cross-file flag to enable cross compilation
  EXTRA_FLAGS="--cross-file $BUILD_PREFIX/meson_cross_file.txt"
fi

export PKG_CONFIG=$(which pkgconf)

meson_options=(
      -Dexamples=disabled
      -Dtests=disabled
)

if [ $(uname) = "Linux" ] ; then
	# v4l2 contains clock_gettime, resulting in linker error
	meson_options+=(-Dv4l2=disabled)
fi

meson --prefix=${PREFIX} \
      --buildtype=release \
      --libdir=$PREFIX/lib \
      $EXTRA_FLAGS \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install
