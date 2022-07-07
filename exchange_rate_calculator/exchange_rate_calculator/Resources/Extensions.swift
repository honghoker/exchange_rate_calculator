//
//  Extensions.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/06/08.
//

import Foundation
import SwiftUI

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3
        formatter.numberStyle = .decimal
        return formatter
    }
}

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Color {
    // hex Color
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
