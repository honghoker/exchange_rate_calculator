import Foundation
import Alamofire
import Combine
import RealmSwift

class ExchangeViewModel: ObservableObject {
    let realm = try! Realm()
    var subscription = Set<AnyCancellable>()
    var realmCheck = false

    @Published var myCountry = [MyCountryModel]()

    init() {
        print(#fileID, #function, #line, "")
        fetchExchangeRate()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        //        try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
        
        //        let myCountryModel = MyCountryModel()
        //        myCountryModel.cur_nm = "대한민국"
        //        myCountryModel.cur_unit = "KOR"
        //        try! realm.write {
        //            realm.add(myCountryModel)
        //        }
        //        let myCountryModel1 = MyCountryModel()
        //        myCountryModel1.cur_nm = "미국"
        //        myCountryModel1.cur_unit = "USA"
        //        try! realm.write {
        //            realm.add(myCountryModel1)
        //        }
        //        let myCountryModel2 = MyCountryModel()
        //        myCountryModel2.cur_nm = "일본"
        //        myCountryModel2.cur_unit = "JAP"
        //        try! realm.write {
        //            realm.add(myCountryModel2)
        //        }
        //        let myCountryModel3 = MyCountryModel()
        //        myCountryModel3.cur_nm = "중국"
        //        myCountryModel3.cur_unit = "CHI"
        //        try! realm.write {
        //            realm.add(myCountryModel3)
        //        }
        //        let myCountryModel4 = MyCountryModel()
        //        myCountryModel4.cur_nm = "인도"
        //        myCountryModel4.cur_unit = "IND"
        //        try! realm.write {
        //            realm.add(myCountryModel4)
        //        }
    }

    fileprivate func fetchExchangeRate() {
        print(#fileID, #function, #line, "")
        myCountry = Array(realm.objects(MyCountryModel.self))
        //        AF.request(KoreaExim.getExchangeRate)
        //            .publishDecodable(type: [ExchangeModel].self)
        //            .compactMap { $0.value }
        //            .sink(receiveCompletion: { completion in
        //                print("데이터스트림 완료")
        //            }, receiveValue: { receiveValue in
        //                print("@@@@@@@@@@@2 receiveValue : \(receiveValue)")
        //                self.exchangeModels = receiveValue
        //            }).store(in: &subscription)
    }

    func changeRealmView(_ from: Int, _ to: Int) {
        let realmCountry = realm.objects(MyCountryModel.self)
        let tempCur_unit = realmCountry[from].cur_unit
        let tempCur_nm = realmCountry[from].cur_nm
        try! realm.write {
            realmCountry[from].cur_unit = realmCountry[to].cur_unit
            realmCountry[from].cur_nm = realmCountry[to].cur_nm
            realmCountry[to].cur_unit = tempCur_unit
            realmCountry[to].cur_nm = tempCur_nm
        }
    }
}
