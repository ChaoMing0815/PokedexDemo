//
//  UIView+SnapKit.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/4/17.
//

import SnapKit
import UIKit

extension UIView {
    func constraint (
        top: ConstraintRelatableTarget? = nil,
        bottom: ConstraintRelatableTarget? = nil,
        left: ConstraintRelatableTarget? = nil,
        right: ConstraintRelatableTarget? = nil,
        centerX: ConstraintRelatableTarget? = nil,
        centerY: ConstraintRelatableTarget? = nil,
        padding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0),
        size: CGSize? = nil) {
            self.snp.makeConstraints {
                //  unwrapped, 確認optional value是否為nil
                if let top {
                    $0.top.equalTo(top).offset(padding.top)
                }
                
                if let bottom {
                    $0.bottom.equalTo(bottom).offset(-padding.bottom)
                }
                
                if let left {
                    $0.left.equalTo(left).offset(padding.left)
                }
                
                if let right {
                    $0.right.equalTo(right).offset(-padding.right)
                }
                
                if let centerX {
                    $0.centerX.equalTo(centerX)
                }
                
                if let centerY {
                    $0.centerY.equalTo(centerY)
                }
                
                if let size {
                    if size.width != 0 {
                        $0.width.equalTo(size.width)
                    }
                    if size.height != 0 {
                        $0.height.equalTo(size.height)
                    }
                }
            }
            
    }
    
    func fillWithPadding(with padding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
        if let superview = superview {
            constraint(
                top: superview.snp.top,
                bottom: superview.snp.bottom,
                left: superview.snp.left,
                right: superview.snp.right,
                padding: padding
            )
        }
    }
    
    func fillWithCenter(with size: CGSize? = nil) {
        guard let superview = self.superview else {
            return
        }
        constraint(
            centerX: superview.snp.centerX,
            centerY: superview.snp.centerY,
            size: size
        )
    }
}
