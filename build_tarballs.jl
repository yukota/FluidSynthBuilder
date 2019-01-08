# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "FluidSynth"
version = v"2.0.3"

# Collection of sources required to build FluidSynth
sources = [
    "https://github.com/FluidSynth/fluidsynth.git" =>
    "1bae9b2fe1a958f54f4910c802a79673e0df9850",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd fluidsynth/
mkdir build
cd build/
cmake .. -DCMAKE_INSTALL_PREFIX=$prefix -DLIB_SUFFIX="" -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libfluidsynth", :libfluidsynth),
    ExecutableProduct(prefix, "fluidsynth", :fluidsynth)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/staticfloat/GlibBuilder/releases/download/v2.54.2-2/build.jl",
    "https://github.com/staticfloat/libffiBuilder/releases/download/v3.2.1-0/build.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
