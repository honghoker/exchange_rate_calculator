import Foundation
import SwiftUI
import Combine

struct CalculateMainView: View {
    let realm = RealmManager.shared.realm
    let mainTextSwitchTimer = Timer.publish(every: 7, on: .main, in: .common).autoconnect() // 앱 이름 <> 업데이트 날짜 바꿔주는 시간 (7초)
    @ObservedObject var dunamuViewModel: DunamuViewModel
    
    @State var inputString = "0" // textField String value
    @State var calculateValueText = "" // keyboard input하면 textField 위에 숫자나 연산자들 보여주는 text
    @State var draggedCountry: MyCountryModel = MyCountryModel() // drag 상태인 국가 (realm)
    @State var mainTextSwitchCheck = true // 메인 앱 이름 <> 업데이트 날짜 바꿔주는 값
    
    
    @ViewBuilder func header() -> some View {
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
    }
    
    @ViewBuilder func standardCurrencyTextField() -> some View {
        let numberFormatter = NumberFormatter.decimal
        HStack{
            Spacer()
            Text("\(calculateValueText)")
                .font(.custom("IBMPlexSansKR-Regular", size: 15))
                .lineLimit(1)
                .truncationMode(.head)
        } // HStack
        .foregroundColor(.gray)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.5, trailing: 20))
        HStack {
            ExchangeFlagView("\(dunamuViewModel.standardCountry.currencyCode)") // 기준나라 국기
                .padding(.horizontal, 20)
            Spacer()
            
            Text("\(numberFormatter.string(for: Double(inputString)!)!)")
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                .font(.custom("IBMPlexSansKR-Regular", size: 25))
                .lineLimit(1)
        }
        Rectangle().frame(height: 1) // underLine
            .foregroundColor(Color.black)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
    }
    
    @ViewBuilder func myCurrencyList() -> some View {
        CalculateCountryListView(dunamuViewModel: dunamuViewModel, draggedCountry: $draggedCountry, inputString: $inputString) // 내가 추가한 국가들 리스트 뷰 (스크롤 뷰로 구현)
    }
    
    @ViewBuilder func admob() -> some View {
        // admob
        //                GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
    }
    
    
    @ViewBuilder func keyBoard() -> some View {
        KeyboardView($inputString,$calculateValueText) // custom calculate keyboard
            .frame(
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height / 3,
                alignment: .center
            )
            .transition(.move(edge: .bottom).animation(.easeInOut(duration:0.5)))
            .edgesIgnoringSafeArea(.bottom)
    }
    
    var body: some View {
        ZStack{
            VStack {
                header()
                standardCurrencyTextField()
                myCurrencyList()
                admob()
                keyBoard()
            } // VStack
        } // ZStack
    } // body
}

struct MyDropDelegate: DropDelegate {
    let currentCountry: DunamuModel
    var myCountry: [DunamuModel]
    var draggedCountry: MyCountryModel
    @ObservedObject var dunamuViewModel: DunamuViewModel
    
    // 드랍 처리
    func performDrop(info: DropInfo) -> Bool {
        if draggedCountry.currencyCode != currentCountry.currencyCode {
            dunamuViewModel.dragAndDropSubject.send((draggedCountry.currencyCode, currentCountry.currencyCode))
        }
        return true
    }
    
    // 드랍에서 벗어났을 때
    func dropExited(info: DropInfo) {
    }
    
    // 드랍 시작
    func dropEntered(info: DropInfo) {
        // 여기서 changeRealmView 처리하면 드래그 하는 동안 realm이 변경돼서 변경되는 애니메이션 효과는 볼 수 있는데, 드랍하지 않았는데 realm 값이 변경돼서 2칸, 3칸 이렇게 이동하면
        // 중간에 변경된 realm 값이 draggedCountry 로 잡혀버림
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
