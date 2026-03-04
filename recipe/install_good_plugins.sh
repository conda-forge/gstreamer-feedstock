#!/bin/bash
set -ex

# Requires.private and Libs.private
# Are not meaningful in the context of shared libraries for conda-forge
# We thus "remove them" outright to avoid
# burdening the recipe
# https://github.com/conda-forge/harfbuzz-feedstock/pull/146
# https://github.com/conda-forge/conda-forge.github.io/issues/1880
find "${PREFIX}/lib/pkgconfig" -type f -name '*.pc' -exec sed -i.bak \
    -e '/^Requires\.private/d' \
    -e '/^Libs\.private/d' \
    {} +
find "${PREFIX}/lib/pkgconfig" -type f -name '*.bak' -delete

pushd plugins_good

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig
EXTRA_FLAGS=""
if [[ $CONDA_BUILD_CROSS_COMPILATION == "1" ]]; then
  # Use Meson cross-file flag to enable cross compilation
  EXTRA_FLAGS="--cross-file $BUILD_PREFIX/meson_cross_file.txt"
  if [[ "${target_platform}" == "osx-arm64" ]]; then
      echo "objcpp = '${CXX}'" >> ${BUILD_PREFIX}/meson_cross_file.txt
      cat ${BUILD_PREFIX}/meson_cross_file.txt
  fi
fi
if [[ "${target_platform}" == "osx-"* ]]; then
    export OBJCXX=${CXX}
    export OBJCXX_FOR_BUILD=${CXX_FOR_BUILD}
fi

export PKG_CONFIG=$(which pkg-config)

meson_options=(
      -Dexamples=disabled
      -Dtests=disabled
)


meson setup ${MESON_ARGS} \
      $EXTRA_FLAGS \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install
