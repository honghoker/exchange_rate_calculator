//
//  DunamuViewModel.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import Foundation
import Alamofire
import Combine

class DunamuViewModel: ObservableObject {
    var subsription = Set<AnyCancellable>()
    
    @Published var dunamuModels = [DunamuModel]()
    
    var refreshActionSubject = PassthroughSubject<(), Never>()
    
    init() {
        print(#fileID, #function, #line, "")
        fetchAllDunamu()
        
        refreshActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchAllDunamu()
        }.store(in: &subsription)
    }
    
    fileprivate func fetchAllDunamu() { // 모든
        print(#fileID, #function, #line, "")
        // MARK: - realm으로 기준나라코드 가져오기
        let baseCountryCode = "KRW"
        // MARK: - FRX.(기준나라)(대상나라)
        
        let resultMap = currencyCodeList.map({ String("FRX.\(baseCountryCode)\($0)") })
        let codes = resultMap.joined(separator: ",")
        
        print(codes)
        AF.request(Dunamu.getAll(codes: codes))
            .publishDecodable(type: [DunamuModel].self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { completion in
                print("데이터스트림 완료")
            }, receiveValue: { receiveValue in
                self.dunamuModels = receiveValue
            }).store(in: &subsription)
    }
    
    fileprivate func fetchMyDunamu() { // 사용자가 추가한 나라만
        print(#fileID, #function, #line, "")
        // MARK: - realm으로 기준나라코드 가져오기
        let baseCountryCode = "KRW"
        // MARK: - realm으로 저장된 나라들 가져오기
        let myCountryCode = ["USD", "JPY", "EUR"]
        
        let resultMap = myCountryCode.map({  String("FRX.\(baseCountryCode)\($0)") })
        let codes = resultMap.joined(separator: ",")
        
        print(codes)
        AF.request(Dunamu.getMy(codes: codes))
            .publishDecodable(type: [DunamuModel].self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { completion in
                print("데이터스트림 완료")
            }, receiveValue: { receiveValue in
                self.dunamuModels = receiveValue
            }).store(in: &subsription)
    }
}
