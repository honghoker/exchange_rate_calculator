//
//  MyCountryModel.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/26.
//

import Foundation
import RealmSwift

class BindableResults<Element>: ObservableObject where Element: RealmSwift.RealmCollectionValue {

    @Published var results: Results<Element>
    private var token: NotificationToken!

    init(results: Results<Element>) {
        self.results = results
        lateInit()
    }

    func lateInit() {
        token = results.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    deinit {
        token.invalidate()
    }
}

class MyCountryModel: Object {
    @objc dynamic var currencyCode = "" // 통화코드 ex) "USD"
//    @objc dynamic var country = "" // 나라 ex) "미국"
//    @objc dynamic var currencyName = "" // 통화이름 ex) "달러"
//    @objc dynamic var basePrice = 0.0 // 매매기준율 ex) 1268.00
}
