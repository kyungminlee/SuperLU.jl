import SuperLU_jll: libsuperlu

gstrs(::Type{Float32}, args...) = sgstrs(args...)
gstrs(::Type{Float64}, args...) = dgstrs(args...)
gstrs(::Type{ComplexF32}, args...) = cgstrs(args...)
gstrs(::Type{ComplexF64}, args...) = zgstrs(args...)

gstrf(::Type{Float32}, args...) = sgstrf(args...)
gstrf(::Type{Float64}, args...) = dgstrf(args...)
gstrf(::Type{ComplexF32}, args...) = cgstrf(args...)
gstrf(::Type{ComplexF64}, args...) = zgstrf(args...)

function sgstrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:sgstrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function sgsitrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:sgsitrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function sgstrs(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    ccall((:sgstrs, libsuperlu), Cvoid, (trans_t, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
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


function dgstrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:dgstrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function dgsitrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:dgsitrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function dgstrs(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    ccall((:dgstrs, libsuperlu), Cvoid, (trans_t, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
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


function cgstrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:cgstrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function cgsitrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:cgsitrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function cgstrs(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    ccall((:cgstrs, libsuperlu), Cvoid, (trans_t, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
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


function zgstrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:zgstrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function zgsitrf(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
    ccall((:zgsitrf, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, SuperLUInt, SuperLUInt, Ptr{SuperLUInt}, Ptr{Cvoid}, SuperLUInt, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{GlobalLU_t}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function zgstrs(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
    ccall((:zgstrs, libsuperlu), Cvoid, (trans_t, Ptr{SuperMatrix}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}, Ptr{SuperLUStat_t}, Ptr{SuperLUInt}), arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
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

function sp_preorder(arg1, arg2, arg3, arg4, arg5)
    ccall((:sp_preorder, libsuperlu), Cvoid, (Ptr{superlu_options_t}, Ptr{SuperMatrix}, Ptr{SuperLUInt}, Ptr{SuperLUInt}, Ptr{SuperMatrix}), arg1, arg2, arg3, arg4, arg5)
end

function get_perm_c(arg1, arg2, arg3)
    ccall((:get_perm_c, libsuperlu), Cvoid, (SuperLUInt, Ptr{SuperMatrix}, Ptr{SuperLUInt}), arg1, arg2, arg3)
end


function set_default_options(options)
    ccall((:set_default_options, libsuperlu), Cvoid, (Ptr{superlu_options_t},), options)
end


function sp_ienv(i)
    return ccall((:sp_ienv, libsuperlu), SuperLUInt, (SuperLUInt,), SuperLUInt(i))
end

function Destroy_SuperMatrix_Store(arg1)
    ccall((:Destroy_SuperMatrix_Store, libsuperlu), Cvoid, (Ptr{SuperMatrix},), arg1)
end

function Destroy_CompCol_Matrix(arg1)
    ccall((:Destroy_CompCol_Matrix, libsuperlu), Cvoid, (Ptr{SuperMatrix},), arg1)
end

function Destroy_CompRow_Matrix(arg1)
    ccall((:Destroy_CompRow_Matrix, libsuperlu), Cvoid, (Ptr{SuperMatrix},), arg1)
end

function Destroy_SuperNode_Matrix(arg1)
    ccall((:Destroy_SuperNode_Matrix, libsuperlu), Cvoid, (Ptr{SuperMatrix},), arg1)
end

function Destroy_CompCol_Permuted(arg1)
    ccall((:Destroy_CompCol_Permuted, libsuperlu), Cvoid, (Ptr{SuperMatrix},), arg1)
end

function Destroy_Dense_Matrix(arg1)
    ccall((:Destroy_Dense_Matrix, libsuperlu), Cvoid, (Ptr{SuperMatrix},), arg1)
end
