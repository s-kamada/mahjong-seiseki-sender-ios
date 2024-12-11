//
//  GameResult.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/11.
//

import Foundation

struct GameResult: APIParameterConvertible {
    var description: String
    var point: Int
    var rank: Int
    var rule: Rule

    func toDoictionary() -> [String : Any] {
        return [
            "description": description,
            "point": point,
            "rank": rank,
            "rule": rule.rawValue
        ]
    }
}

protocol APIParameterConvertible {
    func toDoictionary() -> [String: Any]
}
