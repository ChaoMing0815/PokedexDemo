//
//  ViewController.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import UIKit

class ViewController: UIViewController {

    let allPokemonListViewModel = AllPokemonListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        allPokemonListViewModel.delegate = self
        allPokemonListViewModel.loadAllPokemonList()
    }


}

extension ViewController: AllPokemonListViewModelDelegate {
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListDidUpdate allPokemonList: AllPokemonList) {
        print(allPokemonList)
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListErrorDidUpdate error: AllPokemonListServiceError) {
        print(error)
    }
    
    
}
