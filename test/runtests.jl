using OcalAPI
using CodecZlib
using Base.Test

SERVER_URI = "http://127.0.0.1:8081"

srand(0)

@testset "OcalAPI" begin
    include("test_utils.jl")
    include("parse_parameters_tests.jl")
    include("run_ocal_tests.jl")
    include("webserver_tests.jl")
end
