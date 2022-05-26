//
//  jsonTest.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import SwiftUI
import FlagKit

struct JsonTest: View {
    @ObservedObject var dunamuViewModel = DunamuViewModel()
    
    var body: some View {
        Text("@@@@")
        List(dunamuViewModel.dunamuModels) { dunamu in
            
            
            let endIdx = dunamu.currencyCode.index(dunamu.currencyCode.startIndex, offsetBy: 1)
            let result = String(dunamu.currencyCode[...endIdx])
            let flag = Flag(countryCode: result)
            let originalImage = flag?.originalImage
            
            Button(action: {
//                print("\(exchange.cur_nm), 받으실 때 : \(exchange.ttb), 보내실 때 : \(exchange.tts) ")
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
                        Text("\(dunamu.currencyCode)")
                            .fontWeight(.bold)
                            .font(.system(size : 20))
                            .foregroundColor(.black)
                        
//                        Text("\(dunamu.name) \(dunamu.currencyName)")
//                            .fontWeight(.medium)
//                            .font(.system(size : 14))
//                            .foregroundColor(.gray)
                        
//                        Text("\(dunamu.country) \(dunamu.currencyName)")
//                            .fontWeight(.medium)
//                            .font(.system(size : 14))
//                            .foregroundColor(.gray)
                    }
                    Spacer()
//                    VStack(spacing: 4) {
//                        Text("매매기준율")
//                            .fontWeight(.light)
//                            .font(.system(size : 12))
//                            .foregroundColor(.black)
//                        Text("\(exchange.kftc_deal_bas_r)")
//                            .fontWeight(.bold)
//                            .font(.system(size : 12))
//                            .foregroundColor(.black)
//                    }
                }
                .padding(.vertical, 12)
            })
        }
        .listStyle(.plain)
    }
}
