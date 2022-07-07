//
//  testRealmManager.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/07/07.
//

import Foundation
import RealmSwift

//class TestRealmManager: ObservableObject {
//    private(set) var localRealm: Realm?
//    @Published var standardCurrencyCode: String = ""
//    @Published var myCurrencyCodeList: [MyCountryModel] = []
//
//    init() {
//        openRealm()
//        getStandardCurrencyCode()
//        getMyCurrencyCode()
//    }
//
//    func openRealm() {
//        do {
//            localRealm = try Realm()
//        } catch {
//            print("Error oepning Realm : ", error)
//        }
//    }
//
//    func getStandardCurrencyCode() {
//        if let localRealm = localRealm {
//            if localRealm.objects(StandardCountryModel.self).isEmpty {
//                let newStandard = StandardCountryModel(value: ["currencyCode": "KRW"])
//                try! localRealm.write({
//                    localRealm.add(newStandard)
//                })
//            }
//            let StandardCountryModel = localRealm.object(ofType: StandardCountryModel.self, forPrimaryKey: 1)!
//
//            self.standardCurrencyCode = StandardCountryModel.currencyCode
//        }
//    }
//
//    func updateStandardCurrencyCode(currencyCode: String) {
//        if let localRealm = localRealm {
//            do {
//                let StandardCountryModel = localRealm.object(ofType: StandardCountryModel.self, forPrimaryKey: 1)!
//
//                try localRealm.write({
//                    StandardCountryModel.currencyCode = currencyCode
//                    getStandardCurrencyCode()
//                })
//            } catch {
//                print("Error updateStandardCurrencyCode : ", error)
//            }
//        }
//    }
//
//    func getMyCurrencyCode() {
//        if let localRealm = localRealm {
//            if localRealm.objects(MyCountryModel.self).isEmpty {
//                for currencyCode in ["USD", "JPY", "EUR"] {
//                    let new = MyCountryModel(value: currencyCode)
//                    try! localRealm.write({
//                        localRealm.add(new)
//                    })
//                }
//            }
//            myCurrencyCodeList = Array(localRealm.objects(MyCountryModel.self))
//        }
//    }
//
//    func updateMyCurrencyCode(currencyCode: String) {
//        if myCurrencyCodeList.filter ({ $0.currencyCode == currencyCode }).isEmpty {
//            // 추가
//            addMyCurrencyCode(currencyCode: currencyCode)
//        } else {
//            // 삭제
//            deleteMyCurrencyCode(currencyCode: currencyCode)
//        }
//    }
//
//    func addMyCurrencyCode(currencyCode: String) {
//        if let localRealm = localRealm {
//            do {
//                try localRealm.write({
//                    let new = MyCountryModel(value: currencyCode)
//                    localRealm.add(new)
//                    getMyCurrencyCode()
//                })
//            } catch {
//                print("Error addMyCurrencyCode : ", error)
//            }
//        }
//    }
//
//    func deleteMyCurrencyCode(currencyCode: String) {
//        if let localRealm = localRealm {
//            do {
//                let currencyToDelete = MyCountryModel(value: currencyCode)
//                try localRealm.write({
//                    localRealm.delete(currencyToDelete)
//                    getMyCurrencyCode()
//                })
//            } catch {
//                print("Error deleteMyCurrencyCode : ", error)
//            }
//        }
//    }
//}
