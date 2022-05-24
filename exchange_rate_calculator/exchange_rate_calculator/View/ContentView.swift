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
    @State var inputValue = ""
    //    @Binding var testValue: String
    
    var body: some View {
       // 어차피 이거 램 써서 내부 디비 count 로 작업할거라 foreach 써야함 이렇게 작업하면 가능할지도 ?
        List {
            ForEach(0..<5) { number in
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
                        TextField("init ?", text: $inputValue)
                            .onChange(of: inputValue, perform: { newValue in
                                print("new Value \(newValue)")
                            })
                            .multilineTextAlignment(.trailing)
                        TestView(test: $inputValue, number: number)
                        Text("대한민국")
                    }.onTapGesture {
                        print("tap tap")
                    }
                }
                .frame(height: 100)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 10, style: .circular).stroke(Color.gray))
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
