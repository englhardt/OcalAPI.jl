using CodecZlib
using HTTP
using JSON
using LinearAlgebra
using OcalAPI
using Random
using Test

SERVER_URI = "http://$(SERVER_HOST):$(SERVER_PORT)"

Random.seed!(0)

@testset "OcalAPI" begin
    include("test_utils.jl")
    include("parse_parameters_tests.jl")
    include("run_ocal_tests.jl")
    include("webserver_tests.jl")
end
