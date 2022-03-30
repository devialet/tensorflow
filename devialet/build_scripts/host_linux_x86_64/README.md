# TensorFlow Lite C API library

## Builds

Use the scripts from this directory to build the TensorFlow Lite C API library for native x86_64 architecture and to cross-build for Arm processors.

### Hosts

##### Host: Linux x86 64
Build the library on Linux x86 64 host machine.

### Targets
##### Linux: x86_64 (native build)
Builds the library for `x86_64` architecture.  

Example: `./build_arch.sh builddir x86_64`

##### Arm: aarch64
Builds the library for Arm `aarch64` architecture (64-bit).

Example: `./build_arch.sh builddir aarch64`

##### Arm: armv7l
Builds the library for Arm `armv7l` architecture (32-bit).

Example: `./build_arch.sh builddir armv7l`
