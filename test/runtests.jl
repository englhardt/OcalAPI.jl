using OcalAPI
using CodecZlib
using Base.Test

SERVER_URI = "http://$(SERVER_HOST):$(SERVER_PORT)"

srand(0)

@testset "OcalAPI" begin
    include("test_utils.jl")
    include("parse_parameters_tests.jl")
    include("run_ocal_tests.jl")
    include("webserver_tests.jl")
end
