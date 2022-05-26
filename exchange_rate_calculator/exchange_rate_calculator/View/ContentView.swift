//
//  ContentView.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import SwiftUI
import Combine
import FlagKit

struct ContentView: View {
    @ObservedObject var exchangeViewModel = ExchangeViewModel()

    var body: some View {
        List(exchangeViewModel.exchangeModels) { exchange in
            let endIdx = exchange.cur_unit.index(exchange.cur_unit.startIndex, offsetBy: 1)
            let result = String(exchange.cur_unit[...endIdx])
            let flag = Flag(countryCode: result)
            let originalImage = flag?.originalImage
            Button(action: {
                print("\(exchange.cur_nm), 받으실 때 : \(exchange.ttb), 보내실 때 : \(exchange.tts) ")
            }, label: {
                HStack {
                    if originalImage != nil {
                        Image(uiImage: originalImage!)
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    Spacer().frame(width: 12)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(exchange.cur_unit)")
                            .fontWeight(.bold)
                            .font(.system(size : 20))
                            .foregroundColor(.black)
                        Text("\(exchange.cur_nm)")
                            .fontWeight(.medium)
                            .font(.system(size : 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(spacing: 4) {
                        Text("매매기준율")
                            .fontWeight(.light)
                            .font(.system(size : 12))
                            .foregroundColor(.black)
                        Text("\(exchange.kftc_deal_bas_r)")
                            .fontWeight(.bold)
                            .font(.system(size : 12))
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical, 12)
            })
        }
        .listStyle(.plain)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
