//
//  Extentions.swift
//  FamPayAssignment
//
//  Created by Arnav Singhal on 19/03/24.
//

import SwiftUI

// MARK: COLOR
extension Color {
    init?(hex: String?) {
        if let hex {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            
            var rgb: UInt64 = 0
            
            var r: CGFloat = 0.0
            var g: CGFloat = 0.0
            var b: CGFloat = 0.0
            var a: CGFloat = 1.0
            
            let length = hexSanitized.count
            
            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
            
            if length == 6 {
                r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
                g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
                b = CGFloat(rgb & 0x0000FF) / 255.0
                
            } else if length == 8 {
                r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
                g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
                b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
                a = CGFloat(rgb & 0x000000FF) / 255.0
                
            } else {
                self.init(red: 255, green: 255, blue: 255, opacity: 1)
            }
            
            self.init(red: r, green: g, blue: b, opacity: a)
        } else {
            self.init(red: 255, green: 255, blue: 255, opacity: 1)
        }
    }
}
