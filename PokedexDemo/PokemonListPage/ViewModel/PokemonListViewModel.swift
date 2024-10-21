//
//  AllPokemonListViewModel.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

protocol PokemonListViewModelDelegate: AnyObject {
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, cellModelsDidUpdate cellModels: [PokemonListCellModel])
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, pokemonListErrorDidUpdate error: PokemonListServiceError)
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, willLoadNewPokemonList: Bool)
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, didLoadNewPokemonList: Bool)
}

// MARK: - Internal Methods and Network Service
class PokemonListViewModel {
    weak var delegate: PokemonListViewModelDelegate?
    
    let service = PokemonListService()
    var cellModels = [PokemonListCellModel]()
    var pokemonIDForInfoPage: String?
    var isLoadingAndPresentingNewPokemonList = false
    
    func loadAllPokemonListAndImage() {
        if isLoadingAndPresentingNewPokemonList {
            return
        }
        delegate?.pokemonListViewModel(self, willLoadNewPokemonList: true)
        isLoadingAndPresentingNewPokemonList = true
        service.loadPokemonList { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(allPokemonList):
                let allPokemonInfos = allPokemonList.allPokemonInfos
                let group = DispatchGroup()
                for pokemonInfo in allPokemonInfos {
                    group.enter()
                    self.service.loadPokemonImage(with: pokemonInfo.id) { result in
                        defer { group.leave() }
                        switch result {
                        case let .success(imageData):
                            let cellModel = PokemonListCellModel(id: pokemonInfo.id, name: pokemonInfo.name, imageData: imageData)
                            self.cellModels.append(cellModel)
                        case .failure(_):
                            print("Fail to load image data for \(pokemonInfo.id)")
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.delegate?.pokemonListViewModel(self, didLoadNewPokemonList: true)
                    self.isLoadingAndPresentingNewPokemonList = false
                    self.cellModels.sort(by: { Int($0.id)! < Int($1.id)! })
                    self.delegate?.pokemonListViewModel(self, cellModelsDidUpdate: self.cellModels)
                }
            case let .failure(error):
                self.isLoadingAndPresentingNewPokemonList = false
                self.delegate?.pokemonListViewModel(self, pokemonListErrorDidUpdate: error)
            }
        }
    }
    
    func setupPokemonIDForInfoPage(with indexPath: IndexPath) {
        let id = cellModels[indexPath.row].id
        pokemonIDForInfoPage = id
    }
}


extension PokemonListViewModel {
    func loadNewPokemons(withIndexPath indexPath: IndexPath, lastSectionIndex: Int, lastItemIndex: Int) {
        if indexPath.section == lastSectionIndex && indexPath.item == lastItemIndex {
            if !self.isLoadingAndPresentingNewPokemonList {
                self.loadAllPokemonListAndImage()
            }
        }
    }
}
