//
//  TeseViewModel.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/25.
//

import Foundation

class TestViewModel: ObservableObject {
    @Published var viewModelValue = 0

    func chagne(_ value: Int) {
        viewModelValue =  10 * value
    }
}
