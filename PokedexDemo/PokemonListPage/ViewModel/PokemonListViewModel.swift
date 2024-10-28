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
    var isLastPageLoaded = false
    
    init() {
       
    }
    
    func loadPokemonListAndImage() {
        // 確保當前並沒有在執行載入新的寶可夢列表，且尚未達到當前世代最後一批寶可夢
        guard !isLoadingAndPresentingNewPokemonList, !isLastPageLoaded else { return }
        
        delegate?.pokemonListViewModel(self, willLoadNewPokemonList: true)
        isLoadingAndPresentingNewPokemonList = true
        guard let useCase = self.useCase else { return }
        useCase.loadPokemonListAndImage(with: selectedGeneration) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case let .success(pokemonList):
                    let pokemonInfos = pokemonList.pokemonInfos
                    // 使用append將新載入的寶可夢資料正確加入'cellModels'中，而不是透過賦值的覆蓋原來的'cellModels'，以必免不斷觸發'loadNewPokemons'
                    self.cellModels.append(contentsOf: pokemonInfos.map { PokemonListCellModel(id: $0.id, name: $0.name, imageData: $0.imageData)
                    })
                    self.cellModels.sort(by: { Int($0.id)! < Int($1.id)! })
                    if let lastID = Int(self.cellModels.last?.id ?? ""),
                       lastID > self.selectedGeneration.range.endID {
                        // 移除所有ID超過endID的寶可夢，確保沒有其他世代的寶可夢誤載至當前世代cellModels中
                        self.cellModels.removeAll { Int($0.id)! > self.selectedGeneration.range.endID }
                        // 當已經載入到當前世代的endID寶可夢時代表進入最後一頁加載，因此變更'isLastPageLoaded'為true，使分頁加載功能停止繼續觸發。
                        self.isLastPageLoaded = true
                    }
                    self.delegate?.pokemonListViewModel(self, cellModelsDidUpdate: self.cellModels)
                    self.delegate?.pokemonListViewModel(self, didLoadNewPokemonList: true)
                    self.isLoadingAndPresentingNewPokemonList = false
                    
                case let .failure(error):
                    self.isLoadingAndPresentingNewPokemonList = false
                    self.delegate?.pokemonListViewModel(self, pokemonListErrorDidUpdate: error)
                }
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
            // 確保沒有正在加載新的寶可夢
            if !self.isLoadingAndPresentingNewPokemonList {
                self.loadPokemonListAndImage()
            }
        }
    }
}
