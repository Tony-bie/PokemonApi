//
//  Pokemon.swift
//  Pokemon
//
//  Created by Alumno on 25/08/25.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
    let name: String
    let url: String
    
    var id: String { name }
    
    var pokemonId: Int {
        let components = url.components(separatedBy: "/")
        return Int(components[components.count - 2]) ?? 0
    }
}

struct PokemonDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [TypeElement]
    let stats: [Stat]
    let abilities: [Ability]
    let species: Species
}

struct Sprites: Codable {
    let front_default: String?
    let front_shiny: String?
    let other: Other?
}

struct Other: Codable {
    let official_artwork: OfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
        case official_artwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let front_default: String?
}

struct TypeElement: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
    let url: String
}

struct Stat: Codable {
    let base_stat: Int
    let effort: Int
    let stat: StatInfo
}

struct StatInfo: Codable {
    let name: String
    let url: String
}

struct Ability: Codable {
    let ability: AbilityInfo
    let is_hidden: Bool
    let slot: Int
}

struct AbilityInfo: Codable {
    let name: String
    let url: String
}

struct Species: Codable {
    let name: String
    let url: String
}
