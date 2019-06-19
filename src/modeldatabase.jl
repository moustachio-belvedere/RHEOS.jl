#!/usr/bin/env julia

models_directory = joinpath(@__DIR__, "models")

# spring-pot, spring and dash-pot
include(joinpath(models_directory, "elements.jl"))

# fractional Maxwell model and specialized forms
include(joinpath(models_directory, "maxwell.jl"))

# fractional Kelvin-Voigt model and specialized forms
include(joinpath(models_directory, "kelvinvoigt.jl"))

# fractional Zener model and specialized forms (equivalent to Standard Linear Solid in Maxwell form)
include(joinpath(models_directory, "zener.jl"))

# fractional Special model
include(joinpath(models_directory, "special.jl"))

# poynting-thomson model and specialized forms (equivalent to Standard Linear Solid in Kelvin form)
include(joinpath(models_directory, "poynting-thomson.jl"))

# Standard Linear Solid model 2 time-scales 
include(joinpath(models_directory, "sls2.jl"))

# Plateau-d Power Law
function G_platpow(t::Array{T,1}, params::Array{T,1}) where T<:Real
    Gᵩ, G₀, τ, α = params

    G = Gᵩ + (G₀ - Gᵩ)./(1 + t/τ).^(α)
end

PowerLawPlateau() = RheologyModel(G_platpow, null_modulus, null_modulus, null_modulus, [1.0, 2.0, 1.0, 0.2], ["model created with default parameters"])
PowerLawPlateau(params::Array{T, 1}) where T<:Real = RheologyModel(G_platpow, null_modulus, null_modulus, null_modulus, params, ["model created by user with parameters $params"])