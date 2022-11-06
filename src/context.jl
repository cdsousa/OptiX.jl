export OpContext

mutable struct OpContext
    handle::OptixDeviceContext
    function OpContext()
        ctx = new(C_NULL)
        optixDeviceContextCreate(C_NULL, C_NULL, pointer_from_objref(ctx))
        finalizer(ctx) do ctx
            # optixDeviceContextSetLogCallback(ctx.handle, C_NULL, C_NULL, 0)
            optixDeviceContextDestroy(ctx.handle)
        end
    end
end
Base.unsafe_convert(::Type{OptixDeviceContext}, ctx::OpContext) = ctx.handle
