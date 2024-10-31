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
    lazy var heightIcon = makeImageView()
    lazy var heightLabel = makeLabel()
    lazy var weightIcon = makeImageView()
    lazy var weightLabel = makeLabel()
    lazy var typeIcon1 = makeImageView()
    lazy var typeIcon2 = makeImageView()
    lazy var bgView = makeBackGroudView()
    
    lazy var idAndNameStackView = makeStackView(with: .horizontal, arrangeSubViews: [idLabel, nameLabel])
    lazy var heightAndWeightStackView = makeStackView(with: .horizontal, arrangeSubViews: [heightIcon, heightLabel, weightIcon, weightLabel])
    lazy var typeIconStackView = makeStackView(with: .horizontal, arrangeSubViews: [typeIcon1, typeIcon2])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setBGColor(with: bgView)
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        
    }
}

// MARK: - Internal Methods
extension PokemonInfoCell {
    func configureCell(with cellModel: PokemonInfoCellModel) {
        idLabel.text = String("# \(cellModel.id)")
        nameLabel.text = String("\(cellModel.name)")
        nameLabel.text = nameLabel.text?.capitalized
        heightIcon.image = UIImage(named: "HeightIcon")
        heightLabel.text = String("\(Float(cellModel.height) / 10) m")
        weightIcon.image = UIImage(named: "WeightIcon")
        weightLabel.text =  String("\(Float(cellModel.weight) / 10) kg")
        
        if let imageData = cellModel.imageData {
            let image = UIImage(data: imageData)
            pokemonImageView.image = image
        }
        
        setTypeIcon(with: cellModel)
    }
    
    func updateImage(with cellModel: PokemonInfoCellModel, isShinyEnabled: Bool) {
        if isShinyEnabled {
            if let shinyImageData = cellModel.shinyImageData {
                let shinyImage = UIImage(data: shinyImageData)
                // 加入動畫轉換效果
                UIView.transition(with: pokemonImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: { self.pokemonImageView.image = shinyImage })
            }
        } else {
            if let imageData = cellModel.imageData {
                let image = UIImage(data: imageData)
                UIView.transition(with: pokemonImageView, duration: 0.3, options: .transitionFlipFromLeft, animations: { self.pokemonImageView.image = image })
            }
        }
    }
}

// MARK: - Layout
extension PokemonInfoCell {
    fileprivate func setupLayout() {
        [bgView, pokemonImageView, typeIconStackView, idAndNameStackView, heightAndWeightStackView].forEach { contentView.addSubview($0) }
        
        bgView.constraint(top: contentView.snp.top, bottom: contentView.snp.bottom, left: contentView.snp.left, right: contentView.snp.right, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        // pokemonImage Layout
        let padding: CGFloat = 16
        let width = UIScreen.main.bounds.width - padding * 2
        pokemonImageView.constraint(top: contentView.snp.top, centerX: contentView.snp.centerX, size: .init(width: width, height: width))
       
        // typeIcon Layout
        let iconEdge: CGFloat = 36
        typeIconStackView.constraint(top: pokemonImageView.snp.bottom, bottom: idAndNameStackView.snp.top, centerX: contentView.snp.centerX, padding: .init(top: 16, left: 0, bottom: 16, right: 0), size: .init(width: (iconEdge * 2 + padding), height: iconEdge))
        typeIconStackView.alignment = .center
        typeIconStackView.spacing = padding
        if !typeIcon2.isHidden {
            typeIconStackView.distribution = .fillEqually
            typeIcon1.constraint(size: .init(width: iconEdge, height: iconEdge))
            typeIcon2.constraint(size: .init(width: iconEdge, height: iconEdge))
        } else {
            typeIcon1.constraint(size: .init(width: iconEdge, height: iconEdge))
        }
        
        // idAndName Layout
        idAndNameStackView.constraint(top: typeIconStackView.snp.bottom, bottom: heightAndWeightStackView.snp.top, centerX: contentView.snp.centerX, padding: .init(top: 16, left: 0, bottom: 16, right: 0))
        idAndNameStackView.alignment = .center
        idAndNameStackView.distribution = .fill
        idAndNameStackView.spacing = padding
        
        // 設定Label出使尺寸並使其可彈性變化
        idLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(60)
        }
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(100)
        }
        idLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // heightAndWeight Layout
        heightAndWeightStackView.constraint(top: idAndNameStackView.snp.bottom, centerX: contentView.snp.centerX, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        heightAndWeightStackView.alignment = .center
        heightAndWeightStackView.distribution = .fill
        heightAndWeightStackView.spacing = padding / 2
        heightIcon.constraint(size: .init(width: 24, height: 24))
        heightLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(80)
        }
        weightIcon.constraint(size: .init(width: 24, height: 24))
        weightLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.greaterThanOrEqualTo(80)
        }
        heightLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        weightLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
    }
}

// MARK: - Fatory Methods
extension PokemonInfoCell {
    func makeStackView(with axis: NSLayoutConstraint.Axis, arrangeSubViews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangeSubViews)
        stackView.axis = axis
        return stackView
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 24)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }
    
    func makeBackGroudView() -> UIView {
        let backgroundView = UIView()
        return backgroundView
    }
    
    func makeGradientLayer(with view: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.locations = [0.4, 1.0] //設置顏色過渡點，表示第一個顏色佔比60%
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // 漸層的起點
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1) // 漸層的終點
        return gradientLayer
    }
}

// MARK: - Helpers
extension PokemonInfoCell {
    private func setTypeIcon(with cellModel: PokemonInfoCellModel) {
        let numberOfTypes = cellModel.types.count
        // 先將屬性圖片設置為nil，防止重複使用cell造成數據殘留的錯誤顯示
        typeIcon1.image = nil
        typeIcon2.image = nil
        
        // 因為寶可夢至少有一種屬性，先將typeIcon2預設為隱藏
        typeIcon1.isHidden = false
        typeIcon2.isHidden = (numberOfTypes == 1)
        
        typeIcon1.image = UIImage(named: cellModel.types[0])
        if numberOfTypes == 2 {
            typeIcon2.image = UIImage(named: cellModel.types[1])
        }
    }
    
    private func setBGColor(with view: UIView) {
        if !typeIcon2.isHidden {
            let bgGradientLayer = makeGradientLayer(with: view)
            guard let bgColor1 = typeIcon1.image?.getDominantColor(brightnessAdjustment: 0.6),
                  let bgColor2 = typeIcon2.image?.getDominantColor(brightnessAdjustment: 0.4) else { return }
            bgGradientLayer.colors = [bgColor1.cgColor, bgColor2.cgColor]
            view.layer.insertSublayer(bgGradientLayer, at: 0)
        } else {
            let bgGradientLayer = makeGradientLayer(with: view)
            guard let bgColor1 = typeIcon1.image?.getDominantColor(brightnessAdjustment: 0.6),
                  let bgColor2 = typeIcon1.image?.getDominantColor(brightnessAdjustment: 0) else { return }
            bgGradientLayer.colors = [bgColor1.cgColor, bgColor2.cgColor]
            view.layer.insertSublayer(bgGradientLayer, at: 0)
        }
    }
}
