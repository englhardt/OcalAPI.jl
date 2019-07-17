FROM julia:1.1.1

RUN apt update && apt install -y wget build-essential gfortran hdf5-tools

WORKDIR /app/OcalAPI.jl

COPY . /app/OcalAPI.jl

RUN julia --project -e 'using Pkg; Pkg.instantiate()'
# trigger precompilation
RUN julia --project -e 'using OcalAPI'

EXPOSE 8081

CMD julia --project -e 'using OcalAPI; start_webserver()'
