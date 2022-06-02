////
////  TeseViewModel.swift
////  exchange_rate_calculator
////
////  Created by 김성훈 on 2022/05/25.
////
//
//import Foundation
//import Alamofire
//import Combine
//
//class ExchangeTextViewModel: ObservableObject {
//    var subsription = Set<AnyCancellable>()
//    @Published var basePrice = 0.0
//    var currencyCode: String = ""
//    var inputValue = 0.0
//
//    init() {
////        self.fetchMyDunamu(currencyCode)
//    }
////
////    func chagne() {
////        print("basePrice \(basePrice)")
////        viewModelValue = basePrice
////    }
//
//    func fetchMyDunamu(_ currencyCode: String) { // 사용자가 추가한 나라만
//        print(#fileID, #function, #line, "")
//        // MARK: - realm으로 기준나라코드 가져오기
//        let baseCountryCode = "KRW"
//        // MARK: - realm으로 저장된 나라들 가져오기
//        let myCountryCode = ["\(currencyCode)"]
//
//        let resultMap = myCountryCode.map({  String("FRX.\(baseCountryCode)\($0)") })
//        let codes = resultMap.joined(separator: ",")
//
//        print(codes)
//        AF.request(Dunamu.getMy(codes: codes))
//            .publishDecodable(type: [DunamuModel].self)
//            .compactMap { $0.value }
//            .sink(receiveCompletion: { completion in
//                print("데이터스트림 완료")
//            }, receiveValue: { receiveValue in
//                print("receiveValue \(receiveValue)")
//                self.basePrice = receiveValue[0].basePrice
//            }).store(in: &subsription)
//    }
//}
