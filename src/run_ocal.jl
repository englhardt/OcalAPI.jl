
function train_model(data, pools, model_type, model_C, model_gamma)
    model = instantiate(eval(Symbol(model_type)), data, pools, Dict{Symbol, Any}())
    initialize!(model, FixedParameterInitialization(MLKernels.GaussianKernel(model_gamma), model_C))
    set_adjust_K!(model, true)
    status = fit!(model, DEFAULT_SOLVER)
    if status != :Optimal
        throw(ArgumentError("Cannot fit model due to solver error: '$(status)')."))
    end
    return model
end

predict_data(model, data) = SVDD.classify.(SVDD.predict(model, data))
score_data(model, data) = SVDD.predict(model, data)

function run_query_strategy(data, pools, model, qs_type, query_history)
    qs = initialize_qs(eval(Symbol(qs_type)), model, data, Dict{Symbol, Any}())
    pool_map = labelmap(pools)
    haskey(pool_map, :U) || throw(ArgumentError("No more points that are unlabeled."))
    scores = qs_score(qs, data, pool_map)
    @assert length(scores) == size(data, 2)
    candidates = [i for i in pool_map[:U] if i ∉ query_history]
    return [indmax(scores[candidates])]
end

function run_ocal(r)
    data, pools, params = r["data"], r["labels"], r["params"]

    # train global model
    model_global = train_model(data, pools, params["classifier"], params["C"], params["gamma"])
    prediction_global = predict_data(model_global, data)

    # execute query strategy
    query_ids = run_query_strategy(data, pools, model_global, params["query_strategy"], vcat(r["query_history"]...))

    # train subspace models
    prediction_subspaces = []
    score_subspace_grids = []
    for (k, s) in enumerate(r["subspaces"])
        model_subspace = train_model(data[s, :], pools, params["classifier"], params["C"], params["gamma"])
        push!(prediction_subspaces, predict_data(model_subspace, data[s, :]))
        push!(score_subspace_grids, score_data(model_subspace, r["subspace_grids"][k]))
    end

    # rank subspaces
    ranking_subspaces = collect(1:length(r["subspaces"]))

    return Dict(
        :prediction_global => prediction_global,
        :prediction_subspaces => prediction_subspaces,
        :score_subspace_grids => score_subspace_grids,
        :query_ids => query_ids,
        :ranking_subspaces => ranking_subspaces)
end
