//
//  ContentView.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import SwiftUI
import Combine
import RealmSwift

struct ContentView: View {
    @StateObject var exchangeViewModel = ExchangeViewModel()
    @State var inputString = ""
    @State var inputValue = 1000
    @State var check = 0
    @State var draggedCountry: MyCountryModel = MyCountryModel()
    
    @State var text = "환율 계산기"
    @State var checkTest = true
    @State var destination: AnyView? = nil
    
    let textSwitchTimer = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if checkTest {
                        Text("환율 계산기")
                            .font(.system(size: 25))
                            .fontWeight(.black)
                            .transition(.opacity)
                            .onReceive(textSwitchTimer) { _ in
                                withAnimation (.easeInOut(duration: 1.0)) {
                                    checkTest.toggle()
                                }
                            }
                    } else {
                        Text("업데이트 날짜")
                            .font(.system(size: 25))
                            .fontWeight(.black)
                            .transition(.opacity)
                            .onReceive(textSwitchTimer) { _ in
                                withAnimation (.easeInOut(duration: 1.0)) {
                                    checkTest.toggle()
                                }
                            }
                    }
                    Spacer()
                    NavigationLink(destination: MYNavigationView()) {
                        Image(systemName: "line.horizontal.3")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                    }
                }
                .padding()
                TextField("1,000", text: $inputString)
                    .keyboardType(.numberPad)
                    .onChange(of: inputString, perform: { newValue in
                        if newValue == "" {
                            inputValue = 1000
                        } else if newValue.count > 10 {
                            // 10 글자까지 제한
                            inputString = String(newValue.prefix(10))
                        } else {
                            inputValue = Int(newValue)!
                        }
                    })
                    .multilineTextAlignment(.trailing)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                Rectangle().frame(height: 1)
                    .padding(.horizontal, 20).foregroundColor(Color.black)
                ScrollView {
                    LazyVStack {
                        ForEach(0..<exchangeViewModel.myCountry.count) { number in
                            HStack (alignment: .center, spacing: 15) {
                                Image("testFlag")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.yellow, lineWidth: 3))
                                Text("\(exchangeViewModel.myCountry[number].cur_unit)")
                                    .fontWeight(.light)
                                    .font(.system(size: 30))
                                Spacer()
                                VStack (alignment: .trailing){
                                    TestView(test: $inputValue, number)
                                    Text("\(exchangeViewModel.myCountry[number].cur_nm)")
                                    //                        check == number ? Text("대한민국") : Text("미국")
                                }.onTapGesture {
                                    check = number
                                    print("tap tap \(exchangeViewModel.myCountry[number])")
                                }
                            }
                            .onDrag{
                                print("drag drag")
                                print("exchangeViewModel.myCountry[number] \(exchangeViewModel.myCountry[number])")
                                print("$exchangeViewModel.myCountry count \($exchangeViewModel.myCountry.count)")
                                self.draggedCountry = exchangeViewModel.myCountry[number]
                                print("number \(number)")
                                return NSItemProvider(item: nil, typeIdentifier: exchangeViewModel.myCountry[number].cur_nm)
                            }
                            .onDrop(of: [exchangeViewModel.myCountry[number].cur_nm], delegate: MyDropDelegate(currentCountry: exchangeViewModel.myCountry[number], myCountry: $exchangeViewModel.myCountry, draggedCountry: $draggedCountry))
                            .frame(height: 100)
                            .background(Color.white)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        
        
        
        //                List (exchangeViewModel.exchangeModels){ exchange in
        //                    ExchangeCalCellView(exchange)
        //                        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        //                }.listStyle(PlainListStyle())
    }
}

struct MyDropDelegate: DropDelegate {
    let realm = try! Realm()
    let currentCountry: MyCountryModel
    @Binding var myCountry: [MyCountryModel]
    @Binding var draggedCountry: MyCountryModel
    
    // 드랍 처리
    func performDrop(info: DropInfo) -> Bool {
        print("performDrop performDrop")
        return true
    }
    
    // 드랍에서 벗어났을 때
    func dropExited(info: DropInfo) {
        print("dropExited dropExited")
    }
    
    // 드랍 시작
    func dropEntered(info: DropInfo) {
        print("dropEntered dropEntered")
        print("draggedCountry \(draggedCountry)")
        print("currentCountry \(currentCountry)")
        if draggedCountry != currentCountry {
            let from = myCountry.firstIndex(of: draggedCountry)!
            let to = myCountry.firstIndex(of: currentCountry)!
            print("before from \(from)")
            print("before to \(to)")
            //            ExchangeViewModel().changeRealmView(from, to)
            withAnimation {
                print("withAnimation")
                print("after from \(from)")
                print("after to \(to)")
                self.myCountry.move(fromOffsets: IndexSet(integer: from), toOffset: (to > from ? to + 1 : to))
            }
        }
    }
    
    // 드랍 변경
    func dropUpdated(info: DropInfo) -> DropProposal? {
        //        print("dropUpdated dropUpdated")
        return DropProposal(operation: .move)
    }
    
    // 드랍 유효 여부
    func validateDrop(info: DropInfo) -> Bool {
        print("validateDrop validateDrop")
        return true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
