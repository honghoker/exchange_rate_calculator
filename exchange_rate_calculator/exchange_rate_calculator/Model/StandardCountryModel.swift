//
//  StandardCountryModel.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/07/07.
//

import Foundation
import RealmSwift

class StandardCountryModel: Object {
    @objc dynamic var id = 1
    @objc dynamic var currencyCode = "" // 통화코드 ex) "USD"
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
