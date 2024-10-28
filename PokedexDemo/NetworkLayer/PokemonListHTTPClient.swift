//
//  AllPokemonListHTTPClient.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

class PokemonListHTTPClient: HTTPClient {
    fileprivate var offset: Int
    fileprivate let limit: Int
    fileprivate let startID: Int
    fileprivate let endID: Int
    fileprivate var adjustedLimit: Int
    
    init(limit: Int = 30, startID: Int, endID: Int) {
        self.limit = limit
        self.startID = startID
        self.endID = endID
        self.offset = startID - 1
        self.adjustedLimit = limit
        super.init()
    }
    
    func requestPokemonList(completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void) {
        request(with: pokemonListRequestType, completion: completion)
    }
    
    func updateOffset() {
        // 設置尚未載入的剩餘寶可夢數量，以判定接近最後一隻寶可夢時，QueryItem的limit限制
        let remainUnloadCount = endID - offset
        self.adjustedLimit = min(limit, remainUnloadCount)
        // 如果剩餘數量仍大於每次設定的載入數量limit，則可以繼續以相同限制數量進行加載
        if limit < remainUnloadCount {
            offset += limit
        } else { return }
    }
    
}

extension PokemonListHTTPClient {
    // https://pokeapi.co/api/v2/pokemon?limit=1302
    var pokemonListRequestType: RequestType {
        return RequestType.init(httpMethod: .GET, domainURL: .init(string: "https://pokeapi.co/api/v2")!, path: "/pokemon", queryItems: [.init(name: "limit", value: "\(adjustedLimit)"), .init(name: "offset", value: "\(offset)")])
    }
}
