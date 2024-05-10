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
    lazy var pokemonListCollectionView = makeCollectionView()
    lazy var indicatorFooterView = makeIndicatorView()
    var indicator: UIActivityIndicatorView {
        return indicatorFooterView.indicator
    }
    var footerView: UIView {
        indicatorFooterView.footerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokeomn List"
        
        view.addSubview(pokemonListCollectionView)
        pokemonListCollectionView.constraint(top: view.safeAreaLayoutGuide.snp.top, bottom: view.safeAreaLayoutGuide.snp.bottom, left: view.snp.left, right: view.snp.right)
        
        viewModel.delegate = self
        viewModel.loadAllPokemonList()
    }
    
    func makeIndicatorView() -> (footerView: UIView, indicator: UIActivityIndicatorView) {
        let footerView = UIView(frame: .init(x: 0, y: 0, width: pokemonListCollectionView.frame.width, height: 50))
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = footerView.center
        footerView.addSubview(indicator)
        
        return (footerView, indicator)
    }
}

extension AllPokemonListViewController: AllPokemonListViewModelDelegate {
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, willLoadNewPokemonList: Bool) {
        indicator.startAnimating()
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, didLoadNewPokemonList: Bool) {
        indicator.stopAnimating()
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListDidUpdate allPokemonList: AllPokemonList) {
        pokemonListCollectionView.reloadData()
        viewModel.isLoadingAndPresentingNewPokemonList = false
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListErrorDidUpdate error: AllPokemonListServiceError) {
        viewModel.isLoadingAndPresentingNewPokemonList = false
    }
}

extension AllPokemonListViewController {
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        return collectionView
    }
}

extension AllPokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AllPokemonCollectionCell.self), for: indexPath) as! AllPokemonCollectionCell
        return cell
    }
}

//extension AllPokemonListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.allPokemonListCellModels.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AllPokemonListCell.self), for: indexPath) as! AllPokemonListCell
//        let cellModel = viewModel.allPokemonListCellModels[indexPath.row]
//        cell.configureCell(with: cellModel)
//        return cell
//    }
    
    // 當 tableView 滑到底時
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // 取得當前 tableView 的最後一個 section 的最後一個 row (tableView 的最底下的 row)
//        let lastSectionIndex = tableView.numberOfSections - 1
//        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
//        // 判斷最後一個 cell 是否有要被顯示
//        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
//            viewModel.loadAllPokemonList()
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return footerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
//}

//extension AllPokemonListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.setupPokemonNameForInfoPage(with: indexPath)
//        let pokemonInfoPageViewController = PokemonInfoPageViewController()
//        pokemonInfoPageViewController.dataSource = self
//        navigationController?.pushViewController(pokemonInfoPageViewController, animated: true)
//    }
//}

extension AllPokemonListViewController: PokemonInfoPageViewControllerDataSource {
    var pokemonName: String {
        guard let name = viewModel.pokemonNameForInfoPage else {
            fatalError("PokemonNameForInfoPage should not be nil!")
        }
        return name
    }
}
