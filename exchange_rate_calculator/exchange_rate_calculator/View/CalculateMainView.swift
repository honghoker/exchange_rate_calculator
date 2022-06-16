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


struct CalculateMainView: View {
    let realm = try! Realm()
    let mainTextSwitchTimer = Timer.publish(every: 7, on: .main, in: .common).autoconnect() // 앱 이름 <> 업데이트 날짜 바꿔주는 시간 (7초)
    
    @EnvironmentObject var exchangeViewModel: ExchangeViewModel // 내가 추가한 메인에 보이는 국가 리스트
    @ObservedObject var dunamuViewModel: DunamuViewModel
    
    @State var inputString = "0" // textField String value
    @State var calculateValueText = "" // keyboard input하면 textField 위에 숫자나 연산자들 보여주는 text
    @State var draggedCountry: MyCountryModel = MyCountryModel() // drag 상태인 국가 (realm)
    @State var mainTextSwitchCheck = true // 메인 앱 이름 <> 업데이트 날짜 바꿔주는 값
    
    var body: some View {
        ZStack{
            VStack {
                HStack (alignment: .center, spacing: 0) {
                    if mainTextSwitchCheck {
                        Text("환율 계산기")
                            .font(.custom("IBMPlexSansKR-Regular", size: 20))
                            .fontWeight(.black)
                            .transition(.opacity)
                            .onReceive(mainTextSwitchTimer) { _ in
                                withAnimation (.easeInOut(duration: 1.0)) {
                                    mainTextSwitchCheck.toggle()
                                }
                            }
                    } else {
                        Text("\(dunamuViewModel.dunamuModels[1].time) 기준")
                            .font(.custom("IBMPlexSansKR-Regular", size: 20))
                            .fontWeight(.black)
                            .transition(.opacity)
                            .onReceive(mainTextSwitchTimer) { _ in
                                withAnimation (.easeInOut(duration: 1.0)) {
                                    mainTextSwitchCheck.toggle()
                                }
                            }
                    }
                    Spacer()
                } // HStack
                .padding()
                HStack{
                    Spacer()
                    Text("\(calculateValueText)")
                        .font(.custom("IBMPlexSansKR-Regular", size: 15))
                } // HStack
                .foregroundColor(.gray)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.5, trailing: 20))
                HStack {
                    ExchangeFlagView("\(dunamuViewModel.standardCountry)") // 기준나라 국기
                        .padding(.horizontal, 20)
                    Spacer()
                    Text("\(inputString)")
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                        .font(.custom("IBMPlexSansKR-Regular", size: 25))
                }
                Rectangle().frame(height: 1) // underLine
                    .foregroundColor(Color.black)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                CalculateCountryRowView($draggedCountry, $inputString, $dunamuViewModel.standardCountry, $dunamuViewModel.standardCountryBasePrice) // 내가 추가한 국가들 리스트 뷰 (스크롤 뷰로 구현)
                CalCulateKeyboardView($inputString,$calculateValueText) // custom calculate keyboard
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: UIScreen.main.bounds.height / 3,
                        alignment: .center
                    )
                    .transition(.move(edge: .bottom).animation(.easeInOut(duration:0.5)))
                    .edgesIgnoringSafeArea(.bottom)
            } // VStack
        } // ZStack
    } // body
}

// Drag and Drop
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


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalculateMainView()
//    }
//}
