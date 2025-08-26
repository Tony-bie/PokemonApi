//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Alumno on 25/08/25.
//

import Foundation
import SwiftUI

@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    @Published var pokemonDetails: [String: PokemonDetail] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadPokemonList(limit: Int = 151) async throws {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)") else {
            errorMessage = "Error al crear URL"
            isLoading = false
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            errorMessage = "Error en la respuesta del servidor"
            isLoading = false
            return
        }
        
        let results = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        
        self.pokemonList = results.results
        self.isLoading = false
    }
    
    func loadPokemonDetail(pokemon: Pokemon) async throws {
        if pokemonDetails[pokemon.name] != nil {
            return
        }
        
        guard let url = URL(string: pokemon.url) else {
            errorMessage = "Error al crear URL para detalles"
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            errorMessage = "Error en la respuesta del servidor para detalles"
            return
        }
        
        let pokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: data)
        pokemonDetails[pokemon.name] = pokemonDetail
    }
    
    func getPokemonDetail(for pokemon: Pokemon) -> PokemonDetail? {
        return pokemonDetails[pokemon.name]
    }
}

