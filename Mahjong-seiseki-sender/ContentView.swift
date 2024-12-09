//
//  ContentView.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/09.
//

import SwiftUI

// TODO: 送信ボタンでAPIを叩ける様にする

struct ContentView: View {
    // TODO: stateをフォームの数だけ作る
    @State var description = ""

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            HStack {
                Text("description")
                Text("*").foregroundColor(.red)
                TextField("ベルバードリーグ", text: $description).frame(maxWidth: .infinity, alignment: .trailing).multilineTextAlignment(.trailing)
            }

            HStack {
                Text("point")
                Text("*").foregroundColor(.red)
                TextField("12300", text: $description).frame(maxWidth: .infinity, alignment: .trailing).multilineTextAlignment(.trailing)
            }

            // TODO: SegmentControlにする
            // https://zenn.dev/slowhand/articles/17d7c40d8c5663
            HStack {
                Text("rank")
                Text("*").foregroundColor(.red)
                TextField("1", text: $description).frame(maxWidth: .infinity, alignment: .trailing).multilineTextAlignment(.trailing)
            }

            // TODO: プルダウン or ドラムにする
            HStack {
                Text("rule")
                Text("*").foregroundColor(.red)
                TextField("Mリーグルール", text: $description).frame(maxWidth: .infinity, alignment: .trailing).multilineTextAlignment(.trailing)
            }

            // TODO: 送信ボタン
            // TODO: ボタンを押したらレスポンスに合わせてOK/NGなUIを出す (コンタクト登録時に出るアレみたいな)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
