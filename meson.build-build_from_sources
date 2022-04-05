# Build a TensorFlow library
project('TensorFlow Lite C API library', 'c', version : '2.8.0')

# Call a script which will call CMake
script_name = 'tensorflow_build.sh'
script_path = join_paths(meson.current_source_dir(), script_name)
sourcedir_path = meson.current_source_dir()
builddir_path = meson.current_build_dir()

#  Custom target to build TensorFlow library
tensorflow_ctg = custom_target('tensorflow_ctg',
                             command: [script_path, sourcedir_path, builddir_path],
                             build_always_stale: true,
                             output: 'libtensorflowlite_c.so')

# Declare dependancy
tensorflow_dep = declare_dependency( link_with: tensorflow_ctg, include_directories: '.')
