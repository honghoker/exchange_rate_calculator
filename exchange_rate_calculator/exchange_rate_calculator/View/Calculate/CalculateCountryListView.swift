import Foundation
import SwiftUI
import Introspect

struct PullToRefresh: View {
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }.padding(.top, -20)
    }
}

struct CalculateCountryListView: View {
    @ObservedObject var dunamuViewModel: DunamuViewModel
    @Binding var draggedCountry: MyCountryModel // drag 상태인 국가 (realm)
    @Binding var inputString: String // textField String value
    
    var body: some View {
        ScrollView {
            PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                sleep(1)
                dunamuViewModel.refreshActionSubject.send()
            }
            LazyVStack {
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
            } // LazyVStack
        } // ScrollView
        .coordinateSpace(name: "pullToRefresh")
    }
}
