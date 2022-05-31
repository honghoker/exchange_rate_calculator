//
//  TestView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/24.
//

import Foundation
import SwiftUI

struct ExchangeTextView: View {
    @ObservedObject var exchangeTextViewModel = ExchangeTextViewModel()
    @Binding var inputValue: String
    var number: Int // 국가 순서 (리스트) 번호
    var result = 0

    init(inputValue: Binding<String>, _ number: Int) {
        self._inputValue = inputValue
        self.number = number
        exchangeTextViewModel.chagne(number)
    }
    
    var body: some View {
        Text("\(Int(inputValue == "" ? "1000" : inputValue)! * exchangeTextViewModel.viewModelValue)")
//            .lineLimit(1)
    }
}

