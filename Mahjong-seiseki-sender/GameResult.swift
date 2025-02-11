//
//  GameResult.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/11.
//

import Foundation

struct GameResult: APIParameterConvertible, Identifiable {
    var id: String { "\(timeStamp) \(description)" }
    
    var timeStamp: Date
    var description: String
    var point: Float
    var rank: Rank
    var rule: Rule

    func toDictionary() -> [String : Any] {
        return [
            "description": description,
            "point": point,
            "rank": rank.rawValue,
            "rule": rule.rawValue
        ]
    }
}

protocol APIParameterConvertible {
    func toDictionary() -> [String: Any]
}
