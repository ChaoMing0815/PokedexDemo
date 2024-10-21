//
//  AllPokemonCollectionCell.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/5/8.
//

import Foundation
import UIKit

class PokemonCollectionCell: UICollectionViewCell {
    lazy var nameLabel = makeNameLabel()
    lazy var pokemonImageView = makeImageView()
    lazy var bgView = makeBackgroundView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }
}

// MARK: - Internal Methods
extension PokemonCollectionCell {
    func configureCell(with cellModel: PokemonListCellModel) {
        nameLabel.text = cellModel.name
        nameLabel.text = nameLabel.text?.capitalized
        if let imageData = cellModel.imageData {
            let image = UIImage(data: imageData)
            pokemonImageView.image = image
            
            let bgColor = image?.getDominantColor(brightnessAdjustment: 0.7) ?? .darkGray
            bgView.backgroundColor = bgColor
        }
       
    }
}
// MARK: - Layout
extension PokemonCollectionCell {
    fileprivate func setupLayout() {
        [bgView, nameLabel, pokemonImageView].forEach { contentView.addSubview($0) }
        bgView.fillWithPadding(with: .init(top: 16, left: 16, bottom: 0, right: 16))
        nameLabel.constraint(bottom: contentView.snp.bottom, left: contentView.snp.left, right: contentView.snp.right, padding: .init(top: 0, left: 8, bottom: 16, right: 8))
        pokemonImageView.constraint(top: contentView.snp.top, bottom: nameLabel.snp.top, left: contentView.snp.left, right: contentView.snp.right, padding: .init(top: -4, left: -4, bottom: 8, right: -4))
    }
}

// MARK: - Factory Methods
extension PokemonCollectionCell {
    fileprivate func makeNameLabel() -> UILabel {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.font = .boldSystemFont(ofSize: 20)
        return nameLabel
    }
    
    fileprivate func makeImageView() -> UIImageView {
        let pokeImageView = UIImageView()
        pokeImageView.contentMode = .scaleAspectFill
        return pokeImageView
    }
    
    fileprivate func makeBackgroundView() -> UIView {
        let backgroundView = UIView()
        return backgroundView
    }
}
