#!/usr/bin/bash
sudo apt-get install cmake clang ninja-build libclang-10-dev

ROOTDIR=$(pwd)
PREFIX=$ROOTDIR/ccls-git-bin
CONTROLDIR=$PREFIX/DEBIAN

bold=$(tput bold)
normal=$(tput sgr0)
RED='\033[0;31m'
NC='\033[0m'

echo "${bold}INFO:${normal} Creating working directory"
mkdir -p ${PREFIX} ${CONTROLDIR} || exit

while true; do
    echo "Cleaning directory ${PREFIX}"
    echo "Will delete everything under ${PREFIX} except ${CONTROLDIR}"
    read -p "Continue?" yn
    case $yn in
        [Yy]* ) cd ${PREFIX}; find ./ -mindepth 1 ! -regex '^./DEBIAN\(/.*\)?' -delete; break;;
        [Nn]* ) echo "${bold}Fatal:${normal} Need a clean dir, exiting";exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

BUILDIR=$(mktemp -d)
cd ${BUILDIR}

git clone --depth=1 --recursive https://github.com/MaskRay/ccls
cd ccls

cmake -H. -GNinja --log-level=WARNING -BRelease -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX/usr/local \
    -DCMAKE_PREFIX_PATH=/usr/lib/llvm-10 \
    -DLLVM_INCLUDE_DIR=/usr/lib/llvm-10/include \
    -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-10/

cmake --log-level=WARNING --build Release
cd Release && ninja install

echo ""
echo ""
echo "${bold}INFO:${normal} Edit $CONTROLDIR/control"
echo "${bold}INFO:${normal} Then issue: dpkg-deb --build $PREFIX"
echo "${bold}HINT:${normal} date of latest commit in timestamp: $(git log --pretty=%ct)"

while true; do
    read -p "Do you wish to delete build dir ${BUILDIR}?" yn
    case $yn in
        [Yy]* ) rm -rf ${BUILDIR}; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
