//
//  Mahjong_seiseki_senderApp.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/09.
//

import SwiftUI
import UIKit

@main
struct Mahjong_seiseki_senderApp: App {
    init() {
        // 画面の向きを縦画面に固定
        if #available(iOS 16.0, *) {
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            }
        } else {
            // iOS 16未満の場合
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
