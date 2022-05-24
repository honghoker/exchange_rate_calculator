//
//  exchangeModel.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import Foundation

struct ExchangeModel: Codable, Identifiable {
    
    let id = UUID()
    let result: Int // 1 : 성공, 2 : DATA코드 오류, 3 : 인증코드 오류, 4 : 일일제한횟수 마감
    let cur_unit: String // 통화코드 ex) "AED"
    let ttb: String // 전신환(송금) 받으실때 ex) "288.78"
    let tts: String // 전신환(송금) 보내실때 ex) "294.61"
    let deal_bas_r: String // 매매 기준율 ex) "291.7"
    let bkpr: String // 장부가격 ex) "291"
    let yy_efee_r: String // 년환가료율 ex) "0"
    let ten_dd_efee_r: String // 10일환가료율 ex) "0"
    let kftc_bkpr: String // 서울외국환중개 장부가격 ex) "291"
    let kftc_deal_bas_r: String // 서울외국환중개 매매기준율 ex) "291.7",
    let cur_nm: String // 국가/통화명 ex) "아랍에미리트 디르함"
    
    private enum CodingKeys: CodingKey {
        case result,
             cur_unit,
             ttb, tts,
             deal_bas_r,
             bkpr,
             yy_efee_r, ten_dd_efee_r,
             kftc_bkpr, kftc_deal_bas_r,
             cur_nm
    }
    static func getDummy() -> Self {
        return ExchangeModel(result: 1, cur_unit: "", ttb: "", tts: "", deal_bas_r: "", bkpr: "", yy_efee_r: "", ten_dd_efee_r: "", kftc_bkpr: "", kftc_deal_bas_r: "", cur_nm: "")
    }
}
