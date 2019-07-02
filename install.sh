#!/bin/sh
sudo apt-get install cmake git yasm m4 build-essential autogen automake autoconf libtool autotools-dev texinfo -y
#sudo apt-get install libmpfr-dev libflint-dev -y
mkdir build
cd build

#wget http://mpir.org/mpir-3.0.0.tar.bz2
#tar xvfj mpir-3.0.0.tar.bz2
#cd mpir-3.0.0
#./configure --enable-cxx
#sudo make -j$(nproc) uninstall
#cd ../
#sudo apt-get install libgmp3-dev -y

sudo apt-get purge libgmp3-dev libmpfr-dev libflint-dev -y
git clone git://github.com/wbhart/mpir.git
cd mpir
#wget http://mpir.org/mpir-3.0.0.tar.bz2
#tar xvfj mpir-3.0.0.tar.bz2
#cd mpir-3.0.0
./autogen.sh
./configure --enable-cxx
make -j$(nproc) all
make -j$(nproc) check
sudo make -j$(nproc) uninstall
sudo make -j$(nproc) install
cd ../

mkdir release
cd release
cmake -DBUILD_SHARED_LIBS=FALSE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_BOOST=FALSE -DCRYPTO3_VDF_MPIR=TRUE -DCMAKE_BUILD_TYPE=Release ../../
make chia_vdf_test