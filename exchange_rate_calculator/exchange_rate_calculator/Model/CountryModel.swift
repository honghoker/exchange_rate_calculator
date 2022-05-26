//
//  CountryModel.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import Foundation

struct CountryModel: Codable {
    let key: Int
    let currencyCode: String
    let currencyName: String
    let country: String
}
