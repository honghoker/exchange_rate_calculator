//
//  DunamuListView.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/31.
//

import Foundation
import SwiftUI
import FlagKit
import RealmSwift

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .font(.system(size: 20, weight: .regular, design: .default))
        }
        .onTapGesture {
            withAnimation { configuration.isOn.toggle() }
        }
    }
}

struct DunamuRowView: View {
    @ObservedObject var dunamuViewModel: DunamuViewModel
    var dunamu: DunamuModel
    @State var checked: Bool = false // 국가 리스트에 있는지 체크
    @Binding var editEnable: Bool // checkBox show / hide

    init(_ dunamuViewModel: DunamuViewModel, _ dunamu: DunamuModel, _ editEnable: Binding<Bool> = .constant(false) ) {
        self.dunamuViewModel = dunamuViewModel
        self.dunamu = dunamu
        _editEnable = editEnable
        _checked = State(initialValue: dunamuViewModel.myDunamuModels.contains { $0.currencyCode == dunamu.currencyCode})
    }
    
    @ViewBuilder func checkBox() -> some View {
        if editEnable == true {
            Toggle("", isOn: $checked)
                .toggleStyle(CheckboxStyle())
                .padding(.leading, 16)
                .onChange(of: checked){ value in
                    // MARK: - realm에 추가, 삭제
                    if value == true {
                        // MARK: - 추가
                        MyCountryModel.createMyCountry(dunamu.currencyCode)
                        dunamuViewModel.myCountrySubject.send()
                    } else {
                        // MARK: - 삭제
                        let data = RealmManager.shared.realm.objects(MyCountryModel.self).filter({$0.currencyCode == dunamu.currencyCode})
                        for d in data {
                            RealmManager.shared.delete(d)
                        }
                        dunamuViewModel.myCountrySubject.send()
                    }
                }
        }
    }
    
    @ViewBuilder func currency() -> some View {
        let endIdx = dunamu.currencyCode.index(dunamu.currencyCode.startIndex, offsetBy: 1)
        let result = String(dunamu.currencyCode[...endIdx])
        let flag = Flag(countryCode: result)
        let originalImage = flag?.originalImage
        
        HStack(spacing: 0) {
            if originalImage != nil {
                Spacer().frame(width: 16)
                Image(uiImage: originalImage!)
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            Spacer().frame(width: 12)
            VStack(alignment: .leading, spacing: 4) {
                Text("\(dunamu.currencyCode)")
                    .fontWeight(.bold)
                    .font(.custom("IBMPlexSansKR-Regular", size: 14))
                    .foregroundColor(.black)
                
                Text("\(countryModelList[dunamu.currencyCode]!.country) \(["JPY", "VND", "IDR"].contains(dunamu.currencyCode) ? "100" + countryModelList[dunamu.currencyCode]!.currencyName : countryModelList[dunamu.currencyCode]!.currencyName)")
                
                     
                    .fontWeight(.medium)
                    .font(.custom("IBMPlexSansKR-Regular", size: 12))
                    .foregroundColor(.gray)
            } // VStack
        }
    }
    
    @ViewBuilder func basePrice() -> some View {
        if dunamu.currencyCode == "KRW" {
            Text("-")
                .fontWeight(.bold)
                .font(.custom("IBMPlexSansKR-Regular", size: 12))
                .foregroundColor(.gray)
        } else {
            Text("\(String(format: "%.2f", dunamu.basePrice))")
                .fontWeight(.bold)
                .font(.custom("IBMPlexSansKR-Regular", size: 12))
                .foregroundColor(.black)
        }
        
    }
    
    func pricePercentage() -> String {
        if dunamu.change == "RISE" {
            let startPrice = dunamu.basePrice - dunamu.changePrice
            let diff =  dunamu.basePrice - startPrice
            let result = (diff / startPrice) * 100
            return String(format: "%.2f", result)
        } else {
            let startPrice = dunamu.basePrice + dunamu.changePrice
            let diff = startPrice - dunamu.basePrice
            let result = (diff / startPrice) * 100
            return String(format: "%.2f", result)
        }
    }
    
    @ViewBuilder func changePrice() -> some View {
        if dunamu.currencyCode == "KRW" {
            Text("-")
                .fontWeight(.bold)
                .font(.custom("IBMPlexSansKR-Regular", size: 12))
                .foregroundColor(.gray)
        } else {
            if dunamu.change == "RISE" {
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        Image(systemName: "arrowtriangle.up.fill")
                            .foregroundColor(.red)
                            .font(.custom("IBMPlexSansKR-Regular", size: 10))
                        Text("\(String(format: "%.2f", dunamu.changePrice))")
                            .fontWeight(.medium)
                            .font(.custom("IBMPlexSansKR-Regular", size: 12))
                            .foregroundColor(.red)
                    }
                    Text("(+\(pricePercentage())%)")
                        .fontWeight(.medium)
                        .font(.custom("IBMPlexSansKR-Regular", size: 12))
                        .foregroundColor(.red)
                }
            } else if dunamu.change == "FALL" {
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.blue)
                            .font(.custom("IBMPlexSansKR-Regular", size: 10))
                        Text("\(String(format: "%.2f", dunamu.changePrice))")
                            .fontWeight(.medium)
                            .font(.custom("IBMPlexSansKR-Regular", size: 12))
                            .foregroundColor(.blue)
                    }
                    Text("(-\(pricePercentage())%)")
                        .fontWeight(.medium)
                        .font(.custom("IBMPlexSansKR-Regular", size: 12))
                        .foregroundColor(.blue)
                } // VStack
            } else {
                HStack(spacing: 2) {
                    Text("\(String(format: "%.2f", dunamu.changePrice))")
                        .fontWeight(.medium)
                        .font(.custom("IBMPlexSansKR-Regular", size: 12))
                        .foregroundColor(.black)
                } // HStack
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                checkBox()
                    .frame(width: proxy.size.width * 0.10)
                currency()
                    .frame(minWidth: proxy.size.width * 0.50, maxWidth: proxy.size.width * 0.60, alignment: .leading)
                basePrice()
                    .frame(width: proxy.size.width * 0.20)
                changePrice()
                    .frame(width: proxy.size.width * 0.20)
            } // HStack
            .padding(.vertical, 12)
            .background(Color.clear)
        } // GeometryReader
        .frame(minHeight: 60)
    } // View
}
