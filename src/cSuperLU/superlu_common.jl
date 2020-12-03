# Automatically generated using Clang.jl


const COLAMD_KNOBS = 20
const COLAMD_STATS = 20
const COLAMD_DENSE_ROW = 0
const COLAMD_DENSE_COL = 1
const COLAMD_DEFRAG_COUNT = 2
const COLAMD_STATUS = 3
const COLAMD_INFO1 = 4
const COLAMD_INFO2 = 5
const COLAMD_INFO3 = 6
const COLAMD_OK = 0
const COLAMD_OK_BUT_JUMBLED = 1
const COLAMD_ERROR_A_not_present = -1
const COLAMD_ERROR_p_not_present = -2
const COLAMD_ERROR_nrow_negative = -3
const COLAMD_ERROR_ncol_negative = -4
const COLAMD_ERROR_nnz_negative = -5
const COLAMD_ERROR_p0_nonzero = -6
const COLAMD_ERROR_A_too_small = -7
const COLAMD_ERROR_col_length_negative = -8
const COLAMD_ERROR_row_index_out_of_bounds = -9
const COLAMD_ERROR_out_of_memory = -10
const COLAMD_ERROR_internal_error = -999

# Skipping MacroDefinition: COLAMD_C ( n_col ) ( ( int_t ) ( ( ( n_col ) + 1 ) * sizeof ( Colamd_Col ) / sizeof ( int_t ) ) )
# Skipping MacroDefinition: COLAMD_R ( n_row ) ( ( int_t ) ( ( ( n_row ) + 1 ) * sizeof ( Colamd_Row ) / sizeof ( int_t ) ) )
# Skipping MacroDefinition: COLAMD_RECOMMENDED ( nnz , n_row , n_col ) \
#( \
#( ( nnz ) < 0 || ( n_row ) < 0 || ( n_col ) < 0 ) \
#? ( - 1 ) \
#: ( 2 * ( nnz ) + COLAMD_C ( n_col ) + COLAMD_R ( n_row ) + ( n_col ) + ( ( nnz ) / 5 ) ) \
#)

struct ANONYMOUS1_shared1
    thickness::SuperLUInt
end

struct ANONYMOUS2_shared2
    score::SuperLUInt
end

struct ANONYMOUS3_shared3
    headhash::SuperLUInt
end

struct ANONYMOUS4_shared4
    degree_next::SuperLUInt
end

struct Colamd_Col_struct
    start::SuperLUInt
    length::SuperLUInt
    shared1::ANONYMOUS1_shared1
    shared2::ANONYMOUS2_shared2
    shared3::ANONYMOUS3_shared3
    shared4::ANONYMOUS4_shared4
end

const Colamd_Col = Colamd_Col_struct

struct ANONYMOUS5_shared1
    degree::SuperLUInt
end

struct ANONYMOUS6_shared2
    mark::SuperLUInt
end

struct Colamd_Row_struct
    start::SuperLUInt
    length::SuperLUInt
    shared1::ANONYMOUS5_shared1
    shared2::ANONYMOUS6_shared2
end

const Colamd_Row = Colamd_Row_struct
const ADD_ = 0
const ADD__ = 1
const NOCHANGE = 2
const UPCASE = 3
const OLD_CRAY = 4
const C_CALL = 5
const F77_CALL_C = ADD_

# Skipping MacroDefinition: z_add ( c , a , b ) { ( c ) -> r = ( a ) -> r + ( b ) -> r ; ( c ) -> i = ( a ) -> i + ( b ) -> i ; }
# Skipping MacroDefinition: z_sub ( c , a , b ) { ( c ) -> r = ( a ) -> r - ( b ) -> r ; ( c ) -> i = ( a ) -> i - ( b ) -> i ; }
# Skipping MacroDefinition: zd_mult ( c , a , b ) { ( c ) -> r = ( a ) -> r * ( b ) ; ( c ) -> i = ( a ) -> i * ( b ) ; }
# Skipping MacroDefinition: zz_mult ( c , a , b ) { double cr , ci ; cr = ( a ) -> r * ( b ) -> r - ( a ) -> i * ( b ) -> i ; ci = ( a ) -> i * ( b ) -> r + ( a ) -> r * ( b ) -> i ; ( c ) -> r = cr ; ( c ) -> i = ci ; }
# Skipping MacroDefinition: zz_conj ( a , b ) { ( a ) -> r = ( b ) -> r ; ( a ) -> i = - ( ( b ) -> i ) ; }
# Skipping MacroDefinition: z_eq ( a , b ) ( ( a ) -> r == ( b ) -> r && ( a ) -> i == ( b ) -> i )

