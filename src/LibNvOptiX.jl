module LibNvOptiX

using CEnum

const size_t = Culonglong

const CUdeviceptr = Culonglong

mutable struct OptixDeviceContext_t end

const OptixDeviceContext = Ptr{OptixDeviceContext_t}

mutable struct OptixModule_t end

const OptixModule = Ptr{OptixModule_t}

mutable struct OptixProgramGroup_t end

const OptixProgramGroup = Ptr{OptixProgramGroup_t}

mutable struct OptixPipeline_t end

const OptixPipeline = Ptr{OptixPipeline_t}

mutable struct OptixDenoiser_t end

const OptixDenoiser = Ptr{OptixDenoiser_t}

mutable struct OptixTask_t end

const OptixTask = Ptr{OptixTask_t}

const OptixTraversableHandle = Culonglong

const OptixVisibilityMask = Cuint

@cenum OptixResult::UInt32 begin
    OPTIX_SUCCESS = 0
    OPTIX_ERROR_INVALID_VALUE = 7001
    OPTIX_ERROR_HOST_OUT_OF_MEMORY = 7002
    OPTIX_ERROR_INVALID_OPERATION = 7003
    OPTIX_ERROR_FILE_IO_ERROR = 7004
    OPTIX_ERROR_INVALID_FILE_FORMAT = 7005
    OPTIX_ERROR_DISK_CACHE_INVALID_PATH = 7010
    OPTIX_ERROR_DISK_CACHE_PERMISSION_ERROR = 7011
    OPTIX_ERROR_DISK_CACHE_DATABASE_ERROR = 7012
    OPTIX_ERROR_DISK_CACHE_INVALID_DATA = 7013
    OPTIX_ERROR_LAUNCH_FAILURE = 7050
    OPTIX_ERROR_INVALID_DEVICE_CONTEXT = 7051
    OPTIX_ERROR_CUDA_NOT_INITIALIZED = 7052
    OPTIX_ERROR_VALIDATION_FAILURE = 7053
    OPTIX_ERROR_INVALID_PTX = 7200
    OPTIX_ERROR_INVALID_LAUNCH_PARAMETER = 7201
    OPTIX_ERROR_INVALID_PAYLOAD_ACCESS = 7202
    OPTIX_ERROR_INVALID_ATTRIBUTE_ACCESS = 7203
    OPTIX_ERROR_INVALID_FUNCTION_USE = 7204
    OPTIX_ERROR_INVALID_FUNCTION_ARGUMENTS = 7205
    OPTIX_ERROR_PIPELINE_OUT_OF_CONSTANT_MEMORY = 7250
    OPTIX_ERROR_PIPELINE_LINK_ERROR = 7251
    OPTIX_ERROR_ILLEGAL_DURING_TASK_EXECUTE = 7270
    OPTIX_ERROR_INTERNAL_COMPILER_ERROR = 7299
    OPTIX_ERROR_DENOISER_MODEL_NOT_SET = 7300
    OPTIX_ERROR_DENOISER_NOT_INITIALIZED = 7301
    OPTIX_ERROR_ACCEL_NOT_COMPATIBLE = 7400
    OPTIX_ERROR_PAYLOAD_TYPE_MISMATCH = 7500
    OPTIX_ERROR_PAYLOAD_TYPE_RESOLUTION_FAILED = 7501
    OPTIX_ERROR_PAYLOAD_TYPE_ID_INVALID = 7502
    OPTIX_ERROR_NOT_SUPPORTED = 7800
    OPTIX_ERROR_UNSUPPORTED_ABI_VERSION = 7801
    OPTIX_ERROR_FUNCTION_TABLE_SIZE_MISMATCH = 7802
    OPTIX_ERROR_INVALID_ENTRY_FUNCTION_OPTIONS = 7803
    OPTIX_ERROR_LIBRARY_NOT_FOUND = 7804
    OPTIX_ERROR_ENTRY_SYMBOL_NOT_FOUND = 7805
    OPTIX_ERROR_LIBRARY_UNLOAD_FAILURE = 7806
    OPTIX_ERROR_DEVICE_OUT_OF_MEMORY = 7807
    OPTIX_ERROR_CUDA_ERROR = 7900
    OPTIX_ERROR_INTERNAL_ERROR = 7990
    OPTIX_ERROR_UNKNOWN = 7999
end

@cenum OptixDeviceProperty::UInt32 begin
    OPTIX_DEVICE_PROPERTY_LIMIT_MAX_TRACE_DEPTH = 8193
    OPTIX_DEVICE_PROPERTY_LIMIT_MAX_TRAVERSABLE_GRAPH_DEPTH = 8194
    OPTIX_DEVICE_PROPERTY_LIMIT_MAX_PRIMITIVES_PER_GAS = 8195
    OPTIX_DEVICE_PROPERTY_LIMIT_MAX_INSTANCES_PER_IAS = 8196
    OPTIX_DEVICE_PROPERTY_RTCORE_VERSION = 8197
    OPTIX_DEVICE_PROPERTY_LIMIT_MAX_INSTANCE_ID = 8198
    OPTIX_DEVICE_PROPERTY_LIMIT_NUM_BITS_INSTANCE_VISIBILITY_MASK = 8199
    OPTIX_DEVICE_PROPERTY_LIMIT_MAX_SBT_RECORDS_PER_GAS = 8200
    OPTIX_DEVICE_PROPERTY_LIMIT_MAX_SBT_OFFSET = 8201
end

# typedef void ( * OptixLogCallback ) ( unsigned int level , const char * tag , const char * message , void * cbdata )
const OptixLogCallback = Ptr{Cvoid}

@cenum OptixDeviceContextValidationMode::UInt32 begin
    OPTIX_DEVICE_CONTEXT_VALIDATION_MODE_OFF = 0
    OPTIX_DEVICE_CONTEXT_VALIDATION_MODE_ALL = 0x00000000ffffffff
end

struct OptixDeviceContextOptions
    logCallbackFunction::OptixLogCallback
    logCallbackData::Ptr{Cvoid}
    logCallbackLevel::Cint
    validationMode::OptixDeviceContextValidationMode
end

@cenum OptixGeometryFlags::UInt32 begin
    OPTIX_GEOMETRY_FLAG_NONE = 0
    OPTIX_GEOMETRY_FLAG_DISABLE_ANYHIT = 1
    OPTIX_GEOMETRY_FLAG_REQUIRE_SINGLE_ANYHIT_CALL = 2
    OPTIX_GEOMETRY_FLAG_DISABLE_TRIANGLE_FACE_CULLING = 4
end

@cenum OptixHitKind::UInt32 begin
    OPTIX_HIT_KIND_TRIANGLE_FRONT_FACE = 254
    OPTIX_HIT_KIND_TRIANGLE_BACK_FACE = 255
end

@cenum OptixIndicesFormat::UInt32 begin
    OPTIX_INDICES_FORMAT_NONE = 0
    OPTIX_INDICES_FORMAT_UNSIGNED_SHORT3 = 8450
    OPTIX_INDICES_FORMAT_UNSIGNED_INT3 = 8451
end

@cenum OptixVertexFormat::UInt32 begin
    OPTIX_VERTEX_FORMAT_NONE = 0
    OPTIX_VERTEX_FORMAT_FLOAT3 = 8481
    OPTIX_VERTEX_FORMAT_FLOAT2 = 8482
    OPTIX_VERTEX_FORMAT_HALF3 = 8483
    OPTIX_VERTEX_FORMAT_HALF2 = 8484
    OPTIX_VERTEX_FORMAT_SNORM16_3 = 8485
    OPTIX_VERTEX_FORMAT_SNORM16_2 = 8486
end

@cenum OptixTransformFormat::UInt32 begin
    OPTIX_TRANSFORM_FORMAT_NONE = 0
    OPTIX_TRANSFORM_FORMAT_MATRIX_FLOAT12 = 8673
end

