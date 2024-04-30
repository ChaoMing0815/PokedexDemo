//
//  PokemonInfoService.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/25.
//

import Foundation


enum PokemonInfoServiceError: Error {
    case JSONParsingError
    case ImageDataError
    case NetworkError
}

class PokemonInfoService {
    let client = PokemonInfoHTTPClient()
    
    func loadPokemonInfo(with name: String, completion: @escaping (Result<PokemonInfo, PokemonInfoServiceError>) -> Void) {
        client.requestPokemonInfo(with: name) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success((data, _)):
                    do {
                        let pokemonInfoDTO = try JSONDecoder().decode(PokemonInfoDTO.self, from: data)
                        let pokemonInfo = PokemonInfo.init(from: pokemonInfoDTO)
                        completion(.success(pokemonInfo))
                    } catch {
                        completion(.failure(.JSONParsingError))
                    }
                case .failure(_):
                    completion(.failure(.NetworkError))
                }
            }
        }
    }
    
    func loadPokemonImage(with id: String, completion: @escaping (Result<Data, HTTPClientError>) -> Void) {
        client.requestPokemonImage(with: id) { result in
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
    
    func loadPokemonInfoAndImage(with name: String, completion: @escaping (Result<PokemonInfo, PokemonInfoServiceError>) -> Void) {
        self.loadPokemonInfo(with: name) { [weak self] result in
            guard let self else { return }
            switch result {
            case var .success(pokemonInfo):
                let id = "\(pokemonInfo.id)"
                self.loadPokemonImage(with: id) { result in
                    switch result {
                    case let .success(imageData):
                        pokemonInfo.imageData = imageData
                        completion(.success(pokemonInfo))
                    case .failure(_):
                        completion(.failure(.ImageDataError))
                    }
                }
            case .failure(_):
                completion(.failure(.NetworkError))
            }
        }
    }
}