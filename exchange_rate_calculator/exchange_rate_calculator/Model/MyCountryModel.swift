//
//  MyCountryModel.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/26.
//

import Foundation
import RealmSwift

class MyCountryModel: Object {
    @objc dynamic var cur_unit = ""
    @objc dynamic var cur_nm = ""
    
//    override static func primaryKey() -> String? {
//        return "cur_unit"
//    }
}
