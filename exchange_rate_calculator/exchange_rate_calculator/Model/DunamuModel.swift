//
//  DunamuModel.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import Foundation

struct DunamuModel: Codable, Identifiable {
    let uuid = UUID()
    let code: String // "FRX.KRWUSD"
    let currencyCode: String // "USD"
    let currencyName: String? // "달러"
    let country: String? // "미국"
    let name: String? // "미국 (KRW/USD)"
    let date: String // "2022-05-26"
    let time: String // "15:26:23"
    let recurrenceCount: Int // 409
    let basePrice: Double // 1268.00
    let openingPrice: Double // 1263.30
    let highPrice: Double // 1269.30
    let lowPrice: Double // 1263.30
    let change: String // "FALL", "RISE"
    let changePrice: Double // 3.00
    let cashBuyingPrice: Double // 1290.19
    let cashSellingPrice: Double // 1245.81
    let ttBuyingPrice: Double // 1255.60
    let ttSellingPrice: Double // 1280.40
    let tcBuyingPrice: Double? // null
    let fcSellingPrice: Double? // null
    let exchangeCommission: Double // 2.8253
    let usDollarRate: Double // 1.0000
    let high52wPrice: Double // 1291.30
    let high52wDate: String // "2022-05-12"
    let low52wPrice: Double // 1126.10
    let low52wDate: String // "2021-06-30"
    let currencyUnit: Int // 1
    let provider: String? // "하나은행"
    let timestamp: Int // 1653546384151
    let id: Int // 79
    let createdAt: String // "2016-10-21T06:13:34.000+0000"
    let modifiedAt: String // "2022-05-26T06:26:24.000+0000"
    let changeRate: Double // 0.0023603462
    let signedChangePrice: Double // -3.00
    let signedChangeRate: Double // -0.0023603462
    
    private enum CodingKeys: CodingKey {
        case code,
        currencyCode, currencyName,
        country, name, date, time, recurrenceCount,
             basePrice, openingPrice, highPrice, lowPrice,
             change, changePrice, cashBuyingPrice, cashSellingPrice,
             ttBuyingPrice, ttSellingPrice, tcBuyingPrice, fcSellingPrice,
             exchangeCommission, usDollarRate, high52wPrice, high52wDate,
             low52wPrice, low52wDate, currencyUnit, provider, timestamp,
             id, createdAt, modifiedAt, changeRate, signedChangePrice, signedChangeRate
    }
}
