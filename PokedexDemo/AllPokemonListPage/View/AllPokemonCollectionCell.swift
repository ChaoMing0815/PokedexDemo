//
//  AllPokemonCollectionCell.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/5/8.
//

import Foundation
import UIKit

class AllPokemonCollectionCell: UICollectionViewCell {
    lazy var nameLabel = makeNameLabel()
    lazy var pokeImage = makeImageView()
    lazy var background = makeBackgroundView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentView.addSubview(background)
        background.constraint(top: contentView.snp.top, bottom: contentView.snp.bottom, left: contentView.snp.left, size: .init(width: 80, height: 160))
        background.addSubview(nameLabel)
        background.addSubview(pokeImage)
        nameLabel.constraint(bottom: background.snp.bottom, centerX: background.snp.centerX, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        pokeImage.constraint(top: background.snp.top, bottom: background.snp.bottom, left: background.snp.left, right: background.snp.right, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        pokeImage.contentMode = .center
        
    }
}

extension AllPokemonCollectionCell {
    fileprivate func makeNameLabel() -> UILabel {
        let nameLabel = UILabel()
        return nameLabel
    }
    
    fileprivate func makeImageView() -> UIImageView {
        let pokeImageView = UIImageView()
        pokeImageView.backgroundColor = .blue
        return pokeImageView
    }
    
    fileprivate func makeBackgroundView() -> UIView {
        let backgroundView = UIView()
        return backgroundView
    }
}
