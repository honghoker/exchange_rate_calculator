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
    
    let refreshControlHelper = RefreshControlHelper()
    
    var body: some View {
        VStack {
            HStack() {
                Text("하나은행")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                Spacer().frame(width: 10)
                Text(editHelper.currencyEdit ? "취소" : "편집")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .onTapGesture {
                        editHelper.toggleEdit()
                    }
            }
            Spacer().frame(height : 4)
            if dunamuViewModel.dunamuModels.isEmpty == false {
                HStack {
                    Text("\(dunamuViewModel.dunamuModels[0].date)")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                    Text("\(dunamuViewModel.dunamuModels[0].time) 기준")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .fontWeight(.medium)
                } // HStack
            }
            Spacer().frame(height : 12)
            Section(header: DunamuMainViewHeader()) {
                List(dunamuViewModel.dunamuModels) { dunamu in
                    DunamuRowView(dunamu, $editHelper.currencyEdit)
                        .listRowInsets(EdgeInsets())
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
        print(#fileID, #function, #line, "")
        let myRefresh = UIRefreshControl()
        refreshControlHelper.refreshControl = myRefresh
        refreshControlHelper.parentContentView = self
        myRefresh.addTarget(refreshControlHelper, action: #selector(refreshControlHelper.didRefresh), for: .valueChanged)
        
        tableView.refreshControl = myRefresh
    }
}
