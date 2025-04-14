//
//  GameResult.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/11.
//

import Foundation

struct GameResult: APIParameterConvertible, Identifiable {
    let timeStamp: Date
    let description: String
    let point: Point
    let rank: Rank
    let rule: Rule

    var id: Date { timeStamp }

    /// APIで送信するためのdictionary
    func toDictionary() -> [String : Any] {
        return [
            // timestampとdesctiptionがスペースが入ってjsonエンコードに失敗する可能性があるので""でくくっておく
            "timeStamp": "\(timeStamp)",
            "description": "\(description)",
            "point": point.value,
            "rank": rank.rawValue,
            "rule": rule.rawValue
        ]
    }
}

// プラスの場合+、マイナスの場合▲の記号をつけるようにする
struct Point {
    let value: Float
    var signedString: String {
        let formatter = NumberFormatter()
        formatter.positivePrefix = "+"
        formatter.negativePrefix = "▲"
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    init(value: Float) {
        self.value = value
    }
}

protocol APIParameterConvertible {
    func toDictionary() -> [String: Any]
}
