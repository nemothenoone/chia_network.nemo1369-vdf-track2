#!/bin/sh
sudo apt-get install cmake git yasm m4 build-essential autogen automake autoconf libtool -y
sudo apt-get purge libgmp3-dev libmpfr-dev libflint-dev -y
sudo apt-get install libgmp3-dev libmpfr-dev libflint-dev -y
mkdir build
cd build
#git clone git://github.com/wbhart/mpir.git mpir
#cd mpir
#./autogen.sh
#./configure --enable-cxx
#make -j$(nproc) all
#make -j$(nproc) check
#sudo make -j$(nproc) install
#cd ../
mkdir release
cd release
cmake -DBUILD_SHARED_LIBS=FALSE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_BOOST=FALSE -DCRYPTO3_VDF_GMP=TRUE -DCMAKE_BUILD_TYPE=Release ../../
make chia_vdf_test