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
              let refreshControl = refreshControl else {
            print("@@@@ didRefresh error")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            print("@@@@ 리프레시 완료")
            parentContentView.dunamuViewModel.refreshActionSubject.send()
            refreshControl.endRefreshing()
        })
    }
}

struct DunamuMainView: View {
    @ObservedObject var dunamuViewModel = DunamuViewModel()
    @ObservedObject var editHelper = EditHelper()
    @ObservedObject var myCountryList = BindableResults(results: try! Realm().objects(MyCountryModel.self))
    
    init() {
        print("@@@@@@ realm URL : \(Realm.Configuration.defaultConfiguration.fileURL!)" )
    }
    
    let refreshControlHelper = RefreshControlHelper()
    
    var body: some View {
        VStack {
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
            Spacer().frame(height : 8)
            
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
        } // VStack
        .padding(0)
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
