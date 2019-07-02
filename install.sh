#!/bin/sh
sudo apt-get install cmake git yasm m4 build-essential autogen automake autoconf libtool -y
sudo rm -rf /usr/lib/gcc/x86_64-linux-gnu/8/../../../x86_64-linux-gnu/libgmpxx.a
sudo rm -rf /usr/lib/gcc/x86_64-linux-gnu/8/../../../x86_64-linux-gnu/libgmp.a
sudo apt-get install libgmp3-dev libmpfr-dev libflint-dev -y
mkdir build
cd build
mkdir release
cd release
cmake -DBUILD_SHARED_LIBS=FALSE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_BOOST=FALSE -DCRYPTO3_VDF_GMP=TRUE -DCMAKE_BUILD_TYPE=Release ../../
make chia_vdf_test