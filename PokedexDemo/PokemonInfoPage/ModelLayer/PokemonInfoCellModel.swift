//
//  PokemonInfoCellModel.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/10/9.
//

import Foundation

struct PokemonInfoCellModel {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [String]
    var imageData: Data?
}
