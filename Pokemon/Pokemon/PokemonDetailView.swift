//
//  PokemonDetailView.swift
//  Pokemon
//
//  Created by Alumno on 25/08/25.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    @ObservedObject var pokemonVM: PokemonViewModel
    @State private var isLoading = false
    
    var pokemonDetail: PokemonDetail? {
        pokemonVM.getPokemonDetail(for: pokemon)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Cargando detalles...")
                        .padding()
                } else if let detail = pokemonDetail {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            AsyncImage(url: URL(string: detail.sprites.other?.official_artwork?.front_default ?? detail.sprites.front_default ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 200, height: 200)
                            
                            VStack(spacing: 8) {
                                Text(detail.name.capitalized)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                Text("#\(detail.id)")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 8) {
                                    ForEach(detail.types, id: \.slot) { typeElement in
                                        Text(typeElement.type.name.capitalized)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(typeColor(for: typeElement.type.name))
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Informacion Fisica")
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            HStack {
                                InfoCard(title: "Altura", value: String(format: "%.1f m", Double(detail.height) / 10))
                                Spacer()
                                InfoCard(title: "Peso", value: String(format: "%.1f kg", Double(detail.weight) / 10))
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Estadisticas Base")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(detail.stats, id: \.stat.name) { stat in
                                StatBarView(statName: stat.stat.name, value: stat.base_stat)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Habilidades")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(detail.abilities, id: \.slot) { ability in
                                    VStack {
                                        Text(ability.ability.name.capitalized)
                                            .font(.caption)
                                            .padding(8)
                                            .frame(maxWidth: .infinity)
                                            .background(ability.is_hidden ? Color.purple.opacity(0.2) : Color.blue.opacity(0.2))
                                            .cornerRadius(8)
                                        
                                        if ability.is_hidden {
                                            Text("(Oculta)")
                                                .font(.caption2)
                                                .foregroundColor(.purple)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                } else {
                    Text("No se pudieron cargar los detalles")
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if pokemonDetail == nil {
                isLoading = true
                do {
                    try await pokemonVM.loadPokemonDetail(pokemon: pokemon)
                } catch {
                    pokemonVM.errorMessage = "Error al cargar detalles: \(error.localizedDescription)"
                }
                isLoading = false
            }
        }
    }
    
    private func typeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "fire": return .red
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "psychic": return .purple
        case "ice": return .cyan
        case "dragon": return .indigo
        case "dark": return .black
        case "fairy": return .pink
        case "fighting": return .red.opacity(0.8)
        case "poison": return .purple.opacity(0.7)
        case "ground": return .brown
        case "flying": return .blue.opacity(0.7)
        case "bug": return .green.opacity(0.7)
        case "rock": return .gray
        case "ghost": return .purple.opacity(0.5)
        case "steel": return .gray.opacity(0.7)
        case "normal": return .gray.opacity(0.5)
        default: return .gray
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatBarView: View {
    let statName: String
    let value: Int
    
    var displayName: String {
        switch statName {
        case "hp": return "HP"
        case "attack": return "Ataque"
        case "defense": return "Defensa"
        case "special-attack": return "At. Especial"
        case "special-defense": return "Def. Especial"
        case "speed": return "Velocidad"
        default: return statName.capitalized
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(displayName)
                    .font(.caption)
                    .frame(width: 100, alignment: .leading)
                
                Text("\(value)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(width: 40, alignment: .trailing)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                    
                    Rectangle()
                        .fill(statColor(for: value))
                        .frame(width: CGFloat(value) / 255.0 * 200, height: 6)
                }
                .cornerRadius(3)
                .frame(width: 200)
            }
        }
        .padding(.horizontal)
    }
    
    private func statColor(for value: Int) -> Color {
        switch value {
        case 0...49: return .red
        case 50...79: return .orange
        case 80...109: return .yellow
        case 110...139: return .green
        default: return .blue
        }
    }
}

#Preview {
    NavigationView {
        PokemonDetailView(
            pokemon: Pokemon(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
            pokemonVM: PokemonViewModel()
        )
    }
}
