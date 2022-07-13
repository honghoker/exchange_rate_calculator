//
//  ExchangeFlagView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/06/02.
//

import Foundation
import SwiftUI
import FlagKit

struct ExchangeFlagView: View {
    var currencyCode: String
    
    init(_ currencyCode: String) {
        self.currencyCode = currencyCode
    }

    var body: some View {
        // MARK: - realm으로 저장된 나라들 가져오기
        let dropLast = currencyCode.dropLast()
        let result = String(dropLast)
        let flag = Flag(countryCode: result)
        let originalImage = flag?.originalImage
        
        if originalImage != nil {
            Image(uiImage: originalImage!)
                .resizable()
                .clipShape(Circle())
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
        
    }
}
