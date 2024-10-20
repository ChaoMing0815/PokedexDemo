//
//  HomePageTableViewCell.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/10/18.
//

import Foundation
import UIKit

class HomePageTableViewCell: UITableViewCell {
    
    lazy var label = makeLabel()
    lazy var iconView = makeIconView()
    
    lazy var stackView = makeStackView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    
        
        setupLayout()
    }
}

// MARK: - Layout
private extension HomePageTableViewCell {
    func setupLayout() {
        let views = [iconView, label]
        views.forEach { stackView.addArrangedSubview( $0 )}
        
        contentView.addSubview(stackView)
        stackView.constraint(top: contentView.snp.top, bottom: contentView.snp.bottom, left: contentView.snp.left, right: contentView.snp.right, padding: .init(top: 16, left: 16, bottom: 16, right: 0))
        iconView.constraint(top: contentView.snp.top, bottom: contentView.snp.bottom, left: contentView.snp.left, padding: .init(top: 16, left: 16, bottom: 16, right: 0))
        label.constraint(top: contentView.snp.top, bottom: contentView.snp.bottom, left: iconView.snp.left, right: contentView.snp.right, padding: .init(top: 8, left: 64, bottom: 8, right: 0))
    }
}

// MARK: - Internal Methods
extension HomePageTableViewCell {
    func configureCell(with cellModel: HomePageCellModel) {
        label.text = cellModel.labelText
        label.textColor = .white
        iconView.image = UIImage(named: "Pokeball")
    }
}

// MARK: - Factory Methods
extension HomePageTableViewCell {
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }
    
    func makeIconView() -> UIImageView {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        return iconView
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }
    
}


