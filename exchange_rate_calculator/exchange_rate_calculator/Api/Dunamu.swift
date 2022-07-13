//
//  Dunamu.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import Foundation
import Alamofire

// https://quotation-api-cdn.dunamu.com/v1/forex/recent?codes=FRX.KRWUSD,FRX.KRWJPY,FRX.KRWCNY,FRX.KRWEUR

let dunamuBaseURL = "https://quotation-api-cdn.dunamu.com/v1/forex/recent"

enum Dunamu: URLRequestConvertible {
    case getAll(codes: String)
    case getMy(codes: String)
    
    var baseURL: URL {
        return URL(string: dunamuBaseURL)!
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
        case let .getAll(codes):
            params["codes"] = codes
            return params
        case let .getMy(codes):
            params["codes"] = codes
            return params
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        
        switch self {
        case .getAll:
            return URLEncoding.default
        case .getMy:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.method = method
        
        switch self {
        case .getAll:
            request = try CustomGetEncoding().encode(request, with: parameters)
//            print("@@@@@@@@ getAll url : \(request.url)")
        case .getMy:
            request = try URLEncoding.default.encode(request, with: parameters)
//            print("@@@@@@@@ getMy url : \(request.url)")
        }
        return request
    }
}


struct CustomGetEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%2C", with: ","))
        return request
    }
}

