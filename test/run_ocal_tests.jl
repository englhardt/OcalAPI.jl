
@testset "run ocal" begin
    r = run_ocal(deepcopy(TEST_PARAMETERS))
    @test length(r[:prediction_global]) == size(TEST_PARAMETERS["data"], 2)
    @test length(r[:prediction_subspaces]) == length(TEST_PARAMETERS["subspaces"])
    @test all(length.(r[:prediction_subspaces]) .== size(TEST_PARAMETERS["data"], 2))
    @test all(length.(r[:score_subspace_grids]) .== size.(TEST_PARAMETERS["subspace_grids"], 2))
    @test length(r[:query_ids]) == 1
    @test length(r[:ranking_subspaces]) == length(TEST_PARAMETERS["subspaces"])
end
