//
//  AllPokemonListViewController.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/18.
//

import Foundation
import UIKit

class PokemonListViewController: UIViewController {
    // MARK: - stored properties
    let viewModel = PokemonListViewModel()
    
    lazy var pokemonListCollectionView = makeCollectionView()
    lazy var indicator = makeIndicatorView()
    var selectedGernerationInt: Int?
    private var hasReachedScrollViewBottom = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokémon List"
        
        view.layer.insertSublayer(makeGradientLayer(), at: 0)
        view.addSubview(pokemonListCollectionView)
        pokemonListCollectionView.constraint(top: view.safeAreaLayoutGuide.snp.top, bottom: view.safeAreaLayoutGuide.snp.bottom, left: view.snp.left, right: view.snp.right)

        viewModel.delegate = self
        
        guard let gernerationInt = selectedGernerationInt else { return }
        viewModel.setSelectedGeneration(with: gernerationInt)
        viewModel.loadPokemonListAndImage()
    }
    
    func makeIndicatorView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }
}

// MARK: - PokemonListViewModelDelegate
extension PokemonListViewController: PokemonListViewModelDelegate {
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, cellModelsDidUpdate cellModels: [PokemonListCellModel]) {
        pokemonListCollectionView.reloadData()
        
    }
    
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, willLoadNewPokemonList: Bool) {
        indicator.startAnimating()
    }
    
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, didLoadNewPokemonList: Bool) {
        indicator.stopAnimating()
    }
    
    func pokemonListViewModel(_ pokemonListViewModel: PokemonListViewModel, pokemonListErrorDidUpdate error: PokemonListUseCaseError) {
        // TODO: Error handling
    }
}

// MARK: - Factory Methods
extension PokemonListViewController {
    func makeCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 50
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PokemonCollectionCell.self, forCellWithReuseIdentifier: String(describing: PokemonCollectionCell.self))
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
        return collectionView
    }
    
    func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.systemGray2.cgColor] // 定義漸層顏色
        gradientLayer.locations = [0.4, 1.0] //設置顏色過渡點，表示第一個顏色佔比60%
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // 漸層的起點
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1) // 漸層的終點
        return gradientLayer
    }
}

// MARK: - UICollectionViewDataSource
extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PokemonCollectionCell.self), for: indexPath) as! PokemonCollectionCell
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
extension PokemonListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 設定間隔以計算Cell寬度
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

// MARK: - UICollectionViewDelegate
extension PokemonListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 檢測是否到達底部
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // 當滾動到底部時，設置 hasReachedBottom 標記
        if offsetY >= contentHeight - frameHeight {
            self.hasReachedScrollViewBottom = true
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 當再次滑動時，如果已到達底部則顯示提示
        if self.hasReachedScrollViewBottom {
            if viewModel.isLastPageLoaded {
                let alert = UIAlertController(title: "Hint", message: "Last pokemon of current generation has been loaded!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            self.hasReachedScrollViewBottom = false // 重置標記
        }
    }
}
    
    // MARK: - PokemonInfoPageViewControllerDataSource
extension PokemonListViewController: PokemonInfoPageViewControllerDataSource {
    var SelectedPokemonID: String {
        guard let id = viewModel.pokemonIDForInfoPage else {
            fatalError("PokemonIDForInfoPage should not be nil!")
        }
        return id
    }
}
