//
//  UIImage+DomainColorExtension.swift
//  PokedexDemo
//
//  Created by 黃昭銘 on 2024/5/16.
//

import UIKit

extension UIImage {
    func getDominantColor(brightnessAdjustment adjustBrightness: CGFloat = 0.0) -> UIColor {
        var mostCommonColor: UIColor
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: 1, height: 1))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(CIImage(image: resizedImage!)!, from: CIImage(image: resizedImage!)!.extent)
        let pixelData = cgImage?.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let r = CGFloat(data[0]) / 255
        let g = CGFloat(data[1]) / 255
        let b = CGFloat(data[2]) / 255
        let color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        // 转换为HSB颜色空间来检测亮度和饱和度
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        // 调整亮度
        brightness = max(min(brightness + adjustBrightness, 1.0), 0.0) // 确保亮度在有效范围内
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha) // 返回调整后的颜色
        
    }
}
