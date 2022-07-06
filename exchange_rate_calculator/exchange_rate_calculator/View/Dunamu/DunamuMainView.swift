//
//  jsonTest.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import SwiftUI
import FlagKit
import Introspect
import UIKit
import RealmSwift
import PopupView

class EditHelper: ObservableObject {
    @Published var currencyEdit: Bool = false
    
    func toggleEdit() {
        withAnimation {
            currencyEdit.toggle()
        }
    }
}

class RefreshControlHelper {
    var parentContentView: DunamuMainView?
    var refreshControl: UIRefreshControl?
    
    @objc func didRefresh() {
        print(#fileID, #function, #line, "")
        guard let parentContentView = parentContentView,
              let parentContentRefreshControl = refreshControl else {
            print("@@@@ didRefresh error")
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            print("@@@@ 리프레시 완료")
            parentContentView.dunamuViewModel.refreshActionSubject.send()
            parentContentRefreshControl.endRefreshing()
        })
    }
}

struct DunamuMainView: View {
    @ObservedObject var dunamuViewModel: DunamuViewModel
    @ObservedObject var editHelper = EditHelper()
    @ObservedObject var myCountryList = BindableResults(results: try! Realm().objects(MyCountryModel.self))
    @ObservedObject var standardCountryModel = BindableResults(results: try! Realm().objects(StandardCountryModel.self))
    @State var showModal = false
    
    let refreshControlHelper = RefreshControlHelper()
    
    @ViewBuilder func popList() -> some View {
        GeometryReader { _ in
            VStack() {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(Array(countryModelList.keys), id: \.self) { value in
                            HStack {
                                //                                    Image(uiImage: Flag(countryCode: "KRW")!.originalImage)
                                //                                        .resizable()
                                //                                        .clipShape(Circle())
                                //                                        .scaledToFit()
                                //                                        .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading) {
                                    Text("\(countryModelList[value]!.currencyName)")
                                        .fontWeight(.semibold)
                                    Text("\(countryModelList[value]!.currencyName)")
                                        .fontWeight(.semibold)
                                    
                                    Divider()
                                }
                            }
                            
                            Image(systemName: "arrow.right")
                                .foregroundColor(.gray)
                        }
                    } // VStack
                    .padding()
                } // ScrollView
                .background(Color.white)
                .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.height - 250)
                .cornerRadius(8)
                
                Button(action: {
                    withAnimation {
                        self.showModal.toggle()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.black)
                        .padding(20)
                })
                .background(Color.white)
                .clipShape(Circle())
                .padding(.top, 25)
            } // VStack
        }
        .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
    }
    
    @ViewBuilder func baseCurrency() -> some View {
        let currencyCode = standardCountryModel.results.first!.currencyCode
        let endIdx = currencyCode.index(currencyCode.startIndex, offsetBy: 1)
        let result = String(currencyCode[...endIdx])
        let flag = Flag(countryCode: result)
        let originalImage = flag?.originalImage
        
        VStack {
            Divider()
            HStack{
                Text("현재 기준 통화")
                    .fontWeight(.bold)
                    .font(.custom("IBMPlexSansKR-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.top, 12)
                    .padding(.leading, 16)
                Spacer()
            }
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
                    Text(currencyCode)
                        .fontWeight(.bold)
                        .font(.custom("IBMPlexSansKR-Regular", size: 14))
                        .foregroundColor(.black)
                    Text("\(countryModelList[currencyCode]!.country) \(countryModelList[currencyCode]!.currencyName)")
                        .fontWeight(.medium)
                        .font(.custom("IBMPlexSansKR-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Button(action: {
                    withAnimation {
                        self.showModal.toggle()
                    }
                }, label: {
                    Text("변경")
                        .fontWeight(.medium)
                        .font(.custom("IBMPlexSansKR-Regular", size: 12))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                        )
                })
                
                Spacer().frame(width: 16)
            }
            Divider()
        }
    }
    
    @ViewBuilder func updateTimeAndEdit() -> some View {
        HStack(spacing: 0) {
            Text("")
                .frame(maxWidth: .infinity)
            if dunamuViewModel.dunamuModels.isEmpty == false {
                Text("\(dunamuViewModel.dunamuModels[1].time) 한국 기준")
                    .font(.custom("IBMPlexSansKR-Regular", size: 14))
                    .foregroundColor(.black)
                    .fontWeight(.medium)
            }
            Text(editHelper.currencyEdit ? "취소" : "편집")
                .font(.custom("IBMPlexSansKR-Regular", size: 14))
                .foregroundColor(.black)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    editHelper.toggleEdit()
                }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
    
    @ViewBuilder func currencyList() -> some View {
        Section(header: DunamuMainViewHeader()) {
            List(dunamuViewModel.dunamuModels) { dunamu in
                DunamuRowView(dunamu, $editHelper.currencyEdit, $myCountryList.results)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            } // List
            .listStyle(.plain)
            .introspectTableView {
                self.configureRefreshControl($0)
            }
        }
    }
    
    var body: some View {
        VStack {
            baseCurrency()
            updateTimeAndEdit()
            currencyList()
        } // VStack
        .padding(0)
        .popup(isPresented: $showModal, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4)) {
            ActionSheetFirst()
        }
    } // body
}

