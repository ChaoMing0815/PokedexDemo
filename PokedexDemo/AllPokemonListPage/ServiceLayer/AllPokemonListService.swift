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
    let infoClient = PokemonInfoHTTPClient()
    
    func loadAllPokemonList(completion: @escaping (Result<AllPokemonList, AllPokemonListServiceError>) -> Void) {
        client.requestAllPokemonList { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success((data, _)): // tuple (Data, HTTPURLResponse) -> type
                    // do success behavior
                    do {
                        let allPokemonListDTO = try JSONDecoder().decode(AllPokemonListDTO.self, from: data)
                        let allPokemonList = AllPokemonList(from: allPokemonListDTO)
                        completion(.success(allPokemonList))
                        self.client.updateOffset()
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
    
    func loadPokemonImage(with id: String, completion: @escaping (Result<Data, HTTPClientError>) -> Void) {
        infoClient.requestPokemonImage(with: id) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success((imageData, _)):
                    completion(.success(imageData))
                case .failure(_):
                    completion(.failure(.NetworkError))
                }
            }
        }
    }
}