struct OptixBuildInputTriangleArray
    vertexBuffers::Ptr{CUdeviceptr}
    numVertices::Cuint
    vertexFormat::OptixVertexFormat
    vertexStrideInBytes::Cuint
    indexBuffer::CUdeviceptr
    numIndexTriplets::Cuint
    indexFormat::OptixIndicesFormat
    indexStrideInBytes::Cuint
    preTransform::CUdeviceptr
    flags::Ptr{Cuint}
    numSbtRecords::Cuint
    sbtIndexOffsetBuffer::CUdeviceptr
    sbtIndexOffsetSizeInBytes::Cuint
    sbtIndexOffsetStrideInBytes::Cuint
    primitiveIndexOffset::Cuint
    transformFormat::OptixTransformFormat
end

@cenum OptixPrimitiveType::UInt32 begin
    OPTIX_PRIMITIVE_TYPE_CUSTOM = 9472
    OPTIX_PRIMITIVE_TYPE_ROUND_QUADRATIC_BSPLINE = 9473
    OPTIX_PRIMITIVE_TYPE_ROUND_CUBIC_BSPLINE = 9474
    OPTIX_PRIMITIVE_TYPE_ROUND_LINEAR = 9475
    OPTIX_PRIMITIVE_TYPE_ROUND_CATMULLROM = 9476
    OPTIX_PRIMITIVE_TYPE_SPHERE = 9478
    OPTIX_PRIMITIVE_TYPE_TRIANGLE = 9521
end

@cenum OptixPrimitiveTypeFlags::Int32 begin
    OPTIX_PRIMITIVE_TYPE_FLAGS_CUSTOM = 1
    OPTIX_PRIMITIVE_TYPE_FLAGS_ROUND_QUADRATIC_BSPLINE = 2
    OPTIX_PRIMITIVE_TYPE_FLAGS_ROUND_CUBIC_BSPLINE = 4
    OPTIX_PRIMITIVE_TYPE_FLAGS_ROUND_LINEAR = 8
    OPTIX_PRIMITIVE_TYPE_FLAGS_ROUND_CATMULLROM = 16
    OPTIX_PRIMITIVE_TYPE_FLAGS_SPHERE = 64
    OPTIX_PRIMITIVE_TYPE_FLAGS_TRIANGLE = -2147483648
end

@cenum OptixCurveEndcapFlags::UInt32 begin
    OPTIX_CURVE_ENDCAP_DEFAULT = 0
    OPTIX_CURVE_ENDCAP_ON = 1
end

struct OptixBuildInputCurveArray
    curveType::OptixPrimitiveType
    numPrimitives::Cuint
    vertexBuffers::Ptr{CUdeviceptr}
    numVertices::Cuint
    vertexStrideInBytes::Cuint
    widthBuffers::Ptr{CUdeviceptr}
    widthStrideInBytes::Cuint
    normalBuffers::Ptr{CUdeviceptr}
    normalStrideInBytes::Cuint
    indexBuffer::CUdeviceptr
    indexStrideInBytes::Cuint
    flag::Cuint
    primitiveIndexOffset::Cuint
    endcapFlags::Cuint
end

struct OptixBuildInputSphereArray
    vertexBuffers::Ptr{CUdeviceptr}
    vertexStrideInBytes::Cuint
    numVertices::Cuint
    radiusBuffers::Ptr{CUdeviceptr}
    radiusStrideInBytes::Cuint
    singleRadius::Cint
    flags::Ptr{Cuint}
    numSbtRecords::Cuint
    sbtIndexOffsetBuffer::CUdeviceptr
    sbtIndexOffsetSizeInBytes::Cuint
    sbtIndexOffsetStrideInBytes::Cuint
    primitiveIndexOffset::Cuint
end

struct OptixAabb
    minX::Cfloat
    minY::Cfloat
    minZ::Cfloat
    maxX::Cfloat
    maxY::Cfloat
    maxZ::Cfloat
end

struct OptixBuildInputCustomPrimitiveArray
    aabbBuffers::Ptr{CUdeviceptr}
    numPrimitives::Cuint
    strideInBytes::Cuint
    flags::Ptr{Cuint}
    numSbtRecords::Cuint
    sbtIndexOffsetBuffer::CUdeviceptr
    sbtIndexOffsetSizeInBytes::Cuint
    sbtIndexOffsetStrideInBytes::Cuint
    primitiveIndexOffset::Cuint
end

struct OptixBuildInputInstanceArray
    instances::CUdeviceptr
    numInstances::Cuint
end

@cenum OptixBuildInputType::UInt32 begin
    OPTIX_BUILD_INPUT_TYPE_TRIANGLES = 8513
    OPTIX_BUILD_INPUT_TYPE_CUSTOM_PRIMITIVES = 8514
    OPTIX_BUILD_INPUT_TYPE_INSTANCES = 8515
    OPTIX_BUILD_INPUT_TYPE_INSTANCE_POINTERS = 8516
    OPTIX_BUILD_INPUT_TYPE_CURVES = 8517
    OPTIX_BUILD_INPUT_TYPE_SPHERES = 8518
end

struct OptixBuildInput
    data::NTuple{1032, UInt8}
end

