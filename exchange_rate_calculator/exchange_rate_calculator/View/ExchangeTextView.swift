//
//  TestView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/24.
//

import Foundation
import SwiftUI

struct ExchangeTextView: View {
    @Binding var inputValue: String
    var result = 0
    @Binding var basePrices: [DunamuModel]
    var number = 0
    var currencyCode = ""
    
    init(inputValue: Binding<String>, _ basePrice: Binding<[DunamuModel]>, _ number: Int, _ currencyCode: String) {
        self._inputValue = inputValue
        self._basePrices = basePrice
        self.number = number
        self.currencyCode = currencyCode
    }
    
    var body: some View {
        if !basePrices.isEmpty {
            Text("\(Double(inputValue == "" ? "0" : inputValue)! / basePrices[number].basePrice, specifier: "%.4f")")
        }
    }
}

