//
//  TestView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/24.
//

import Foundation
import SwiftUI

struct TestView: View {
    @ObservedObject var testViewModel = TestViewModel()
    @Binding var test: Int
    var number: Int
    var result = 0

    init(test: Binding<Int>, _ number: Int) {
        self._test = test
        self.number = number
        testViewModel.chagne(number)
    }
    
    var body: some View {
        Text("\(test * testViewModel.viewModelValue)")
//            .lineLimit(1)
    }
}

