//
//  AllPokemonList.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

struct AllPokemonList {
    let pokemonNames: [String]
    
    init(from dto: AllPokemonListDTO) {
        self.pokemonNames = dto.results.map { $0.name }
    }
}