function Base.getproperty(x::Ptr{OptixBuildInput}, f::Symbol)
    f === :type && return Ptr{OptixBuildInputType}(x + 0)
    f === :triangleArray && return Ptr{OptixBuildInputTriangleArray}(x + 8)
    f === :curveArray && return Ptr{OptixBuildInputCurveArray}(x + 8)
    f === :sphereArray && return Ptr{OptixBuildInputSphereArray}(x + 8)
    f === :customPrimitiveArray && return Ptr{OptixBuildInputCustomPrimitiveArray}(x + 8)
    f === :instanceArray && return Ptr{OptixBuildInputInstanceArray}(x + 8)
    f === :pad && return Ptr{NTuple{1024, Cchar}}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::OptixBuildInput, f::Symbol)
    r = Ref{OptixBuildInput}(x)
    ptr = Base.unsafe_convert(Ptr{OptixBuildInput}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{OptixBuildInput}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

@cenum OptixInstanceFlags::UInt32 begin
    OPTIX_INSTANCE_FLAG_NONE = 0
    OPTIX_INSTANCE_FLAG_DISABLE_TRIANGLE_FACE_CULLING = 1
    OPTIX_INSTANCE_FLAG_FLIP_TRIANGLE_FACING = 2
    OPTIX_INSTANCE_FLAG_DISABLE_ANYHIT = 4
    OPTIX_INSTANCE_FLAG_ENFORCE_ANYHIT = 8
end

struct OptixInstance
    transform::NTuple{12, Cfloat}
    instanceId::Cuint
    sbtOffset::Cuint
    visibilityMask::Cuint
    flags::Cuint
    traversableHandle::OptixTraversableHandle
    pad::NTuple{2, Cuint}
end

@cenum OptixBuildFlags::UInt32 begin
    OPTIX_BUILD_FLAG_NONE = 0
    OPTIX_BUILD_FLAG_ALLOW_UPDATE = 1
    OPTIX_BUILD_FLAG_ALLOW_COMPACTION = 2
    OPTIX_BUILD_FLAG_PREFER_FAST_TRACE = 4
    OPTIX_BUILD_FLAG_PREFER_FAST_BUILD = 8
    OPTIX_BUILD_FLAG_ALLOW_RANDOM_VERTEX_ACCESS = 16
    OPTIX_BUILD_FLAG_ALLOW_RANDOM_INSTANCE_ACCESS = 32
end

@cenum OptixBuildOperation::UInt32 begin
    OPTIX_BUILD_OPERATION_BUILD = 8545
    OPTIX_BUILD_OPERATION_UPDATE = 8546
end

@cenum OptixMotionFlags::UInt32 begin
    OPTIX_MOTION_FLAG_NONE = 0
    OPTIX_MOTION_FLAG_START_VANISH = 1
    OPTIX_MOTION_FLAG_END_VANISH = 2
end

struct OptixMotionOptions
    numKeys::Cushort
    flags::Cushort
    timeBegin::Cfloat
    timeEnd::Cfloat
end

struct OptixAccelBuildOptions
    buildFlags::Cuint
    operation::OptixBuildOperation
    motionOptions::OptixMotionOptions
end

struct OptixAccelBufferSizes
    outputSizeInBytes::Csize_t
    tempSizeInBytes::Csize_t
    tempUpdateSizeInBytes::Csize_t
end

@cenum OptixAccelPropertyType::UInt32 begin
    OPTIX_PROPERTY_TYPE_COMPACTED_SIZE = 8577
    OPTIX_PROPERTY_TYPE_AABBS = 8578
end

struct OptixAccelEmitDesc
    result::CUdeviceptr
    type::OptixAccelPropertyType
end

struct OptixAccelRelocationInfo
    info::NTuple{4, Culonglong}
end

struct OptixStaticTransform
    child::OptixTraversableHandle
    pad::NTuple{2, Cuint}
    transform::NTuple{12, Cfloat}
    invTransform::NTuple{12, Cfloat}
end

struct OptixMatrixMotionTransform
    child::OptixTraversableHandle
    motionOptions::OptixMotionOptions
    pad::NTuple{3, Cuint}
    transform::NTuple{2, NTuple{12, Cfloat}}
end

struct OptixSRTData
    sx::Cfloat
    a::Cfloat
    b::Cfloat
    pvx::Cfloat
    sy::Cfloat
    c::Cfloat
    pvy::Cfloat
    sz::Cfloat
    pvz::Cfloat
    qx::Cfloat
    qy::Cfloat
    qz::Cfloat
    qw::Cfloat
    tx::Cfloat
    ty::Cfloat
    tz::Cfloat
end

struct OptixSRTMotionTransform
    child::OptixTraversableHandle
    motionOptions::OptixMotionOptions
    pad::NTuple{3, Cuint}
    srtData::NTuple{2, OptixSRTData}
end

@cenum OptixTraversableType::UInt32 begin
    OPTIX_TRAVERSABLE_TYPE_STATIC_TRANSFORM = 8641
    OPTIX_TRAVERSABLE_TYPE_MATRIX_MOTION_TRANSFORM = 8642
    OPTIX_TRAVERSABLE_TYPE_SRT_MOTION_TRANSFORM = 8643
end

@cenum OptixPixelFormat::UInt32 begin
    OPTIX_PIXEL_FORMAT_HALF2 = 8711
    OPTIX_PIXEL_FORMAT_HALF3 = 8705
    OPTIX_PIXEL_FORMAT_HALF4 = 8706
    OPTIX_PIXEL_FORMAT_FLOAT2 = 8712
    OPTIX_PIXEL_FORMAT_FLOAT3 = 8707
    OPTIX_PIXEL_FORMAT_FLOAT4 = 8708
    OPTIX_PIXEL_FORMAT_UCHAR3 = 8709
    OPTIX_PIXEL_FORMAT_UCHAR4 = 8710
    OPTIX_PIXEL_FORMAT_INTERNAL_GUIDE_LAYER = 8713
end

struct OptixImage2D
    data::CUdeviceptr
    width::Cuint
    height::Cuint
    rowStrideInBytes::Cuint
    pixelStrideInBytes::Cuint
    format::OptixPixelFormat
end

@cenum OptixDenoiserModelKind::UInt32 begin
    OPTIX_DENOISER_MODEL_KIND_LDR = 8994
    OPTIX_DENOISER_MODEL_KIND_HDR = 8995
    OPTIX_DENOISER_MODEL_KIND_AOV = 8996
    OPTIX_DENOISER_MODEL_KIND_TEMPORAL = 8997
    OPTIX_DENOISER_MODEL_KIND_TEMPORAL_AOV = 8998
    OPTIX_DENOISER_MODEL_KIND_UPSCALE2X = 8999
    OPTIX_DENOISER_MODEL_KIND_TEMPORAL_UPSCALE2X = 9000
end

struct OptixDenoiserOptions
    guideAlbedo::Cuint
    guideNormal::Cuint
end

struct OptixDenoiserGuideLayer
    albedo::OptixImage2D
    normal::OptixImage2D
    flow::OptixImage2D
    previousOutputInternalGuideLayer::OptixImage2D
    outputInternalGuideLayer::OptixImage2D
end

struct OptixDenoiserLayer
    input::OptixImage2D
    previousOutput::OptixImage2D
    output::OptixImage2D
end

@cenum OptixDenoiserAlphaMode::UInt32 begin
    OPTIX_DENOISER_ALPHA_MODE_COPY = 0
    OPTIX_DENOISER_ALPHA_MODE_ALPHA_AS_AOV = 1
    OPTIX_DENOISER_ALPHA_MODE_FULL_DENOISE_PASS = 2
end

struct OptixDenoiserParams
    denoiseAlpha::OptixDenoiserAlphaMode
    hdrIntensity::CUdeviceptr
    blendFactor::Cfloat
    hdrAverageColor::CUdeviceptr
    temporalModeUsePreviousLayers::Cuint
end

struct OptixDenoiserSizes
    stateSizeInBytes::Csize_t
    withOverlapScratchSizeInBytes::Csize_t
    withoutOverlapScratchSizeInBytes::Csize_t
    overlapWindowSizeInPixels::Cuint
    computeAverageColorSizeInBytes::Csize_t
    computeIntensitySizeInBytes::Csize_t
    internalGuideLayerPixelSizeInBytes::Csize_t
end

@cenum OptixRayFlags::UInt32 begin
    OPTIX_RAY_FLAG_NONE = 0
    OPTIX_RAY_FLAG_DISABLE_ANYHIT = 1
    OPTIX_RAY_FLAG_ENFORCE_ANYHIT = 2
    OPTIX_RAY_FLAG_TERMINATE_ON_FIRST_HIT = 4
    OPTIX_RAY_FLAG_DISABLE_CLOSESTHIT = 8
    OPTIX_RAY_FLAG_CULL_BACK_FACING_TRIANGLES = 16
    OPTIX_RAY_FLAG_CULL_FRONT_FACING_TRIANGLES = 32
    OPTIX_RAY_FLAG_CULL_DISABLED_ANYHIT = 64
    OPTIX_RAY_FLAG_CULL_ENFORCED_ANYHIT = 128
end

@cenum OptixTransformType::UInt32 begin
    OPTIX_TRANSFORM_TYPE_NONE = 0
    OPTIX_TRANSFORM_TYPE_STATIC_TRANSFORM = 1
    OPTIX_TRANSFORM_TYPE_MATRIX_MOTION_TRANSFORM = 2
    OPTIX_TRANSFORM_TYPE_SRT_MOTION_TRANSFORM = 3
    OPTIX_TRANSFORM_TYPE_INSTANCE = 4
end

@cenum OptixTraversableGraphFlags::UInt32 begin
    OPTIX_TRAVERSABLE_GRAPH_FLAG_ALLOW_ANY = 0
    OPTIX_TRAVERSABLE_GRAPH_FLAG_ALLOW_SINGLE_GAS = 1
    OPTIX_TRAVERSABLE_GRAPH_FLAG_ALLOW_SINGLE_LEVEL_INSTANCING = 2
end

@cenum OptixCompileOptimizationLevel::UInt32 begin
    OPTIX_COMPILE_OPTIMIZATION_DEFAULT = 0
    OPTIX_COMPILE_OPTIMIZATION_LEVEL_0 = 9024
    OPTIX_COMPILE_OPTIMIZATION_LEVEL_1 = 9025
    OPTIX_COMPILE_OPTIMIZATION_LEVEL_2 = 9026
    OPTIX_COMPILE_OPTIMIZATION_LEVEL_3 = 9027
end

@cenum OptixCompileDebugLevel::UInt32 begin
    OPTIX_COMPILE_DEBUG_LEVEL_DEFAULT = 0
    OPTIX_COMPILE_DEBUG_LEVEL_NONE = 9040
    OPTIX_COMPILE_DEBUG_LEVEL_MINIMAL = 9041
    OPTIX_COMPILE_DEBUG_LEVEL_MODERATE = 9043
    OPTIX_COMPILE_DEBUG_LEVEL_FULL = 9042
end

@cenum OptixModuleCompileState::UInt32 begin
    OPTIX_MODULE_COMPILE_STATE_NOT_STARTED = 9056
    OPTIX_MODULE_COMPILE_STATE_STARTED = 9057
    OPTIX_MODULE_COMPILE_STATE_IMPENDING_FAILURE = 9058
    OPTIX_MODULE_COMPILE_STATE_FAILED = 9059
    OPTIX_MODULE_COMPILE_STATE_COMPLETED = 9060
end

struct OptixModuleCompileBoundValueEntry
    pipelineParamOffsetInBytes::Csize_t
    sizeInBytes::Csize_t
    boundValuePtr::Ptr{Cvoid}
    annotation::Ptr{Cchar}
end

@cenum OptixPayloadTypeID::UInt32 begin
    OPTIX_PAYLOAD_TYPE_DEFAULT = 0
    OPTIX_PAYLOAD_TYPE_ID_0 = 1
    OPTIX_PAYLOAD_TYPE_ID_1 = 2
    OPTIX_PAYLOAD_TYPE_ID_2 = 4
    OPTIX_PAYLOAD_TYPE_ID_3 = 8
    OPTIX_PAYLOAD_TYPE_ID_4 = 16
    OPTIX_PAYLOAD_TYPE_ID_5 = 32
    OPTIX_PAYLOAD_TYPE_ID_6 = 64
    OPTIX_PAYLOAD_TYPE_ID_7 = 128
end

@cenum OptixPayloadSemantics::UInt32 begin
    OPTIX_PAYLOAD_SEMANTICS_TRACE_CALLER_NONE = 0
    OPTIX_PAYLOAD_SEMANTICS_TRACE_CALLER_READ = 1
    OPTIX_PAYLOAD_SEMANTICS_TRACE_CALLER_WRITE = 2
    OPTIX_PAYLOAD_SEMANTICS_TRACE_CALLER_READ_WRITE = 3
    OPTIX_PAYLOAD_SEMANTICS_CH_NONE = 0
    OPTIX_PAYLOAD_SEMANTICS_CH_READ = 4
    OPTIX_PAYLOAD_SEMANTICS_CH_WRITE = 8
    OPTIX_PAYLOAD_SEMANTICS_CH_READ_WRITE = 12
    OPTIX_PAYLOAD_SEMANTICS_MS_NONE = 0
    OPTIX_PAYLOAD_SEMANTICS_MS_READ = 16
    OPTIX_PAYLOAD_SEMANTICS_MS_WRITE = 32
    OPTIX_PAYLOAD_SEMANTICS_MS_READ_WRITE = 48
    OPTIX_PAYLOAD_SEMANTICS_AH_NONE = 0
    OPTIX_PAYLOAD_SEMANTICS_AH_READ = 64
    OPTIX_PAYLOAD_SEMANTICS_AH_WRITE = 128
    OPTIX_PAYLOAD_SEMANTICS_AH_READ_WRITE = 192
    OPTIX_PAYLOAD_SEMANTICS_IS_NONE = 0
    OPTIX_PAYLOAD_SEMANTICS_IS_READ = 256
    OPTIX_PAYLOAD_SEMANTICS_IS_WRITE = 512
    OPTIX_PAYLOAD_SEMANTICS_IS_READ_WRITE = 768
end

struct OptixPayloadType
    numPayloadValues::Cuint
    payloadSemantics::Ptr{Cuint}
end

struct OptixModuleCompileOptions
    maxRegisterCount::Cint
    optLevel::OptixCompileOptimizationLevel
    debugLevel::OptixCompileDebugLevel
    boundValues::Ptr{OptixModuleCompileBoundValueEntry}
    numBoundValues::Cuint
    numPayloadTypes::Cuint
    payloadTypes::Ptr{OptixPayloadType}
end

@cenum OptixProgramGroupKind::UInt32 begin
    OPTIX_PROGRAM_GROUP_KIND_RAYGEN = 9249
    OPTIX_PROGRAM_GROUP_KIND_MISS = 9250
    OPTIX_PROGRAM_GROUP_KIND_EXCEPTION = 9251
    OPTIX_PROGRAM_GROUP_KIND_HITGROUP = 9252
    OPTIX_PROGRAM_GROUP_KIND_CALLABLES = 9253
end

@cenum OptixProgramGroupFlags::UInt32 begin
    OPTIX_PROGRAM_GROUP_FLAGS_NONE = 0
end

struct OptixProgramGroupSingleModule
    _module::OptixModule
    entryFunctionName::Ptr{Cchar}
end

struct OptixProgramGroupHitgroup
    moduleCH::OptixModule
    entryFunctionNameCH::Ptr{Cchar}
    moduleAH::OptixModule
    entryFunctionNameAH::Ptr{Cchar}
    moduleIS::OptixModule
    entryFunctionNameIS::Ptr{Cchar}
end

struct OptixProgramGroupCallables
    moduleDC::OptixModule
    entryFunctionNameDC::Ptr{Cchar}
    moduleCC::OptixModule
    entryFunctionNameCC::Ptr{Cchar}
end

struct OptixProgramGroupDesc
    data::NTuple{56, UInt8}
end

function Base.getproperty(x::Ptr{OptixProgramGroupDesc}, f::Symbol)
    f === :kind && return Ptr{OptixProgramGroupKind}(x + 0)
    f === :flags && return Ptr{Cuint}(x + 4)
    f === :raygen && return Ptr{OptixProgramGroupSingleModule}(x + 8)
    f === :miss && return Ptr{OptixProgramGroupSingleModule}(x + 8)
    f === :exception && return Ptr{OptixProgramGroupSingleModule}(x + 8)
    f === :callables && return Ptr{OptixProgramGroupCallables}(x + 8)
    f === :hitgroup && return Ptr{OptixProgramGroupHitgroup}(x + 8)
    return getfield(x, f)
end

function Base.getproperty(x::OptixProgramGroupDesc, f::Symbol)
    r = Ref{OptixProgramGroupDesc}(x)
    ptr = Base.unsafe_convert(Ptr{OptixProgramGroupDesc}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{OptixProgramGroupDesc}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct OptixProgramGroupOptions
    payloadType::Ptr{OptixPayloadType}
end

@cenum OptixExceptionCodes::Int32 begin
    OPTIX_EXCEPTION_CODE_STACK_OVERFLOW = -1
    OPTIX_EXCEPTION_CODE_TRACE_DEPTH_EXCEEDED = -2
    OPTIX_EXCEPTION_CODE_TRAVERSAL_DEPTH_EXCEEDED = -3
    OPTIX_EXCEPTION_CODE_TRAVERSAL_INVALID_TRAVERSABLE = -5
    OPTIX_EXCEPTION_CODE_TRAVERSAL_INVALID_MISS_SBT = -6
    OPTIX_EXCEPTION_CODE_TRAVERSAL_INVALID_HIT_SBT = -7
    OPTIX_EXCEPTION_CODE_UNSUPPORTED_PRIMITIVE_TYPE = -8
    OPTIX_EXCEPTION_CODE_INVALID_RAY = -9
    OPTIX_EXCEPTION_CODE_CALLABLE_PARAMETER_MISMATCH = -10
    OPTIX_EXCEPTION_CODE_BUILTIN_IS_MISMATCH = -11
    OPTIX_EXCEPTION_CODE_CALLABLE_INVALID_SBT = -12
    OPTIX_EXCEPTION_CODE_CALLABLE_NO_DC_SBT_RECORD = -13
    OPTIX_EXCEPTION_CODE_CALLABLE_NO_CC_SBT_RECORD = -14
    OPTIX_EXCEPTION_CODE_UNSUPPORTED_SINGLE_LEVEL_GAS = -15
    OPTIX_EXCEPTION_CODE_INVALID_VALUE_ARGUMENT_0 = -16
    OPTIX_EXCEPTION_CODE_INVALID_VALUE_ARGUMENT_1 = -17
    OPTIX_EXCEPTION_CODE_INVALID_VALUE_ARGUMENT_2 = -18
    OPTIX_EXCEPTION_CODE_UNSUPPORTED_DATA_ACCESS = -32
    OPTIX_EXCEPTION_CODE_PAYLOAD_TYPE_MISMATCH = -33
end

@cenum OptixExceptionFlags::UInt32 begin
    OPTIX_EXCEPTION_FLAG_NONE = 0
    OPTIX_EXCEPTION_FLAG_STACK_OVERFLOW = 1
    OPTIX_EXCEPTION_FLAG_TRACE_DEPTH = 2
    OPTIX_EXCEPTION_FLAG_USER = 4
    OPTIX_EXCEPTION_FLAG_DEBUG = 8
end

struct OptixPipelineCompileOptions
    usesMotionBlur::Cint
    traversableGraphFlags::Cuint
    numPayloadValues::Cint
    numAttributeValues::Cint
    exceptionFlags::Cuint
    pipelineLaunchParamsVariableName::Ptr{Cchar}
    usesPrimitiveTypeFlags::Cuint
end

struct OptixPipelineLinkOptions
    maxTraceDepth::Cuint
    debugLevel::OptixCompileDebugLevel
end

struct OptixShaderBindingTable
    raygenRecord::CUdeviceptr
    exceptionRecord::CUdeviceptr
    missRecordBase::CUdeviceptr
    missRecordStrideInBytes::Cuint
    missRecordCount::Cuint
    hitgroupRecordBase::CUdeviceptr
    hitgroupRecordStrideInBytes::Cuint
    hitgroupRecordCount::Cuint
    callablesRecordBase::CUdeviceptr
    callablesRecordStrideInBytes::Cuint
    callablesRecordCount::Cuint
end

struct OptixStackSizes
    cssRG::Cuint
    cssMS::Cuint
    cssCH::Cuint
    cssAH::Cuint
    cssIS::Cuint
    cssCC::Cuint
    dssDC::Cuint
end

@cenum OptixQueryFunctionTableOptions::UInt32 begin
    OPTIX_QUERY_FUNCTION_TABLE_OPTION_DUMMY = 0
end

# typedef OptixResult ( OptixQueryFunctionTable_t ) ( int abiId , unsigned int numOptions , OptixQueryFunctionTableOptions * /*optionKeys*/ , const void * * /*optionValues*/ , void * functionTable , size_t sizeOfTable )
const OptixQueryFunctionTable_t = Cvoid

struct OptixBuiltinISOptions
    builtinISModuleType::OptixPrimitiveType
    usesMotionBlur::Cint
    buildFlags::Cuint
    curveEndcapFlags::Cuint
end

function optixGetErrorName(result)
    ccall((:optixGetErrorName, :nvoptix), Ptr{Cchar}, (OptixResult,), result)
end

function optixGetErrorName(result, fptr)
    ccall(fptr, Ptr{Cchar}, (OptixResult,), result)
end

function optixGetErrorString(result)
    ccall((:optixGetErrorString, :nvoptix), Ptr{Cchar}, (OptixResult,), result)
end

function optixGetErrorString(result, fptr)
    ccall(fptr, Ptr{Cchar}, (OptixResult,), result)
end

function optixDeviceContextCreate(fromContext, options, context)
    ccall((:optixDeviceContextCreate, :nvoptix), OptixResult, (Ptr{Cvoid}, Ptr{OptixDeviceContextOptions}, Ptr{OptixDeviceContext}), fromContext, options, context)
end

function optixDeviceContextCreate(fromContext, options, context, fptr)
    ccall(fptr, OptixResult, (Ptr{Cvoid}, Ptr{OptixDeviceContextOptions}, Ptr{OptixDeviceContext}), fromContext, options, context)
end

function optixDeviceContextDestroy(context)
    ccall((:optixDeviceContextDestroy, :nvoptix), OptixResult, (OptixDeviceContext,), context)
end

function optixDeviceContextDestroy(context, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext,), context)
end

function optixDeviceContextGetProperty(context, property, value, sizeInBytes)
    ccall((:optixDeviceContextGetProperty, :nvoptix), OptixResult, (OptixDeviceContext, OptixDeviceProperty, Ptr{Cvoid}, Csize_t), context, property, value, sizeInBytes)
end

function optixDeviceContextGetProperty(context, property, value, sizeInBytes, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, OptixDeviceProperty, Ptr{Cvoid}, Csize_t), context, property, value, sizeInBytes)
end

