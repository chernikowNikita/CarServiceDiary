//
//  Colors.swift
//  CarServiceDiary
//
//  Created by Никита Черников on 06/12/2019.
//  Copyright © 2019 Никита Черников. All rights reserved.
//

import UIKit

extension UIColor {
    var grey: UIColor {
        get {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
    }
    var customYellow: UIColor {
        get {
            return UIColor.colorFromHex("#FFDD00")!
        }
    }
}

// MARK: - Hex Color
extension UIColor {
    public static func colorFromHex(_ hex: String) -> UIColor? {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    let color = self.init(red: r, green: g, blue: b, alpha: a)
                    return color
                }
            }
        }

        return nil
    }
}
