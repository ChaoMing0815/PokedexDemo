//
//  AllPokemonListCell.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/21.
//

import UIKit

class AllPokemonListCell: UITableViewCell {
    lazy var nameLabel = makeNameLabel()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentView.addSubview(nameLabel)
        nameLabel.constraint(top: contentView.snp.top, bottom: contentView.snp.bottom, left: contentView.snp.left)
    }
}

extension AllPokemonListCell {
    func makeNameLabel() -> UILabel {
        let nameLabel = UILabel()
        return nameLabel
    }
    
    func setupData(with cellModel: AllPokemonListViewModel, indexPath: IndexPath) {
        nameLabel.text = cellModel.allPokemonNames[indexPath.row]
    }
}
