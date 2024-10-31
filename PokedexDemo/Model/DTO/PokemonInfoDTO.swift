//
//  PokemonInfoDTO.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

struct PokemonInfoDTO: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let stats: [PokemonStatInfo]
    let types: [PokemonTypeSlot]
}

// MARK: - PokemonType
struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonType
}

// MARK: - PokemonStat
struct Stat: Codable {
    let name: String
    let url: String
}

struct PokemonStatInfo: Codable {
    let baseStat: Int
    let effort: Int
    let stat: Stat
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}
