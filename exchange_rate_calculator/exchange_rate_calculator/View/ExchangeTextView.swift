//
//  TestView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/24.
//

import Foundation
import SwiftUI

// 입력한 값에 맞춰서 각 나라의 환율로 계산한 Text
struct ExchangeTextView: View {
    var number = 0

    @Binding var inputValue: String
    @Binding var basePrices: [DunamuModel]
    
    init(inputValue: Binding<String>, _ basePrice: Binding<[DunamuModel]>, _ number: Int) {
        self._inputValue = inputValue
        self._basePrices = basePrice
        self.number = number
    }
    
    var body: some View {
        if !basePrices.isEmpty {
            Text("\(Double(inputValue == "" ? "0" : inputValue)! / basePrices[number].basePrice, specifier: "%.4f")")
        }
    }
}