extension DunamuMainView {
    fileprivate func configureRefreshControl(_ tableView: UITableView) {
        let myRefresh = UIRefreshControl()
        refreshControlHelper.refreshControl = myRefresh
        refreshControlHelper.parentContentView = self
        myRefresh.addTarget(refreshControlHelper, action: #selector(refreshControlHelper.didRefresh), for: .valueChanged)
        
        tableView.refreshControl = myRefresh
    }
}


#if os(iOS)
struct ActionSheetView<Content: View>: View {
    
    let content: Content
    let topPadding: CGFloat
    let fixedHeight: Bool
    let bgColor: Color
    
    init(topPadding: CGFloat = 100, fixedHeight: Bool = false, bgColor: Color = .white, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.topPadding = topPadding
        self.fixedHeight = fixedHeight
        self.bgColor = bgColor
    }
    
    var body: some View {
        ZStack {
            bgColor.cornerRadius(20, corners: [.topLeft, .topRight])
            VStack {
                Color.black
                    .opacity(0.2)
                    .frame(width: 30, height: 4)
                    .clipShape(Capsule())
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                
                content
                    .padding(.bottom, 30)
                    .applyIf(fixedHeight) {
                        $0.frame(height: UIScreen.main.bounds.height - topPadding)
                    }
                    .applyIf(!fixedHeight) {
                        $0.frame(maxHeight: UIScreen.main.bounds.height - topPadding)
                    }
            }
        }
        .fixedSize(horizontal: false, vertical: false)
    }
}

private struct ActivityView: View {
    let emoji: String
    let name: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.system(size: 24))
            
            Text(name.uppercased())
                .font(.system(size: 13, weight: isSelected ? .regular : .light))
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(Color(hex: "9265F8"))
            }
        }
        .opacity(isSelected ? 1.0 : 0.8)
    }
}


struct ActionSheetFirst: View {
    @ObservedObject var standardCountryModel = BindableResults(results: try! Realm().objects(StandardCountryModel.self))
    
    @ViewBuilder func sheetItem(_ key: String) -> some View {
        let endIdx = key.index(key.startIndex, offsetBy: 1)
        let result = String(key[...endIdx])
        let flag = Flag(countryCode: result)
        let originalImage = flag?.originalImage
        
        let results = $standardCountryModel.results
        
        let isSelected = results.wrappedValue.contains(where: { $0.currencyCode != key })
        Button(action: {
            if isSelected != false {
                let realm = try! Realm()
                if let userinfo = realm.objects(StandardCountryModel.self).first {
                    try! realm.write {
                        userinfo.currencyCode = key
                    }
                }
            }
        }, label: {
            HStack {
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
                    Text("\(key)")
                        .fontWeight(.bold)
                        .font(.custom("IBMPlexSansKR-Regular", size: 14))
                        .foregroundColor(.black)
                    Text("\(countryModelList[key]!.country) \(countryModelList[key]!.currencyName)")
                        .fontWeight(.medium)
                        .font(.custom("IBMPlexSansKR-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                if isSelected == false {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(hex: "9265F8"))
                }
                Spacer().frame(width: 12)
            }
        })
    }
    
    var body: some View {
        ActionSheetView(bgColor: .white) {
            List(currencyCodeList, id: \.self) { value in
                sheetItem(value)
                    .padding(.vertical, 12)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
    }
}

#endif
//
//  Utils.swift
//  Example
//
//  Created by Alisa Mylnikova on 10/06/2021.
//


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}

extension View {
    
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
    
    func shadowedStyle() -> some View {
        self
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
            .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
    }
    
    func customButtonStyle(
        foreground: Color = .black,
        background: Color = .white
    ) -> some View {
        self.buttonStyle(
            ExampleButtonStyle(
                foreground: foreground,
                background: background
            )
        )
    }
    
#if os(iOS)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
#endif
}

private struct ExampleButtonStyle: ButtonStyle {
    let foreground: Color
    let background: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.45 : 1)
            .foregroundColor(configuration.isPressed ? foreground.opacity(0.55) : foreground)
            .background(configuration.isPressed ? background.opacity(0.55) : background)
    }
}

#if os(iOS)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
