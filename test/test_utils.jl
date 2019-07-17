TEST_PARAMETERS = Dict(
    "data" => rand(2, 50),
    "labels" => fill(:U, 50),
    "params" => Dict(
        "C" => 0.1,
        "gamma" => 4,
        "classifier" => "SVDDneg",
        "query_strategy" => "RandomPQs"),
    "query_history" => [],
    "subspaces" => [[1, 2]],
    "subspace_grids" => [hcat([[x,y] for x in 1:10 for y in 1:10]...)])

RAW_PARAMETERS = JSON.parse(JSON.json(TEST_PARAMETERS))
