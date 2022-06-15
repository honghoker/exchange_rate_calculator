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
}

class StandardCountryModel: Object {
    @objc dynamic var currencyCode = "" // 통화코드 ex) "USD"
}
