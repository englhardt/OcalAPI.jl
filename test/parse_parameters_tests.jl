import OcalAPI: check_keys, check_and_parse_values!, check_value_sizes,
                parse_parameters!

@testset "parse parameters" begin
    @testset "missing keys" begin
        p = deepcopy(RAW_PARAMETERS)
        delete!(p, "data")
        delete!(p["params"], "C")
        @test_throws ArgumentError check_keys(p)
    end

    @testset "check and parse" begin

        @testset "data" begin
            p = deepcopy(RAW_PARAMETERS)
            p["data"] = trues(2, 5)
            @test_throws ArgumentError check_and_parse_values!(p)
            p = deepcopy(RAW_PARAMETERS)
            p["data"] = [[2, 5], [5, 2, 10]]
            @test_throws ArgumentError check_and_parse_values!(p)
        end

        @testset "labels" begin
            p = deepcopy(RAW_PARAMETERS)
            p["labels"] = nothing
            @test_throws ArgumentError check_and_parse_values!(p)
        end

        @testset "params" begin
            p = deepcopy(RAW_PARAMETERS)
            p["params"] = nothing
            @test_throws ArgumentError check_and_parse_values!(p)
        end

        @testset "query_history" begin
            p = deepcopy(RAW_PARAMETERS)
            p["query_history"] = [["test"]]
            @test_throws ArgumentError check_and_parse_values!(p)
            p = deepcopy(RAW_PARAMETERS)
            p["query_history"] = [1, 2]
            @test_throws ArgumentError check_and_parse_values!(p)
        end

        @testset "subspaces" begin
            p = deepcopy(RAW_PARAMETERS)
            p["subspaces"] = [["test"]]
            @test_throws ArgumentError check_and_parse_values!(p)
            p = deepcopy(RAW_PARAMETERS)
            p["subspaces"] = [1, 2]
            @test_throws ArgumentError check_and_parse_values!(p)
        end

        @testset "subspace_grids" begin
            p = deepcopy(RAW_PARAMETERS)
            p["subspace_grids"] = []
            @test check_and_parse_values!(p) == nothing
            p = deepcopy(RAW_PARAMETERS)
            p["subspace_grids"] = p["subspace_grids"][1]
            @test_throws ArgumentError check_and_parse_values!(p)
        end
    end

    @testset "check value sizes" begin
        p = deepcopy(TEST_PARAMETERS)
        p["subspace_grids"] = []
        @test_throws ArgumentError check_value_sizes(p)
        p = deepcopy(TEST_PARAMETERS)
        p["labels"] = []
        @test_throws ArgumentError check_value_sizes(p)
    end

    @testset "encode decode" begin
        binary_parameters = transcode(GzipCompressor, JSON.json(TEST_PARAMETERS))
        r = JSON.parse(String(transcode(GzipDecompressor, binary_parameters)))
        @test parse_parameters!(r) == nothing
        @test all(collect(values(r)) .== collect(values(TEST_PARAMETERS)))
    end
end
