#!/bin/sh
sudo apt-get install build-essential -y
sudo apt-get install yasm -y
sudo apt-get install autoconf autotools-dev libtool texinfo -y
sudo apt-get install cmake git m4 autogen automake -y
sudo apt-get install libmpfr-dev libflint-dev libgmp3-dev -y
mkdir build
cd build

#wget http://mpir.org/mpir-3.0.0.tar.bz2
#tar xvfj mpir-3.0.0.tar.bz2
#cd mpir-3.0.0
#./configure
#sudo make -j$(nproc) uninstall
#cd ../

#sudo rm -rf /usr/lib/gcc/x86_64-linux-gnu/8/../../../x86_64-linux-gnu/libgmpxx.a
#sudo rm -rf /usr/lib/gcc/x86_64-linux-gnu/8/../../../x86_64-linux-gnu/libgmp.a

git clone git://github.com/wbhart/mpir.git
cd mpir
#wget http://mpir.org/mpir-3.0.0.tar.bz2
#tar xvfj mpir-3.0.0.tar.bz2
#cd mpir-3.0.0
./autogen.sh
./configure --enable-cxx
./autogen.sh
./configure --enable-cxx
make -j$(nproc) all
#make -j$(nproc) check
#cd tune
#make -j$(nproc) tune
#cd ../
sudo make -j$(nproc) uninstall
sudo make -j$(nproc) install
cd ../

mkdir release
cd release
cmake -DBUILD_SHARED_LIBS=FALSE -DBUILD_UNIT_TESTS=FALSE -DCRYPTO3_VDF_BOOST=FALSE -DCRYPTO3_VDF_MPIR=TRUE -DCMAKE_BUILD_TYPE=Release ../../
make chia_vdf_test