//
//  ContentView.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var exchangeViewModel = ExchangeViewModel()
    
    var body: some View {
        Text("result :  \(exchangeViewModel.exchangeModels.count)")
        List(exchangeViewModel.exchangeModels) { exchange in
            HStack {
                Text("\(exchange.cur_nm)")
                    .fontWeight(.bold)
                    .font(.system(size : 26))
                    .foregroundColor(.black)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
