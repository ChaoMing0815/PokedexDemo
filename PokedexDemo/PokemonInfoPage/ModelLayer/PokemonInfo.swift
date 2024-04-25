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
    var imageData: Data?
    
    init(from dto: PokemonInfoDTO) {
        id = dto.id
        name = dto.name
        height = dto.height
        weight = dto.weight
    }
}
