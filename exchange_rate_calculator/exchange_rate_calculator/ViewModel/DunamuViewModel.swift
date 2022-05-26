//
//  DunamuViewModel.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import Foundation
import Alamofire
import Combine

class DunamuViewModel: ObservableObject {
    var subsription = Set<AnyCancellable>()
    
    @Published var dunamuModels = [DunamuModel]()
    
    init() {
        print(#fileID, #function, #line, "")
        fetchAllDunamu()
    }
    
    func load() -> Data? {
        // 1. 불러올 파일 이름
        let fileNm: String = "Country"
        // 2. 불러올 파일의 확장자명
        let extensionType = "json"
        
        // 3. 파일 위치
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return nil }
        
        do {
            // 4. 해당 위치의 파일을 Data로 초기화하기
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            // 5. 잘못된 위치나 불가능한 파일 처리 (오늘은 따로 안하기)
            return nil
        }
    }
    
    fileprivate func fetchAllDunamu() {
        print(#fileID, #function, #line, "")
        guard
            let jsonData = load(),
            let userList = try? JSONDecoder().decode([CountryModel].self, from: jsonData)
        else { return }

        let resultMap = userList.map({  String("FRX.KRW\($0.currencyCode)") })
        let codes = resultMap.joined(separator: ",")
        
        print(codes)
        AF.request(Dunamu.getAll(codes: codes))
            .publishDecodable(type: [DunamuModel].self)
            .compactMap { $0.value }
            .sink(receiveCompletion: { completion in
                print("데이터스트림 완료")
            }, receiveValue: { receiveValue in
                self.dunamuModels = receiveValue
            }).store(in: &subsription)
    }
    
}
