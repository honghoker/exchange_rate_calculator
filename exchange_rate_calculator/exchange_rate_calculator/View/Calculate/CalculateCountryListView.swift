//
//  CalculateCountryRowView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/06/08.
//

import Foundation
import SwiftUI
import Introspect

class CalculateMainRefreshControlHelper {
    var parentContentView: CalculateCountryListView?
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

struct CalculateCountryListView: View {
    let refreshContorlHelper = CalculateMainRefreshControlHelper()
    
    @ObservedObject var dunamuViewModel: DunamuViewModel
    @Binding var draggedCountry: MyCountryModel // drag 상태인 국가 (realm)
    @Binding var inputString: String // textField String value
    
    func listRow() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .listRowInsets(EdgeInsets(top: -1, leading: -1, bottom: -1, trailing: -1))
            .background(Color(.systemBackground))
    }
    
    var body: some View {
        List {
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
                .listRowBackground(Color.clear)
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
        }
        .listStyle(.plain)
        .introspectTableView {
            $0.separatorStyle = .none
            self.configrueRefreshControl($0)
        }
    }
}

extension CalculateCountryListView {
    fileprivate func configrueRefreshControl(_ tableView: UITableView) {
        let myRefresh = UIRefreshControl()
        refreshContorlHelper.refreshControl = myRefresh
        refreshContorlHelper.parentContentView = self
        myRefresh.addTarget(refreshContorlHelper, action: #selector(refreshContorlHelper.didRefresh), for: .valueChanged)
        
        tableView.refreshControl = myRefresh
    }
}
