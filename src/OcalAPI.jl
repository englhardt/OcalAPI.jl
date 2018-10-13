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

include("http_utils.jl")
include("parse_parameters.jl")
include("run_ocal.jl")
include("webserver.jl")

export
    run_ocal, start_webserver

end
