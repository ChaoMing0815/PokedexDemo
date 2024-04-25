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
}
