import Foundation
import SwiftUI

struct DunamuMainViewHeader: View {
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: proxy.size.width * 0.60)
                    .overlay(
                        Text("통화")
                            .font(.custom("IBMPlexSansKR-Regular", size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    )
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: proxy.size.width * 0.20)
                    .overlay(
                        Text("매매기준율")
                            .font(.custom("IBMPlexSansKR-Regular", size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    )
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: proxy.size.width * 0.20)
                    .overlay(
                        Text("전일대비")
                            .font(.custom("IBMPlexSansKR-Regular", size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    )
            }
        }
        .frame(height: 30)
    }
}
