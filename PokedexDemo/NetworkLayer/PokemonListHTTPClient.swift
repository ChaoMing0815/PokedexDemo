//
//  AllPokemonListHTTPClient.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

class PokemonListHTTPClient: HTTPClient {
    fileprivate var offset: Int = 0
    fileprivate let limit: Int
    
    init(limit: Int = 30) {
        self.limit = limit
    }
    
    func requestAllPokemonList(completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void) {
        request(with: allPokemonListRequestType, completion: completion)
    }
    
    func updateOffset() {
        offset += limit
    }
    
    
}

extension PokemonListHTTPClient {
    // https://pokeapi.co/api/v2/pokemon?limit=1302
    var allPokemonListRequestType: RequestType {
        return RequestType.init(httpMethod: .GET, domainURL: .init(string: "https://pokeapi.co/api/v2")!, path: "/pokemon", queryItems: [.init(name: "limit", value: "\(limit)"), .init(name: "offset", value: "\(offset)")])
    }
}
