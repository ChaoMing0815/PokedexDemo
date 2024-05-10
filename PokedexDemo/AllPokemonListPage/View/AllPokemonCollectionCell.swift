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
    }
}

extension AllPokemonCollectionCell {
    fileprivate func makeNameLabel() -> UILabel {
        let nameLabel = UILabel()
        return nameLabel
    }
    
    fileprivate func makeImageView() -> UIImageView {
        let pokeImageView = UIImageView()
        return pokeImageView
    }
    
    fileprivate func makeBackgroundView() -> UIView {
        let backgroundView = UIView()
        return backgroundView
    }
}