function optixDeviceContextSetLogCallback(context, callbackFunction, callbackData, callbackLevel)
    ccall((:optixDeviceContextSetLogCallback, :nvoptix), OptixResult, (OptixDeviceContext, OptixLogCallback, Ptr{Cvoid}, Cuint), context, callbackFunction, callbackData, callbackLevel)
end

function optixDeviceContextSetLogCallback(context, callbackFunction, callbackData, callbackLevel, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, OptixLogCallback, Ptr{Cvoid}, Cuint), context, callbackFunction, callbackData, callbackLevel)
end

function optixDeviceContextSetCacheEnabled(context, enabled)
    ccall((:optixDeviceContextSetCacheEnabled, :nvoptix), OptixResult, (OptixDeviceContext, Cint), context, enabled)
end

function optixDeviceContextSetCacheEnabled(context, enabled, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Cint), context, enabled)
end

function optixDeviceContextSetCacheLocation(context, location)
    ccall((:optixDeviceContextSetCacheLocation, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{Cchar}), context, location)
end

function optixDeviceContextSetCacheLocation(context, location, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{Cchar}), context, location)
end

function optixDeviceContextSetCacheDatabaseSizes(context, lowWaterMark, highWaterMark)
    ccall((:optixDeviceContextSetCacheDatabaseSizes, :nvoptix), OptixResult, (OptixDeviceContext, Csize_t, Csize_t), context, lowWaterMark, highWaterMark)
