export OpPipeline

mutable struct OpPipeline
    context::OpContext
    optixmodule::OptixModule
    raygen_prog_group::OptixProgramGroup
    miss_prog_group::OptixProgramGroup
    hitgroup_prog_group::OptixProgramGroup
    handle::OptixPipeline

    function OpPipeline(context, optixmodule, raygen_prog_group, miss_prog_group, hitgroup_prog_group, pipeline)
        p = new(context, optixmodule, raygen_prog_group, miss_prog_group, hitgroup_prog_group, pipeline)
        finalizer(p) do p
            optixPipelineDestroy( p.handle )
            optixProgramGroupDestroy( p.hitgroup_prog_group )
            optixProgramGroupDestroy( p.miss_prog_group )
            optixProgramGroupDestroy( p.raygen_prog_group )
            optixModuleDestroy( p.optixmodule )
        end
    end
end


function OpPipeline(context::OpContext, raygen, closesthit, miss, params_name::Symbol, params_type::Type{P}, numPayloadValues) where P

    raygen_name = string(raygen)
    closesthit_name = string(closesthit)
    miss_name = string(miss)
    @assert startswith(raygen_name, "__raygen__")
    @assert startswith(closesthit_name, "__closesthit__")
    @assert startswith(miss_name, "__miss__")

    function _optix_programs_dummy_call()
        @noinline raygen()
        @noinline closesthit()
        @noinline miss()
    end

    source = CUDA.GPUCompiler.FunctionSpec(_optix_programs_dummy_call, Tuple{}, false)
    target = CUDA.CUDACompilerTarget(device(), always_inline=true)
    params = CUDA.CUDACompilerParams()
    job = CUDA.GPUCompiler.CompilerJob(target, source, params)
    asm, meta = CUDA.GPUCompiler.codegen(:asm, job; strip=true, only_entry=false, validate=true)

    program_name_prefixes = [
        "__raygen__","__intersection__",
        "__anyhit__","__closesthit__",
        "__miss__","__direct_callable__",
        "__continuation_callable__","__exception__",
    ]
    optix_ptx_1 = foldl((asm, prefix)->replace(asm, Regex("(\\w*julia_)($prefix\\w*)(_\\d+)") => s"\2"), program_name_prefixes, init=asm)
    optix_ptx_2 = foldl((asm, prefix)->replace(asm, Regex("(.func )($prefix\\w*)") => s".visible \1\2"), program_name_prefixes, init=optix_ptx_1)
    optix_ptx = foldl((asm, prefix)->replace(asm, Regex(".visible .func (julia__optix_programs_dummy_call_\\d+)[\\s\\S]*?// -- End function\\n}") => s"// /-- REDACTED --------------------\n// | \1\n// \\--------------------------------"), program_name_prefixes, init=optix_ptx_2)

    # write("out.ptx", optix_ptx)



    # # module

    _module_compile_options = Box{OptixModuleCompileOptions}()
    _module_compile_options.maxRegisterCount     = OPTIX_COMPILE_DEFAULT_MAX_REGISTER_COUNT
    _module_compile_options.optLevel             = OPTIX_COMPILE_OPTIMIZATION_DEFAULT
    _module_compile_options.debugLevel           = OPTIX_COMPILE_DEBUG_LEVEL_MINIMAL


    _pipeline_compile_options = Box{OptixPipelineCompileOptions}()
    _pipeline_compile_options.usesMotionBlur        = false
    _pipeline_compile_options.traversableGraphFlags = OPTIX_TRAVERSABLE_GRAPH_FLAG_ALLOW_SINGLE_GAS
    _pipeline_compile_options.numPayloadValues      = numPayloadValues
    _pipeline_compile_options.numAttributeValues    = 3
    _pipeline_compile_options.exceptionFlags        = OPTIX_EXCEPTION_FLAG_NONE
    _pipeline_compile_options.usesPrimitiveTypeFlags = reinterpret(UInt32, OPTIX_PRIMITIVE_TYPE_FLAGS_TRIANGLE)
    pipelineLaunchParamsVariableName_ = Base.cconvert(Cstring, string(params_name))
    _pipeline_compile_options.pipelineLaunchParamsVariableName = pointer(pipelineLaunchParamsVariableName_)


    input = Base.cconvert(Cstring, optix_ptx)
    inputSize = Csize_t(sizeof(input))

    _optixmodule = Ref(OptixModule(C_NULL))
    GC.@preserve pipelineLaunchParamsVariableName_ begin
            optixModuleCreateFromPTX(
            context,
            _module_compile_options,
            _pipeline_compile_options,
            input,
            inputSize,
            C_NULL,
            C_NULL,
            _optixmodule
        )
    end
    optixmodule = _optixmodule[]


    # # program groups

    _program_group_options = Box{OptixProgramGroupOptions}()


    _raygen = Box{OptixProgramGroupSingleModule}()
    _raygen._module = _optixmodule[]
    raygen_entryFunctionName_ = Base.cconvert(Cstring, raygen_name)
    _raygen.entryFunctionName = pointer(raygen_entryFunctionName_)

    _raygen_prog_group_desc = Box{OptixProgramGroupDesc}()
    pointer(_raygen_prog_group_desc).kind   = OPTIX_PROGRAM_GROUP_KIND_RAYGEN
    pointer(_raygen_prog_group_desc).raygen = _raygen[]

    _raygen_prog_group   = Ref(OptixProgramGroup(C_NULL))
    GC.@preserve raygen_entryFunctionName_ optixProgramGroupCreate(
        context,
        _raygen_prog_group_desc,
        1,
        _program_group_options,
        C_NULL,
        C_NULL,
        _raygen_prog_group
    )
    raygen_prog_group = _raygen_prog_group[]


    _miss = Box{OptixProgramGroupSingleModule}()
    _miss._module = _optixmodule[]
    miss_entryFunctionName_ = Base.cconvert(Cstring, miss_name)
    _miss.entryFunctionName = pointer(miss_entryFunctionName_)

    _miss_prog_group_desc  = Box{OptixProgramGroupDesc}()
    pointer(_miss_prog_group_desc).kind   = OPTIX_PROGRAM_GROUP_KIND_MISS
    pointer(_miss_prog_group_desc).miss = _miss[]

    _miss_prog_group     = Ref(OptixProgramGroup(C_NULL))
    GC.@preserve miss_entryFunctionName_ optixProgramGroupCreate(
        context,
        _miss_prog_group_desc,
        1,
        _program_group_options,
        C_NULL,
        C_NULL,
        _miss_prog_group
    )
    miss_prog_group = _miss_prog_group[]


    _hitgroup = Box{OptixProgramGroupHitgroup}()
    _hitgroup.moduleCH = _optixmodule[]
    closesthit_entryFunctionName_ = Base.cconvert(Cstring, closesthit_name)
    _hitgroup.entryFunctionNameCH = pointer(closesthit_entryFunctionName_)

    _hitgroup_prog_group_desc   = Box{OptixProgramGroupDesc}()
    pointer(_hitgroup_prog_group_desc).kind   = OPTIX_PROGRAM_GROUP_KIND_HITGROUP
    pointer(_hitgroup_prog_group_desc).hitgroup = _hitgroup[]

    _hitgroup_prog_group = Ref(OptixProgramGroup(C_NULL))
    GC.@preserve closesthit_entryFunctionName_ optixProgramGroupCreate(
        context,
        _hitgroup_prog_group_desc,
        1,
        _program_group_options,
        C_NULL,
        C_NULL,
        _hitgroup_prog_group
    )
    hitgroup_prog_group = _hitgroup_prog_group[]


    # link pipeline

    max_trace_depth = UInt32(1)

    program_groups = [raygen_prog_group, miss_prog_group, hitgroup_prog_group]

    _pipeline_link_options = Box{OptixPipelineLinkOptions}()
    _pipeline_link_options.maxTraceDepth = max_trace_depth
    _pipeline_link_options.debugLevel    = OPTIX_COMPILE_DEBUG_LEVEL_FULL

    _pipeline = Ref(OptixPipeline(C_NULL))
    GC.@preserve pipelineLaunchParamsVariableName_ optixPipelineCreate(
        context,
        _pipeline_compile_options,
        _pipeline_link_options,
        program_groups,
        length( program_groups ),
        C_NULL,
        C_NULL,
        _pipeline
    )
    pipeline = _pipeline[]

    _stack_sizes = Box{OptixStackSizes}()

    for prog_group in program_groups
        _localStackSizes = Box{OptixStackSizes}()
        optixProgramGroupGetStackSize( prog_group, _localStackSizes )

        _stack_sizes.cssRG = max(_stack_sizes.cssRG, _localStackSizes.cssRG)
        _stack_sizes.cssMS = max(_stack_sizes.cssMS, _localStackSizes.cssMS)
        _stack_sizes.cssCH = max(_stack_sizes.cssCH, _localStackSizes.cssCH)
        _stack_sizes.cssAH = max(_stack_sizes.cssAH, _localStackSizes.cssAH)
        _stack_sizes.cssIS = max(_stack_sizes.cssIS, _localStackSizes.cssIS)
        _stack_sizes.cssCC = max(_stack_sizes.cssCC, _localStackSizes.cssCC)
        _stack_sizes.dssDC = max(_stack_sizes.dssDC, _localStackSizes.dssDC)
    end

    maxCCDepth = 0
    maxDCDepth = 0
    maxTraceDepth = max_trace_depth
    maxTraversableDepth = 1

    directCallableStackSizeFromTraversal = maxDCDepth * _stack_sizes.dssDC
    directCallableStackSizeFromState = maxDCDepth * _stack_sizes.dssDC

    cssCCTree = maxCCDepth * _stack_sizes.cssCC

    cssCHOrMSPlusCCTree = max( _stack_sizes.cssCH, _stack_sizes.cssMS ) + cssCCTree

    continuationStackSize = _stack_sizes.cssRG + cssCCTree +
            ( max( maxTraceDepth, 1 ) - 1 ) * cssCHOrMSPlusCCTree +
            min( maxTraceDepth, 1 ) * max( cssCHOrMSPlusCCTree, _stack_sizes.cssIS + _stack_sizes.cssAH )


    optixPipelineSetStackSize(
        pipeline,
        directCallableStackSizeFromTraversal,
        directCallableStackSizeFromState,
        continuationStackSize,
        maxTraversableDepth
    )

    OpPipeline(
        context,
        optixmodule,
        raygen_prog_group,
        miss_prog_group,
        hitgroup_prog_group,
        pipeline
    )
end


