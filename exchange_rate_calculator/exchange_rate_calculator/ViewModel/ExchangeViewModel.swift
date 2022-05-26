//
//  ExchangeViewModel.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import Foundation
import Alamofire
import Combine

class ExchangeViewModel: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var exchangeModels = [ExchangeModel]()
    
    init() {
        print(#fileID, #function, #line, "")
        fetchExchangeRate()
    }
    
    fileprivate func fetchExchangeRate() {
        print(#fileID, #function, #line, "")
        AF.request(KoreaExim.getExchangeRate)
            .publishDecodable(type: [ExchangeModel].self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { completion in
                print("데이터스트림 완료")
            }, receiveValue: { receiveValue in
                self.exchangeModels = receiveValue
            }).store(in: &subscription)
    }
}
