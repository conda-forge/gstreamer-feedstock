#!/bin/bash

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  # Meson pulls arm64 python as part of its distribution, which cannot be executed on x86_64 CIs
  CONDA_SUBDIR="osx-64" conda create -y --prefix "${SRC_DIR}/osx_64_python" python -c conda-forge
  export PATH="${SRC_DIR}/osx_64_python/bin":$PATH
fi

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

# remove gdb files
rm -rf $PREFIX/share/gdb
rm -rf $PREFIX/share/gstreamer-1.0/gdb
