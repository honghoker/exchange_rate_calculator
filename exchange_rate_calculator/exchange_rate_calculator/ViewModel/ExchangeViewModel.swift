import Foundation
import Alamofire
import Combine
import RealmSwift
import FlagKit

class ExchangeViewModel: ObservableObject {
    let realm = try! Realm()
    var subscription = Set<AnyCancellable>()
    var realmCheck = false
    
    @Published var myCountry = [MyCountryModel]()
    @Published var basePrice = [DunamuModel]()
    @Published var standardCountry = [StandardCountryModel]()
    
    init() {
        print(#fileID, #function, #line, "")
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" )
        fetchExchangeRate()
        fetchExchangeBasePrice(myCountry)
//                        try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func fetchExchangeRate() {
        print(#fileID, #function, #line, "")
        myCountry = Array(realm.objects(MyCountryModel.self))
        standardCountry = Array(realm.objects(StandardCountryModel.self))
        // MARK: realm 아무것도 없을 때 기본 나라 세팅
        if standardCountry.isEmpty {
            let tempKRW = StandardCountryModel()
            tempKRW.currencyCode = "KRW"
            try! realm.write {
                realm.add(tempKRW)
            }
        }
        if myCountry.isEmpty {
            let tempUSD = MyCountryModel()
            tempUSD.currencyCode = "USD"
            try! realm.write {
                realm.add(tempUSD)
            }
            let tempJPY = MyCountryModel()
            tempJPY.currencyCode = "JPY"
            try! realm.write {
                realm.add(tempJPY)
            }
            let tempEUR = MyCountryModel()
            tempEUR.currencyCode = "EUR"
            try! realm.write {
                realm.add(tempEUR)
            }
            myCountry = Array(realm.objects(MyCountryModel.self))
            standardCountry = Array(realm.objects(StandardCountryModel.self))
        }
    }
    
    func fetchExchangeBasePrice(_ currencyCode: [MyCountryModel]) { // 사용자가 추가한 나라만
        print(#fileID, #function, #line, "")
        // MARK: - realm으로 기준나라코드 가져오기
        let baseCountryCode = "KRW"
        // MARK: - realm으로 저장된 나라들 가져오기
        let resultMap = currencyCode.map({  String("FRX.\(baseCountryCode)\($0.currencyCode)") })
        let codes = resultMap.joined(separator: ",")
        
        print(codes)
        AF.request(Dunamu.getMy(codes: codes))
            .publishDecodable(type: [DunamuModel].self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { completion in
                print("데이터스트림 완료")
            }, receiveValue: { receiveValue in
                print("receiveValue \(receiveValue)")
                self.basePrice = receiveValue
            }).store(in: &subscription)
    }
    
    func changeRealmView(_ from: Int, _ to: Int) {
        let realmCountry = realm.objects(MyCountryModel.self)
        let tempCur_currencyCode = realmCountry[from].currencyCode

        try! realm.write {
            realmCountry[from].currencyCode = realmCountry[to].currencyCode
            realmCountry[to].currencyCode = tempCur_currencyCode
        }
    }
}
