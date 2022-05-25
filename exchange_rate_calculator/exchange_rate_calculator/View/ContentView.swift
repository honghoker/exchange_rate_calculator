//
//  ContentView.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var exchangeViewModel = ExchangeViewModel()
    @State var inputString = ""
    @State var inputValue = 0
    @State var check = 0
    
    var body: some View {
        TextField("init ?", text: $inputString)
            .onChange(of: inputString, perform: { newValue in
                if newValue == "" {
                    inputValue = 0
                } else if newValue.count > 10 {
                    // 10 글자까지 제한
                    inputString = String(newValue.prefix(10))
                } else {
                    inputValue = Int(newValue)!
                }
            })
            .multilineTextAlignment(.trailing)
            .padding()
        List {
            ForEach(1..<6) { number in
                HStack (alignment: .center, spacing: 15) {
                    Image("testFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.yellow, lineWidth: 3))
                    Text("KOR \(number)")
                        .fontWeight(.light)
                        .font(.system(size: 30))
                    Spacer()
                    VStack (alignment: .trailing){
                        TestView(test: $inputValue, number)
                        check == number ? Text("대한민국") : Text("미국")
                    }.onTapGesture {
                        check = number
                        print("tap tap \(number)")
                    }
                }
                .frame(height: 100)
                .background(Color.white)
//                .overlay(RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color.gray))
            } .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }.listStyle(PlainListStyle())
        
        //        List (exchangeViewModel.exchangeModels){ exchange in
        //            ExchangeCalCellView(exchange)
        //                .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        //        }.listStyle(PlainListStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
