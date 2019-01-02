# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libfluidsynth"
version = v"2.0.2"

# Collection of sources required to build libfluidsynth
sources = [
    "https://github.com/FluidSynth/fluidsynth.git" =>
    "6e9d84f02a7a0f7e436c2adffc4a065608f490ba",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd fluidsynth/
mkdir build
cd build/
cmake ..  -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
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
    LibraryProduct(prefix, "libfluidsynth", :libfluidsynth)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/staticfloat/GlibBuilder/releases/download/v2.54.2-2/build.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

