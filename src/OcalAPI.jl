module OcalAPI

using HTTP
using JSON
using CodecZlib
using Ipopt
using SVDD
using OneClassActiveLearning
using MLLabelUtils
using MLKernels

DEFAULT_SOLVER = IpoptSolver(print_level=0)
SERVER_HOST = "OCAL_API_HOST" in keys(ENV) ? ENV["OCAL_API_HOST"] : ip"0.0.0.0"
SERVER_PORT = "OCAL_API_PORT" in keys(ENV) ? parse(Int, ENV["OCAL_API_PORT"]) : 8081

include("http_utils.jl")
include("parse_parameters.jl")
include("run_ocal.jl")
include("webserver.jl")

export
    SERVER_HOST, SERVER_PORT,
    run_ocal, start_webserver

end
