//
//  BindableResults.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/07/07.
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
