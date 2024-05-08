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
    
    func loadAllPokemonList() {
        if isLoadingAndPresentingNewPokemonList {
            // 代表現在正在 loading data
            return
        }
        // 代表要開始 loading data 了
        delegate?.allPokemonListViewModel(self, willLoadNewPokemonList: true)
        isLoadingAndPresentingNewPokemonList = true
        service.loadAllPokemonList { [weak self] result in
            guard let self else { return }
            // 已經從 server 拿回資料了
            self.delegate?.allPokemonListViewModel(self, didLoadNewPokemonList: true)
            switch result {
            case let .success(allPokemonList):
                self.allPokemonListCellModels += allPokemonList.allPokemonInfos.map { .init(name: $0.name) }
                self.delegate?.allPokemonListViewModel(self, allPokemonListDidUpdate: allPokemonList)
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
