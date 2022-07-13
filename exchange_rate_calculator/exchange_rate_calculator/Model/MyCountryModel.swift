import Foundation
import RealmSwift

class MyCountryModel: Object {
    @objc dynamic var idx: Int = 1
    @objc dynamic var currencyCode = "" // 통화코드 ex) "USD"
    
    override static func primaryKey() -> String? {
        return "idx"
    }
    
    class func createMyCountry(_ currencyCode: String) {
        var idx = 1
        if let lastCountry = RealmManager.shared.realm.objects(MyCountryModel.self).last {
            idx = lastCountry.idx + 1
        }
        let myCountry = MyCountryModel()
        myCountry.idx = idx
        myCountry.currencyCode = currencyCode
        
        RealmManager.shared.create(myCountry)
    }
}
