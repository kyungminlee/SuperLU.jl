using CEnum
import SuperLU_jll: libsuperlu
const SuperLUInt = Cint

include("libsuperlu_api/superlu_common.jl")
include("libsuperlu_api/superlu_api.jl")
include("libsuperlu_api/superlu_util.jl")
