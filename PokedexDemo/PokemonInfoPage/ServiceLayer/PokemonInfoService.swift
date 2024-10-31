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
    
    func loadShinyPokemonImage(with id: String, completion: @escaping (Result<Data, HTTPClientError>) -> Void) {
        client.requestShinyPokemonImage(with: id) { result in
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
                // 設定DispatchGruop，處理加載一般圖片與異色圖片的異步任務
                let group = DispatchGroup()
                var normalImageData: Data?
                var shinyImageData: Data?
                var imageError: PokemonInfoServiceError?
                
                group.enter()
                self.loadPokemonImage(with: id) { result in
                    defer { group.leave() }
                    switch result {
                    case let .success(imageData):
                        normalImageData = imageData
                    case .failure(_):
                        imageError = .ImageDataError
                    }
                }
                
                group.enter()
                self.loadShinyPokemonImage(with: id) { result in
                    defer { group.leave() }
                    switch result {
                    case let .success(imageData):
                        shinyImageData = imageData
                    case .failure(_):
                        imageError = .ImageDataError
                    }
                }
                
                group.notify(queue: .main) {
                    if let imageError = imageError {
                        completion(.failure(.ImageDataError))
                    } else {
                        pokemonInfo.imageData = normalImageData
                        pokemonInfo.shinyImageData = shinyImageData
                        completion(.success(pokemonInfo))
                    }
                }
            case .failure(_):
                completion(.failure(.NetworkError))
            }
        }
    }
}
