#module cSuperLU
# export SuperLUInt
# export SuperMatrix
# export SuperLUStat_t

using CEnum
const SuperLUInt = Cint
include("cSuperLU/superlu_common.jl")
include("cSuperLU/superlu_api.jl")
include("cSuperLU/superlu_util.jl")
#end
