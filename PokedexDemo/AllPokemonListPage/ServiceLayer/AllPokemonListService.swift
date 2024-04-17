//
//  AllPokemonListService.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation
enum AllPokemonListServiceError: Error {
    case JSONParsingError
    case NetworkError
}

class AllPokemonListService {
    let client = AllPokemonListHTTPClient()
    func loadAllPokemonList(completion: @escaping (Result<AllPokemonList, AllPokemonListServiceError>) -> Void) {
        client.requestAllPokemonList { result in
            switch result {
            case let .success((data, _)): // tuple (Data, HTTPURLResponse) -> type
                // do success behavior
                do {
                    let allPokemonListDTO = try JSONDecoder().decode(AllPokemonListDTO.self, from: data)
                    let allPokemonList = AllPokemonList(from: allPokemonListDTO)
                    completion(.success(allPokemonList))
                } catch {
                    completion(.failure(.JSONParsingError))
                }
            case .failure:
                // do failure behavior
                completion(.failure(.NetworkError))
            }
        }
    }
}
