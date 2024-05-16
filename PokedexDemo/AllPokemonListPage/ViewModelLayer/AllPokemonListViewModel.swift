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
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, willLoadNewPokemonList: Bool)
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, didLoadNewPokemonList: Bool)
}

// MARK: - Internal Methods and Network Service
class AllPokemonListViewModel {
    weak var delegate: AllPokemonListViewModelDelegate?
    
    let service = AllPokemonListService()
    var allPokemonListCellModels = [AllPokemonListCellModel]()
    var pokemonNameForInfoPage: String?
    var isLoadingAndPresentingNewPokemonList = false
    
    func loadAllPokemonListAndImage() {
        if isLoadingAndPresentingNewPokemonList {
            return
        }
        delegate?.allPokemonListViewModel(self, willLoadNewPokemonList: true)
        isLoadingAndPresentingNewPokemonList = true
        service.loadAllPokemonList { [weak self] result in
            guard let self else { return }
//            self.delegate?.allPokemonListViewModel(self, didLoadNewPokemonList: true)
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
                            let cellModel = AllPokemonListCellModel(name: pokemonInfo.name, imageData: imageData)
                            self.allPokemonListCellModels.append(cellModel)
                        case .failure(_):
                            print("Fail to load image data for \(pokemonInfo.id)")
                        }
                    }
                }
                group.notify(queue: .main) {
                    self.delegate?.allPokemonListViewModel(self, allPokemonListDidUpdate: allPokemonList)
                }
            case let .failure(error):
                self.delegate?.allPokemonListViewModel(self, allPokemonListErrorDidUpdate: error)
            }
        }
    }
    
    func setupPokemonNameForInfoPage(with indexPath: IndexPath) {
        let name = allPokemonListCellModels[indexPath.row].name
        pokemonNameForInfoPage = name
    }
}
