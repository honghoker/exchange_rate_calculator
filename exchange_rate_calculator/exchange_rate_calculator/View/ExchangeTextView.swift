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
    
    init(inputValue: Binding<String>, _ basePrice: Binding<[DunamuModel]>, _ number: Int, _ standardCountry: Binding<String>, _ standardCountryBasePrice: Binding<Double>) {
        self._inputValue = inputValue
        self._basePrices = basePrice
        self.number = number
        self._standardCountry = standardCountry // 기준국가
        self._standardCountryBasePrice = standardCountryBasePrice // 기준국가 매매기준율
    }
    
    //    if 일본, 베트남, 인도네시아 :
    //
    //    ((기준통화 / 상대통화) * 100) * 입력값
    //
    //    else
    //
    //    (기준통화 / 상대통화) * 입력값
    
    var body: some View {
        // 성훈 -> 일본, 베트남, 인도네시아 == * 100 예외처리 + 값 디버깅
        if !basePrices.isEmpty {
            //            Text("\(Double(inputValue == "" ? "0" : inputValue)! / basePrices[number].basePrice, specifier: "%.2f")")
            Text("\(Double((standardCountryBasePrice / basePrices[number].basePrice) * Double(inputValue == "" ? "0" : inputValue)!), specifier: "%.2f")")
                .font(.custom("IBMPlexSansKR-Regular", size: 20))
        }
    }
    
    func testCalculate() {
        
    }
}
