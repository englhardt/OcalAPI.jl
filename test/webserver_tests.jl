
@testset "webserver" begin
    @async start_webserver()
    sleep(2)

    valid_params = JSON.json(TEST_PARAMETERS)

    @testset "valid plain input" begin
        response = HTTP.request("POST", SERVER_URI, ["Content-Type" => "application/json"],
                                valid_params)
        @test response.status == 200
    end

    @testset "invalid json plain input" begin
        try
            HTTP.request("POST", SERVER_URI, ["Content-Type" => "application/json"],
                                valid_params * "foo;baa")
        catch e
            @test e isa HTTP.ExceptionRequest.StatusError
            @test e.status == 400
        end
    end

    @testset "invalid content-type" begin
        try
            HTTP.request("POST", SERVER_URI, ["Content-Type" => "text/plain"],
                                valid_params)
        catch e
            @test e isa HTTP.ExceptionRequest.StatusError
            @test e.status == 400
        end
    end

    @testset "valid gzip input" begin
        response = HTTP.request("POST", SERVER_URI, ["Content-Type" => "application/json", "Content-Encoding" => "gzip"],
                                transcode(GzipCompressor, valid_params))
        @test response.status == 200
    end

    @testset "invalid content-encoding" begin
        try
            HTTP.request("POST", SERVER_URI, ["Content-Type" => "application/json", "Content-Encoding" => "compress"],
                                transcode(GzipCompressor, valid_params))
        catch e
            @test e isa HTTP.ExceptionRequest.StatusError
            @test e.status == 400
        end
    end
end
