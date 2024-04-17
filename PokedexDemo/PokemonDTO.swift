//
//  PokemonDTO.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

struct PokemonDTO: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    struct Sprites: Codable {
        let other: Other
        struct Other: Codable {
            let home: Home
            enum CodingKeys: String, CodingKey {
                case home
            }
            struct Home: Codable {
                let frontShiny: String?

                enum CodingKeys: String, CodingKey {
                    case frontShiny = "front_shiny"
                }
            }
        }
    }
}
