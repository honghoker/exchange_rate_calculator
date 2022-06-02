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
    
    init() {
        print(#fileID, #function, #line, "")
        print("realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" )
        fetchExchangeRate()
        fetchExchangeBasePrice(myCountry)
//                        try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    fileprivate func fetchExchangeRate() {
        print(#fileID, #function, #line, "")
        myCountry = Array(realm.objects(MyCountryModel.self))
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
        let tempCur_country = realmCountry[from].country
        let tempCur_currencyName = realmCountry[from].currencyName
        let tempCur_basePrice = realmCountry[from].basePrice
        try! realm.write {
            realmCountry[from].currencyCode = realmCountry[to].currencyCode
            realmCountry[from].country = realmCountry[to].country
            realmCountry[from].currencyName = realmCountry[to].currencyName
            realmCountry[from].basePrice = realmCountry[to].basePrice
            realmCountry[to].currencyCode = tempCur_currencyCode
            realmCountry[to].country = tempCur_country
            realmCountry[to].currencyName = tempCur_currencyName
            realmCountry[to].basePrice = tempCur_basePrice
        }
    }
}
