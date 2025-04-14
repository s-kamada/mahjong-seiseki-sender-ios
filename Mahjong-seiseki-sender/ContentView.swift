//
//  ContentView.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/09.
//

import SwiftUI

struct ContentView: View {
    @State var description = "テスト"
    @State var rank = Rank.first
    @State var point: Float = 0.0
    @State var rule = Rule.M_REAGUE
    @State var results: [GameResult] = []

    @State var isSending = false
    @State private var showingResetAlert = false

    var body: some View {
        VStack {
            inputSection
            resultListSection
        }
        .padding()
    }
    
    // TODO: 各セクション毎くらいに別ファイルに切り出す
    /// 入力セクション
    private var inputSection: some View {
        VStack {
            descriptionInput
            pointInput
            rankInput
            ruleInput
            HStack {
                Spacer()
                sendButton
                Spacer()
                resetButton
            }
        }
    }
    
    // ログを表示するセクション
    private var resultListSection: some View {
        VStack {
            List {
                ForEach(results, id: \.timeStamp) { result in
                    HStack {
                        Text(result.timeStamp.format())
                        Text(result.rule.shortHanded)
                        Spacer()
                        Text(result.rank.toString())
                        Text(result.point.value > 0 ? "+" + String(format: "%.1f", round(result.point.value * 10) / 10) : String(format: "%.1f", round(result.point.value * 10) / 10))
                    }
                }
            }
            .listStyle(.plain)
            
            // 合計ポイントと平均順位を表示するView
            HStack {
                Spacer()
                Text("平均順位: \(String(format: "%.2f", results.map { Double($0.rank.rawValue) }.reduce(0, +) / Double(results.count)))")
                Text("合計: \(results.map { $0.point.value }.reduce(0, +).signedString)")
            }
            .padding()
            .background(Color(red: 240/255, green: 240/255, blue: 240/255))
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 200/255, green: 200/255, blue: 200/255), lineWidth: 2)
        )
    }
    
    /// 説明欄
    private var descriptionInput: some View {
        HStack {
            Text("description")
            Text("*").foregroundColor(.red)
            TextField("例: ベルバードリーグ", text: $description)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
        }
    }
    
    /// ポイントの入力欄
    private var pointInput: some View {
        HStack {
            Text("point")
            Text("*").foregroundColor(.red)
            TextField("5桁の数字 例: 12300", value: $point, format: .number)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
        }
    }
    
    /// 順位の入力欄
    private var rankInput: some View {
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
    }
    
    /// ルールの入力欄(ドラム)
    private var ruleInput: some View {
        HStack {
            Text("rule")
            Text("*").foregroundColor(.red)
            Picker("", selection: $rule) {
                ForEach(Rule.allCases) {
                    Text("\($0.rawValue)").tag($0)
                }
            }.pickerStyle(.wheel)
        }
    }
    
    /// 送信ボタン
    // TODO: 送信時の処理をUsecase的なところに移植する
    private var sendButton: some View {
        HStack {
            Button(action: {
                isSending = true
                let addingResult = GameResult(
                    timeStamp: Date(),
                    description: description,
                    point: Point(value: point),
                    rank: rank,
                    rule: rule
                )
                ApiClient.shared.saveResults(
                    gameResult: addingResult
                ) { _ in
                    // ぐるぐるを引っ込める
                    isSending = false
                    // 履歴viewに追加する
                    // TODO: 切り出す
                    results.append(addingResult)
                }
            }, label: {
                Text("Send")
            })

            if (isSending) {
                ProgressView().progressViewStyle(.circular)
            }
        }
    }
    
    // リセットボタン
    private var resetButton: some View {
        Button(action: {
            showingResetAlert = true
        }, label: {
            Text("Reset")
                .foregroundColor(.red)
        })
        .alert("確認", isPresented: $showingResetAlert) {
            Button("キャンセル", role: .cancel) {
                // do nothing
            }
            Button("削除", role: .destructive) {
                results.removeAll()
            }
        } message: {
            Text("全てのデータを削除しますか？\n削除しても送信した先のデータが消えることはありません。")
        }
    }
}

#Preview {
    ContentView()
}

// TODO: 切り出す
extension Date {
    func format() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd HH:mm"
        return formatter.string(from: self)
    }
}

extension Float {
    var signedString: String {
        let formatter = NumberFormatter()
        formatter.positivePrefix = "+"
        formatter.negativePrefix = "▲"
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
