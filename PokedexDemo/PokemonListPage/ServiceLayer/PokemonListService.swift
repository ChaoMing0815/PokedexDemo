//
//  AllPokemonListService.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation
enum PokemonListServiceError: Error {
    case JSONParsingError
    case NetworkError
}

class PokemonListService {
    fileprivate let startID: Int
    fileprivate let endID: Int
    fileprivate let listClient: PokemonListHTTPClient!
    
    init(startID: Int, endID: Int) {
        self.startID = startID
        self.endID = endID
        self.listClient = PokemonListHTTPClient(startID: self.startID, endID: self.endID)
    }
    
    let infoClient = PokemonInfoHTTPClient()
    
    func loadPokemonList(completion: @escaping (Result<PokemonListDTO, PokemonListServiceError>) -> Void) {
        listClient.requestPokemonList { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success((data, _)): // tuple (Data, HTTPURLResponse) -> type
                    // do success behavior
                    do {
                        let pokemonListDTO = try JSONDecoder().decode(PokemonListDTO.self, from: data)
                        completion(.success(pokemonListDTO))
                        self.listClient.updateOffset()
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
    
    func loadPokemonImage(with id: String, completion: @escaping (Result<Data, PokemonListServiceError>) -> Void) {
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
