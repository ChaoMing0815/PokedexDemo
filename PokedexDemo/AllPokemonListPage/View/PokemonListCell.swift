//
//  AllPokemonListCell.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/21.
//

import UIKit

class PokemonListCell: UITableViewCell {
    
    lazy var pokemonNameCellBackground = makeCellBackgroundView()
    lazy var nameLabel = makeNameLabel()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupLayout()
        
        contentView.backgroundColor = .clear
        pokemonNameCellBackground.backgroundColor = .clear
        nameLabel.text = nameLabel.text?.capitalized
        nameLabel.font = .boldSystemFont(ofSize: 22)
    }
}

extension PokemonListCell {
    fileprivate func setupLayout() {
        contentView.addSubview(pokemonNameCellBackground)
        pokemonNameCellBackground.addSubview(nameLabel)
        pokemonNameCellBackground.constraint(top: contentView.snp.top, bottom: contentView.snp.bottom, left: contentView.snp.left)
        nameLabel.constraint(top: pokemonNameCellBackground.snp.top, bottom: pokemonNameCellBackground.snp.bottom, left: pokemonNameCellBackground.snp.left, padding: .init(top: 8, left: 16, bottom: 8, right: 0))
    }
    
    fileprivate func makeCellBackgroundView() -> UIView {
        let view = UIView()
        return view
    }
    
    fileprivate func makeNameLabel() -> UILabel {
        let nameLabel = UILabel()
        return nameLabel
    }
}

extension PokemonListCell {
    func configureCell(with cellModel: PokemonListCellModel) {
        nameLabel.text = cellModel.name
    }
}
