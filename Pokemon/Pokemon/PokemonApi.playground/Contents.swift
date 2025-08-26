import UIKit

var arrPokemon = [Pokemon]()

struct PokemonListResponse: Decodable {
    let results: [Pokemon]
}

struct Pokemon : Identifiable, Decodable {
    var id = UUID()
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

struct PokemonDetail: Decodable, Identifiable {
    var id = UUID()
    let weight: Int
    let stats: [Stat]
    let types: [TypeElement]
    let abilities: [Ability]
    let sprites: Sprites
    
    enum CodingKeys: String, CodingKey {
        case weight, stats, types, abilities, sprites
    }
}

struct Stat: Decodable {
    let base_stat: Int
    let stat: NamedAPIResource
}

struct TypeElement: Decodable {
    let type: NamedAPIResource
}

struct Ability: Decodable {
    let ability: NamedAPIResource
}

struct Sprites: Decodable {
    let front_default: String?
}

struct NamedAPIResource: Decodable {
    let name: String
    let url: String
}


func loadPokemonDetail(url: String) async throws -> PokemonDetail {
    let url = URL(string: url)!
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoded = try JSONDecoder().decode(PokemonDetail.self, from: data)
    return decoded
}

func loadPokemonList() async throws -> [Pokemon] {
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=3")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
    return decoded.results
}

Task {
    do {
        arrPokemon = try await loadPokemonList()
        for poke in arrPokemon {
            let detail = try await loadPokemonDetail(url: poke.url)
            print("Nombre: \(poke.name)")
            print("Peso: \(detail.weight)")
            print("Tipos: \(detail.types.map { $0.type.name })")
            print("Habilidades: \(detail.abilities.map { $0.ability.name })")
            print("Sprite: \(detail.sprites.front_default ?? "No sprite")")
            print("--------")
        }
    } catch {
        print("Error: \(error)")
    }
}




