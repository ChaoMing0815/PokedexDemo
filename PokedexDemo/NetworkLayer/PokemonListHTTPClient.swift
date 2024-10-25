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
    
    init(limit: Int = 30, startID: Int, endID: Int) {
        self.limit = limit
        self.startID = startID
        self.endID = endID
        self.offset = startID - 1
        super.init()
    }
    
    func requestPokemonList(completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void) {
        request(with: pokemonListRequestType, completion: completion)
    }
    
    func updateOffset() {
        offset += limit
        if offset > endID {
            offset = endID
        }
    }
    
}

extension PokemonListHTTPClient {
    // https://pokeapi.co/api/v2/pokemon?limit=1302
    var pokemonListRequestType: RequestType {
        return RequestType.init(httpMethod: .GET, domainURL: .init(string: "https://pokeapi.co/api/v2")!, path: "/pokemon", queryItems: [.init(name: "limit", value: "\(limit)"), .init(name: "offset", value: "\(offset)")])
    }
}
