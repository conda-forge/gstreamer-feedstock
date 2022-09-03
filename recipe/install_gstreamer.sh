#!/bin/bash
set -ex

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig
EXTRA_FLAGS="-Dintrospection=enabled"
if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  # Add pkg-config to cross-file binaries since meson will disable it
  # See https://github.com/mesonbuild/meson/issues/7276
  echo "[binaries]" >> $BUILD_PREFIX/meson_cross_file.txt
  echo "pkg-config = '$(which pkg-config)'" >> $BUILD_PREFIX/meson_cross_file.txt
  # Use Meson cross-file flag to enable cross compilation
  EXTRA_FLAGS="--cross-file $BUILD_PREFIX/meson_cross_file.txt -Dintrospection=disabled"
fi

export PKG_CONFIG=$(which pkg-config)

meson --prefix=${PREFIX} \
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
