//
//  ExchangeCalView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/24.
//

import Foundation
import SwiftUI

struct ExchangeCalCellView: View {
    
    @State var inputValue = ""
    
    var exchangeModel: ExchangeModel
    
    init(_ exchangeModel: ExchangeModel) {
        self.exchangeModel = exchangeModel
    }
    
    var body: some View {
        HStack (alignment: .center, spacing: 15) {
            Image("testFlag")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.yellow, lineWidth: 3))
            Text("\(exchangeModel.cur_unit)")
                .fontWeight(.light)
                .font(.system(size: 30))
            Spacer()
            VStack (alignment: .trailing){
                TextField("", text: $inputValue)
                    .onChange(of: inputValue, perform: { newValue in
                        print("new Value \(newValue)")
                    })
                    .multilineTextAlignment(.trailing)
//                TestView(test: $inputValue)
                Text("\(exchangeModel.cur_nm)")
            }.onTapGesture {
                print("tap tap")
            }
        }
        .frame(height: 100)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color.gray))
    }
}

struct ExchangeCalCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeCalCellView(ExchangeModel.getDummy())
    }
}
