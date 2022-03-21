#!/bin/sh

set -x
# TensorFlow source dir
HOME_DIR=$1
# Meson build dir
BUILD_DIR=$2

# CMake build dir
TFLITEC_BUILDDIR=${HOME_DIR}/tflitec_builddir
# TFLITEC_BUILDDIR=${BUILD_DIR}/tflitec_builddir
mkdir -p ${TFLITEC_BUILDDIR}
cd ${TFLITEC_BUILDDIR}

# Build the TensorFlow Lite C API shared library
echo "Calling CMake to build TensorFlow Lite C API..."
cmake -S ${HOME_DIR}/tensorflow/lite/c >> cmakelog.txt 2>&1
cmake --build . -j >> cmakelog.txt 2>&1

# Copy the binaries
cp libtensorflowlite_c.so ${BUILD_DIR}
