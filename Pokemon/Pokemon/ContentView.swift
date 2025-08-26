//
//  ContentView.swift
//  Pokemon
//
//  Created by Alumno on 25/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var pokemonVM = PokemonViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if pokemonVM.isLoading {
                    ProgressView("Cargando Pokemon...")
                        .padding()
                } else if let errorMessage = pokemonVM.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(pokemonVM.pokemonList) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon, pokemonVM: pokemonVM)) {
                            PokemonRowView(pokemon: pokemon)
                        }
                    }
                }
            }
            .navigationTitle("Pokedex 1era gen")
            .task {
                if pokemonVM.pokemonList.isEmpty {
                    do {
                        try await pokemonVM.loadPokemonList()
                    } catch {
                        pokemonVM.errorMessage = "Error al cargar Pokemon: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
