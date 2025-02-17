//
//  Extension+UIColor.swift
//  movies-db
//
//  Created by Heinar Kuulme on 16/02/25.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
         var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
         if hexSanitized.hasPrefix("#") {
             hexSanitized.remove(at: hexSanitized.startIndex)
         }
         var rgb: UInt64 = 0
         Scanner(string: hexSanitized).scanHexInt64(&rgb)
         let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
         let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
         let b = CGFloat(rgb & 0xFF) / 255.0
         self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
