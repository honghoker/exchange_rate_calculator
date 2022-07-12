//
//  TabBarViewTest.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/06/03.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    
    @State var isNavigationBarHidden: Bool = false
    // DunamuMainView 에서 리프래시했을 때 기준시간바뀌면 CalculateMainView에 있는 시간도 바껴야해서 같은 ViewModel 객체가 둘 다 가지고 있어야한다. -> 각자 뷰에서 생성하는 ViewModel 객체는 서로 다르기 때문에 객체를 만들어서 각 뷰에 전달
    @State var dunamuViewModel = DunamuViewModel()
    
    var body: some View {
        NavigationView {
            TabView {
                CalculateMainView(dunamuViewModel: dunamuViewModel)
                DunamuMainView(dunamuViewModel: dunamuViewModel)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}
