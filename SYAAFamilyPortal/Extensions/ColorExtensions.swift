//
//  ColorExtensions.swift
//  SYAAFamilyPortal
//
//  Created by Walter Allen on 10/8/20.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        var r, g, b, a: Double
        (r, g, b, a) = (0, 0, 0, 0)
        
        var hexColor = hex
                
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        }
        
        if hexColor.count == 6 {
            hexColor += "FF"
        }
        
        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = Double((hexNumber & 0xff000000) >> 24) / 255
                g = Double((hexNumber & 0x00ff0000) >> 16) / 255
                b = Double((hexNumber & 0x0000ff00) >> 8) / 255
                a = Double(hexNumber & 0x000000ff) / 255

                self.init(.sRGB, red: r, green: g, blue: b, opacity: a)

                return
            }
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
        return
    }
        
    
    func hexValue(withHash: Bool) -> String {
        let (outputR, outputG, outputB) = self.getComponents()
        
        return (withHash ? "#" : "")
            + String(format:"%02X", outputR)
            + String(format:"%02X", outputG)
            + String(format:"%02X", outputB)
    }
    
    func getComponents() -> (Int, Int, Int) {
        let values = self.cgColor?.components
        
        let outputR: Int = Int(255 * values![0])
        let outputG: Int = Int(255 * (values!.count < 3
                                ? values![0] : values![1]))
        let outputB: Int = Int(255 * (values!.count < 3
                                ? values![0] : values![2]))
        
        return (outputR, outputG, outputB)
    }
    
    func getBrightness() -> Double {
        let (r, g, b) = self.getComponents()
        return (Double(r + g + b) / 3.0) / 255
    }
}