struct doublecomplex
    r::Cdouble
    i::Cdouble
end

# Skipping MacroDefinition: c_add ( c , a , b ) { ( c ) -> r = ( a ) -> r + ( b ) -> r ; ( c ) -> i = ( a ) -> i + ( b ) -> i ; }
# Skipping MacroDefinition: c_sub ( c , a , b ) { ( c ) -> r = ( a ) -> r - ( b ) -> r ; ( c ) -> i = ( a ) -> i - ( b ) -> i ; }
# Skipping MacroDefinition: cs_mult ( c , a , b ) { ( c ) -> r = ( a ) -> r * ( b ) ; ( c ) -> i = ( a ) -> i * ( b ) ; }
# Skipping MacroDefinition: cc_mult ( c , a , b ) { float cr , ci ; cr = ( a ) -> r * ( b ) -> r - ( a ) -> i * ( b ) -> i ; ci = ( a ) -> i * ( b ) -> r + ( a ) -> r * ( b ) -> i ; ( c ) -> r = cr ; ( c ) -> i = ci ; }
# Skipping MacroDefinition: cc_conj ( a , b ) { ( a ) -> r = ( b ) -> r ; ( a ) -> i = - ( ( b ) -> i ) ; }
# Skipping MacroDefinition: c_eq ( a , b ) ( ( a ) -> r == ( b ) -> r && ( a ) -> i == ( b ) -> i )

struct complex
    r::Cfloat
    i::Cfloat
end

const SUPERLU_MAJOR_VERSION = 5
const SUPERLU_MINOR_VERSION = 2
const SUPERLU_PATCH_VERSION = 2

# Skipping MacroDefinition: FIRSTCOL_OF_SNODE ( i ) ( xsup [ i ] )

const NO_MARKER = 3

# Skipping MacroDefinition: NUM_TEMPV ( m , w , t , b ) ( SUPERLU_MAX ( m , ( t + b ) * w ) )
# Skipping MacroDefinition: USER_ABORT ( msg ) superlu_abort_and_exit ( msg )
# Skipping MacroDefinition: ABORT ( err_msg ) { char msg [ 256 ] ; sprintf ( msg , "%s at line %d in file %s\n" , err_msg , __LINE__ , __FILE__ ) ; USER_ABORT ( msg ) ; }
# Skipping MacroDefinition: USER_MALLOC ( size ) superlu_malloc ( size )
# Skipping MacroDefinition: SUPERLU_MALLOC ( size ) USER_MALLOC ( size )
# Skipping MacroDefinition: USER_FREE ( addr ) superlu_free ( addr )
# Skipping MacroDefinition: SUPERLU_FREE ( addr ) USER_FREE ( addr )
# Skipping MacroDefinition: CHECK_MALLOC ( where ) { extern int_t superlu_malloc_total ; printf ( "%s: malloc_total %d Bytes\n" , where , superlu_malloc_total ) ; \
#}
# Skipping MacroDefinition: SUPERLU_MAX ( x , y ) ( ( x ) > ( y ) ? ( x ) : ( y ) )
# Skipping MacroDefinition: SUPERLU_MIN ( x , y ) ( ( x ) < ( y ) ? ( x ) : ( y ) )
# Skipping MacroDefinition: L_SUB_START ( col ) ( Lstore -> rowind_colptr [ col ] )
# Skipping MacroDefinition: L_SUB ( ptr ) ( Lstore -> rowind [ ptr ] )
# Skipping MacroDefinition: L_NZ_START ( col ) ( Lstore -> nzval_colptr [ col ] )
# Skipping MacroDefinition: L_FST_SUPC ( superno ) ( Lstore -> sup_to_col [ superno ] )
# Skipping MacroDefinition: U_NZ_START ( col ) ( Ustore -> colptr [ col ] )
# Skipping MacroDefinition: U_SUB ( ptr ) ( Ustore -> rowind [ ptr ] )

