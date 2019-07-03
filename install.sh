#!/bin/sh
sudo apt-get -qq install build-essential -y
sudo apt-get -qq install yasm -y
sudo apt-get -qq install autoconf autotools-dev libtool texinfo -y
sudo apt-get -qq install cmake git m4 autogen automake -y

#sudo rm -rf /usr/lib/gcc/x86_64-linux-gnu/8/../../../x86_64-linux-gnu/libgmpxx.a
#sudo rm -rf /usr/lib/gcc/x86_64-linux-gnu/8/../../../x86_64-linux-gnu/libgmp.a

sudo apt-get -qq install libmpfr-dev libflint-dev libgmp3-dev -y
mkdir build
cd build

#wget http://mpir.org/mpir-3.0.0.tar.bz2
#tar xvfj mpir-3.0.0.tar.bz2
#cd mpir-3.0.0
#./configure
#sudo make -j$(nproc) uninstall
#cd ../

git clone git://github.com/wbhart/mpir.git > /dev/null 2>&1
cd mpir
#wget http://mpir.org/mpir-3.0.0.tar.bz2
#tar xvfj mpir-3.0.0.tar.bz2
#cd mpir-3.0.0
./autogen.sh > /dev/null 2>&1
./autogen.sh > /dev/null 2>&1
./configure --enable-cxx --build=skylakeavx-pc-linux-gnu > /dev/null 2>&1
./config.guess
make -j$(nproc) > /dev/null 2>&1
make -j$(nproc) check > /dev/null 2>&1
sudo make -j$(nproc) uninstall > /dev/null 2>&1
sudo make -j$(nproc) install > /dev/null 2>&1
cd ../

mkdir release
cd release
cmake -DBUILD_SHARED_LIBS=FALSE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_BOOST=FALSE -DCRYPTO3_VDF_MPIR=TRUE -DCMAKE_BUILD_TYPE=Release ../../
make chia_vdf_test