//
//  CalculateCountryRowView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/06/08.
//

import Foundation
import SwiftUI

struct CalculateCountryRowView: View {
    @ObservedObject var dunamuViewModel: DunamuViewModel
    @Binding var draggedCountry: MyCountryModel // drag 상태인 국가 (realm)
    @Binding var inputString: String // textField String value
        
    var body: some View {
        ScrollView {
            LazyVStack {
                if !dunamuViewModel.myDunamuModels.isEmpty {
                    ForEach(0..<(dunamuViewModel.myDunamuModels.count), id: \.self) { number in
                        HStack (alignment: .center, spacing: 15) {
                            ExchangeFlagView(dunamuViewModel.myDunamuModels[dunamuViewModel.myDunamuModels.count <= number ? 0 : number].currencyCode)
                            Text("\(dunamuViewModel.myDunamuModels[dunamuViewModel.myDunamuModels.count <= number ? 0 : number].currencyCode)")
                                .font(.custom("IBMPlexSansKR-Regular", size: 20))
                            Spacer()
                            VStack (alignment: .trailing){
                                ExchangeTextView(inputValue: $inputString, dunamuModel: dunamuViewModel.myDunamuModels[number], standardCountry: dunamuViewModel.standardCountry.currencyCode, standardCountryBasePrice: dunamuViewModel.standardCountryBasePrice)
                                HStack (spacing: 5){
                                    Text(countryModelList["\(dunamuViewModel.myDunamuModels[dunamuViewModel.myDunamuModels.count <= number ? 0 : number].currencyCode)"]!.country)
                                        .font(.custom("IBMPlexSansKR-Regular", size: 15))
                                        .foregroundColor(.gray)
                                    Text(countryModelList["\(dunamuViewModel.myDunamuModels[dunamuViewModel.myDunamuModels.count <= number ? 0 : number].currencyCode)"]!.currencyName)
                                        .font(.custom("IBMPlexSansKR-Regular", size: 15))
                                        .foregroundColor(.gray)
                                }
                            }.onTapGesture {
                                // 국가 tap
                            }
                        }
                        .onDrag{
                            let dragCountry = MyCountryModel()
                            dragCountry.currencyCode = dunamuViewModel.myDunamuModels[number].currencyCode
                            self.draggedCountry = dragCountry
                            return NSItemProvider(item: nil, typeIdentifier: dragCountry.currencyCode)
                        }
                        .onDrop(of: [dunamuViewModel.myDunamuModels[dunamuViewModel.myDunamuModels.count <= number ? 0 : number].currencyCode], delegate: MyDropDelegate(currentCountry: dunamuViewModel.myDunamuModels[dunamuViewModel.myDunamuModels.count <= number ? 0 : number], myCountry: dunamuViewModel.myDunamuModels, draggedCountry: draggedCountry, dunamuViewModel: dunamuViewModel)
                        )
                        .frame(height: 80)
                        .background(Color.white)
                    } // ForEach
                    .padding(.horizontal, 20)
                }
            } // LazyVStack
        } // ScrollView
    }
}
