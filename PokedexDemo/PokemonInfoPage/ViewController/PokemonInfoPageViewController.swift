//
//  PokemonInfoPageViewController.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/25.
//

import Foundation
import UIKit

// MARK: - Set protocol 'PokemonInfoPageViewControllerDataSource'
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
    let shinyIcon = UIImage(named: "shiny")!.withRenderingMode(.alwaysOriginal)
    let filledShinyIcon = UIImage(named: "shinyTapped")!.withRenderingMode(.alwaysOriginal)
    lazy var shinyButton = makeButton(with: shinyIcon, tappedIcon: filledShinyIcon)
    
    var selectedPokemonIndex: Int?
    var isShinyEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        view.layer.insertSublayer(makeGradientLayer(), at: 0)
        viewModel.delegate = self
        setupIDsToLoadPokemonInfoAndImage()
        shinyButton.addTarget(self, action: #selector(shinyButtonTapped(_:)), for: .touchUpInside)
        
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
        self.view.addSubview(shinyButton)
        
        pokemonInfoCollectionView.constraint(top: view.safeAreaLayoutGuide.snp.top, bottom: view.safeAreaLayoutGuide.snp.bottom, left: view.snp.left, right: view.snp.right)
        shinyButton.constraint(top: view.safeAreaLayoutGuide.snp.top, right: view.snp.right, padding: .init(top: 16, left: 0, bottom: 0, right: 16), size: .init(width: 48, height: 48))
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
    
    func makeButton(with icon: UIImage, tappedIcon: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(icon, for: .normal)
        button.setImage(tappedIcon, for: .selected)
        button.layer.borderWidth = 0 // 設置空心邊框寬度
        button.backgroundColor = .clear // 初始設置為透明
        button.adjustsImageWhenHighlighted = false // 禁用高亮顯示
        button.adjustsImageWhenDisabled = false
        button.tintColor = .clear
        return button
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

// MARK: - Heplers
private extension PokemonInfoPageViewController {
    // 設定進入PokemonInfoPage後需要存取的其他寶可夢資料陣列，並設定被選取Pokemon的IndexPath，以利進入畫面後設定顯示該PokemonInfoCell
    func setupIDsToLoadPokemonInfoAndImage() {
        // 首先確保DataSource資料
        guard let idString = dataSource?.SelectedPokemonID else { fatalError("Must conform PokemonInfoPageViewControllerDataSource!") }
        //        guard let id = Int(idString) else { fatalError("SeletedPokemonID should not be nil!") }
        //        let start = max(0, id - 9)
        //        let end = id + 9
        let idsToLoad: [String] = [idString] /*(start...end).map { "\($0)"}*/
        
        if let index = idsToLoad.firstIndex(of: idString) {
            self.selectedPokemonIndex = index
        }
        viewModel.loadPokemonInfoAndImage(with: idsToLoad)
    }
    
    func updateCellsForShinyState() {
        for cell in pokemonInfoCollectionView.visibleCells {
            if let pokemonCell = cell as? PokemonInfoCell,
               // 透過UICollectionViewCell在CollectionView中的IndexPath指定其cellModel
               let indexPath = pokemonInfoCollectionView.indexPath(for: pokemonCell) {
                pokemonCell.updateImage(with: viewModel.cellModels[indexPath.row], isShinyEnabled: isShinyEnabled)
            }
        }
    }
    
    @objc private func toggleShiny() {
        isShinyEnabled.toggle()
        updateCellsForShinyState()
    }
    
    // 設置shinyButton點擊後的效果與功能
    @objc private func shinyButtonTapped(_ sender: UIButton) {
        UIView.performWithoutAnimation {
            // 設置點擊後改變為'isSelected'狀態
            sender.isSelected.toggle()
            sender.layoutIfNeeded()
        }
        // 執行的shinyButton的功能
        toggleShiny()
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
