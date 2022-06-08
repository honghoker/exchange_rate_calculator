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
    
    var body: some View {
        NavigationView {
            TabView{
                CalculateMainView()
                DunamuMainView()
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}
