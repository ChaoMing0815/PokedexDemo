//
//  PokemonInfoCell.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/10/9.
//

import Foundation
import UIKit

class PokemonInfoCell: UICollectionViewCell {
    lazy var pokemonImageView = makeImageView()
    lazy var idLabel = makeLabel()
    lazy var nameLabel = makeLabel()
    lazy var heightLabel = makeLabel()
    lazy var weightLabel = makeLabel()
    
    lazy var pokemonInfoStackView = makeLabelStackView(arrangeSubViews: [idLabel, nameLabel, heightLabel, weightLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods
extension PokemonInfoCell {
    func configureCell(with cellModel: PokemonInfoCellModel) {
        idLabel.text = String("ID: \(cellModel.id)")
        nameLabel.text = String("Name: \(cellModel.name)")
        nameLabel.text = nameLabel.text?.capitalized
        heightLabel.text = String("Height: \(cellModel.height)")
        weightLabel.text =  String("Weight: \(cellModel.weight)")
        if let imageData = cellModel.imageData {
            let image = UIImage(data: imageData)
            pokemonImageView.image = image
        }
    }
}

// MARK: - Layout
extension PokemonInfoCell {
    func setupLayout() {
        contentView.addSubview(pokemonImageView)
        contentView.addSubview(pokemonInfoStackView)
        
        let padding: CGFloat = 16
        let width = UIScreen.main.bounds.width - padding * 2
        pokemonImageView.constraint(top: contentView.snp.top, centerX: contentView.snp.centerX, size: .init(width: width, height: width))
        pokemonInfoStackView.constraint(top: pokemonImageView.snp.bottom, bottom: contentView.snp.bottom, left: contentView.snp.left, right: contentView.snp.right, size: .init(width: width, height: width))
    }
}

// MARK: - Fatory Methods
extension PokemonInfoCell {
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
