//
//  PokemonInfoViewModel.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/25.
//

import Foundation

protocol PokemonInfoViewModelDelegate: AnyObject {
    func pokemonInfoViewModel(_ pokemonInfoViewModel: PokemonInfoViewModel, pokemonInfoDidUpdate pokemonInfo: PokemonInfo)
    func pokemonInfoViewModel(_ pokemonInfoViewModel: PokemonInfoViewModel, pokemonInfoErrorDidUpdate serviceError: PokemonInfoServiceError)
}


class PokemonInfoViewModel {
    weak var delegate: PokemonInfoViewModelDelegate?
    
    let service = PokemonInfoService()
    var pokemonInfo: PokemonInfo?
    
    func loadPokemonInfoAndImage(with name: String) {
        service.loadPokemonInfoAndImage(with: name) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(pokemonInfo):
                self.pokemonInfo = pokemonInfo
                self.delegate?.pokemonInfoViewModel(self, pokemonInfoDidUpdate: pokemonInfo)
            case let .failure(error):
                self.delegate?.pokemonInfoViewModel(self, pokemonInfoErrorDidUpdate: error)
            }
        }
    }
}
