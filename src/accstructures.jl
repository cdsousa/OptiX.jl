export create_triangle_mesh_gas



function create_triangle_mesh_gas(context::OpContext, d_vertices)
    #Specify options for the build. We use default options for simplicity.
    _accel_options = Box{OptixAccelBuildOptions}()
    _accel_options.buildFlags = OPTIX_BUILD_FLAG_NONE
    _accel_options.operation = OPTIX_BUILD_OPERATION_BUILD

    # Populate the build input struct with our triangle data as well as
    # information about the sizes and types of our data
    triangle_input_flags = [OPTIX_GEOMETRY_FLAG_NONE]
    vertexBuffers = [pointer(d_vertices)]
    _triangle_input_triangleArray = Box{OptixBuildInputTriangleArray}()
    _triangle_input_triangleArray.vertexFormat = OPTIX_VERTEX_FORMAT_FLOAT3
    _triangle_input_triangleArray.numVertices = length(d_vertices)
    _triangle_input_triangleArray.vertexBuffers = pointer(vertexBuffers)
    _triangle_input_triangleArray.flags = pointer(triangle_input_flags)
    _triangle_input_triangleArray.numSbtRecords= 1

    _triangle_input = Box{OptixBuildInput}()
    pointer(_triangle_input).type = OPTIX_BUILD_INPUT_TYPE_TRIANGLES
    pointer(_triangle_input).triangleArray = _triangle_input_triangleArray[]

    # Query OptiX for the memory requirements for our GAS
    _gas_buffer_sizes = Box{OptixAccelBufferSizes}()
    GC.@preserve d_vertices vertexBuffers triangle_input_flags begin
        optixAccelComputeMemoryUsage(
            context,         # The device context we are using
            _accel_options,
            _triangle_input, # Describes our geometry
            1,               # Number of build inputs, could have multiple
            _gas_buffer_sizes)
    end
    gas_buffer_sizes = _gas_buffer_sizes[]

    # Allocate device memory for the scratch space buffer as well
    # as the GAS itself
    d_temp_buffer_gas = CuVector{UInt8}(undef, gas_buffer_sizes.tempSizeInBytes)
    d_gas_output_buffer = CuVector{UInt8}(undef, gas_buffer_sizes.outputSizeInBytes)

    # Now build the GAS
    _gas_handle = Ref(OptixTraversableHandle(0))

    GC.@preserve d_vertices vertexBuffers triangle_input_flags d_temp_buffer_gas d_gas_output_buffer begin
        optixAccelBuild(
            context,
            C_NULL,           # CUDA stream
            _accel_options,
            _triangle_input,
            1,           # num build inputs
            pointer(d_temp_buffer_gas),
            gas_buffer_sizes.tempSizeInBytes,
            pointer(d_gas_output_buffer),
            gas_buffer_sizes.outputSizeInBytes,
            _gas_handle, # Output handle to the struct
            C_NULL,     # emitted property list
            0,         # num emitted properties
            )
    end

    # We can now free scratch space used during the build
    d_temp_buffer_gas = nothing

    _gas_handle[]
end

