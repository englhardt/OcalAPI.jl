
function start_webserver()
    HTTP.listen() do request::HTTP.Request
        try
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