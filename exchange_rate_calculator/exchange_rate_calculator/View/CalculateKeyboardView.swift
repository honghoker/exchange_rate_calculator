//
//  CalculateKeyboardView.swift
//  exchange_rate_calculator
//
//  Created by 김성훈 on 2022/05/30.
//

import Foundation
import SwiftUI

struct CalCulateKeyboardView: View {
    
    @Binding var inputValue: String
    @Binding var isShowing: Bool
    
    init(_ inputValue: Binding<String>, _ isShowing: Binding<Bool>) {
        self._inputValue = inputValue
        self._isShowing = isShowing
    }
    
    var body: some View {
        VStack (alignment: .trailing){
            Image(systemName: "keyboard.chevron.compact.down")
                .frame(width: 100, height: 30)
                .onTapGesture {
                    withAnimation {
                        isShowing = false
                    }
                }
            HStack{
                Text("7")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
//                        inputValue = Int(String(describing: inputValue) + "7")!
                        inputValue += "7"
                    }
                Text("8")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("9")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Image(systemName: "plus")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack{
                Text("4")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("5")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("6")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Image(systemName: "minus")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack{
                Text("1")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("2")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("3")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Image(systemName: "multiply")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack{
                Text(".")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Text("0")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Image(systemName: "delete.left")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Image(systemName: "divide")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.white)
        
    }
}

//struct CalCulateKeyboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalCulateKeyboardView()
//    }
//}
