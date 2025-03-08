#!/bin/bash

hasbin() {
  local BIN="$1"
  if [ ! -f /usr/bin/"$BIN" ]; then
    echo "Error: $1 is not installed."
    exit 1
  fi
}

# Check that the needed binaries are installed.
hasbin wget
hasbin tar

# Download the source code.
if [ ! -f glibc-2.41.tar.xz ]; then
  wget https://ftp.gnu.org/gnu/glibc/glibc-2.41.tar.xz
fi

# Extract the source code.
tar -xf glibc-2.41.tar.xz

cd glibc-2.41
mkdir build
cd build

../configure \
    --prefix=/usr \
    --libdir=/usr/lib \
    --libexecdir=/usr/lib \
    --with-headers=/usr/include \
    --enable-stack-protector=strong \
    --enable-bind-now \
    --enable-fortify-source \
    --enable-systemtap \
    --disable-multi-arch \
    --disable-nscd \
    --disable-profile \
    --disable-werror \
    --enable-shared

\make -j$(nproc)