end

function optixDeviceContextSetCacheDatabaseSizes(context, lowWaterMark, highWaterMark, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Csize_t, Csize_t), context, lowWaterMark, highWaterMark)
end

function optixDeviceContextGetCacheEnabled(context, enabled)
    ccall((:optixDeviceContextGetCacheEnabled, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{Cint}), context, enabled)
end

function optixDeviceContextGetCacheEnabled(context, enabled, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{Cint}), context, enabled)
end

function optixDeviceContextGetCacheLocation(context, location, locationSize)
    ccall((:optixDeviceContextGetCacheLocation, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{Cchar}, Csize_t), context, location, locationSize)
end

function optixDeviceContextGetCacheLocation(context, location, locationSize, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{Cchar}, Csize_t), context, location, locationSize)
end

function optixDeviceContextGetCacheDatabaseSizes(context, lowWaterMark, highWaterMark)
    ccall((:optixDeviceContextGetCacheDatabaseSizes, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{Csize_t}, Ptr{Csize_t}), context, lowWaterMark, highWaterMark)
end

function optixDeviceContextGetCacheDatabaseSizes(context, lowWaterMark, highWaterMark, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{Csize_t}, Ptr{Csize_t}), context, lowWaterMark, highWaterMark)
end

function optixPipelineCreate(context, pipelineCompileOptions, pipelineLinkOptions, programGroups, numProgramGroups, logString, logStringSize, pipeline)
    ccall((:optixPipelineCreate, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{OptixPipelineCompileOptions}, Ptr{OptixPipelineLinkOptions}, Ptr{OptixProgramGroup}, Cuint, Ptr{Cchar}, Ptr{Csize_t}, Ptr{OptixPipeline}), context, pipelineCompileOptions, pipelineLinkOptions, programGroups, numProgramGroups, logString, logStringSize, pipeline)
end

function optixPipelineCreate(context, pipelineCompileOptions, pipelineLinkOptions, programGroups, numProgramGroups, logString, logStringSize, pipeline, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{OptixPipelineCompileOptions}, Ptr{OptixPipelineLinkOptions}, Ptr{OptixProgramGroup}, Cuint, Ptr{Cchar}, Ptr{Csize_t}, Ptr{OptixPipeline}), context, pipelineCompileOptions, pipelineLinkOptions, programGroups, numProgramGroups, logString, logStringSize, pipeline)
end

function optixPipelineDestroy(pipeline)
    ccall((:optixPipelineDestroy, :nvoptix), OptixResult, (OptixPipeline,), pipeline)
end

function optixPipelineDestroy(pipeline, fptr)
    ccall(fptr, OptixResult, (OptixPipeline,), pipeline)
end

