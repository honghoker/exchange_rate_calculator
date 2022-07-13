import Foundation
import RealmSwift

class StandardCountryModel: Object {
    @objc dynamic var id = 1
    @objc dynamic var currencyCode = "" // 통화코드 ex) "USD"
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
