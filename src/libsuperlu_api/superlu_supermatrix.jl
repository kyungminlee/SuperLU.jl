
abstract type SuperLUStorageFormat{Tv<:Number} end

struct SuperMatrix{Tv,StorageFormat<:SuperLUStorageFormat{Tv}}
    Stype::Stype_t
    Dtype::Dtype_t
    Mtype::Mtype_t
    nrow::SuperLUInt
    ncol::SuperLUInt
    Store::Ptr{StorageFormat}
end

struct NCformat{Tv}<:SuperLUStorageFormat{Tv}
    nnz::SuperLUInt
    nzval::Ptr{Tv}
    rowind::Ptr{SuperLUInt}
    colptr::Ptr{SuperLUInt}
end

struct NRformat{Tv}<:SuperLUStorageFormat{Tv}
    nnz::SuperLUInt
    nzval::Ptr{Tv}
    colind::Ptr{SuperLUInt}
    rowptr::Ptr{SuperLUInt}
end

struct SCformat{Tv}<:SuperLUStorageFormat{Tv}
    nnz::SuperLUInt
    nsuper::SuperLUInt
    nzval::Ptr{Tv}
    nzval_colptr::Ptr{SuperLUInt}
    rowind::Ptr{SuperLUInt}
    rowind_colptr::Ptr{SuperLUInt}
    col_to_sup::Ptr{SuperLUInt}
    sup_to_col::Ptr{SuperLUInt}
end

struct SCPformat{Tv}<:SuperLUStorageFormat{Tv}
    nnz::SuperLUInt
    nsuper::SuperLUInt
    nzval::Ptr{Tv}
    nzval_colbeg::Ptr{SuperLUInt}
    nzval_colend::Ptr{SuperLUInt}
    rowind::Ptr{SuperLUInt}
    rowind_colbeg::Ptr{SuperLUInt}
    rowind_colend::Ptr{SuperLUInt}
    col_to_sup::Ptr{SuperLUInt}
    sup_to_colbeg::Ptr{SuperLUInt}
    sup_to_colend::Ptr{SuperLUInt}
end

struct NCPformat{Tv}<:SuperLUStorageFormat{Tv}
    nnz::SuperLUInt
    nzval::Ptr{Tv}
    rowind::Ptr{SuperLUInt}
    colbeg::Ptr{SuperLUInt}
    colend::Ptr{SuperLUInt}
end

struct DNformat{Tv}<:SuperLUStorageFormat{Tv}
    lda::SuperLUInt
    nzval::Ptr{Tv}
end

struct NRformat_loc{Tv}<:SuperLUStorageFormat{Tv}
    nnz_loc::SuperLUInt
    m_loc::SuperLUInt
    fst_row::SuperLUInt
    nzval::Ptr{Tv}
    rowptr::Ptr{SuperLUInt}
    colind::Ptr{SuperLUInt}
end