function optixPipelineSetStackSize(pipeline, directCallableStackSizeFromTraversal, directCallableStackSizeFromState, continuationStackSize, maxTraversableGraphDepth)
    ccall((:optixPipelineSetStackSize, :nvoptix), OptixResult, (OptixPipeline, Cuint, Cuint, Cuint, Cuint), pipeline, directCallableStackSizeFromTraversal, directCallableStackSizeFromState, continuationStackSize, maxTraversableGraphDepth)
end

function optixPipelineSetStackSize(pipeline, directCallableStackSizeFromTraversal, directCallableStackSizeFromState, continuationStackSize, maxTraversableGraphDepth, fptr)
    ccall(fptr, OptixResult, (OptixPipeline, Cuint, Cuint, Cuint, Cuint), pipeline, directCallableStackSizeFromTraversal, directCallableStackSizeFromState, continuationStackSize, maxTraversableGraphDepth)
end

function optixModuleCreateFromPTX(context, moduleCompileOptions, pipelineCompileOptions, PTX, PTXsize, logString, logStringSize, _module)
    ccall((:optixModuleCreateFromPTX, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{OptixModuleCompileOptions}, Ptr{OptixPipelineCompileOptions}, Ptr{Cchar}, Csize_t, Ptr{Cchar}, Ptr{Csize_t}, Ptr{OptixModule}), context, moduleCompileOptions, pipelineCompileOptions, PTX, PTXsize, logString, logStringSize, _module)
end

function optixModuleCreateFromPTX(context, moduleCompileOptions, pipelineCompileOptions, PTX, PTXsize, logString, logStringSize, _module, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{OptixModuleCompileOptions}, Ptr{OptixPipelineCompileOptions}, Ptr{Cchar}, Csize_t, Ptr{Cchar}, Ptr{Csize_t}, Ptr{OptixModule}), context, moduleCompileOptions, pipelineCompileOptions, PTX, PTXsize, logString, logStringSize, _module)
end

function optixModuleCreateFromPTXWithTasks(context, moduleCompileOptions, pipelineCompileOptions, PTX, PTXsize, logString, logStringSize, _module, firstTask)
    ccall((:optixModuleCreateFromPTXWithTasks, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{OptixModuleCompileOptions}, Ptr{OptixPipelineCompileOptions}, Ptr{Cchar}, Csize_t, Ptr{Cchar}, Ptr{Csize_t}, Ptr{OptixModule}, Ptr{OptixTask}), context, moduleCompileOptions, pipelineCompileOptions, PTX, PTXsize, logString, logStringSize, _module, firstTask)
end

function optixModuleCreateFromPTXWithTasks(context, moduleCompileOptions, pipelineCompileOptions, PTX, PTXsize, logString, logStringSize, _module, firstTask, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{OptixModuleCompileOptions}, Ptr{OptixPipelineCompileOptions}, Ptr{Cchar}, Csize_t, Ptr{Cchar}, Ptr{Csize_t}, Ptr{OptixModule}, Ptr{OptixTask}), context, moduleCompileOptions, pipelineCompileOptions, PTX, PTXsize, logString, logStringSize, _module, firstTask)
end

function optixModuleGetCompilationState(_module, state)
    ccall((:optixModuleGetCompilationState, :nvoptix), OptixResult, (OptixModule, Ptr{OptixModuleCompileState}), _module, state)
end

function optixModuleGetCompilationState(_module, state, fptr)
    ccall(fptr, OptixResult, (OptixModule, Ptr{OptixModuleCompileState}), _module, state)
end

function optixModuleDestroy(_module)
    ccall((:optixModuleDestroy, :nvoptix), OptixResult, (OptixModule,), _module)
end

function optixModuleDestroy(_module, fptr)
    ccall(fptr, OptixResult, (OptixModule,), _module)
end

function optixBuiltinISModuleGet(context, moduleCompileOptions, pipelineCompileOptions, builtinISOptions, builtinModule)
    ccall((:optixBuiltinISModuleGet, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{OptixModuleCompileOptions}, Ptr{OptixPipelineCompileOptions}, Ptr{OptixBuiltinISOptions}, Ptr{OptixModule}), context, moduleCompileOptions, pipelineCompileOptions, builtinISOptions, builtinModule)
end

function optixBuiltinISModuleGet(context, moduleCompileOptions, pipelineCompileOptions, builtinISOptions, builtinModule, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{OptixModuleCompileOptions}, Ptr{OptixPipelineCompileOptions}, Ptr{OptixBuiltinISOptions}, Ptr{OptixModule}), context, moduleCompileOptions, pipelineCompileOptions, builtinISOptions, builtinModule)
end

function optixTaskExecute(task, additionalTasks, maxNumAdditionalTasks, numAdditionalTasksCreated)
    ccall((:optixTaskExecute, :nvoptix), OptixResult, (OptixTask, Ptr{OptixTask}, Cuint, Ptr{Cuint}), task, additionalTasks, maxNumAdditionalTasks, numAdditionalTasksCreated)
end

function optixTaskExecute(task, additionalTasks, maxNumAdditionalTasks, numAdditionalTasksCreated, fptr)
    ccall(fptr, OptixResult, (OptixTask, Ptr{OptixTask}, Cuint, Ptr{Cuint}), task, additionalTasks, maxNumAdditionalTasks, numAdditionalTasksCreated)
end

function optixProgramGroupGetStackSize(programGroup, stackSizes)
    ccall((:optixProgramGroupGetStackSize, :nvoptix), OptixResult, (OptixProgramGroup, Ptr{OptixStackSizes}), programGroup, stackSizes)
end

function optixProgramGroupGetStackSize(programGroup, stackSizes, fptr)
    ccall(fptr, OptixResult, (OptixProgramGroup, Ptr{OptixStackSizes}), programGroup, stackSizes)
end

function optixProgramGroupCreate(context, programDescriptions, numProgramGroups, options, logString, logStringSize, programGroups)
    ccall((:optixProgramGroupCreate, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{OptixProgramGroupDesc}, Cuint, Ptr{OptixProgramGroupOptions}, Ptr{Cchar}, Ptr{Csize_t}, Ptr{OptixProgramGroup}), context, programDescriptions, numProgramGroups, options, logString, logStringSize, programGroups)
end

function optixProgramGroupCreate(context, programDescriptions, numProgramGroups, options, logString, logStringSize, programGroups, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{OptixProgramGroupDesc}, Cuint, Ptr{OptixProgramGroupOptions}, Ptr{Cchar}, Ptr{Csize_t}, Ptr{OptixProgramGroup}), context, programDescriptions, numProgramGroups, options, logString, logStringSize, programGroups)
end

function optixProgramGroupDestroy(programGroup)
    ccall((:optixProgramGroupDestroy, :nvoptix), OptixResult, (OptixProgramGroup,), programGroup)
end

function optixProgramGroupDestroy(programGroup, fptr)
    ccall(fptr, OptixResult, (OptixProgramGroup,), programGroup)
end

function optixLaunch(pipeline, stream, pipelineParams, pipelineParamsSize, sbt, width, height, depth)
    ccall((:optixLaunch, :nvoptix), OptixResult, (OptixPipeline, Ptr{Cvoid}, CUdeviceptr, Csize_t, Ptr{OptixShaderBindingTable}, Cuint, Cuint, Cuint), pipeline, stream, pipelineParams, pipelineParamsSize, sbt, width, height, depth)
end

function optixLaunch(pipeline, stream, pipelineParams, pipelineParamsSize, sbt, width, height, depth, fptr)
    ccall(fptr, OptixResult, (OptixPipeline, Ptr{Cvoid}, CUdeviceptr, Csize_t, Ptr{OptixShaderBindingTable}, Cuint, Cuint, Cuint), pipeline, stream, pipelineParams, pipelineParamsSize, sbt, width, height, depth)
end

function optixSbtRecordPackHeader(programGroup, sbtRecordHeaderHostPointer)
    ccall((:optixSbtRecordPackHeader, :nvoptix), OptixResult, (OptixProgramGroup, Ptr{Cvoid}), programGroup, sbtRecordHeaderHostPointer)
end

function optixSbtRecordPackHeader(programGroup, sbtRecordHeaderHostPointer, fptr)
    ccall(fptr, OptixResult, (OptixProgramGroup, Ptr{Cvoid}), programGroup, sbtRecordHeaderHostPointer)
