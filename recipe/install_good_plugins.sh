#!/bin/bash

pushd plugins_good

./configure \
	--disable-examples \
	--enable-experimental \
	--prefix="$PREFIX" \
	--with-html-dir=$(pwd)/tmphtml \
;
make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install
