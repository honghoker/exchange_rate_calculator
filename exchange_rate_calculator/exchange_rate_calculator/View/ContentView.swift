//
//  ContentView.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/23.
//

import SwiftUI
import Combine
import FlagKit
import RealmSwift

struct ContentView: View {
    @StateObject var exchangeViewModel = ExchangeViewModel() // 내가 추가한 메인에 보이는 국가 리스트
    
    @State var inputString = "" // textField String value
//    @State var inputValue = 1000 // textField Int value
    
    @State var calculateValueText = ""
    
    @State var draggedCountry: MyCountryModel = MyCountryModel() // drag 상태인 국가 (realm)
    
    @State var destination: AnyView? = nil // set page 로 이동하는 View
    
    @State private var isShowing = false // calculate keyboard on off
    
    @State var mainTextSwitchCheck = true // 메인 앱 이름 <> 업데이트 날짜 바꿔주는 값
    let mainTextSwitchTimer = Timer.publish(every: 7, on: .main, in: .common).autoconnect() // 앱 이름 <> 업데이트 날짜 바꿔주는 시간

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        if mainTextSwitchCheck {
                            Text("환율 계산기")
                                .font(.system(size: 25))
                                .fontWeight(.black)
                                .transition(.opacity)
                                .onReceive(mainTextSwitchTimer) { _ in
                                    withAnimation (.easeInOut(duration: 1.0)) {
                                        mainTextSwitchCheck.toggle()
                                    }
                                }
                        } else {
                            Text("업데이트 날짜")
                                .font(.system(size: 25))
                                .fontWeight(.black)
                                .transition(.opacity)
                                .onReceive(mainTextSwitchTimer) { _ in
                                    withAnimation (.easeInOut(duration: 1.0)) {
                                        mainTextSwitchCheck.toggle()
                                    }
                                }
                        }
                        Spacer()
                        NavigationLink(destination: SettingView()) {
                            Image(systemName: "line.horizontal.3")
                                .font(.largeTitle)
                                .foregroundColor(Color.black)
                        }
                    }
                    .padding()
                    HStack{
                        Spacer()
                        Text("\(calculateValueText)")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                    // 1차 완성 추후에 이거 보완 수정
                    TextField("1000", text: $inputString)
                        .onTapGesture {
                            // 기본 textField 이용시 사용하는 키보드 사용을 중지하도록 제어할 수 있는 항목에게 요청 -> https://seons-dev.tistory.com/4 참고 에뮬에서는 확인 불가능
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }
                        .onChange(of: inputString, perform: { newValue in
                            if String(describing:newValue).count == 0 {
//                                inputValue = 0
                                inputString = "0"
                            } else if String(describing:newValue).count > 20 {
                                // 20 글자까지 제한
                                inputString = String(newValue.prefix(20))
//                                inputValue = Int(newValue.prefix(10))!
                            } else {
                                print("newValue \(newValue)")
                                inputString = newValue
//                                inputValue = Int(newValue)!
                            }
                        })
                        .multilineTextAlignment(.trailing)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    Rectangle().frame(height: 1)
                        .padding(.horizontal, 20).foregroundColor(Color.black)
                    ScrollView {
                        LazyVStack {
                            ForEach(0..<exchangeViewModel.myCountry.count, id: \.self) { number in
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
                                        ExchangeTextView(inputValue: $inputString, number)
                                        Text("\(exchangeViewModel.myCountry[number].cur_nm)")
                                    }.onTapGesture {
                                        // 국가 tap
                                    }
                                }
                                .onDrag{
                                    print("Drag")
                                    self.draggedCountry = exchangeViewModel.myCountry[number]
                                    return NSItemProvider(item: nil, typeIdentifier: exchangeViewModel.myCountry[number].cur_nm)
                                }
                                .onDrop(of: [exchangeViewModel.myCountry[number].cur_nm], delegate: MyDropDelegate(currentCountry: exchangeViewModel.myCountry[number], myCountry: $exchangeViewModel.myCountry, draggedCountry: $draggedCountry))
                                .frame(height: 100)
                                .background(Color.white)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    if self.isShowing {
                        CalCulateKeyboardView($inputString, $isShowing, $calculateValueText)
                            .frame(
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.height / 2.5,
                                alignment: .center
                            )
                            .transition(.move(edge: .bottom).animation(.easeInOut(duration:0.5)))
                            .edgesIgnoringSafeArea(.bottom)
                    }
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                
            }
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
        myCountry = Array(realm.objects(MyCountryModel.self))
        return true
    }
    
    // 드랍에서 벗어났을 때
    func dropExited(info: DropInfo) {
    }
    
    // 드랍 시작
    func dropEntered(info: DropInfo) {
        if draggedCountry != currentCountry {
            let from = myCountry.firstIndex(of: draggedCountry)!
            let to = myCountry.firstIndex(of: currentCountry)!
            ExchangeViewModel().changeRealmView(from, to)
        }
    }
    
    // 드랍 변경
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    // 드랍 유효 여부
    func validateDrop(info: DropInfo) -> Bool {
        return true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
