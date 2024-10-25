//
//  Generation.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/10/24.
//

import Foundation

struct GenerationRange {
    let startID: Int
    let endID: Int
}

enum Generation: Int {
    case all = 0
    case generationI
    case generationII
    case generationIII
    case generationIV
    case generationV
    case generationVI
    case generationVII
    case generationVIII
    case generationIX
    
    var range: GenerationRange {
        switch self {
        case .all:
            return GenerationRange(startID: 1, endID: 1025) // 顯示所有寶可夢，1到1010
        case .generationI:
            return GenerationRange(startID: 1, endID: 151)   // 第一世代
        case .generationII:
            return GenerationRange(startID: 152, endID: 251) // 第二世代
        case .generationIII:
            return GenerationRange(startID: 252, endID: 386) // 第三世代
        case .generationIV:
            return GenerationRange(startID: 387, endID: 494) // 第四世代
        case .generationV:
            return GenerationRange(startID: 495, endID: 649) // 第五世代
        case .generationVI:
            return GenerationRange(startID: 650, endID: 721) // 第六世代
        case .generationVII:
            return GenerationRange(startID: 722, endID: 809) // 第七世代
        case .generationVIII:
            return GenerationRange(startID: 810, endID: 905) // 第八世代
        case .generationIX:
            return GenerationRange(startID: 906, endID: 1025) // 第九世代
        }
    }
}
