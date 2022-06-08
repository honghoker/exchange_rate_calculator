//
//  Extensions.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/06/08.
//

import Foundation

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
