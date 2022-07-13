//
//  TestView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/24.
//

import Foundation
import SwiftUI

// 입력한 값에 맞춰서 각 나라의 환율로 계산한 Text
struct ExchangeTextView: View {
    @Binding var inputValue: String
    var dunamuModel: DunamuModel
    var standardCountry: String
    var standardCountryBasePrice: Double

    var body: some View {
        if dunamuModel.currencyCode == "JPY" || dunamuModel.currencyCode == "VND" || dunamuModel.currencyCode == "IDR" {
            if standardCountry == "JPY" || standardCountry == "VND" || standardCountry == "IDR" {
                Text("\(Double((standardCountryBasePrice / dunamuModel.basePrice) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                    .font(.custom("IBMPlexSansKR-Regular", size: 20))
                    .lineLimit(1)
            } else {
                Text("\(Double((standardCountryBasePrice / dunamuModel.basePrice * 100) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                    .font(.custom("IBMPlexSansKR-Regular", size: 20))
                    .lineLimit(1)
            }
        } else {
            if standardCountry == "JPY" || standardCountry == "VND" || standardCountry == "IDR" {
                Text("\(Double((standardCountryBasePrice / dunamuModel.basePrice * 100) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                    .font(.custom("IBMPlexSansKR-Regular", size: 20))
                    .lineLimit(1)
            } else {
                Text("\(Double((standardCountryBasePrice / dunamuModel.basePrice) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                    .font(.custom("IBMPlexSansKR-Regular", size: 20))
                    .lineLimit(1)
            }
        }
    }
}
