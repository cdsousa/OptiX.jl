for n in fieldnames(OptixFunctionTable)
    if startswith(String(n), "optix")
        @eval $n(t::OptixFunctionTable, args...) = $n(args..., t.$n)
    end
end