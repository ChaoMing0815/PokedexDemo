//
//  PokemonInfoDTO.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonTypeSlot: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonInfoDTO: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeSlot]
}
