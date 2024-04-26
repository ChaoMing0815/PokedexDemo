//
//  AllPokemonListViewController.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/18.
//

import Foundation
import UIKit

class AllPokemonListViewController: UIViewController {
    // MARK: - stored properties
    let viewModel = AllPokemonListViewModel()
    lazy var pokemonListTableView = makeTableView()
    
    let pokemonInfoHTTPClient = PokemonInfoHTTPClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokeomn List"
        
        view.addSubview(pokemonListTableView)
        pokemonListTableView.constraint(top: view.snp.top, bottom: view.snp.bottom, left: view.snp.left, right: view.snp.right)
        
        viewModel.delegate = self
        viewModel.loadAllPokemonList()
        
        pokemonInfoHTTPClient.requestPokemonInfo(with: "bulbasaur") { result in
            switch result {
            case let .success(data, response):
                print(data)
                let image = UIImage.init(data: data)
                let imageView = UIImageView(image: image)
            case let .failure(_):
                return
            }
        }
        
        pokemonInfoHTTPClient.requestPokemonImage(with: "1") { result in
            switch result {
            case let .success(data):
                print(data)
            case .failure(_):
                return
            }
        }
    }
}

extension AllPokemonListViewController: AllPokemonListViewModelDelegate {
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListDidUpdate allPokemonList: AllPokemonList) {
        pokemonListTableView.reloadData()
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListErrorDidUpdate error: AllPokemonListServiceError) {
    }
}

extension AllPokemonListViewController {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AllPokemonListCell.self, forCellReuseIdentifier: String(describing: AllPokemonListCell.self))
        return tableView
    }
}

extension AllPokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allPokemonNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllPokemonListCell.self), for: indexPath) as! AllPokemonListCell
        let cellModel = viewModel.makeCellModel(with: indexPath)
        cell.configureCell(with: cellModel)
        return cell
    }
}

extension AllPokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setupPokemonNameForInfoPage(with: indexPath)
        let pokemonInfoPageViewController = PokemonInfoPageViewController()
        pokemonInfoPageViewController.dataSource = self
        navigationController?.pushViewController(pokemonInfoPageViewController, animated: true)
    }
}

extension AllPokemonListViewController: PokemonInfoPageViewControllerDataSource {
    var pokemonName: String {
        guard let name = viewModel.pokemonNameForInfoPage else {
            fatalError("PokemonNameForInfoPage should not be nil!")
        }
        return name
    }
}
