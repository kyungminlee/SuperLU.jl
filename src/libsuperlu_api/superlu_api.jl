# COV_EXCL_START

macro superlufunc(x)
    return Expr(:quote, Symbol(x))
end

for (fname, elty) in [
    (:sgstrf, Float32),
    (:dgstrf, Float64),
    (:cgstrf, ComplexF32),
    (:zgstrf, ComplexF64),
]
    @eval begin
        function gstrf(
            options::Ref{superlu_options_t},
            A::Ref{SuperMatrix{$elty, NCPformat{$elty}}},
            relax::SuperLUInt,
            panel_size::SuperLUInt,
            etree::DenseVector{SuperLUInt},
            work::Ptr{Cvoid},
            lwork::SuperLUInt,
            perm_c::DenseVector{SuperLUInt},
            perm_r::DenseVector{SuperLUInt},
            L::Ref{SuperMatrix{$elty, SCformat{$elty}}},
            U::Ref{SuperMatrix{$elty, NCformat{$elty}}},
            Glu::Ref{GlobalLU_t},
            stat::Ref{SuperLUStat_t},
            info::Ref{SuperLUInt}
        )
            ccall(
                (@superlufunc($fname), libsuperlu),
                Cvoid,
                (
                    Ptr{superlu_options_t},
                    Ptr{SuperMatrix{$elty, NCPformat{$elty}}},
                    SuperLUInt, SuperLUInt,
                    Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt,
                    Ptr{SuperLUInt}, Ptr{SuperLUInt},
                    Ptr{SuperMatrix{$elty, SCformat{$elty}}},
                    Ptr{SuperMatrix{$elty, NCformat{$elty}}},
                    Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}
                ),
                options, A, relax, panel_size, etree, work, lwork, perm_c, perm_r, L, U, Glu, stat, info
            )
        end
    end
end

for (fname, elty) in [
    (:sgstrs, Float32),
    (:dgstrs, Float64),
    (:cgstrs, ComplexF32),
    (:zgstrs, ComplexF64),
]
    @eval begin
        function gstrs(
            trans::trans_t,
            L::Ref{SuperMatrix{$elty, SCformat{$elty}}},
            U::Ref{SuperMatrix{$elty, NCformat{$elty}}},
            perm_c::DenseVector{SuperLUInt},
            perm_r::DenseVector{SuperLUInt},
            B::Ref{SuperMatrix{$elty, DNformat{$elty}}},
            stat::Ref{SuperLUStat_t},
            info::Ref{SuperLUInt}
        )
            ccall(
                (@superlufunc($fname), libsuperlu), Cvoid,
                (trans_t, Ptr{SuperMatrix{$elty, SCformat{$elty}}}, Ptr{SuperMatrix{$elty, NCformat{$elty}}}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix{$elty, DNformat{$elty}}}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}),
                trans, L, U, perm_c, perm_r, B, stat, info)
        end
    end
end


for (fname, elty, relty) in [
    (:sgstrs, Float32, Float32),
    (:dgstrs, Float64, Float64),
    (:cgstrs, ComplexF32, Float32),
    (:zgstrs, ComplexF64, Float64),
]
    @eval begin
        function gsequ(A::SuperMatrix{$elty, NCformat{$elty}}, R::DenseVector{$relty}, C::DenseVector{$relty}, rowcnd::Ref{$relty}, colcnd::Ref{$relty}, amax::Ref{$relty}, info::Ref{SuperLUInt})
            ccall((fname, libsuperlu), Cvoid, (Ptr{SuperMatrix{$elty, NCformat{$elty}}}, Ptr{$relty}, Ptr{$relty}, Ptr{$relty}, Ptr{$relty}, Ptr{$relty}, Ptr{SuperLUInt}), A, R, C, rowcnd, colcnd, amax, info)
        end
    end
end


function sgsitrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:sgsitrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function sgscon(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:sgscon, libsuperlu), Cvoid, (Cstring, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Cdouble, Ptr{Cdouble}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function sgsequ(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:sgsequ, libsuperlu), Cvoid, (Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function slaqgs(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:slaqgs, libsuperlu), Cvoid, (Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Cdouble, Cdouble, Cdouble, Cstring), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function sgsrfs(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
    ccall((:sgsrfs, libsuperlu), Cvoid, (trans_t, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Cstring, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
end


function dgsitrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:dgsitrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function dgscon(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:dgscon, libsuperlu), Cvoid, (Cstring, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Cdouble, Ptr{Cdouble}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function dgsequ(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:dgsequ, libsuperlu), Cvoid, (Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function dlaqgs(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:dlaqgs, libsuperlu), Cvoid, (Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Cdouble, Cdouble, Cdouble, Cstring), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function dgsrfs(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
    ccall((:dgsrfs, libsuperlu), Cvoid, (trans_t, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Cstring, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
end


function cgsitrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:cgsitrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function cgscon(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:cgscon, libsuperlu), Cvoid, (Cstring, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Cdouble, Ptr{Cdouble}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function cgsequ(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:cgsequ, libsuperlu), Cvoid, (Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function claqgs(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:claqgs, libsuperlu), Cvoid, (Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Cdouble, Cdouble, Cdouble, Cstring), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function cgsrfs(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
    ccall((:cgsrfs, libsuperlu), Cvoid, (trans_t, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Cstring, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
end


function zgsitrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:zgsitrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function zgscon(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:zgscon, libsuperlu), Cvoid, (Cstring, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Cdouble, Ptr{Cdouble}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function zgsequ(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:zgsequ, libsuperlu), Cvoid, (Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function zlaqgs(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
    ccall((:zlaqgs, libsuperlu), Cvoid, (Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Cdouble, Cdouble, Cdouble, Cstring), arg1, arg2, arg3, arg4, arg5, arg6, arg7)
end
function zgsrfs(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
    ccall((:zgsrfs, libsuperlu), Cvoid, (trans_t, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Cstring, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
end


function StatInit(arg1)
    ccall((:StatInit, libsuperlu), Cvoid, (Ptr{SuperLUStat_t},), arg1)
end

function StatFree(arg1)
    ccall((:StatFree, libsuperlu), Cvoid, (Ptr{SuperLUStat_t},), arg1)
end


function sp_preorder(options::Ref{superlu_options_t}, A::Ref{SuperMatrix{Tv, NCformat{Tv}}}, perm_c::DenseVector{SuperLUInt}, etree::DenseVector{SuperLUInt}, AC::Ref{SuperMatrix{Tv, NCPformat{Tv}}}) where {Tv}
    ccall(
        (:sp_preorder, libsuperlu),
        Cvoid,
        (Ptr{superlu_options_t}, Ptr{SuperMatrix{Tv, NCformat{Tv}}}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix{Tv, NCPformat{Tv}}}),
        options, A, perm_c, etree, AC
    )
end

function get_perm_c(arg1, arg2::Base.RefValue{SuperMatrix{Tv, NCformat{Tv}}}, arg3) where Tv
    ccall((:get_perm_c, libsuperlu), Cvoid, (SuperLUInt, Ptr{SuperMatrix{Tv, NCformat{Tv}}}, Ptr{SuperLUInt}), arg1, arg2, arg3)
end


function set_default_options(options)
    ccall((:set_default_options, libsuperlu), Cvoid, (Ptr{superlu_options_t},), options)
end


function sp_ienv(i)
    return ccall((:sp_ienv, libsuperlu), SuperLUInt, (SuperLUInt,), SuperLUInt(i))
end

function Destroy_SuperMatrix_Store(arg1::Ref{SuperMatrix{Tv, S}}) where {Tv, S<:SuperLUStorageFormat}
    ccall((:Destroy_SuperMatrix_Store, libsuperlu), Cvoid, (Ptr{SuperMatrix{Tv, S}},), arg1)
end

function Destroy_CompCol_Matrix(arg1::Ref{SuperMatrix{Tv, NCformat{Tv}}}) where Tv
    ccall((:Destroy_CompCol_Matrix, libsuperlu), Cvoid, (Ptr{SuperMatrix{Tv, NCformat{Tv}}},), arg1)
end

function Destroy_CompRow_Matrix(arg1::Ref{SuperMatrix{Tv, NRformat{Tv}}}) where Tv
    ccall((:Destroy_CompRow_Matrix, libsuperlu), Cvoid, (Ptr{SuperMatrix{Tv, NRformat{Tv}}},), arg1)
end

function Destroy_SuperNode_Matrix(arg1::Ref{SuperMatrix{Tv, SCformat{Tv}}}) where Tv
    ccall((:Destroy_SuperNode_Matrix, libsuperlu), Cvoid, (Ptr{SuperMatrix{Tv, SCformat{Tv}}},), arg1)
end

function Destroy_CompCol_Permuted(arg1::Ref{SuperMatrix{Tv, NCPformat{Tv}}}) where Tv
    ccall((:Destroy_CompCol_Permuted, libsuperlu), Cvoid, (Ptr{SuperMatrix{Tv, NCPformat{Tv}}},), arg1)
end

function Destroy_Dense_Matrix(arg1::Ref{SuperMatrix{Tv, DNformat{Tv}}}) where Tv
    ccall((:Destroy_Dense_Matrix, libsuperlu), Cvoid, (Ptr{SuperMatrix{Tv, DNformat{Tv}}},), arg1)
end

# COV_EXCL_STOP
