export optixGetLaunchIndex, optixGetLaunchDimensions, optixGetSbtData, optixGetSbtDataVector,
       optixTrace, optixSetPayload, optixGetTriangleBarycentrics

using CUDA.LLVM

# ---------- Adapted from OptiX SDK 7.4.0 include\internal\optix_7_device_impl.h ----------

import CUDA: @device_override, @device_function

@device_function @inline function optixGetLaunchIndex()
    # u0 = ccall("extern _optix_get_launch_index_x", llvmcall, UInt32, (), ) # <- this doesn' work
    u0 = CUDA.GPUCompiler.@asmcall("call (\$0), _optix_get_launch_index_x, ();", "=r", UInt32)
    u1 = CUDA.GPUCompiler.@asmcall("call (\$0), _optix_get_launch_index_y, ();", "=r", UInt32)
    u2 = CUDA.GPUCompiler.@asmcall("call (\$0), _optix_get_launch_index_z, ();", "=r", UInt32)
    return (;x = u0 + UInt32(1), y = u1 + UInt32(1), z = u2 + UInt32(1))
end

@device_function @inline function optixGetLaunchDimensions()
    u0 = CUDA.GPUCompiler.@asmcall("call (\$0), _optix_get_launch_dimension_x, ();", "=r", UInt32)
    u1 = CUDA.GPUCompiler.@asmcall("call (\$0), _optix_get_launch_dimension_y, ();", "=r", UInt32)
    u2 = CUDA.GPUCompiler.@asmcall("call (\$0), _optix_get_launch_dimension_z, ();", "=r", UInt32)
    return (;x = u0, y = u1, z = u2)
end

@device_function @inline function optixGetSbtDataPointer()
    Ptr{Cvoid}(CUDA.GPUCompiler.@asmcall("call (\$0), _optix_get_sbt_data_ptr_64, ();", "=l", UInt64))
end

@device_function @inline function optixTrace(
        handle::OptixTraversableHandle,
        rayOrigin::NTuple{3, Float32},
        rayDirection::NTuple{3, Float32},
        tmin::Float32,
        tmax::Float32,
        rayTime::Float32,
        visibilityMask::OptixVisibilityMask,
        rayFlags::UInt32,
        SBToffset::UInt32,
        SBTstride::UInt32,
        missSBTIndex::UInt32,
        ps::NTuple{N, UInt32}) where N

    @assert 0 <= N <= 32

    ox, oy, oz = rayOrigin
    dx, dy, dz = rayDirection

    ret = CUDA.GPUCompiler.@asmcall("call (\$0,\$1,\$2,\$3,\$4,\$5,\$6,\$7,\$8,\$9,\$10,\$11,\$12,\$13,\$14,\$15,\$16,\$17,\$18,\$19,\$20,\$21,\$22,\$23,\$24,\$25,\$26,\$27,\$28,\$29,\$30,\$31), _optix_trace_typed_32, (\$32,\$33,\$34,\$35,\$36,\$37,\$38,\$39,\$40,\$41,\$42,\$43,\$44,\$45,\$46,\$47,\$48,\$49,\$50,\$51,\$52,\$53,\$54,\$55,\$56,\$57,\$58,\$59,\$60,\$61,\$62,\$63,\$64,\$65,\$66,\$67,\$68,\$69,\$70,\$71,\$72,\$73,\$74,\$75,\$76,\$77,\$78,\$79,\$80);",
    "=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,=r,r,l,f,f,f,f,f,f,f,f,f,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r,r",
    Tuple{
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        Nothing}, # A dummy `Nothing` is needed here as a workaround to avoid
                  # that LLVM defines the return type as [32 x i32] which would
                  # make this asm call fail
    Tuple{
        UInt32, UInt64, Float32, Float32, Float32, Float32, Float32, Float32,
        Float32, Float32, Float32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,
        UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32,},
    UInt32(0), handle, ox, oy, oz, dx, dy, dz,
    tmin, tmax, rayTime, visibilityMask, rayFlags, SBToffset, SBTstride, missSBTIndex, UInt32(N), ps..., Ref{NTuple{32-N, UInt32}}()[]...)

    # cast NTuple{32, UInt32} to NTuple{N, UInt32}
    _ret = Ref(ret)
    retn = GC.@preserve _ret begin
       unsafe_load(convert(Ptr{NTuple{N, UInt32}}, Base.unsafe_convert(Ptr{Cvoid}, _ret)))
    end

    return retn
end

@device_function @inline function optixGetTriangleBarycentrics()
    ret = CUDA.GPUCompiler.@asmcall("call (\$0, \$1), _optix_get_triangle_barycentrics, ();", "=f,=f", Tuple{Float32, Float32, Nothing})
    return ret[1:2]
end

@device_function @inline function optixSetPayload(i::UInt32, p::UInt32)
    CUDA.GPUCompiler.@asmcall("call _optix_set_payload, (\$0, \$1);", "r,r", Nothing, Tuple{UInt32, UInt32}, i, p)
end

for i=0:31
    func_name = Symbol("optixSetPayload_$(i)")
    @eval @device_function @inline function $func_name(p::UInt32)
        optixSetPayload($(UInt32(i)), p)
    end
end



# ---------- helpers ----------


@device_function @inline function optixGetSbtData(::Type{T}) where T
    CuDeviceVector(1, CUDA.LLVMPtr{T, 2}(optixGetSbtDataPointer()))[1]
end

@device_function @inline function optixGetSbtDataVector(::Type{T}, len::Int) where T
    CuDeviceVector(len, CUDA.LLVMPtr{T, 2}(optixGetSbtDataPointer()))
end

@device_function @inline function optixTrace(handle::OptixTraversableHandle, rayOrigin, rayDirection, tmin, tmax, rayTime, visibilityMask::OptixVisibilityMask, rayFlags, SBToffset, SBTstride, missSBTIndex, ::Type{T}) where T

    N = ceil(Int, sizeof(T) // sizeof(UInt32))
    @assert N <= 32

    pin = Ref{NTuple{N, UInt32}}()[]

    pout = optixTrace(handle::OptixTraversableHandle, NTuple{3, Float32}(rayOrigin), NTuple{3, Float32}(rayDirection), Float32(tmin), Float32(tmax), Float32(rayTime), OptixVisibilityMask(visibilityMask), UInt32(rayFlags), UInt32(SBToffset), UInt32(SBTstride), UInt32(missSBTIndex), pin)

    # cast NTuple{N, UInt32} to T
    _pout = Ref(pout)
    payload = GC.@preserve _pout unsafe_load(convert(Ptr{T}, Base.unsafe_convert(Ptr{Cvoid}, _pout)))

    return payload
end

@device_function @inline function optixSetPayload(payload::T) where T

    N = ceil(Int, sizeof(T) // sizeof(UInt32))
    @assert N <= 32

    # store payload::T into a pout::NTuple{N, UInt32}
    _pout = Ref{NTuple{N, UInt32}}()
    GC.@preserve _pout unsafe_store!(convert(Ptr{T}, Base.unsafe_convert(Ptr{Cvoid}, _pout)), payload)
    pout = _pout[]

    for i in 1:N
        optixSetPayload(UInt32(i-1), pout[i])
    end

    return nothing
end
