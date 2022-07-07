import Foundation
import RealmSwift

class RealmManager {
    private init() {}
    static let shared = RealmManager()

    var realm = try! Realm()

    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }

        } catch {
            print(error)
        }
    }

    func update(_ object: RealmSwift.Object, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for(key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }

        } catch {
            print(error)
        }
    }

    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error)
        }
    }

    func reset() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
}
