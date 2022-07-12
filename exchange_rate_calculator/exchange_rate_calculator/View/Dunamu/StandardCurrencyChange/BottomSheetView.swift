//
//  BottomSheet.swift
//  exchange_rate_calculator
//
//  Created by 홍은표 on 2022/07/07.
//

import Foundation
import SwiftUI
import FlagKit

struct ActionSheetView<Content: View>: View {    
    let content: Content
    let topPadding: CGFloat
    let fixedHeight: Bool
    let bgColor: Color
    
    init(topPadding: CGFloat = 100, fixedHeight: Bool = false, bgColor: Color = .white, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.topPadding = topPadding
        self.fixedHeight = fixedHeight
        self.bgColor = bgColor
    }
    
    var body: some View {
        ZStack {
            bgColor.cornerRadius(20, corners: [.topLeft, .topRight])
            VStack {
                Color.black
                    .opacity(0.2)
                    .frame(width: 30, height: 4)
                    .clipShape(Capsule())
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                
                content
                    .padding(.bottom, 30)
                    .applyIf(fixedHeight) {
                        $0.frame(height: UIScreen.main.bounds.height - topPadding)
                    }
                    .applyIf(!fixedHeight) {
                        $0.frame(maxHeight: UIScreen.main.bounds.height - topPadding)
                    }
            }
        }
        .fixedSize(horizontal: false, vertical: false)
    }
}

struct BottomSheetView: View {
    @ObservedObject var dunamuViewModel: DunamuViewModel
    
    @ViewBuilder func sheetItem(_ currencyCode: String) -> some View {
        let endIdx = currencyCode.index(currencyCode.startIndex, offsetBy: 1)
        let result = String(currencyCode[...endIdx])
        let flag = Flag(countryCode: result)
        let originalImage = flag?.originalImage
        
        let isSelected = dunamuViewModel.standardCountry.currencyCode == currencyCode
        Button(action: {
            // 기준 통화 변경
            if isSelected == false {
                dunamuViewModel.standardCountrySubject.send(currencyCode)
            }
        }, label: {
            HStack {
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
                    Text("\(currencyCode)")
                        .fontWeight(.bold)
                        .font(.custom("IBMPlexSansKR-Regular", size: 14))
                        .foregroundColor(.black)
                    Text("\(countryModelList[currencyCode]!.country) \(countryModelList[currencyCode]!.currencyName)")
                        .fontWeight(.medium)
                        .font(.custom("IBMPlexSansKR-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                if isSelected == true {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(hex: "9265F8"))
                }
                Spacer().frame(width: 12)
            }
        })
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 72)
            ActionSheetView(bgColor: .white) {
                List(currencyCodeList, id: \.self) { currencyCode in
                    sheetItem(currencyCode)
                        .padding(.vertical, 12)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
            }
        }
    }
}

extension View {
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
    
//    func shadowedStyle() -> some View {
//        self
//            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
//            .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
//    }
    
//    func customButtonStyle(
//        foreground: Color = .black,
//        background: Color = .white
//    ) -> some View {
//        self.buttonStyle(
//            ExampleButtonStyle(
//                foreground: foreground,
//                background: background
//            )
//        )
//    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

//private struct ExampleButtonStyle: ButtonStyle {
//    let foreground: Color
//    let background: Color
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .opacity(configuration.isPressed ? 0.45 : 1)
//            .foregroundColor(configuration.isPressed ? foreground.opacity(0.55) : foreground)
//            .background(configuration.isPressed ? background.opacity(0.55) : background)
//    }
//}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
