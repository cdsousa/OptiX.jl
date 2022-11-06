module Boxes

import Setfield
export Box

mutable struct Box{T} <: Ref{T}
    x::T
    Box{T}() where {T} = (x=new(); Base.unsafe_securezero!(convert(Ptr{T}, pointer_from_objref(x))); x)
    Box{T}(::UndefInitializer) where {T} = new()
    Box{T}(x) where {T} = new(x)
end
Box(x::T) where {T} = Box{T}(x)

Base.getindex(b::Box) = Core.getfield(b, :x)
Base.setindex!(b::Box, val) = Core.setfield!(b, :x, val)
Base.getproperty(b::Box, sym::Symbol) = Base.getproperty(b[], sym)
Base.setproperty!(b::Box, sym::Symbol, val) = (x = b[]; b[] = Setfield.@set x.$sym = val)

Base.unsafe_convert(P::Type{Ptr{Nothing}}, b::Box)::P = pointer_from_objref(b)
(Base.unsafe_convert(P::Type{Ptr{T}}, b::Box{T})::P) where T = pointer_from_objref(b)
(Base.pointer(b::Box{T})::Ptr{T}) where T = Base.unsafe_convert(Ptr{T}, b)

end  # module Boxes
