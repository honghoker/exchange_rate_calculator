//
//  StandardCountryManager.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/07/06.
//

import Foundation
import RealmSwift

//struct StandardCountryManager {
//    private init() {}
//    static let shared = StandardCountryManager()
//    
//    var object = BindableResults(results: RealmManager.shared.realm.objects(StandardCountryModel.self))
//    
//    func getStandardCurrencyCode() -> String {
//        return object.results.first!.currencyCode
//    }
//    
//    func setStandardCurrencyCode(_ currencyCode: String) {
//        RealmManager.shared.update(object.results.first!, with: ["currencyCode": currencyCode])
//    }
//    
//    func isEqualTo(_ currencyCode: String) -> Bool {
//        return object.results.first!.currencyCode == currencyCode ? true : false
//    }
//}
