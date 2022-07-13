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
    
    var number = 0
    
    @Binding var inputValue: String
    @Binding var basePrices: [DunamuModel]
    @Binding var standardCountry: String
    @Binding var standardCountryBasePrice: Double
    
    var dunamuModels = [DunamuModel]()
    var standardCountryWrappedValue = ""
    
    init(inputValue: Binding<String>, _ basePrice: Binding<[DunamuModel]>, _ number: Int, _ standardCountry: Binding<String>, _ standardCountryBasePrice: Binding<Double>) {
        self._inputValue = inputValue
        self._basePrices = basePrice
        self.number = number
        self._standardCountry = standardCountry // 기준국가
        standardCountryWrappedValue = standardCountry.wrappedValue
        self._standardCountryBasePrice = standardCountryBasePrice // 기준국가 매매기준율
    }
    
    var body: some View {
        if !basePrices.isEmpty {
            if standardCountryWrappedValue == "JPY" || standardCountryWrappedValue == "VND" || standardCountryWrappedValue == "IDR" {
                if basePrices[number].currencyCode == "JPY" || basePrices[number].currencyCode == "VND" || basePrices[number].currencyCode == "IDR" {
                    Text("\(Double((standardCountryBasePrice / basePrices[number].basePrice) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                        .font(.custom("IBMPlexSansKR-Regular", size: 20))
                        .lineLimit(1)
                } else {
                    Text("\(Double((standardCountryBasePrice / basePrices[number].basePrice / 100) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                        .font(.custom("IBMPlexSansKR-Regular", size: 20))
                        .lineLimit(1)
                }
            } else {
                if basePrices[number].currencyCode == "JPY" || basePrices[number].currencyCode == "VND" || basePrices[number].currencyCode == "IDR" {
                    Text("\(Double((standardCountryBasePrice / basePrices[number].basePrice * 100) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                        .font(.custom("IBMPlexSansKR-Regular", size: 20))
                        .lineLimit(1)
                } else {
                    Text("\(Double((standardCountryBasePrice / basePrices[number].basePrice) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                        .font(.custom("IBMPlexSansKR-Regular", size: 20))
                        .lineLimit(1)
                }
            }
        }
    }
}
