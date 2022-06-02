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
import Alamofire

// MARK: extenstion
extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 3
        formatter.numberStyle = .decimal
        return formatter
    }
}

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

struct ContentView: View {
    //    @ObservedObject var exchangeViewModel = ExchangeViewModel() // 내가 추가한 메인에 보이는 국가 리스트
    @StateObject var exchangeViewModel = ExchangeViewModel() // 내가 추가한 메인에 보이는 국가 리스트
    @State var inputString = "" // textField String value
    
    @State var calculateValueText = ""
    
    @State var draggedCountry: MyCountryModel = MyCountryModel() // drag 상태인 국가 (realm)
    
    @State var destination: AnyView? = nil // set page 로 이동하는 View
    
    @State private var isShowing = false // calculate keyboard on off
    
    @State var mainTextSwitchCheck = true // 메인 앱 이름 <> 업데이트 날짜 바꿔주는 값
    let mainTextSwitchTimer = Timer.publish(every: 7, on: .main, in: .common).autoconnect() // 앱 이름 <> 업데이트 날짜 바꿔주는 시간
    
    var body: some View {
        
        ZStack{
            VStack {
                HStack (alignment: .center, spacing: 0){
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
                TextField("0", text: $inputString)
                    .onTapGesture {
                        // 기본 textField 이용시 사용하는 키보드 사용을 중지하도록 제어할 수 있는 항목에게 요청 -> https://seons-dev.tistory.com/4 참고 에뮬에서는 확인 불가능
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        withAnimation {
                            self.isShowing.toggle()
                        }
                    }
                    .onChange(of: inputString, perform: { newValue in
                        if String(describing:newValue).count == 0 {
                            inputString = "0"
                        } else if String(describing:newValue).count > 20 {
                            // 20 글자까지 제한
                            inputString = String(newValue.prefix(20))
                        } else {
                            print("newValue \(newValue)")
                            inputString = newValue
                        }
                    })
                    .multilineTextAlignment(.trailing)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                Rectangle().frame(height: 1)
                    .padding(.horizontal, 20).foregroundColor(Color.black)
                ScrollView {
                    LazyVStack {
                        ForEach(0..<exchangeViewModel.basePrice.count, id: \.self) { number in
                            HStack (alignment: .center, spacing: 15) {
                                ExchangeFlagView(exchangeViewModel.myCountry[number].currencyCode)
                                Text("\(exchangeViewModel.myCountry[number].currencyCode)")
                                    .fontWeight(.light)
                                    .font(.system(size: 30))
                                Spacer()
                                VStack (alignment: .trailing){
                                    // 여기
                                    ExchangeTextView(inputValue: $inputString,  $exchangeViewModel.basePrice, number)
                                    HStack (spacing: 5){
                                        Text("\(exchangeViewModel.basePrice[number].country!)")
                                        Text("\(exchangeViewModel.basePrice[number].currencyName!)")
                                    }
                                }.onTapGesture {
                                    // 국가 tap
                                }
                            }
                            .onDrag{
                                print("Drag \(exchangeViewModel.myCountry[number])")
                                self.draggedCountry = exchangeViewModel.myCountry[number]
                                return NSItemProvider(item: nil, typeIdentifier: exchangeViewModel.myCountry[number].currencyCode)
                            }
                            
                            .onDrop(of: [exchangeViewModel.myCountry[number].currencyCode], delegate: MyDropDelegate(currentCountry: exchangeViewModel.myCountry[number], myCountry: $exchangeViewModel.myCountry, draggedCountry: $draggedCountry, exchangeViewModel: exchangeViewModel
                                                                                                                    ))
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
        }
        
    }
}


struct MyDropDelegate: DropDelegate {
    let realm = try! Realm()
    let currentCountry: MyCountryModel
    @Binding var myCountry: [MyCountryModel]
    @Binding var draggedCountry: MyCountryModel
    @ObservedObject var exchangeViewModel: ExchangeViewModel
    
    // 드랍 처리
    func performDrop(info: DropInfo) -> Bool {
        myCountry = Array(realm.objects(MyCountryModel.self))
        exchangeViewModel.fetchExchangeBasePrice(myCountry)
        return true
    }
    
    // 드랍에서 벗어났을 때
    func dropExited(info: DropInfo) {
    }
    
    // 드랍 시작
    func dropEntered(info: DropInfo) {
        if draggedCountry != currentCountry {
            print("draggedCountry \(draggedCountry)")
            print("currentCountry \(currentCountry)")
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
