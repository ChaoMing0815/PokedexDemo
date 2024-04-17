//
//  AllPokemonListHTTPClient.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

class AllPokemonListHTTPClient: HTTPClient {
    func requestAllPokemonList(completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void) {
        request(with: allPokemonListRequestType, completion: completion)
    }
}

// https://raw.githubusercontent.com/pokemon/{name}
extension AllPokemonListHTTPClient {
    // https://pokeapi.co/api/v2/pokemon?limit=1302
    var allPokemonListRequestType: RequestType {
        return RequestType.init(httpMethod: .GET, domainURL: .init(string: "https://pokeapi.co/api/v2")!, path: "pokemon", queryItems: [.init(name: "limit", value: "1302")])
    }
}
