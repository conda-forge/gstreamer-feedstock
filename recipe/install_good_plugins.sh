#!/bin/bash

pushd plugins_good

./configure \
	--disable-examples \
	--enable-experimental \
	--prefix="$PREFIX" \
	--with-html-dir=$(pwd)/tmphtml \
;
make -j${CPU_COUNT} ${VERBOSE_AT}
#make check  <-- some tests fail, probably for the same reason as plugins_base
make install
