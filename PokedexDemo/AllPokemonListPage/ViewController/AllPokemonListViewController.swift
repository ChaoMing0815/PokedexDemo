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
    lazy var indicator = makeIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokemon List"
        
        view.addSubview(pokemonListCollectionView)
        pokemonListCollectionView.constraint(top: view.safeAreaLayoutGuide.snp.top, bottom: view.safeAreaLayoutGuide.snp.bottom, left: view.snp.left, right: view.snp.right)

        viewModel.delegate = self
        viewModel.loadAllPokemonListAndImage()
    }
    
    func makeIndicatorView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }
}

// MARK: - AllPokemonListViewModelDelegate
extension AllPokemonListViewController: AllPokemonListViewModelDelegate {
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, cellModelsDidUpdate cellModels: [AllPokemonListCellModel]) {
        pokemonListCollectionView.reloadData()
        
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, willLoadNewPokemonList: Bool) {
        indicator.startAnimating()
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, didLoadNewPokemonList: Bool) {
        indicator.stopAnimating()
    }
    
    func allPokemonListViewModel(_ allPokemonListViewModel: AllPokemonListViewModel, allPokemonListErrorDidUpdate error: AllPokemonListServiceError) {
        
    }
}

// MARK: - Factory Methods
extension AllPokemonListViewController {
    func makeCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 50
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AllPokemonCollectionCell.self, forCellWithReuseIdentifier: String(describing: AllPokemonCollectionCell.self))
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
        return collectionView
    }
}

// MARK: - UICollectionViewDataSource
extension AllPokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AllPokemonCollectionCell.self), for: indexPath) as! AllPokemonCollectionCell
        let cellModel = viewModel.cellModels[indexPath.row]
        cell.configureCell(with: cellModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastItemIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        viewModel.loadNewPokemons(withIndexPath: indexPath, lastSectionIndex: lastSectionIndex, lastItemIndex: lastItemIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
            footerView.addSubview(indicator)
            indicator.fillWithCenter(with: .init(width: 25, height: 25))
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width
        return .init(width: width, height: 50)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension AllPokemonListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 16
        let totalSpacing: CGFloat = spacing * 3
        let width = (UIScreen.main.bounds.width - totalSpacing) / 2
        return .init(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // 設定 Cell 之間的間距
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 設定 Cell 的垂直間距
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 設定 Section 的邊距（頂部、左側、底部、右側），使得左右邊距與中間間距相等
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationViewController = PokemonInfoPageViewController()
        destinationViewController.dataSource = self
        viewModel.setupPokemonIDForInfoPage(with: indexPath)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

// MARK: - PokemonInfoPageViewControllerDataSource
extension AllPokemonListViewController: PokemonInfoPageViewControllerDataSource {
    var SelectedPokemonID: String {
        guard let id = viewModel.pokemonIDForInfoPage else {
            fatalError("PokemonIDForInfoPage should not be nil!")
        }
        return id
    }    
}
