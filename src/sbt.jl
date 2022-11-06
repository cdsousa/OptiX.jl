export SbtRecord

function SbtRecord(::Type{T}) where T
    H = NTuple{Int(OPTIX_SBT_RECORD_HEADER_SIZE), UInt8}
    A = Tuple{H, T}
    s = Int(OPTIX_SBT_RECORD_ALIGNMENT)
    @NamedTuple{
        header::H,  # __align__( OPTIX_SBT_RECORD_ALIGNMENT ) char header[OPTIX_SBT_RECORD_HEADER_SIZE];
        data::T,
        _pad::NTuple{s - mod1(sizeof(A), s), UInt8}
    }
end
function SbtRecord(::Type{S}, data::T) where {S, T}
    header = ntuple(_->zero(UInt8), sizeof(fieldtype(S,1)))
    _pad = ntuple(_->zero(UInt8), sizeof(fieldtype(S,3)))
    S((;header, data, _pad))
end
