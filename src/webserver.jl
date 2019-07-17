
function start_webserver(host=SERVER_HOST, port=SERVER_PORT)
    @info "Listening on $SERVER_HOST:$SERVER_PORT"
    HTTP.serve(host, port) do request::HTTP.Request
        try
            @debug "Processing request."
            response = handle_http_request_method(request)
            if response != nothing
                return response
            end
            # check and parse raw http request
            check_content_type(request)
            r = parse_content_body(request)
            # parse input parameters (with validation)
            parse_parameters!(r)
            # calculate response
            response = run_ocal(r)
            return build_response(200, response)
        catch e
            if isa(e, ArgumentError)
                return build_response(400, Dict(:error => e.msg))
            else
                return build_response(500, Dict(:error => "Unknown error $e."))
            end
        end
    end
end
