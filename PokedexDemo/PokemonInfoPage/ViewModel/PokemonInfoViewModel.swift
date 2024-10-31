//
//  PokemonInfoViewModel.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/25.
//

import Foundation

protocol PokemonInfoViewModelDelegate: AnyObject {
    func pokemonInfoViewModel(_ pokemonInfoViewModel: PokemonInfoViewModel, cellModelsDidUpdate pokemonInfoCellModel: [PokemonInfoCellModel])
    func pokemonInfoViewModel(_ pokemonInfoViewModel: PokemonInfoViewModel, pokemonInfoErrorDidUpdate serviceError: PokemonInfoServiceError)
}


class PokemonInfoViewModel {
    weak var delegate: PokemonInfoViewModelDelegate?
    
    let service = PokemonInfoService()
    var cellModels = [PokemonInfoCellModel]()
    var pokemonInfo: PokemonInfo?
    
    func loadPokemonInfoAndImage(with idsToLoad: [String]) {
        var loadedCellModels = [PokemonInfoCellModel]()
        let group = DispatchGroup()
        
        for id in idsToLoad {
            group.enter()
            service.loadPokemonInfoAndImage(with: id) { [weak self] result in
                defer { group.leave()}
                guard let self else { return }
                
                switch result {
                case let .success(pokemonInfo):
                    let cellModel = PokemonInfoCellModel(id: pokemonInfo.id, name: pokemonInfo.name, height: pokemonInfo.height, weight: pokemonInfo.weight, types: pokemonInfo.types, imageData: pokemonInfo.imageData, shinyImageData: pokemonInfo.shinyImageData)
                    loadedCellModels.append(cellModel)
                case let .failure(error):
                    self.delegate?.pokemonInfoViewModel(self, pokemonInfoErrorDidUpdate: error)
                }
            }
        }
        group.notify(queue: .main) {
            self.cellModels = loadedCellModels.sorted(by: { $0.id < $1.id })
            self.delegate?.pokemonInfoViewModel(self, cellModelsDidUpdate: self.cellModels)
        }
    }
}


