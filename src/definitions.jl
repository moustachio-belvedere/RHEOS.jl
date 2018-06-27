#!/usr/bin/env julia

"""
    RheologyData(σ::Array{Float64,1}, ϵ::Array{Float64,1}, t::Array{Float64,1}, sampling::String, log::Array{String,1})

RheologyData struct used for high level interaction with RHEOS
preprocessing and fitting functions. Initialise an instance directly or
indirectly. If data is in three column, comma separated CSV file then
fileload function can be used, which calls the RheologyData outer constructor method. 
If not, load data in according to format and call RheologyData outer constructor method.
"""
struct RheologyData

    # original data
    σ::Array{Float64,1}
    ϵ::Array{Float64,1}
    t::Array{Float64,1}

    # sampling type. "constant" by default. Use of `var_resample`, `downsample`
    # with more than one section or `fixed_resample` with more than one section
    # overrides to "variable".
    sampling::String

    # operations applied, stores history of which functions (including arguments)
    log::Array{String,1}

end

"""
    RheologyData(colnames::Array{String,1}, data1::Array{Float64,1}, data2::Array{Float64,1}[, data3::Array{Float64,1}; filedir::String="none", log::Array{String,1}=Array{String}(0)])::RheologyData

Constructor function for RheologyData struct, if stress/strain arrays have NaN values at the beginning (some datasets
have 1 or 2 samples of NaN at beginning) then deletes these and starts at the first non-NaN sample, also readjusts time start to 
t = 0 to account for NaNs and and negative time values at beginning of data recording.
"""
function RheologyData(colnames::Array{String,1}, data1::Array{Float64,1}, data2::Array{Float64,1}, data3::Array{Float64,1}=zeros(length(data2)); filedir::String="none", log::Array{String,1}=Array{String}(0))::RheologyData

    # checks
    @assert length(data1)==length(data2) "Data arrays must be same length"
    @assert length(data1)==length(data3) "Data arrays must be same length"

    # get data in correct variables
    data = [data1, data2, data3]
    local σ::Array{Float64,1} = zeros(length(data1))
    local ϵ::Array{Float64,1} = zeros(length(data1))
    local t::Array{Float64,1} = zeros(length(data1))

    # occurence flags
    local stress_present::Bool = false
    local strain_present::Bool = false
    local time_present::Bool = false

    for (i, v) in enumerate(colnames)
        if v == "stress"
            σ = data[i]
        elseif v == "strain"
            ϵ = data[i]
        elseif v == "time"
            t = data[i]
        else
            @assert false "Incorrect Column Names"
        end
    end

    # define as local so it can be accessed in subsequent scopes
    local newstartingval::T where T<:Integer

    # test for NaNs
    for i in 1:length(σ)
        if !isnan(σ[i]) && !isnan(ϵ[i])
            newstartingval = i
            break
        end
    end

    # adjust starting point accordingly to remove NaNs in σ, ϵ
    σ = σ[newstartingval:end]
    ϵ = ϵ[newstartingval:end]
    t = t[newstartingval:end]

    # readjust time to account for NaN movement and/or negative time values
    t = t - minimum(t)

    # initialise empty array to record operations applied during preprocessing
    if filedir != "none" || length(log)==0
        if length(colnames)<3
            push!(log, "partial data loaded from:")
        elseif length(colnames)==3
            push!(log, "complete data loaded from:")
        end
        push!(log, filedir)
    end

    # Check if time vector is equally spaced
    diff = round.(t[2:end]-t[1:end-1], 4)
    check = any(x->x!=diff[1], diff)
    if check == true
       sampling = "variable"
    else
       sampling = "constant"
    end

    # return class with all fields initialised
    RheologyData(σ, ϵ, t, sampling, log)
    
end

"""
    fileload(colnames::Array{String,1}, filedir::String)

Load data from a CSV file (three columns, comma seperated). Columns must
be identified by providing an array of strings which tell the function
which data (stress, strain or time) is contained in each column. This is
used to construct a RheologyData struct, which provides the basis for
subsequent high level operations within RHEOS.

# Example

```jldoctest
# directory path to the file
fileDir = "../data/rheologyData1.csv"

# load the data into RheologyData struct
dataforprocessing = fileload(["time","stress","strain"], fileDir)
```
"""
function fileload(colnames::Array{String,1}, filedir::String)::RheologyData

    # check colnames length is correct
    @assert length(colnames)==3 || length(colnames)==2 "Two or three column names required, one of each: 'stress', 'strain' and 'time'."

    # init types helper
    types = [Float64 for i = 1:length(colnames)]

    # read data from file
    (datacsv, head_out) = uCSV.read(filedir; delim=',', types=types)

    # init data var
    local data::RheologyData

    # generate RheologyData struct and output
    if length(colnames)==3
        data = RheologyData(colnames, datacsv[1], datacsv[2], datacsv[3]; filedir = filedir)
    elseif length(colnames)==2
        data = RheologyData(colnames, datacsv[1], datacsv[2]; filedir = filedir)
    end
end

"""
    RheologyModel(name::Function, parameters::Array{Float64,1}[, log::Array{String,1}])

Struct which contains the results of a model fit: model name, parameters, and inherited log with final cost, 
reason for termination of fitting procedure and time taken to fit appended to it.
"""
struct RheologyModel

    modulus::Function

    parameters::Array{Float64,1}

    log::Array{String,1}

end

function RheologyModel(name::Function, parameters::Array{Float64,1})

    namestring = string(name)

    RheologyModel(name, parameters, ["$namestring model with parameters $parameters generated by user"])

end