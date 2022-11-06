export optix_init

__optixFunctionTable::OptixFunctionTable = (x = Ref{OptixFunctionTable}(); Base.unsafe_securezero!(convert(Ptr{OptixFunctionTable}, pointer_from_objref(x))); x[])

for n in fieldnames(OptixFunctionTable)
    if startswith(String(n), "optix")
        @eval $n(args...) = LibNvOptiX.$n(args..., __optixFunctionTable.$n)
    end
end

function optix_init(libnvoptix_path)
    # load lib
    libnvoptix = Libdl.dlopen(libnvoptix_path, Libdl.RTLD_NOW)

    # function table
    _optixFunctionTable = Box{OptixFunctionTable}()
    @ccall :nvoptix.optixQueryFunctionTable(OPTIX_ABI_VERSION::Cint, 0::Cint, 0::Cint, 0::Cint, (_optixFunctionTable)::Ptr{Cvoid}, sizeof(_optixFunctionTable)::Cint)::Cint
    global __optixFunctionTable = _optixFunctionTable[]

    return nothing
end