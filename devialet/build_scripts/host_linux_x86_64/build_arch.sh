################################################################################
#!/bin/bash
#
# Build "TensorFlow Lite C API" library on Linux x86_64 host.
#
################################################################################
if [[ $# -ne 2 ]]; then
  echo "Build TensorFlow Lite C API library on Linux x86-64 host."
  echo "Usage: build_arch.sh /path/to/builddir target [armv7l|aarch64|x86_64]."
  exit 2
fi
################################################################################
# Arm 32 or 64 or native x86 64
TARGET=$2
################################################################################
if [ "$TARGET" == "aarch64" ]; then
  TOOLCHAIN_NAME=gcc-arm-11.2-2022.02-x86_64-aarch64-none-linux-gnu
  TOOLCHAIN_NAME_SHORT=aarch64-none-linux-gnu
  # Compiler flags
  ARMCC_FLAGS="-march=armv8-a -funsafe-math-optimizations"
  PROCESSOR=$TARGET
elif [ "$TARGET" == "armv7l" ]; then
  TOOLCHAIN_NAME=gcc-arm-11.2-2022.02-x86_64-arm-none-linux-gnueabihf
  TOOLCHAIN_NAME_SHORT=arm-none-linux-gnueabihf
  # Compiler flags
  ARMCC_FLAGS="-march=armv7-a -funsafe-math-optimizations -mfp16-format=ieee"
  PROCESSOR=$TARGET
elif [ "$TARGET" == "x86_64" ]; then
  TOOLCHAIN_NAME=
  TOOLCHAIN_NAME_SHORT=
  ARMCC_FLAGS=
  PROCESSOR=$TARGET
else
  echo "Error: unsupported target: $TARGET"
  echo "Usage: build_arch.sh /path/to/builddir target [armv7l|aarch64|x86_64]."
  exit 2
fi
################################################################################
# Library name and headers
LIBNAME=libtensorflowlite_c.so
INCNAME=c_api.h
################################################################################
# Where to build
BUILDDIR=$(realpath "$1")
mkdir -p $BUILDDIR
CMAKEDIR=${BUILDDIR}/cmakedir-$TARGET
mkdir -p $CMAKEDIR
################################################################################
# TensorFlow source relative to this script
FULL_PATH_TO_SCRIPT="$(realpath "$0")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"
TENSORFLOW_SRC=${SCRIPT_DIRECTORY}/../../../tensorflow/lite/c/
BINARY_DIR=${SCRIPT_DIRECTORY}/../../binaries/${TARGET}/
INCLUDE_DIR=${SCRIPT_DIRECTORY}/../../binaries/include/
################################################################################
# Toolchain if not native
if [ "$TARGET" == "aarch64" ] || [ "$TARGET" == "armv7l" ]; then
  # Toolchain dir
  TOOLCHAINDIR=${BUILDDIR}/toolchains
  mkdir -p $TOOLCHAINDIR
  # Get the toolchain from developer.arm.com
  TOOLCHAIN_HTTPS=https://developer.arm.com/-/media/Files/downloads/gnu/11.2-2022.02/binrel
  # Toolchain file
  TOOLCHAIN_FILE=${TOOLCHAIN_NAME}.tar.xz
  TOOLCHAIN_URL=${TOOLCHAIN_HTTPS}/${TOOLCHAIN_FILE}

  # Go to build dir
  cd $BUILDDIR
  # Get the toolchain and unpack it
  echo "Getting toolchain ${TOOLCHAIN_URL}"
  curl -LO ${TOOLCHAIN_URL}
  echo "Extracting toolchain to ${TOOLCHAINDIR}..."
  tar xvf ${TOOLCHAIN_FILE} -C ${TOOLCHAINDIR}
  echo "Done."

  ARMCC_PREFIX=${TOOLCHAINDIR}/${TOOLCHAIN_NAME}/bin/${TOOLCHAIN_NAME_SHORT}-
else
  ARMCC_PREFIX=
fi
################################################################################
# Run CMake
cd $CMAKEDIR
cmake \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_SYSTEM_PROCESSOR=${PROCESSOR} \
  -DCMAKE_C_COMPILER=${ARMCC_PREFIX}gcc \
  -DCMAKE_CXX_COMPILER=${ARMCC_PREFIX}g++ \
  -DCMAKE_C_FLAGS="${ARMCC_FLAGS}" \
  -DCMAKE_CXX_FLAGS="${ARMCC_FLAGS}" \
  -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF \
  ${TENSORFLOW_SRC}
cmake --build . --parallel 4 --clean-first
################################################################################
# Copy the library and headers to destination directory
cp $CMAKEDIR/$LIBNAME $BINARY_DIR
cp $TENSORFLOW_SRC/$INCNAME $INCLUDE_DIR
################################################################################
