import SwiftUI
import FlagKit
import Introspect
import UIKit
import RealmSwift
import PopupView
import GoogleMobileAds

class EditHelper: ObservableObject {
    @Published var currencyEdit: Bool = false
    
    func toggleEdit() {
        withAnimation {
            currencyEdit.toggle()
        }
    }
}

class DunamuMainRefreshControlHelper {
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
            // MARK: - 리프레시
            parentContentView.dunamuViewModel.refreshActionSubject.send()
            parentContentRefreshControl.endRefreshing()
        })
    }
}

struct DunamuMainView: View {
    @ObservedObject var dunamuViewModel: DunamuViewModel
    @StateObject var editHelper = EditHelper()
    @State var showModal = false
    @State var showToast = false
    let refreshControlHelper = DunamuMainRefreshControlHelper()
    
    @ViewBuilder func baseCurrency() -> some View {
        let result = String(dunamuViewModel.standardCountry.currencyCode.dropLast())
        let flag = Flag(countryCode: result)
        let originalImage = flag?.originalImage
        
        VStack {
            Divider()
            HStack{
                Text("현재 기준 통화")
                    .fontWeight(.bold)
                    .font(.custom("IBMPlexSansKR-Medium", size: 14))
                    .foregroundColor(.black)
                    .padding(.top, 12)
                    .padding(.leading, 16)
                Spacer()
            } // HStack
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
                    Text(dunamuViewModel.standardCountry.currencyCode)
                        .fontWeight(.bold)
                        .font(.custom("IBMPlexSansKR-Regular", size: 14))
                        .foregroundColor(.black)
                    Text("\(countryModelList[dunamuViewModel.standardCountry.currencyCode]!.country) \(countryModelList[dunamuViewModel.standardCountry.currencyCode]!.currencyName)")
                        .fontWeight(.medium)
                        .font(.custom("IBMPlexSansKR-Regular", size: 12))
                        .foregroundColor(.gray)
                } // VStack
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
            } // HStack
        } // VStack
        .padding(.bottom, 24)
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
            Text(editHelper.currencyEdit ? "완료" : "편집")
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
        .padding(.bottom, 12)
    }
    
    @ViewBuilder func currencyList() -> some View {
        Section(header: DunamuMainViewHeader()) {
            List(dunamuViewModel.dunamuModels) { dunamu in
                DunamuRowView(dunamuViewModel, dunamu, $editHelper.currencyEdit, $showToast)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            } // List
            .listStyle(.plain)
            .introspectTableView {
                self.configureRefreshControl($0)
            }
        } // Section
    }
    
    @ViewBuilder func admob() -> some View {
        //         admob
        GADBanner().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
    }
    
    var body: some View {
        VStack {
            updateTimeAndEdit()
            baseCurrency()
            currencyList()
            admob()
        } // VStack
        .padding(0)
        .popup(isPresented: $showModal, type: .toast, position: .bottom, closeOnTap: false, closeOnTapOutside: true, backgroundColor: .black.opacity(0.4)) {
            BottomSheetView(dunamuViewModel: dunamuViewModel)
        }
        .popup(isPresented: $showToast, type: .floater(verticalPadding: 0, useSafeAreaInset: true), autohideIn: 2) {
            HStack(spacing: 8) {
                Text("더 이상 삭제할 수 없습니다.")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(hex: "474850")
            .cornerRadius(12))
            .padding(.horizontal, 16)
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
