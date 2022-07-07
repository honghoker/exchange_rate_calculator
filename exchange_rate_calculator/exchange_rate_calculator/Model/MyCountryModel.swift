//
//  MyCountryModel.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/26.
//

import Foundation
import RealmSwift

class MyCountryModel: Object {
    @objc dynamic var currencyCode = "" // 통화코드 ex) "USD"
}
