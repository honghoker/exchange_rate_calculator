//
//  KoreaExim.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import Foundation
import Alamofire


// https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=AUTHKEY1234567890&searchdate=20180102&data=AP01
let BaseURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON"

enum KoreaExim: URLRequestConvertible {
    case getExchangeRate
    
    var baseURL: URL {
        return URL(string: BaseURL)!
    }
    
    var endPoint: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    
    var parameters: Parameters {
        var params = Parameters()
        switch self {
        case .getExchangeRate:
            params["authkey"] = ""
            params["searchdate"] = "20220523"
            params["data"] = "AP01"
            return params
        default:
            return Parameters()
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.method = method
        
        switch self {
        case .getExchangeRate:
            request = try URLEncoding.default.encode(request, with: parameters)
            print("@@@@@@@@ getExchangeRate url : \(request.url)")
        default:
            return request
        }
        return request
    }
}
