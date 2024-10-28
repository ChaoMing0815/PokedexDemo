//
//  PokemonInfoPageViewController.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/25.
//

import Foundation
import UIKit

protocol PokemonInfoPageViewControllerDataSource: AnyObject {
    var SelectedPokemonID: String { get }
}

class PokemonInfoPageViewController: UIViewController {
    // 外部使用
    weak var dataSource: PokemonInfoPageViewControllerDataSource?
    
    // 內部使用
    fileprivate var _dataSource: PokemonInfoPageViewControllerDataSource {
        guard let dataSource else {
            fatalError("Must conform PokemonInfoPageViewControllerDataSource!")
        }
        return dataSource
    }
    
    let viewModel = PokemonInfoViewModel()
    lazy var pokemonInfoCollectionView = makeCollectionView()
    
    var selectedPokemonIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        view.layer.insertSublayer(makeGradientLayer(), at: 0)
        viewModel.delegate = self
        setupIDsToLoadPokemonInfoAndImage()
        
    }
}

// MARK: - PokemonInfoViewModelDelegate
extension PokemonInfoPageViewController: PokemonInfoViewModelDelegate {
    func pokemonInfoViewModel(_ pokemonInfoViewModel: PokemonInfoViewModel, cellModelsDidUpdate pokemonInfoCellModel: [PokemonInfoCellModel]) {
        pokemonInfoCollectionView.reloadData()
        if let selectedPokemonIndex = selectedPokemonIndex {
            let indexPath = IndexPath(item: selectedPokemonIndex, section: 0)
            pokemonInfoCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
    }
    
    func pokemonInfoViewModel(_ pokemonInfoViewModel: PokemonInfoViewModel, pokemonInfoErrorDidUpdate serviceError: PokemonInfoServiceError) {
            // TODO: Error handling
    }
    
    
}

// MARK: - UI Layout
extension PokemonInfoPageViewController {
    func setupLayout() {
        self.view.addSubview(pokemonInfoCollectionView)
        
        pokemonInfoCollectionView.constraint(top: view.safeAreaLayoutGuide.snp.top, bottom: view.safeAreaLayoutGuide.snp.bottom, left: view.snp.left, right: view.snp.right)
    }
}

// MARK: - Heplers
extension PokemonInfoPageViewController {
    // 設定進入PokemonInfoPage後需要存取的其他寶可夢資料陣列，並設定被選取Pokemon的IndexPath，以利進入畫面後設定顯示該PokemonInfoCell
    func setupIDsToLoadPokemonInfoAndImage() {
        // 首先確保DataSource資料
        guard let idString = dataSource?.SelectedPokemonID else { fatalError("Must conform PokemonInfoPageViewControllerDataSource!") }
        guard let id = Int(idString) else { fatalError("SeletedPokemonID should not be nil!") }
//        let start = max(0, id - 9)
//        let end = id + 9
        let idsToLoad: [String] = [idString] /*(start...end).map { "\($0)"}*/
        
        if let index = idsToLoad.firstIndex(of: idString) {
            self.selectedPokemonIndex = index
        }
        viewModel.loadPokemonInfoAndImage(with: idsToLoad)
    }
}

// MARK: - Factory Methods
extension PokemonInfoPageViewController {
    func makeLabelStackView(arrangeSubViews: [UIView]) -> UIStackView {
        let labelStackView = UIStackView(arrangedSubviews: arrangeSubViews)
        labelStackView.axis = .vertical
        labelStackView.distribution = .equalSpacing
        return labelStackView
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 22)
        view.textColor = .white
        return view
    }
    
    func makeCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 20
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast // 讓滾動效果更自然
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PokemonInfoCell.self, forCellWithReuseIdentifier: String(describing: PokemonInfoCell.self))
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
        return collectionView
    }
    
    func makeGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.blue.cgColor] // 定義漸層顏色
        gradientLayer.locations = [0.4, 1.0] //設置顏色過渡點，表示第一個顏色佔比60%
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // 漸層的起點
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1) // 漸層的終點
        return gradientLayer
    }
}

// MARK: - UICollectionViewDataSource
extension PokemonInfoPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PokemonInfoCell.self), for: indexPath) as! PokemonInfoCell
        let cellModel = viewModel.cellModels[indexPath.row]
        cell.configureCell(with: cellModel)
        cell.backgroundColor = .clear
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegate
extension PokemonInfoPageViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PokemonInfoPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.7
        let height = collectionView.bounds.height * 0.8
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // 計算左右邊距，使第一個和最後一個 Cell 可以居中
        let inset = (collectionView.bounds.width - collectionView.bounds.width * 0.7) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 設定 Cell 之間的間距
        return 16
    }
}

// MARK: - UIScrollViewDelegate
//extension PokemonInfoPageViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let centerX = scrollView.contentOffset.x + (scrollView.frame.size.width / 2)
//
//            for cell in pokemonInfoCollectionView.visibleCells {
//                let basePosition = pokemonInfoCollectionView.convert(cell.center, to: pokemonInfoCollectionView.superview)
//                let distance = abs(basePosition.x - centerX)
//                
//                // 設置縮放比例，距離中心越遠，縮放越小
//                let scale = max(0.75, 1 - distance / (scrollView.frame.size.width))
//                cell.transform = CGAffineTransform(scaleX: scale, y: scale)
//                
//                // 設置透明度，距離中心越遠，透明度越高
//                let alpha = max(0.5, 1 - distance / (scrollView.frame.size.width * 0.5))
//                cell.alpha = alpha
//            }
//    }
//}
