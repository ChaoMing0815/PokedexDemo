//
//  PokemonListUseCase.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/10/21.
//

import Foundation

enum PokemonListUseCaseError: Error {
    case NetworkError
    case ParsingError
    case BusinessLogicError
    case DatabaseOrCacheError
}

protocol PokemonListUseCaseProtocol {
    func loadPokemonListAndImage(with generation: Generation, completion: @escaping (Result<PokemonList, PokemonListUseCaseError>) -> Void)
}

class PokemonListUseCase: PokemonListUseCaseProtocol {
    
    private let service: PokemonListService
    
    init(service: PokemonListService) {
        self.service = service
    }
    
    func loadPokemonListAndImage(with generation: Generation, completion: @escaping (Result<PokemonList, PokemonListUseCaseError>) -> Void) {
        service.loadPokemonList { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(pokemonListDTO):
                var pokemonList = PokemonList(from: pokemonListDTO)
                let group = DispatchGroup()
                
                for index in pokemonList.pokemonInfos.indices {
                    group.enter()
                    let pokemonInfo = pokemonList.pokemonInfos[index]
                    self.service.loadPokemonImage(with: pokemonInfo.id) { result in
                        defer { group.leave() }
                        switch result {
                        case let .success(imageData):
                            pokemonList.pokemonInfos[index].imageData = imageData
                        case .failure(_):
                            print("Fail to load image data for \(pokemonInfo.id)")
                            completion(.failure(.ParsingError))
                        }
                    }
                }
                group.notify(queue: .main) {
                    completion(.success(pokemonList))
                }
            case .failure(_):
                completion(.failure(.NetworkError))
            }
        }
    }
}



