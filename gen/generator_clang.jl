using Clang.Generators
using Clang

OPTIX_SDK_PATH = raw"C:\ProgramData\NVIDIA Corporation\OptiX SDK 7.5.0"

optix_h = [normpath(OPTIX_SDK_PATH, "include", "optix.h")]

options = load_options("generator_clang.toml")

args = [get_default_args(); String["-DOPTIX_DONT_INCLUDE_CUDA", "-DCUcontext=void*", "-DCUstream=void*"]]

ctx = create_context(optix_h, args, options)

build!(ctx)

