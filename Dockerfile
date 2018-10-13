FROM julia:0.6.4

RUN apt update && apt install -y wget build-essential gfortran hdf5-tools
RUN julia -e 'Pkg.update()'

RUN julia -e 'Pkg.clone("https://github.com/englhardt/SVDD.jl.git")'
RUN julia -e 'Pkg.clone("https://github.com/englhardt/OneClassActiveLearning.jl.git"); Pkg.build("OneClassActiveLearning")'

WORKDIR /app/OcalAPI.jl

COPY . /app/OcalAPI.jl

RUN julia -e 'Pkg.clone(pwd())'
# trigger precompilation
RUN julia -e 'using OcalAPI'

EXPOSE 8081

CMD julia -e 'using OcalAPI; start_webserver()'
