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
    var basePrices: DunamuModel
//    @Binding var basePrices: [DunamuModel]
//    @ObservedObject var exchangeViewModel = ExchangeViewModel() // 내가 추가한 메인에 보이는 국가 리스트
    var number = 0
    var currencyCode = ""
    
    init(inputValue: Binding<String>, _ basePrice: DunamuModel, _ number: Int, _ currencyCode: String) {
        self._inputValue = inputValue
        self.basePrices = basePrice
//        self._basePrices = basePrice
        self.number = number
        self.currencyCode = currencyCode
    }
    
    var body: some View {
        Text("\(basePrices.basePrice)")
//        if !basePrices.isEmpty {
//            Text("\(basePrices[number].basePrice)")
////            Text("\(exchangeViewModel.basePrice[number].basePrice)")
////            Text("\(Double(inputValue == "" ? "0" : inputValue)! / basePrices[number].basePrice, specifier: "%.4f")")
//        }
    }
}

