//
//  exchange_rate_calculatorApp.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import SwiftUI
import Firebase

@main
struct exchange_rate_calculatorApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            TabBarView().environmentObject(ExchangeViewModel())
        }
    }
}
