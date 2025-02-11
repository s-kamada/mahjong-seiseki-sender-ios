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
    @State var point: Float = 0.0
    @State var rule = Rule.M_REAGUE
    @State var results: [GameResult] = [
        GameResult(timeStamp: Date(), description: "1戦目", point: 33.4, rank: Rank.first, rule: Rule.KYOKAI),
        GameResult(timeStamp: Date(), description: "2戦目", point: 33.4, rank: Rank.second, rule: Rule.SAIKOUISEN),
        GameResult(timeStamp: Date(), description: "3戦目", point: -33.4, rank: Rank.first, rule: Rule.RENMEI)
    ]

    @State var isSending = false

    var body: some View {
        VStack {
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
            HStack {
                Button(action: {
                    isSending = true
                    ApiClient.shared.saveResults(
                        gameResult: GameResult(
                            timeStamp: Date(),
                            description: description,
                            point: point,
                            rank: rank,
                            rule: rule
                        )
                    ) { _ in
                        isSending = false
                    }
                }, label: {
                    Text("Send")
                })

                if (isSending) {
                    ProgressView().progressViewStyle(.circular)
                }
            }
            
            List {
                ForEach(results) { result in
                    HStack {
                        Text(result.timeStamp.format())
                        Text(result.rule.rawValue)
                        Spacer()
                        Text(result.rank.toString())
                        Text("\(result.point)")
                    }
                }
            }
            .listStyle(.plain)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 200/255, green: 200/255, blue: 200/255), lineWidth: 2)
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

extension Date {
    
    func format() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd HH:mm"
        return formatter.string(from: self)
    }
}
