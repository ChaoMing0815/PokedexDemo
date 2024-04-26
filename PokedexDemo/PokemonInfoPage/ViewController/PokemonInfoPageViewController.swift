//
//  PokemonInfoPageViewController.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/25.
//

import Foundation
import UIKit

protocol PokemonInfoPageViewControllerDataSource: AnyObject {
    var pokemonName: String { get }
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
    
    lazy var pokemonImageView = makeImageView()
    lazy var pokemonIDLabel = makeLabel()
    lazy var pokemonNameLabel = makeLabel()
    lazy var pokemonHeightLabel = makeLabel()
    lazy var pokemonWeightLabel = makeLabel()
    
    lazy var pokemonInfoStackView = makeLabelStackView(arrangeSubViews: [pokemonIDLabel, pokemonNameLabel, pokemonHeightLabel, pokemonWeightLabel])
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .black
        viewModel.delegate = self
        guard let name = dataSource?.pokemonName else { return }
        viewModel.loadPokemonInfoAndImage(with: name)
    }
}

// MARK: - PokemonInfoViewModelDelegate
extension PokemonInfoPageViewController: PokemonInfoViewModelDelegate {
    func pokemonInfoViewModel(_ pokemonInfoViewModel: PokemonInfoViewModel, pokemonInfoDidUpdate pokemonInfo: PokemonInfo) {
        if let imageData = pokemonInfo.imageData {
            pokemonImageView.image = UIImage(data: imageData)
        }
        pokemonIDLabel.text = "ID: \(pokemonInfo.id)"
        pokemonNameLabel.text = "Name: \(pokemonInfo.name)"
        pokemonHeightLabel.text = "Height: \(pokemonInfo.height)"
        pokemonWeightLabel.text = "Weight: \(pokemonInfo.weight)"
    }
    
    func pokemonInfoViewModel(_ pokemonInfoViewModel: PokemonInfoViewModel, pokemonInfoErrorDidUpdate serviceError: PokemonInfoServiceError) {
        
    }
    
    
}

// MARK: - UI Layout
extension PokemonInfoPageViewController {
    func setupLayout() {
        self.view.addSubview(pokemonImageView)
        self.view.addSubview(pokemonInfoStackView)
        
        let padding: CGFloat = 16
        let width = UIScreen.main.bounds.width - padding * 2
        pokemonImageView.constraint(top: view.safeAreaLayoutGuide.snp.top, centerX: view.snp.centerX, size: .init(width: width, height: width))
        pokemonInfoStackView.constraint(top: pokemonImageView.snp.bottom, bottom: view.safeAreaLayoutGuide.snp.bottom, centerX: view.snp.centerX, size: .init(width: width, height: width))
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
}
