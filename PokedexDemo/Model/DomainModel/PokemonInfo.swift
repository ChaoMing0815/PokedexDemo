//
//  PokemonInfo.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/25.
//

import Foundation

struct PokemonInfo {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let stats: [PokemonStat]
    let types: [String]
    var imageData: Data?
    var shinyImageData: Data?
    
    init(from dto: PokemonInfoDTO) {
        id = dto.id
        name = dto.name
        height = dto.height
        weight = dto.weight
        stats = dto.stats.map { PokemonStat(baseStat: $0.baseStat, name: $0.stat.name)  }
        types = dto.types.map { $0.type.name }
    }
}

struct PokemonStat {
    let baseStat: Int
    let name: String
}
