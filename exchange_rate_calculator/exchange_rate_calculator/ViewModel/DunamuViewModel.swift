//
//  DunamuViewModel.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import Foundation
import Alamofire
import Combine
import RealmSwift

class DunamuViewModel: ObservableObject {
    let realm = try! Realm()
    
    var subsription = Set<AnyCancellable>()
    
    @Published var dunamuModels = [DunamuModel]()
    @Published var standardCountry = "KRW"
    @Published var standardCountryBasePrice = 0.0
    
    var refreshActionSubject = PassthroughSubject<(), Never>()
    
    let koreaTemp = DunamuModel(code: "", currencyCode: "KRW", currencyName: "원", country: "대한민국", name: "", date: "", time: "", recurrenceCount: 1, basePrice: 1, openingPrice: 1, highPrice: 1, lowPrice: 1, change: "", changePrice: 1, cashBuyingPrice: 1, cashSellingPrice: 1, ttBuyingPrice: 1, ttSellingPrice: 1, tcBuyingPrice: 1, fcSellingPrice: 1, exchangeCommission: 1, usDollarRate: 1, high52wPrice: 1, high52wDate: "", low52wPrice: 1, low52wDate: "", currencyUnit: 1, provider: "", timestamp: 1, id: -99, createdAt: "", modifiedAt: "", changeRate: 1, signedChangePrice: 1, signedChangeRate: 1)
    
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
        
        // MARK: - FRX.(기준나라)(대상나라)
        let baseCountryCode = "KRW"
        let resultMap = currencyCodeList.map({ String("FRX.\(baseCountryCode)\($0)") })
        let codes = resultMap.joined(separator: ",")
        
        print(codes)
        AF.request(Dunamu.getAll(codes: codes))
            .publishDecodable(type: [DunamuModel].self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { completion in
                print("데이터스트림 완료")
                // 성훈 -> standardCountr == KRW 면 dunamuModels 에 KRW 없어서 매매기준율 따로 값 줘서 예외처리해야함
                let standardCountryBasePrice = self.dunamuModels.filter{ $0.currencyCode == self.standardCountry}
                self.standardCountryBasePrice = standardCountryBasePrice[0].basePrice
                print("MARK: - realm으로 기준나라코드 매매기준율 가져오기 \(standardCountryBasePrice[0].basePrice)")
            }, receiveValue: { receiveValue in
                var result = [self.koreaTemp]
                result += receiveValue
                print("@@@@@@@ result : \(result)")
                self.dunamuModels = result
            }).store(in: &subsription)
        
        // standardCountry ->
        
        // MARK: - realm으로 기준나라코드 가져오기
        let standardCountryArray = Array(realm.objects(StandardCountryModel.self))
        if !standardCountryArray.isEmpty {
            for item in standardCountryArray {
                standardCountry = item.currencyCode
            }
            print("MARK: - realm으로 기준나라코드 가져오기 \(standardCountry)")
        }
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
