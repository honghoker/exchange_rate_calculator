//
//  jsonTest.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/05/26.
//

import SwiftUI
import FlagKit

struct DunamuMainView: View {
    @ObservedObject var dunamuViewModel = DunamuViewModel()
    
    var body: some View {
        VStack {
            Text("하나은행")
                .font(.system(size: 16))
                .foregroundColor(.black)
                .fontWeight(.bold)
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
        } // VStack
        List(dunamuViewModel.dunamuModels) { dunamu in
            DunamuRowView(dunamu)
        } // List
        .listStyle(.plain)
    } // body
}
