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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokeomn List"
        
        view.addSubview(pokemonListTableView)
        pokemonListTableView.constraint(top: view.safeAreaLayoutGuide.snp.top, bottom: view.safeAreaLayoutGuide.snp.bottom, left: view.snp.left, right: view.snp.right)
        
        viewModel.delegate = self
        viewModel.loadAllPokemonList()
        
    }
}

extension AllPokemonListViewController: AllPokemonListViewModelDelegate {
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListDidUpdate allPokemonList: AllPokemonList) {
        pokemonListTableView.reloadData()
        viewModel.isLoadingAndPresentingNewPokemonList = false
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListErrorDidUpdate error: AllPokemonListServiceError) {
        viewModel.isLoadingAndPresentingNewPokemonList = false
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
    
    // 當 tableView 滑到底時
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 取得當前 tableView 的最後一個 section 的最後一個 row (tableView 的最底下的 row)
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        // 判斷最後一個 cell 是否有要被顯示
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            viewModel.loadAllPokemonList()
        }
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
