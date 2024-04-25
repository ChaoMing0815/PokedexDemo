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
        setupLayout()
    }
}

extension AllPokemonListCell {
    fileprivate func setupLayout() {
        contentView.addSubview(nameLabel)
        nameLabel.constraint(top: contentView.snp.top, bottom: contentView.snp.bottom, left: contentView.snp.left)
    }
    fileprivate func makeNameLabel() -> UILabel {
        let nameLabel = UILabel()
        return nameLabel
    }
}

extension AllPokemonListCell {
    func configureCell(with cellModel: AllPokemonListCellModel) {
        nameLabel.text = cellModel.name
    }
}
