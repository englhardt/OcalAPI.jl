
MAIN_KEYS = ["query_history", "subspace_grids", "subspaces", "data", "labels", "params"]
PARAM_KEYS = ["C", "gamma", "classifier", "query_strategy"]

function check_keys(r)
    missing_keys = []
    for k ∈ MAIN_KEYS
        if k ∉ keys(r)
            push!(missing_keys, k)
        end
    end
    if "params" ∈ keys(r)
        for k ∈ PARAM_KEYS
            if k ∉ keys(r["params"])
                push!(missing_keys, k)
            end
        end
    end
    if !isempty(missing_keys)
        throw(ArgumentError("Missing keys in request: $(missing_keys)."))
    end
    return nothing
end


function convert_value!(r, name, target_type, func=identity)
    try
        r[name] = func(convert(target_type, r[name]))
    catch e
        throw(ArgumentError("Failed parsing '$(name)': $(r[name])."))
    end
end

function check_and_parse_values!(r)
    convert_value!(r, "data", Vector{Vector{Float64}}, x -> hcat(x...))
    convert_value!(r, "labels", Vector{Symbol})
    convert_value!(r, "params", Dict{String, Any})
    convert_value!(r, "query_history", Vector{Vector{Int}})
    convert_value!(r, "subspaces", Vector{Vector{Int}})
    convert_value!(r, "subspace_grids", Vector{Vector{Vector{Float64}}}, x -> [hcat(s...) for s in x])
    return nothing
end

function check_value_sizes(r)
    size(r["data"], 2) == length(r["labels"]) || throw(ArgumentError("Data size does not match number of labels."))
    length(r["subspaces"]) == length(r["subspace_grids"]) || throw(ArgumentError("Number of subspaces does not match requested number of grids."))
    return nothing
end

function parse_parameters!(r)
    check_keys(r)
    check_and_parse_values!(r)
    check_value_sizes(r)
    return nothing
end
