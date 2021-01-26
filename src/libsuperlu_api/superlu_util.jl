const superlu_options_fields = Dict(
    fieldname(superlu_options_t,i)=>(fieldoffset(superlu_options_t,i), fieldtype(superlu_options_t,i))
    for i = 1:fieldcount(superlu_options_t)
)

function set_options(options::superlu_options_t, field::Symbol, value)
    options_ref = Ref(options)
    options_ptr = Base.unsafe_convert(Ptr{superlu_options_t}, options_ref)
    offset, type = superlu_options_fields[field]
    GC.@preserve options_ref begin
        Base.unsafe_store!(Ptr{type}(options_ptr + offset), value)
        return options_ref[]
    end
end
