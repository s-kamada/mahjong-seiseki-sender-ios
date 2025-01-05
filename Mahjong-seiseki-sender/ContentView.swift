//
//  ContentView.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/09.
//

import SwiftUI

// TODO: 送信ボタンでAPIを叩ける様にする

struct ContentView: View {
    @State var description = "テスト"
    @State var rank = Rank.first
    @State var point: Int = 0
    @State var rule = Rule.M_REAGUE

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            HStack {
                Text("description")
                Text("*").foregroundColor(.red)
                TextField("例: ベルバードリーグ", text: $description).frame(maxWidth: .infinity, alignment: .trailing).multilineTextAlignment(.trailing)
            }

            HStack {
                Text("point")
                Text("*").foregroundColor(.red)
                TextField("5桁の数字 例: 12300", value: $point, format: .number).frame(maxWidth: .infinity, alignment: .trailing).multilineTextAlignment(.trailing).keyboardType(.decimalPad)
            }

            // TODO: スペース管理、幅をもう少し小さくしたい
            HStack {
                Text("rank")
                Text("*").foregroundColor(.red)
                Spacer()
                Picker("順位", selection: $rank) {
                    ForEach(Rank.allCases) {
                        Text("\($0.rawValue)").tag($0)
                    }
                }.pickerStyle(.segmented)
            }

            HStack {
                Text("rule")
                Text("*").foregroundColor(.red)
                Picker("", selection: $rule) {
                    ForEach(Rule.allCases) {
                        Text("\($0.rawValue)").tag($0)
                    }
                }.pickerStyle(.wheel)
            }

            // TODO: ボタンを押したらレスポンスに合わせてOK/NGなUIを出す (コンタクト登録時に出るアレみたいな)
            // TODO: validate
            Button(action: {
                ApiClient.shared.saveResults(
                    gameResult: GameResult(
                        description: description,
                        point: point,
                        rank: rank.rawValue,
                        rule: rule
                    )
                )
            }, label: {
                Text("Send")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
