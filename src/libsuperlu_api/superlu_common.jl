# COV_EXCL_START

const flops_t = Cfloat

@cenum fact_t::UInt32 begin
    DOFACT = 0
    SamePattern = 1
    SamePattern_SameRowPerm = 2
    FACTORED = 3
end

@cenum yes_no_t::UInt32 begin
    NO = 0
    YES = 1
end

@cenum colperm_t::UInt32 begin
    NATURAL = 0
    MMD_ATA = 1
    MMD_AT_PLUS_A = 2
    COLAMD = 3
    METIS_AT_PLUS_A = 4
    PARMETIS = 5
    ZOLTAN = 6
    MY_PERMC = 7
end

@cenum trans_t::UInt32 begin
    NOTRANS = 0
    TRANS = 1
    CONJ = 2
end

@cenum IterRefine_t::UInt32 begin
    NOREFINE = 0
    SLU_SINGLE = 1
    SLU_DOUBLE = 2
    SLU_EXTRA = 3
end

@cenum rowperm_t::UInt32 begin
    NOROWPERM = 0
    LargeDiag_MC64 = 1
    LargeDiag_AWPM = 2
    MY_PERMR = 3
end

@cenum norm_t::UInt32 begin
    ONE_NORM = 0
    TWO_NORM = 1
    INF_NORM = 2
end

@cenum milu_t::UInt32 begin
    SILU = 0
    SMILU_1 = 1
    SMILU_2 = 2
    SMILU_3 = 3
end


struct superlu_options_t
    Fact::fact_t
    Equil::yes_no_t
    ColPerm::colperm_t
    Trans::trans_t
    IterRefine::IterRefine_t
    DiagPivotThresh::Cdouble
    SymmetricMode::yes_no_t
    PivotGrowth::yes_no_t
    ConditionNumber::yes_no_t
    RowPerm::rowperm_t
    ILU_DropRule::SuperLUInt
    ILU_DropTol::Cdouble
    ILU_FillFactor::Cdouble
    ILU_Norm::norm_t
    ILU_FillTol::Cdouble
    ILU_MILU::milu_t
    ILU_MILU_Dim::Cdouble
    ParSymbFact::yes_no_t
    ReplaceTinyPivot::yes_no_t
    SolveInitialized::yes_no_t
    RefineInitialized::yes_no_t
    PrintStat::yes_no_t
    nnzL::SuperLUInt
    nnzU::SuperLUInt
    num_lookaheads::SuperLUInt
    lookahead_etree::yes_no_t
    SymPattern::yes_no_t
end

struct e_node
    size::SuperLUInt
    mem::Ptr{Cvoid}
end

const ExpHeader = e_node

struct LU_stack_t
    size::SuperLUInt
    used::SuperLUInt
    top1::SuperLUInt
    top2::SuperLUInt
    array::Ptr{Cvoid}
end

struct SuperLUStat_t
    panel_histo::Ptr{SuperLUInt}
    utime::Ptr{Cdouble}
    ops::Ptr{flops_t}
    TinyPivots::SuperLUInt
    RefineSteps::SuperLUInt
    expansions::SuperLUInt
end

# struct mem_usage_t
#     for_lu::Cfloat
#     total_needed::Cfloat
# end

@cenum LU_space_t::UInt32 begin
    SYSTEM = 0
    USER = 1
end


struct GlobalLU_t
    xsup::Ptr{SuperLUInt}
    supno::Ptr{SuperLUInt}
    lsub::Ptr{SuperLUInt}
    xlsub::Ptr{SuperLUInt}
    lusup::Ptr{Cvoid}
    xlusup::Ptr{SuperLUInt}
    ucol::Ptr{Cvoid}
    usub::Ptr{SuperLUInt}
    xusub::Ptr{SuperLUInt}
    nzlmax::SuperLUInt
    nzumax::SuperLUInt
    nzlumax::SuperLUInt
    n::SuperLUInt
    MemModel::LU_space_t
    num_expansions::SuperLUInt
    expanders::Ptr{ExpHeader}
    stack::LU_stack_t
end

# @cenum DiagScale_t::UInt32 begin
#     NOEQUIL = 0
#     ROW = 1
#     COL = 2
#     BOTH = 3
# end

# @cenum stack_end_t::UInt32 begin
#     HEAD = 0
#     TAIL = 1
# end

@cenum PhaseType::UInt32 begin
    COLPERM = 0
    ROWPERM = 1
    RELAX = 2
    ETREE = 3
    EQUIL = 4
    SYMBFAC = 5
    DIST = 6
    FACT = 7
    COMM = 8
    COMM_DIAG = 9
    COMM_RIGHT = 10
    COMM_DOWN = 11
    SOL_COMM = 12
    SOL_GEMM = 13
    SOL_TRSM = 14
    SOL_TOT = 15
    RCOND = 16
    SOLVE = 17
    REFINE = 18
    TRSV = 19
    GEMV = 20
    FERR = 21
    NPHASES = 22
end

@cenum Stype_t::UInt32 begin
    SLU_NC = 0
    SLU_NCP = 1
    SLU_NR = 2
    SLU_SC = 3
    SLU_SCP = 4
    SLU_SR = 5
    SLU_DN = 6
    SLU_NR_loc = 7
end

@cenum Dtype_t::UInt32 begin
    SLU_S = 0
    SLU_D = 1
    SLU_C = 2
    SLU_Z = 3
end

@cenum Mtype_t::UInt32 begin
    SLU_GE = 0
    SLU_TRLU = 1
    SLU_TRUU = 2
    SLU_TRL = 3
    SLU_TRU = 4
    SLU_SYL = 5
    SLU_SYU = 6
    SLU_HEL = 7
    SLU_HEU = 8
end

# COV_EXCL_STOP
