//
//  TestView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/24.
//

import Foundation
import SwiftUI

struct TestView: View {
    
    @Binding var test: String
//    @State var test2: Int
    var number: Int

//    init(test: Binding<String> = .constant(""), _ number: Int) {
//        _test = test
//        self.number = number
//    }
    
    var body: some View {
        Text("number \(number) test \(test + String(describing: number))")
    }
}
