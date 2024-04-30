//
//  AllPokemonListViewModel.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import Foundation

protocol AllPokemonListViewModelDelegate: AnyObject {
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListDidUpdate allPokemonList: AllPokemonList)
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListErrorDidUpdate error: AllPokemonListServiceError)
}

// MARK: - Internal Methods and Network Service
class AllPokemonListViewModel {
    weak var delegate: AllPokemonListViewModelDelegate?
    
    let service = AllPokemonListService()
    var allPokemonNames = [String]()
    var pokemonNameForInfoPage: String?
    var isLoadingAndPresentingNewPokemonList = false
    
    func loadAllPokemonList() {
        if isLoadingAndPresentingNewPokemonList {
            // 代表現在正在 loading data
            return
        }
        isLoadingAndPresentingNewPokemonList = true
        service.loadAllPokemonList { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(allPokemonList):
//                allPokemonNames = allPokemonList.pokemonNames
                self.allPokemonNames.append(contentsOf: allPokemonList.pokemonNames)
                self.delegate?.allPokemonListViewModel(self, allPokemonListDidUpdate: allPokemonList)
            case let .failure(error):
                self.delegate?.allPokemonListViewModel(self, allPokemonListErrorDidUpdate: error)
            }
        }
    }
    
    func makeCellModel(with indexPath: IndexPath) -> AllPokemonListCellModel {
        let name = allPokemonNames[indexPath.row]
        return .init(name: name)
    }
    
    func setupPokemonNameForInfoPage(with indexPath: IndexPath) {
        let name = allPokemonNames[indexPath.row]
        pokemonNameForInfoPage = name
    }
}