const EMPTY = -1
const FALSE = 0
const TRUE = 1

@cenum MemType::UInt32 begin
    USUB = 0
    LSUB = 1
    UCOL = 2
    LUSUP = 3
    LLVL = 4
    ULVL = 5
    NO_MEMTYPE = 6
end


# Skipping MacroDefinition: GluIntArray ( n ) ( 5 * ( n ) + 5 )

const NODROP = 0x0000
const DROP_BASIC = 0x0001
const DROP_PROWS = 0x0002
const DROP_COLUMN = 0x0004
const DROP_AREA = 0x0008
const DROP_SECONDARY = 0x000e
const DROP_DYNAMIC = 0x0010
const DROP_INTERP = 0x0100
const MILU_ALPHA = 0.01
const flops_t = Cfloat
const Logical = Cuchar

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

struct mem_usage_t
    for_lu::Cfloat
    total_needed::Cfloat
end

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

@cenum DiagScale_t::UInt32 begin
    NOEQUIL = 0
    ROW = 1
    COL = 2
    BOTH = 3
end

@cenum stack_end_t::UInt32 begin
    HEAD = 0
    TAIL = 1
end

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


struct SuperMatrix
    Stype::Stype_t
    Dtype::Dtype_t
    Mtype::Mtype_t
    nrow::SuperLUInt
    ncol::SuperLUInt
    Store::Ptr{Cvoid}
end

struct NCformat
    nnz::SuperLUInt
    nzval::Ptr{Cvoid}
    rowind::Ptr{SuperLUInt}
    colptr::Ptr{SuperLUInt}
end

struct NRformat
    nnz::SuperLUInt
    nzval::Ptr{Cvoid}
    colind::Ptr{SuperLUInt}
    rowptr::Ptr{SuperLUInt}
end

struct SCformat
    nnz::SuperLUInt
    nsuper::SuperLUInt
    nzval::Ptr{Cvoid}
    nzval_colptr::Ptr{SuperLUInt}
    rowind::Ptr{SuperLUInt}
    rowind_colptr::Ptr{SuperLUInt}
    col_to_sup::Ptr{SuperLUInt}
    sup_to_col::Ptr{SuperLUInt}
end

struct SCPformat
    nnz::SuperLUInt
    nsuper::SuperLUInt
    nzval::Ptr{Cvoid}
    nzval_colbeg::Ptr{SuperLUInt}
    nzval_colend::Ptr{SuperLUInt}
    rowind::Ptr{SuperLUInt}
    rowind_colbeg::Ptr{SuperLUInt}
    rowind_colend::Ptr{SuperLUInt}
    col_to_sup::Ptr{SuperLUInt}
    sup_to_colbeg::Ptr{SuperLUInt}
    sup_to_colend::Ptr{SuperLUInt}
end

struct NCPformat
    nnz::SuperLUInt
    nzval::Ptr{Cvoid}
    rowind::Ptr{SuperLUInt}
    colbeg::Ptr{SuperLUInt}
    colend::Ptr{SuperLUInt}
end

struct DNformat
    lda::SuperLUInt
    nzval::Ptr{Cvoid}
end

struct NRformat_loc
    nnz_loc::SuperLUInt
    m_loc::SuperLUInt
    fst_row::SuperLUInt
    nzval::Ptr{Cvoid}
    rowptr::Ptr{SuperLUInt}
    colind::Ptr{SuperLUInt}
end
