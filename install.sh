#!/bin/sh
sudo apt-get install cmake -y
sudo apt-get install libgmp3-dev -y
sudo apt-get install libflint-dev -y
mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=TRUE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_NO_BOOST=TRUE -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc) chia_vdf_test