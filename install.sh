#!/bin/sh
sudo apt-get install cmake -y
sudo apt-get install git -y
sudo apt-get install yasm -y
sudo apt-get install m4 -y
sudo apt-get install build-essential -y
sudo apt-get install libgmp3-dev -y
sudo apt-get install libmpfr-dev -y
sudo apt-get install libflint-dev -y
mkdir build
cd build
git clone git://github.com/wbhart/mpir.git mpir
cd mpir
./autogen.sh
./configure
make
make check
sudo make install
mkdir release
cd release
cmake -DBUILD_SHARED_LIBS=FALSE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_BOOST=FALSE -DCRYPTO3_VDF_MPIR=TRUE -DCMAKE_BUILD_TYPE=Release ../../
make chia_vdf_test