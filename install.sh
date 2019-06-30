#!/bin/sh
sudo apt-get install cmake -y
sudo apt-get install libgmp3-dev -y
sudo apt-get install libmpfr-dev -y
sudo apt-get install libflint-dev -y
mkdir build
cd build
mkdir release
cd release
cmake -DBUILD_SHARED_LIBS=FALSE -DCRYPTO3_VDF_USE_SIMD=FALSE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_BOOST=FALSE -DCRYPTO3_VDF_GMP=TRUE -DCMAKE_BUILD_TYPE=Release ../../
make chia_vdf_test