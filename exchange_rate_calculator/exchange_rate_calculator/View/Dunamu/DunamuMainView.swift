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
    @State var showModal = false
    
    let refreshControlHelper = RefreshControlHelper()

//    init() {
//        print("@@@@@@ realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" )
//    }
    
    @ViewBuilder func popList() -> some View {
        GeometryReader { _ in
            VStack() {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                            ForEach(Array(countryModelList.keys), id: \.self) { value in
                                ZStack(alignment: .trailing) {
                                    HStack {
    //                                    Image(uiImage: Flag(countryCode: "KRW")!.originalImage)
    //                                        .resizable()
    //                                        .clipShape(Circle())
    //                                        .scaledToFit()
    //                                        .frame(width: 40, height: 40)
                                        
                                        VStack(alignment: .leading) {
                                            Text("KRW")
                                                .fontWeight(.semibold)
                                            Text("대한민국 원")
                                                .fontWeight(.semibold)

                                            Divider()
                                        }
                                    }

                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.gray)

                                }

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
        let endIdx = "KRW".index("KRW".startIndex, offsetBy: 1)
        let result = String("KRW"[...endIdx])
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
                    Text("KRW")
                        .fontWeight(.bold)
                        .font(.custom("IBMPlexSansKR-Regular", size: 14))
                        .foregroundColor(.black)
                    Text("\(countryModelList["KRW"]!.country) \(countryModelList["KRW"]!.currencyName)")
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
        .popup(isPresented: $showModal, type: .toast, position: .bottom, dragToDismiss: true) {
            ForEach(Array(countryModelList.keys), id: \.self) { value in
                ZStack(alignment: .trailing) {
                    HStack {
//                                    Image(uiImage: Flag(countryCode: "KRW")!.originalImage)
//                                        .resizable()
//                                        .clipShape(Circle())
//                                        .scaledToFit()
//                                        .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text("KRW")
                                .fontWeight(.semibold)
                            Text("대한민국 원")
                                .fontWeight(.semibold)

                            Divider()
                        }
                    }

                    Image(systemName: "arrow.right")
                        .foregroundColor(.gray)

                }

            }

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
