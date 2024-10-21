//
//  AllPokemonListDTO.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

struct PokemonListDTO: Codable {
    struct Result: Codable {
        let name: String
        let url: String

        enum CodingKeys: String, CodingKey {
            case name
            case url
        }
    }
    
    let count: Int
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
}
