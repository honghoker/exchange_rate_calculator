//
//  TestTabBarView.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/07/12.
//

import Foundation
import SwiftUI

struct TabbarView: View {
    // Observable Object를 처음 초기화할 때는 StateObject를 사용
    // 이미 객체화된 것을 넘겨 받을 때 ObservedObject의 사용을 추천
    @StateObject var dunamuViewModel: DunamuViewModel = DunamuViewModel()

    var body: some View {
        NavigationView {
            TabView {
                CalculateMainView(dunamuViewModel: dunamuViewModel)
                DunamuMainView(dunamuViewModel: dunamuViewModel)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationTitle("")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