end

function optixAccelComputeMemoryUsage(context, accelOptions, buildInputs, numBuildInputs, bufferSizes)
    ccall((:optixAccelComputeMemoryUsage, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{OptixAccelBuildOptions}, Ptr{OptixBuildInput}, Cuint, Ptr{OptixAccelBufferSizes}), context, accelOptions, buildInputs, numBuildInputs, bufferSizes)
end

function optixAccelComputeMemoryUsage(context, accelOptions, buildInputs, numBuildInputs, bufferSizes, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{OptixAccelBuildOptions}, Ptr{OptixBuildInput}, Cuint, Ptr{OptixAccelBufferSizes}), context, accelOptions, buildInputs, numBuildInputs, bufferSizes)
end

function optixAccelBuild(context, stream, accelOptions, buildInputs, numBuildInputs, tempBuffer, tempBufferSizeInBytes, outputBuffer, outputBufferSizeInBytes, outputHandle, emittedProperties, numEmittedProperties)
    ccall((:optixAccelBuild, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{Cvoid}, Ptr{OptixAccelBuildOptions}, Ptr{OptixBuildInput}, Cuint, CUdeviceptr, Csize_t, CUdeviceptr, Csize_t, Ptr{OptixTraversableHandle}, Ptr{OptixAccelEmitDesc}, Cuint), context, stream, accelOptions, buildInputs, numBuildInputs, tempBuffer, tempBufferSizeInBytes, outputBuffer, outputBufferSizeInBytes, outputHandle, emittedProperties, numEmittedProperties)
end

function optixAccelBuild(context, stream, accelOptions, buildInputs, numBuildInputs, tempBuffer, tempBufferSizeInBytes, outputBuffer, outputBufferSizeInBytes, outputHandle, emittedProperties, numEmittedProperties, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{Cvoid}, Ptr{OptixAccelBuildOptions}, Ptr{OptixBuildInput}, Cuint, CUdeviceptr, Csize_t, CUdeviceptr, Csize_t, Ptr{OptixTraversableHandle}, Ptr{OptixAccelEmitDesc}, Cuint), context, stream, accelOptions, buildInputs, numBuildInputs, tempBuffer, tempBufferSizeInBytes, outputBuffer, outputBufferSizeInBytes, outputHandle, emittedProperties, numEmittedProperties)
end

function optixAccelGetRelocationInfo(context, handle, info)
    ccall((:optixAccelGetRelocationInfo, :nvoptix), OptixResult, (OptixDeviceContext, OptixTraversableHandle, Ptr{OptixAccelRelocationInfo}), context, handle, info)
end

function optixAccelGetRelocationInfo(context, handle, info, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, OptixTraversableHandle, Ptr{OptixAccelRelocationInfo}), context, handle, info)
end

function optixAccelCheckRelocationCompatibility(context, info, compatible)
    ccall((:optixAccelCheckRelocationCompatibility, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{OptixAccelRelocationInfo}, Ptr{Cint}), context, info, compatible)
end

function optixAccelCheckRelocationCompatibility(context, info, compatible, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{OptixAccelRelocationInfo}, Ptr{Cint}), context, info, compatible)
end

function optixAccelRelocate(context, stream, info, instanceTraversableHandles, numInstanceTraversableHandles, targetAccel, targetAccelSizeInBytes, targetHandle)
    ccall((:optixAccelRelocate, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{Cvoid}, Ptr{OptixAccelRelocationInfo}, CUdeviceptr, Csize_t, CUdeviceptr, Csize_t, Ptr{OptixTraversableHandle}), context, stream, info, instanceTraversableHandles, numInstanceTraversableHandles, targetAccel, targetAccelSizeInBytes, targetHandle)
end

function optixAccelRelocate(context, stream, info, instanceTraversableHandles, numInstanceTraversableHandles, targetAccel, targetAccelSizeInBytes, targetHandle, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{Cvoid}, Ptr{OptixAccelRelocationInfo}, CUdeviceptr, Csize_t, CUdeviceptr, Csize_t, Ptr{OptixTraversableHandle}), context, stream, info, instanceTraversableHandles, numInstanceTraversableHandles, targetAccel, targetAccelSizeInBytes, targetHandle)
end

function optixAccelCompact(context, stream, inputHandle, outputBuffer, outputBufferSizeInBytes, outputHandle)
    ccall((:optixAccelCompact, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{Cvoid}, OptixTraversableHandle, CUdeviceptr, Csize_t, Ptr{OptixTraversableHandle}), context, stream, inputHandle, outputBuffer, outputBufferSizeInBytes, outputHandle)
end

function optixAccelCompact(context, stream, inputHandle, outputBuffer, outputBufferSizeInBytes, outputHandle, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{Cvoid}, OptixTraversableHandle, CUdeviceptr, Csize_t, Ptr{OptixTraversableHandle}), context, stream, inputHandle, outputBuffer, outputBufferSizeInBytes, outputHandle)
end

function optixConvertPointerToTraversableHandle(onDevice, pointer, traversableType, traversableHandle)
    ccall((:optixConvertPointerToTraversableHandle, :nvoptix), OptixResult, (OptixDeviceContext, CUdeviceptr, OptixTraversableType, Ptr{OptixTraversableHandle}), onDevice, pointer, traversableType, traversableHandle)
end

function optixConvertPointerToTraversableHandle(onDevice, pointer, traversableType, traversableHandle, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, CUdeviceptr, OptixTraversableType, Ptr{OptixTraversableHandle}), onDevice, pointer, traversableType, traversableHandle)
end

function optixDenoiserCreate(context, modelKind, options, denoiser)
    ccall((:optixDenoiserCreate, :nvoptix), OptixResult, (OptixDeviceContext, OptixDenoiserModelKind, Ptr{OptixDenoiserOptions}, Ptr{OptixDenoiser}), context, modelKind, options, denoiser)
end

function optixDenoiserCreate(context, modelKind, options, denoiser, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, OptixDenoiserModelKind, Ptr{OptixDenoiserOptions}, Ptr{OptixDenoiser}), context, modelKind, options, denoiser)
end

function optixDenoiserCreateWithUserModel(context, userData, userDataSizeInBytes, denoiser)
    ccall((:optixDenoiserCreateWithUserModel, :nvoptix), OptixResult, (OptixDeviceContext, Ptr{Cvoid}, Csize_t, Ptr{OptixDenoiser}), context, userData, userDataSizeInBytes, denoiser)
end

function optixDenoiserCreateWithUserModel(context, userData, userDataSizeInBytes, denoiser, fptr)
    ccall(fptr, OptixResult, (OptixDeviceContext, Ptr{Cvoid}, Csize_t, Ptr{OptixDenoiser}), context, userData, userDataSizeInBytes, denoiser)
end

function optixDenoiserDestroy(denoiser)
    ccall((:optixDenoiserDestroy, :nvoptix), OptixResult, (OptixDenoiser,), denoiser)
end

function optixDenoiserDestroy(denoiser, fptr)
    ccall(fptr, OptixResult, (OptixDenoiser,), denoiser)
end

function optixDenoiserComputeMemoryResources(denoiser, outputWidth, outputHeight, returnSizes)
    ccall((:optixDenoiserComputeMemoryResources, :nvoptix), OptixResult, (OptixDenoiser, Cuint, Cuint, Ptr{OptixDenoiserSizes}), denoiser, outputWidth, outputHeight, returnSizes)
end

function optixDenoiserComputeMemoryResources(denoiser, outputWidth, outputHeight, returnSizes, fptr)
    ccall(fptr, OptixResult, (OptixDenoiser, Cuint, Cuint, Ptr{OptixDenoiserSizes}), denoiser, outputWidth, outputHeight, returnSizes)
end

function optixDenoiserSetup(denoiser, stream, inputWidth, inputHeight, denoiserState, denoiserStateSizeInBytes, scratch, scratchSizeInBytes)
    ccall((:optixDenoiserSetup, :nvoptix), OptixResult, (OptixDenoiser, Ptr{Cvoid}, Cuint, Cuint, CUdeviceptr, Csize_t, CUdeviceptr, Csize_t), denoiser, stream, inputWidth, inputHeight, denoiserState, denoiserStateSizeInBytes, scratch, scratchSizeInBytes)
