
using LinearAlgebra
using Images
using StaticArrays
using GeometryBasics
using CUDA

using OptiX


CUDA.allowscalar(false)


## Init OptiX.jl

if Sys.iswindows()
    libnvoptix_path = "C:/Windows/System32/DriverStore/FileRepository/nvblwi.inf_amd64_7045481d1095a779/nvoptix.dll" # It's hard to find the DLL in Windows
else
    libnvoptix_path = Libdl.find_library("nvoptix.so")
end

optix_init(libnvoptix_path)


## Create OptiX context

optix_context = nothing
GC.gc()

CuArray([0])  # Init CUDA context from CUDA.jl

optix_context = OpContext()

# Set OptiX logging callback (optional)
cf_optix_log_cb = @cfunction((level, tag, message, cbdata) -> (@ccall jl_safe_printf(("<<< OPTIX LOG [%d][%s]: %s >>>\n")::Cstring, level::Cint, unsafe_string(tag)::Cstring, unsafe_string(message)::Cstring)::Cvoid), Cvoid, (Cuint, Cstring, Cstring, Ptr{Cvoid}))
OptiX.optixDeviceContextSetLogCallback(optix_context, cf_optix_log_cb, C_NULL, 4)


## User data structures to be used by the OptiX "programs"

struct Params # main parameters data structure
    image::CuDeviceMatrix{RGBA{N0f8}, CUDA.AS.Global}
    handle::OptiX.OptixTraversableHandle
end

struct MissData # data used by the "miss" program
    bg_color::RGB{Float32}
end


## User OptiX "programs" and pipeline

# "Ray Generation" program
function __raygen__rg()
    idx = optixGetLaunchIndex()
    dim = optixGetLaunchDimensions()

    params = unsafe_load(unsafe_get_global_const_pointer(Val(:params), Params))

    vy = 2f0 * (Float32(idx.x)/Float32(dim.x) - 0.5f0)
    vx = 2f0 * (Float32(idx.y)/Float32(dim.y) - 0.5f0)
    ray = (origin=Vec3f(0,0,1), direction=normalize(Vec3f(vx,vy,-1)))

    # Trace the ray
    rgb_f32 = optixTrace(
        params.handle,
        ray.origin,
        ray.direction,
        0f0,   # Min intersection distance
        1f16,  # Max intersection distance
        0f0,   # ray-time -- used for motion blur
        OptiX.OptixVisibilityMask( 255 ), # Specify always visible
        OptiX.OPTIX_RAY_FLAG_NONE,
        0,      # SBT offset
        0,      # SBT stride
        0,      # missSBTIndex
        RGB{Float32} ); # Ray payload

    result = RGB{N0f8}(
        clamp(rgb_f32.r, N0f8),
        clamp(rgb_f32.g, N0f8),
        clamp(rgb_f32.b, N0f8))

    @inbounds params.image[idx.x, idx.y] = result

    return nothing
end

# "Closest Hit" program
function __closesthit__ch()
    barycentrics = optixGetTriangleBarycentrics()
    c = RGB{Float32}( barycentrics[1], barycentrics[2], 1f0 )
    optixSetPayload(c)
    return nothing
end

# "Miss" program
function __miss__ms()
    miss_data = optixGetSbtData(MissData)
    optixSetPayload( miss_data.bg_color )
    return nothing
end

# Pipeline
pipeline = OpPipeline(optix_context, __raygen__rg, __closesthit__ch, __miss__ms, :params, Params, 3)


## OptiX Shader Binding Table (SBT)  --  Not yet abstracted

RayGenSbtRecord = SbtRecord(Nothing)
HitGroupSbtRecord = SbtRecord(Nothing)
MissSbtRecord = SbtRecord(MissData)

_raygen_record = Ref(SbtRecord(RayGenSbtRecord, nothing))
OptiX.optixSbtRecordPackHeader( pipeline.raygen_prog_group, _raygen_record )
raygen_record = CuArray([_raygen_record[]])

_miss_record = Ref(SbtRecord(MissSbtRecord, MissData(RGB(0.3f0, 0.1f0, 0.2f0))))
OptiX.optixSbtRecordPackHeader( pipeline.miss_prog_group, _miss_record )
miss_record = CuArray([_miss_record[]])

_hitgroup_record = Ref(SbtRecord(HitGroupSbtRecord, nothing))
OptiX.optixSbtRecordPackHeader( pipeline.hitgroup_prog_group, _hitgroup_record )
hitgroup_record = CuArray([_hitgroup_record[]])

_sbt_ = OptiX.Box{OptiX.OptixShaderBindingTable}()
_sbt_.raygenRecord = pointer(raygen_record)
_sbt_.missRecordBase = pointer(miss_record)
_sbt_.missRecordStrideInBytes = sizeof(eltype(miss_record))
_sbt_.missRecordCount = length(miss_record)
_sbt_.hitgroupRecordBase = pointer(hitgroup_record)
_sbt_.hitgroupRecordStrideInBytes = sizeof(eltype(hitgroup_record))
_sbt_.hitgroupRecordCount = length(hitgroup_record)


## Objects creation

# Geometry object
vertices = CuArray(Vec3f[
    ( -0.5f0, -0.5f0, 0.0f0 ),
    (  0.5f0, -0.5f0, 0.0f0 ),
    (  0.0f0,  0.5f0, 0.0f0 )
])
gas = create_triangle_mesh_gas(optix_context, vertices)

# Output buffer and parameters
width, height = 1024, 786
output_buffer = CuArray{RGBA{N0f8}}(fill(RGBA(0,0.5,0,1), (height, width)));
params = Params(
    cudaconvert(output_buffer),  # image::CuDeviceMatrix{RGBA{N0f8}, CUDA.AS.Global}
    gas  # handle::OptixTraversableHandle
)
d_params = CuArray([params])


## Launch

@time OptiX.optixLaunch( pipeline.handle, CUDA.stream().handle, pointer(d_params), sizeof( Params ), _sbt_, height, width, #=depth=#1 )
@time CUDA.synchronize()

# display
Array(output_buffer) |> display


