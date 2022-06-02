//
//  DunamuListView.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/31.
//

import Foundation
import SwiftUI
import FlagKit
 
struct DunamuRowView: View {
    
    var dunamu: DunamuModel
    
    init(_ dunamu: DunamuModel) {
        self.dunamu = dunamu
    }
    
    var body: some View {
        let endIdx = dunamu.currencyCode.index(dunamu.currencyCode.startIndex, offsetBy: 1)
        let result = String(dunamu.currencyCode[...endIdx])
        let flag = Flag(countryCode: result)
        let originalImage = flag?.originalImage

        Button(action: {
            print(dunamu.currencyCode)
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
                    if dunamu.country != nil {
                        Text("\(dunamu.country!) \(dunamu.currencyName!)")
                            .fontWeight(.medium)
                            .font(.system(size : 14))
                            .foregroundColor(.gray)
                        Text("\(dunamu.name!)")
                            .fontWeight(.medium)
                            .font(.system(size : 14))
                            .foregroundColor(.gray)
                    }
                    
                } // VStack
                Spacer()
                VStack(spacing: 4) {
                    Text("매매기준율")
                        .fontWeight(.light)
                        .font(.system(size : 12))
                        .foregroundColor(.black)
                    Text("\(String(format: "%.2f", dunamu.basePrice))")
                        .fontWeight(.bold)
                        .font(.system(size : 12))
                        .foregroundColor(.black)
                } // VStack
                VStack(spacing: 4) {
                    Text("전일대비")
                        .fontWeight(.light)
                        .font(.system(size : 12))
                        .foregroundColor(.black)
                    if(dunamu.change == "RISE") {
                        HStack(spacing: 2) {
                            Image(systemName: "arrowtriangle.up.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 10))
                            Text("\(String(format: "%.2f", dunamu.changePrice))")
                                .fontWeight(.medium)
                                .font(.system(size: 12))
                                .foregroundColor(.red)
                        }
                    } else {
                        HStack(spacing: 2) {
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 10))
                            Text("\(String(format: "%.2f", dunamu.changePrice))")
                                .fontWeight(.medium)
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }
                    }
                } // VStack
            } // HStack
            .padding(.vertical, 12)
        }) // Button
    } // View
}