end

function optixDenoiserSetup(denoiser, stream, inputWidth, inputHeight, denoiserState, denoiserStateSizeInBytes, scratch, scratchSizeInBytes, fptr)
    ccall(fptr, OptixResult, (OptixDenoiser, Ptr{Cvoid}, Cuint, Cuint, CUdeviceptr, Csize_t, CUdeviceptr, Csize_t), denoiser, stream, inputWidth, inputHeight, denoiserState, denoiserStateSizeInBytes, scratch, scratchSizeInBytes)
end

function optixDenoiserInvoke(denoiser, stream, params, denoiserState, denoiserStateSizeInBytes, guideLayer, layers, numLayers, inputOffsetX, inputOffsetY, scratch, scratchSizeInBytes)
    ccall((:optixDenoiserInvoke, :nvoptix), OptixResult, (OptixDenoiser, Ptr{Cvoid}, Ptr{OptixDenoiserParams}, CUdeviceptr, Csize_t, Ptr{OptixDenoiserGuideLayer}, Ptr{OptixDenoiserLayer}, Cuint, Cuint, Cuint, CUdeviceptr, Csize_t), denoiser, stream, params, denoiserState, denoiserStateSizeInBytes, guideLayer, layers, numLayers, inputOffsetX, inputOffsetY, scratch, scratchSizeInBytes)
end

function optixDenoiserInvoke(denoiser, stream, params, denoiserState, denoiserStateSizeInBytes, guideLayer, layers, numLayers, inputOffsetX, inputOffsetY, scratch, scratchSizeInBytes, fptr)
    ccall(fptr, OptixResult, (OptixDenoiser, Ptr{Cvoid}, Ptr{OptixDenoiserParams}, CUdeviceptr, Csize_t, Ptr{OptixDenoiserGuideLayer}, Ptr{OptixDenoiserLayer}, Cuint, Cuint, Cuint, CUdeviceptr, Csize_t), denoiser, stream, params, denoiserState, denoiserStateSizeInBytes, guideLayer, layers, numLayers, inputOffsetX, inputOffsetY, scratch, scratchSizeInBytes)
end

function optixDenoiserComputeIntensity(denoiser, stream, inputImage, outputIntensity, scratch, scratchSizeInBytes)
    ccall((:optixDenoiserComputeIntensity, :nvoptix), OptixResult, (OptixDenoiser, Ptr{Cvoid}, Ptr{OptixImage2D}, CUdeviceptr, CUdeviceptr, Csize_t), denoiser, stream, inputImage, outputIntensity, scratch, scratchSizeInBytes)
end

function optixDenoiserComputeIntensity(denoiser, stream, inputImage, outputIntensity, scratch, scratchSizeInBytes, fptr)
    ccall(fptr, OptixResult, (OptixDenoiser, Ptr{Cvoid}, Ptr{OptixImage2D}, CUdeviceptr, CUdeviceptr, Csize_t), denoiser, stream, inputImage, outputIntensity, scratch, scratchSizeInBytes)
end

function optixDenoiserComputeAverageColor(denoiser, stream, inputImage, outputAverageColor, scratch, scratchSizeInBytes)
    ccall((:optixDenoiserComputeAverageColor, :nvoptix), OptixResult, (OptixDenoiser, Ptr{Cvoid}, Ptr{OptixImage2D}, CUdeviceptr, CUdeviceptr, Csize_t), denoiser, stream, inputImage, outputAverageColor, scratch, scratchSizeInBytes)
end

function optixDenoiserComputeAverageColor(denoiser, stream, inputImage, outputAverageColor, scratch, scratchSizeInBytes, fptr)
    ccall(fptr, OptixResult, (OptixDenoiser, Ptr{Cvoid}, Ptr{OptixImage2D}, CUdeviceptr, CUdeviceptr, Csize_t), denoiser, stream, inputImage, outputAverageColor, scratch, scratchSizeInBytes)
end

struct OptixFunctionTable
    optixGetErrorName::Ptr{Cvoid}
    optixGetErrorString::Ptr{Cvoid}
    optixDeviceContextCreate::Ptr{Cvoid}
    optixDeviceContextDestroy::Ptr{Cvoid}
    optixDeviceContextGetProperty::Ptr{Cvoid}
    optixDeviceContextSetLogCallback::Ptr{Cvoid}
    optixDeviceContextSetCacheEnabled::Ptr{Cvoid}
    optixDeviceContextSetCacheLocation::Ptr{Cvoid}
    optixDeviceContextSetCacheDatabaseSizes::Ptr{Cvoid}
    optixDeviceContextGetCacheEnabled::Ptr{Cvoid}
    optixDeviceContextGetCacheLocation::Ptr{Cvoid}
    optixDeviceContextGetCacheDatabaseSizes::Ptr{Cvoid}
    optixModuleCreateFromPTX::Ptr{Cvoid}
    optixModuleCreateFromPTXWithTasks::Ptr{Cvoid}
    optixModuleGetCompilationState::Ptr{Cvoid}
    optixModuleDestroy::Ptr{Cvoid}
    optixBuiltinISModuleGet::Ptr{Cvoid}
    optixTaskExecute::Ptr{Cvoid}
    optixProgramGroupCreate::Ptr{Cvoid}
    optixProgramGroupDestroy::Ptr{Cvoid}
    optixProgramGroupGetStackSize::Ptr{Cvoid}
    optixPipelineCreate::Ptr{Cvoid}
    optixPipelineDestroy::Ptr{Cvoid}
    optixPipelineSetStackSize::Ptr{Cvoid}
    optixAccelComputeMemoryUsage::Ptr{Cvoid}
    optixAccelBuild::Ptr{Cvoid}
    optixAccelGetRelocationInfo::Ptr{Cvoid}
    optixAccelCheckRelocationCompatibility::Ptr{Cvoid}
    optixAccelRelocate::Ptr{Cvoid}
    optixAccelCompact::Ptr{Cvoid}
    optixConvertPointerToTraversableHandle::Ptr{Cvoid}
    reserved1::Ptr{Cvoid}
    reserved2::Ptr{Cvoid}
    optixSbtRecordPackHeader::Ptr{Cvoid}
    optixLaunch::Ptr{Cvoid}
    optixDenoiserCreate::Ptr{Cvoid}
    optixDenoiserDestroy::Ptr{Cvoid}
    optixDenoiserComputeMemoryResources::Ptr{Cvoid}
    optixDenoiserSetup::Ptr{Cvoid}
    optixDenoiserInvoke::Ptr{Cvoid}
    optixDenoiserComputeIntensity::Ptr{Cvoid}
    optixDenoiserComputeAverageColor::Ptr{Cvoid}
    optixDenoiserCreateWithUserModel::Ptr{Cvoid}
end

const OPTIX_VERSION = 70500

const OPTIX_SBT_RECORD_HEADER_SIZE = size_t(32)

const OPTIX_SBT_RECORD_ALIGNMENT = Culonglong(16)

const OPTIX_ACCEL_BUFFER_BYTE_ALIGNMENT = Culonglong(128)

const OPTIX_INSTANCE_BYTE_ALIGNMENT = Culonglong(16)

const OPTIX_AABB_BUFFER_BYTE_ALIGNMENT = Culonglong(8)

const OPTIX_GEOMETRY_TRANSFORM_BYTE_ALIGNMENT = Culonglong(16)

const OPTIX_TRANSFORM_BYTE_ALIGNMENT = Culonglong(64)

const OPTIX_COMPILE_DEFAULT_MAX_REGISTER_COUNT = 0

const OPTIX_COMPILE_DEFAULT_MAX_PAYLOAD_TYPE_COUNT = 8

const OPTIX_COMPILE_DEFAULT_MAX_PAYLOAD_VALUE_COUNT = 32

const OPTIX_ABI_VERSION = 60

for n in fieldnames(OptixFunctionTable)
    if startswith(String(n), "optix")
        @eval $n(t::OptixFunctionTable, args...) = $n(args..., t.$n)
    end
end

# exports
const PREFIXES = ["Optix", "OPTIX", "optix"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
