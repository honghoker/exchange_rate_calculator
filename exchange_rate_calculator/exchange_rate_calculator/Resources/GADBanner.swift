import UIKit
import SwiftUI
import GoogleMobileAds

// 광고 무효트래픽으로 인한 게재 제한.. 일단 광고 제거
//
//struct GADBanner: UIViewControllerRepresentable {

//    func makeUIViewController(context: Context) -> some UIViewController {
//        let view = GADBannerView(adSize: GADAdSizeBanner)
//        let viewController = UIViewController()
//        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 샘플 광고 ID
//        //        view.adUnitID = "ca-app-pub-1976572399218124/2058314751" // 앱 출시하면 이걸로 바꿔야함
//        view.rootViewController = viewController
//        viewController.view.addSubview(view)
//        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
//        view.load(GADRequest())
//        return viewController
//    }
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//    }
//}
