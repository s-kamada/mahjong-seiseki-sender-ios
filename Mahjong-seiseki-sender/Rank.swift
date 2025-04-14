//
//  Rank.swift
//  Mahjong-seiseki-sender
//
//  Created by Shunsuke Kamada on 2024/12/10.
//

import Foundation

enum Rank: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    
    case first = 1
    case second = 2
    case third = 3
    case forth = 4
}

extension Rank {
    /// 1着、2着、3着、4着いずれかのStringを返す
    func toString() -> String {
        return "\(self.rawValue)着"
    }
}
