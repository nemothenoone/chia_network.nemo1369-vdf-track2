#!/bin/sh
sudo apt-get install cmake git yasm m4 build-essential autogen autoconf libtool -y
sudo apt-get install libgmp3-dev libmpfr-dev libflint-dev -y
mkdir build
cd build
git clone git://github.com/wbhart/mpir.git mpir
cd mpir
./autogen.sh
./configure --enable-cxx
make all
make check
sudo make install
cd ../
mkdir release
cd release
cmake -DBUILD_SHARED_LIBS=FALSE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_BOOST=FALSE -DCRYPTO3_VDF_MPIR=TRUE -DCMAKE_BUILD_TYPE=Release ../../
make chia_vdf_test