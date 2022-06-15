//
//  CalculateCountryRowView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/06/08.
//

import Foundation
import SwiftUI

struct CalculateCountryRowView: View {
    
    @EnvironmentObject var exchangeViewModel: ExchangeViewModel // 내가 추가한 메인에 보이는 국가 리스트
    @Binding var draggedCountry: MyCountryModel // drag 상태인 국가 (realm)
    @Binding var inputString: String // textField String value
    
    init(_ draggedCountry: Binding<MyCountryModel>, _ inputString: Binding<String>) {
        self._draggedCountry = draggedCountry
        self._inputString = inputString
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<(exchangeViewModel.myCountry.count == 0 ? exchangeViewModel.myCountry.count : exchangeViewModel.basePrice.count), id: \.self) { number in
                    HStack (alignment: .center, spacing: 15) {
                        ExchangeFlagView(exchangeViewModel.myCountry[exchangeViewModel.myCountry.count <= number ? 0 : number].currencyCode)
                        Text("\(exchangeViewModel.myCountry[exchangeViewModel.myCountry.count <= number ? 0 : number].currencyCode)")
                            .font(.custom("IBMPlexSansKR-Regular", size: 20))
                        Spacer()
                        VStack (alignment: .trailing){
                            ExchangeTextView(inputValue: $inputString,  $exchangeViewModel.basePrice, exchangeViewModel.myCountry.count <= number ? 0 : number)
                            HStack (spacing: 5){
                                Text(countryModelList["\(exchangeViewModel.basePrice[exchangeViewModel.myCountry.count <= number ? 0 : number].currencyCode)"]!.country)
                                    .font(.custom("IBMPlexSansKR-Regular", size: 15))
                                    .foregroundColor(.gray)
                                Text(countryModelList["\(exchangeViewModel.basePrice[exchangeViewModel.myCountry.count <= number ? 0 : number].currencyCode)"]!.currencyName)
                                    .font(.custom("IBMPlexSansKR-Regular", size: 15))
                                    .foregroundColor(.gray)
                            }
                        }.onTapGesture {
                            // 국가 tap
                        }
                    }
                    .onDrag{
                        // print("Drag \(exchangeViewModel.myCountry[number])")
                        self.draggedCountry = exchangeViewModel.myCountry[number]
                        return NSItemProvider(item: nil, typeIdentifier: exchangeViewModel.myCountry[number].currencyCode)
                    }
                    .onDrop(of: [exchangeViewModel.myCountry[exchangeViewModel.myCountry.count <= number ? 0 : number].currencyCode], delegate: MyDropDelegate(currentCountry: exchangeViewModel.myCountry[exchangeViewModel.myCountry.count <= number ? 0 : number], myCountry: $exchangeViewModel.myCountry, draggedCountry: $draggedCountry, exchangeViewModel: exchangeViewModel)
                    )
                    .frame(height: 80)
                    .background(Color.white)
                } // ForEach
                .padding(.horizontal, 20)
            } // LazyVStack
        } // ScrollView
    }
}

//struct CalculateCountryRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalculateCountryRowView()
//    }
//}
