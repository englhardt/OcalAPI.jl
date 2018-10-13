
function check_content_type(request::HTTP.Request)
    content_type = HTTP.header(request, "Content-Type")
    if content_type != "application/json"
        throw(ArgumentError("Invalid Content-Type '$(content_type)'"))
    end
    return nothing
end

function parse_content_body(request::HTTP.Request)
    content_encoding = HTTP.header(request, "Content-Encoding")
    request_body = nothing
    if content_encoding == "gzip"
        try
            request_body = String(transcode(GzipDecompressor, request.body))
        catch e
            throw(ArgumentError("Cannot decompress with gzip."))
        end
    elseif content_encoding == ""
        request_body = String(request.body)
    else
        throw(ArgumentError("Invalid Content-Encoding '$(content_encoding)'"))
    end
    try
        return JSON.parse(request_body)
    catch e
        throw(ArgumentError("Cannot parse JSON."))
    end
    return nothing
end

function build_response(status, params)
    return HTTP.Response(status,
                         ["Content-Type" => "application/json", "Content-Encoding" => "gzip"];
                         body=transcode(GzipCompressor, JSON.json(Dict(:status => status, params...))))
end
