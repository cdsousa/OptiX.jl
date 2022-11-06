# **Proof of concept** NVIDIA OptiX interface/abstraction for Julia

**Notice, this is just a proof of concept, it is not intended to be a *real* Julia package!**

This package demonstrates how GPUCompiler.jl/CUDA.jl can be used to create OptiX "programs" written in Julia.

This code demonstrates solutions to several problems in wrapping and abstracting OptiX, for example:
- The OptiX library is accessed by function pointers obtained in runtime;
- Parameters are passed to OptiX "programs" as constant global GPU memory;
- Device side functions must be called using custom assembly code (some have multiple return variables);
- OptiX consumes PTX containing functions with very specific signatures.

A usage sample is available in *samples* folder, it produces this:
![](samples/hello_triangle_output.png)