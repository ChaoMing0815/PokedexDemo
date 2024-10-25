//
//  AllPokemonListViewModel.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

protocol PokemonListViewModelDelegate: AnyObject {
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, cellModelsDidUpdate cellModels: [PokemonListCellModel])
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, pokemonListErrorDidUpdate error: PokemonListUseCaseError)
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, willLoadNewPokemonList: Bool)
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, didLoadNewPokemonList: Bool)
}

// MARK: - Internal Methods and Network Service
class PokemonListViewModel {
    weak var delegate: PokemonListViewModelDelegate?
    
    private var useCase: PokemonListUseCaseProtocol?
    private var selectedGeneration: Generation = .all
    
    var cellModels = [PokemonListCellModel]()
    var pokemonIDForInfoPage: String?
    var isLoadingAndPresentingNewPokemonList = false
    
    init() {
       
    }
    
    func loadPokemonListAndImage() {
        if isLoadingAndPresentingNewPokemonList {
            return
        }
        delegate?.pokemonListViewModel(self, willLoadNewPokemonList: true)
        isLoadingAndPresentingNewPokemonList = true
        guard let useCase = self.useCase else { return }
        useCase.loadPokemonListAndImage(with: selectedGeneration) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(pokemonList):
                let pokemonInfos = pokemonList.pokemonInfos
                self.cellModels = pokemonInfos.map({ PokemonListCellModel(id: $0.id, name: $0.name, imageData: $0.imageData)
                })
                self.cellModels.sort(by: { Int($0.id)! < Int($1.id)! })
                self.delegate?.pokemonListViewModel(self, cellModelsDidUpdate: self.cellModels)
                self.delegate?.pokemonListViewModel(self, didLoadNewPokemonList: true)
                self.isLoadingAndPresentingNewPokemonList = false
                
            case let .failure(error):
                self.isLoadingAndPresentingNewPokemonList = false
                self.delegate?.pokemonListViewModel(self, pokemonListErrorDidUpdate: error)
            }
        }
    }
    
    func setSelectedGeneration(with selectedGenerationInt: Int) {
        self.selectedGeneration = Generation(rawValue: selectedGenerationInt) ?? .all
        let service = PokemonListService(startID: self.selectedGeneration.range.startID, endID: self.selectedGeneration.range.endID)
        self.useCase = PokemonListUseCase(service: service)
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
                self.loadPokemonListAndImage()
            }
        }
    }
}
