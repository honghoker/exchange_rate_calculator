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
    var subsription = Set<AnyCancellable>()
    var standardCountrySubsription = Set<AnyCancellable>()
    var myCountrySubsription = Set<AnyCancellable>()
    var dragAndDropSubsription = Set<AnyCancellable>()
    
    @Published var dunamuModels = [DunamuModel]()
    @Published var myDunamuModels = [DunamuModel]()
    @Published var standardCountry: StandardCountryModel = StandardCountryModel()
    @Published var standardCountryBasePrice = 0.0
    
    var refreshActionSubject = PassthroughSubject<(), Never>()
    var standardCountrySubject = PassthroughSubject<String, Never>()
    var myCountrySubject = PassthroughSubject<(), Never>()
    var dragAndDropSubject = PassthroughSubject<(String, String), Never>()
    
    let koreaTemp = DunamuModel(code: "", currencyCode: "KRW", currencyName: "원", country: "대한민국", name: "", date: "", time: "", recurrenceCount: 1, basePrice: 1, openingPrice: 1, highPrice: 1, lowPrice: 1, change: "", changePrice: 1, cashBuyingPrice: 1, cashSellingPrice: 1, ttBuyingPrice: 1, ttSellingPrice: 1, tcBuyingPrice: 1, fcSellingPrice: 1, exchangeCommission: 1, usDollarRate: 1, high52wPrice: 1, high52wDate: "", low52wPrice: 1, low52wDate: "", currencyUnit: 1, provider: "", timestamp: 1, id: -99, createdAt: "", modifiedAt: "", changeRate: 1, signedChangePrice: 1, signedChangeRate: 1)
    
    init() {
        print(#fileID, #function, #line, "")
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" )
        initStandardCountry()
        
        fetchAllDunamu()
        
        standardCountrySubject.sink { [weak self] value in
            guard let self = self else { return }
            self.changeStandardCountry(value)
        }.store(in: &standardCountrySubsription)
        
        myCountrySubject.sink { [weak self] value in
            guard let self = self else { return }
            self.fetchMyDunamu()
        }.store(in: &myCountrySubsription)
        
        dragAndDropSubject.sink { [weak self] value in
            guard let self = self else { return }
            self.changeRealmView(value.0, value.1)
        }.store(in: &dragAndDropSubsription)
        
        refreshActionSubject.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchAllDunamu()
        }.store(in: &subsription)
    }
    
    fileprivate func initStandardCountry() {
        if let object = RealmManager.shared.realm.object(ofType: StandardCountryModel.self, forPrimaryKey: 1) {
            standardCountry = object
        } else {
            let tempKRW = StandardCountryModel()
            tempKRW.currencyCode = "KRW"
            RealmManager.shared.create(tempKRW)
            standardCountry = tempKRW
        }
    }
    
    fileprivate func fetchAllDunamu() { // 모든
        print(#fileID, #function, #line, "")
        
        // MARK: - FRX.(기준나라)(대상나라)
        let baseCountryCode = "KRW"
        let resultMap = currencyCodeList.map({ String("FRX.\(baseCountryCode)\($0)") })
        let codes = resultMap.joined(separator: ",")
        
        AF.request(Dunamu.getAll(codes: codes))
            .publishDecodable(type: [DunamuModel].self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { completion in
                // 성훈 -> standardCountr == KRW 면 dunamuModels 에 KRW 없어서 매매기준율 따로 값 줘서 예외처리해야함
                let standardCountryBasePrice = self.dunamuModels.filter{ $0.currencyCode == self.standardCountry.currencyCode}
                // MARK: - 매매 기준율 세팅
                self.standardCountryBasePrice = standardCountryBasePrice[0].basePrice
            }, receiveValue: { receiveValue in
                var result = [self.koreaTemp]
                result += receiveValue
                self.dunamuModels = result
                self.fetchMyDunamu()
            }).store(in: &subsription)
    }
    
    fileprivate func changeStandardCountry(_ currencyCode: String) {
        RealmManager.shared.update(self.standardCountry, with: ["currencyCode": currencyCode])
        self.standardCountry = RealmManager.shared.realm.object(ofType: StandardCountryModel.self, forPrimaryKey: 1)!
        let standardCountryBasePrice = self.dunamuModels.filter{ $0.currencyCode == self.standardCountry.currencyCode}
        self.standardCountryBasePrice = standardCountryBasePrice[0].basePrice
    }
    
    fileprivate func fetchMyDunamu() { // 사용자가 추가한 나라만
        print(#fileID, #function, #line, "")
        // MARK: - realm으로 저장된 나라들 가져오기
        var myCountry = Array(RealmManager.shared.realm.objects(MyCountryModel.self))
        if myCountry.isEmpty {
            MyCountryModel.createMyCountry("USD")
            MyCountryModel.createMyCountry("JPY")
            MyCountryModel.createMyCountry("EUR")
            myCountry = Array(RealmManager.shared.realm.objects(MyCountryModel.self))
        }
        let currencyCodeArr = myCountry.map { String($0.currencyCode) }
        
        var arr = [DunamuModel]()
        // MARK: - 은표 개선 필요
        for code in currencyCodeArr {
            let a = self.dunamuModels.filter { $0.currencyCode == code }
            arr.append(contentsOf: a)
        }
        
        self.myDunamuModels = arr
    }
    
    fileprivate func changeRealmView(_ str1: String, _ str2: String) {
        let myCountry = Array(RealmManager.shared.realm.objects(MyCountryModel.self))
        
        let from = myCountry.firstIndex(where: { $0.currencyCode == str1 })!
        let to = myCountry.firstIndex(where: { $0.currencyCode == str2 })!
        
        let realmCountry = RealmManager.shared.realm.objects(MyCountryModel.self)
        let tempCur_currencyCode = realmCountry[from].currencyCode

        try! RealmManager.shared.realm.write {
            realmCountry[from].currencyCode = realmCountry[to].currencyCode
            realmCountry[to].currencyCode = tempCur_currencyCode
            fetchMyDunamu()
        }
    }
}
