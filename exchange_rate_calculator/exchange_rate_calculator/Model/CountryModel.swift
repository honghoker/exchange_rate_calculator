import Foundation

struct CountryModel: Codable {
    let country: String
    let currencyName: String
}

let currencyCodeList = ["KRW", "USD", "JPY", "EUR", "CNY", "HKD", "THB", "TWD", "PHP", "SGD", "AUD", "VND", "GBP", "CAD", "MYR", "RUB", "ZAR", "NOK", "NZD", "DKK", "MXN","MNT", "BHD", "BDT", "BRL", "BND", "SAR", "LKR", "SEK", "CHF", "AED", "DZD", "OMR", "JOD", "ILS", "EGP", "INR", "IDR", "CZK", "CLP", "KZT", "QAR", "KES", "COP", "KWD", "TZS", "TRY", "PKR", "PLN", "HUF"]

let countryModelList : [String: CountryModel] = [
    "KRW" : CountryModel(country: "대한민국", currencyName: "원"),
    "USD" : CountryModel(country: "미국", currencyName: "달러"),
    "JPY" : CountryModel(country: "일본", currencyName: "엔"),
    "EUR" : CountryModel(country: "유로", currencyName: "유로"),
    "CNY" : CountryModel(country: "중국", currencyName: "위안"),
    "HKD" : CountryModel(country: "홍콩", currencyName: "달러"),
    "THB" : CountryModel(country: "태국", currencyName: "바트"),
    "TWD" : CountryModel(country: "대만", currencyName: "달러"),
    "PHP" : CountryModel(country: "필리핀", currencyName: "페소"),
    "SGD" : CountryModel(country: "싱가포르", currencyName: "달러"),
    "AUD" : CountryModel(country: "호주", currencyName: "달러"),
    "VND" : CountryModel(country: "베트남", currencyName: "동"),
    "GBP" : CountryModel(country: "영국", currencyName: "파운드"),
    "CAD" : CountryModel(country: "캐나다", currencyName: "달러"),
    "MYR" : CountryModel(country: "말레이시아", currencyName: "링깃"),
    "RUB" : CountryModel(country: "러시아", currencyName: "루블"),
    "ZAR" : CountryModel(country: "남아프리카공화국", currencyName: "랜드"),
    "NOK" : CountryModel(country: "노르웨이", currencyName: "크로네"),
    "NZD" : CountryModel(country: "뉴질랜드", currencyName: "달러"),
    "DKK" : CountryModel(country: "덴마크", currencyName: "크로네"),
    "MXN" : CountryModel(country: "멕시코", currencyName: "페소"),
    "MNT" : CountryModel(country: "몽골", currencyName: "투그릭"),
    "BHD" : CountryModel(country: "바레인", currencyName: "디나르"),
    "BDT" : CountryModel(country: "방글라데시", currencyName: "타카"),
    "BRL" : CountryModel(country: "브라질", currencyName: "헤알"),
    "BND" : CountryModel(country: "브루나이", currencyName: "달러"),
    "SAR" : CountryModel(country: "사우디아라비아", currencyName: "리얄"),
    "LKR" : CountryModel(country: "스리랑카", currencyName: "루피"),
    "SEK" : CountryModel(country: "스웨덴", currencyName: "크로나"),
    "CHF" : CountryModel(country: "스위스", currencyName: "프랑"),
    "AED" : CountryModel(country: "아랍에미리트공화국", currencyName: "디르함"),
    "DZD" : CountryModel(country: "알제리", currencyName: "디나르"),
    "OMR" : CountryModel(country: "오만", currencyName: "리얄"),
    "JOD" : CountryModel(country: "요르단", currencyName: "디나르"),
    "ILS" : CountryModel(country: "이스라엘", currencyName: "셰켈"),
    "EGP" : CountryModel(country: "이집트", currencyName: "파운드"),
    "INR" : CountryModel(country: "인도", currencyName: "루피"),
    "IDR" : CountryModel(country: "인도네시아", currencyName: "루피아"),
    "CZK" : CountryModel(country: "체코", currencyName: "코루나"),
    "CLP" : CountryModel(country: "칠레", currencyName: "페소"),
    "KZT" : CountryModel(country: "카자흐스탄", currencyName: "텡게"),
    "QAR" : CountryModel(country: "카타르", currencyName: "리얄"),
    "KES" : CountryModel(country: "케냐", currencyName: "실링"),
    "COP" : CountryModel(country: "콜롬비아", currencyName: "페소"),
    "KWD" : CountryModel(country: "쿠웨이트", currencyName: "디나르"),
    "TZS" : CountryModel(country: "탄자니아", currencyName: "실링"),
    "TRY" : CountryModel(country: "터키", currencyName: "리라"),
    "PKR" : CountryModel(country: "파키스탄", currencyName: "루피"),
    "PLN" : CountryModel(country: "폴란드", currencyName: "즈워티"),
    "HUF" : CountryModel(country: "헝가리", currencyName: "포린트"),
]

