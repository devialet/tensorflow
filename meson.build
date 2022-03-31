################################################################################
# TensorFlow library
################################################################################
project('TensorFlow Lite C API library', 'c', version : '2.8.0')
################################################################################
# System info
os = host_machine.system()
cpu = host_machine.cpu_family()
ccompiler = meson.get_compiler('c')
################################################################################
# Binaries and include location
bins_dir = join_paths(meson.current_source_dir(), 'devialet/binaries')
inc_dir = './devialet/binaries/include'
################################################################################
# Locate OS specific binary
if os.startswith('linux')
  host_machine_to_directory_name = {
    'x86_64':'x86_64',
    'arm':'armv7l',
    'aarch64':'aarch64',
  }
  lib_dir = join_paths(bins_dir, host_machine_to_directory_name[cpu])
else
  # To do:
  error('Unsupported OS: ' + os)
endif
################################################################################
# Get the library
tensorflow_lib = ccompiler.find_library('tensorflowlite_c', dirs: lib_dir)
################################################################################
# Create dependency
tensorflow_dep = declare_dependency(
  dependencies: tensorflow_lib,
  include_directories: include_directories(inc_dir),
)
################################################################################
