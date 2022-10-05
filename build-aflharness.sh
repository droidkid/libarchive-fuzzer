WORKSPACE=${PWD}
BUILDS=$WORKSPACE/fuzzer/builds
DEPS=$WORKSPACE/fuzzer/deps
OUT=$WORKSPACE/fuzzer
CC=afl-clang-fast
CXX=afl-clang-fast++

git clone  https://github.com/libarchive/libarchive.git
git clone  https://gitlab.gnome.org/GNOME/libxml2.git
# For the seed files.
git clone  https://github.com/google/oss-fuzz



mkdir -p ${DEPS}
mkdir -p ${BUILDS}
mkdir -p ${OUT}

# compile libxml2 from source so we can statically link
cd ./libxml2
./autogen.sh \
    --without-debug \
    --without-ftp \
    --without-http \
    --without-legacy \
    --without-python \
    --enable-static 

./configure --prefix=$BUILDS/libxml2 --enable-static
make -j$(nproc)
make install
cp $BUILDS/libxml2/lib/libxml2.a ${DEPS}/

cd $WORKSPACE/libarchive
rm -rf build2
mkdir -p build2
cd build2
cmake ../ -D CMAKE_C_COMPILER=$CC -D CMAKE_CXX_COMPILER=$CXX
make

cp $WORKSPACE/libarchive/contrib/oss-fuzz/corpus.zip\
        $OUT/seed.zip
unzip $OUT/seed.zip -d $OUT/seed/

cd $WORKSPACE/libarchive
cd build2
$CXX $CXXFLAGS -I../libarchive \
    $WORKSPACE/harness.cc -o $OUT/fuzzer \
    ./libarchive/libarchive.a \
    -lcrypto -lacl -llzma -llz4 -lbz2 -lz -lzstd ${DEPS}/libxml2.a
